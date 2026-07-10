-- VisitFlow initial tenant foundation.
--
-- Scope:
-- - organizations
-- - organization memberships
-- - audit events for organization creation
-- - tenant membership helper functions
-- - transactional organization creation
-- - deny-by-default RLS and grants

create extension if not exists pgcrypto with schema extensions;

create schema if not exists app_private;
revoke all on schema app_private from public;
grant usage on schema app_private to authenticated, service_role;

create type public.membership_role as enum (
  'owner',
  'admin',
  'guard',
  'receptionist',
  'employee',
  'auditor'
);

create type public.membership_status as enum (
  'invited',
  'active',
  'suspended',
  'removed'
);

create table public.organizations (
  id uuid primary key default extensions.gen_random_uuid(),
  name text not null,
  slug text not null unique,
  industry text,
  logo_path text,
  timezone text not null default 'Asia/Manila',
  visitor_retention_days integer not null default 365,
  photo_retention_days integer not null default 30,
  created_by uuid not null references auth.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organizations_name_length check (char_length(name) between 2 and 120),
  constraint organizations_name_trimmed check (name = btrim(name)),
  constraint organizations_slug_format check (
    slug = lower(slug)
    and slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'
    and char_length(slug) between 3 and 63
  ),
  constraint organizations_visitor_retention_range check (
    visitor_retention_days between 1 and 3650
  ),
  constraint organizations_photo_retention_range check (
    photo_retention_days between 0 and 3650
  )
);

create table public.organization_members (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role public.membership_role not null,
  status public.membership_status not null default 'invited',
  invited_by uuid references auth.users(id) on delete set null,
  joined_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint organization_members_user_organization_unique unique (organization_id, user_id),
  constraint organization_members_active_joined check (
    status <> 'active' or joined_at is not null
  )
);

create index organization_members_user_status_idx
  on public.organization_members (user_id, status);

create index organization_members_organization_status_idx
  on public.organization_members (organization_id, status);

create table public.audit_logs (
  id uuid primary key default extensions.gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  request_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  constraint audit_logs_action_length check (char_length(action) between 3 and 100),
  constraint audit_logs_entity_type_length check (char_length(entity_type) between 3 and 100),
  constraint audit_logs_metadata_object check (jsonb_typeof(metadata) = 'object')
);

create index audit_logs_organization_created_at_idx
  on public.audit_logs (organization_id, created_at desc);

create or replace function app_private.set_updated_at()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger organizations_set_updated_at
before update on public.organizations
for each row execute function app_private.set_updated_at();

create trigger organization_members_set_updated_at
before update on public.organization_members
for each row execute function app_private.set_updated_at();

create or replace function app_private.is_active_member(target_organization_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.organization_members as membership
    where membership.organization_id = target_organization_id
      and membership.user_id = auth.uid()
      and membership.status = 'active'::public.membership_status
  );
$$;

create or replace function app_private.has_organization_role(
  target_organization_id uuid,
  allowed_roles public.membership_role[]
)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.organization_members as membership
    where membership.organization_id = target_organization_id
      and membership.user_id = auth.uid()
      and membership.status = 'active'::public.membership_status
      and membership.role = any (allowed_roles)
  );
$$;

revoke all on function app_private.set_updated_at() from public;
revoke all on function app_private.is_active_member(uuid) from public, anon;
revoke all on function app_private.has_organization_role(uuid, public.membership_role[]) from public, anon;
grant execute on function app_private.is_active_member(uuid) to authenticated, service_role;
grant execute on function app_private.has_organization_role(uuid, public.membership_role[]) to authenticated, service_role;

alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.audit_logs enable row level security;

create policy organizations_select_active_members
on public.organizations
for select
to authenticated
using (app_private.is_active_member(id));

create policy organization_members_select_self_or_admin
on public.organization_members
for select
to authenticated
using (
  user_id = auth.uid()
  or app_private.has_organization_role(
    organization_id,
    array['owner', 'admin']::public.membership_role[]
  )
);

create policy audit_logs_select_owner_or_admin
on public.audit_logs
for select
to authenticated
using (
  app_private.has_organization_role(
    organization_id,
    array['owner', 'admin']::public.membership_role[]
  )
);

revoke all on table public.organizations from anon, authenticated;
revoke all on table public.organization_members from anon, authenticated;
revoke all on table public.audit_logs from anon, authenticated;

grant select on table public.organizations to authenticated;
grant select on table public.organization_members to authenticated;
grant select on table public.audit_logs to authenticated;

create or replace function public.create_organization(
  p_name text,
  p_slug text,
  p_timezone text default 'Asia/Manila'
)
returns uuid
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_user_id uuid := auth.uid();
  v_name text := regexp_replace(btrim(coalesce(p_name, '')), '[[:space:]]+', ' ', 'g');
  v_slug text := lower(btrim(coalesce(p_slug, '')));
  v_timezone text := btrim(coalesce(p_timezone, ''));
  v_organization_id uuid;
begin
  if v_user_id is null then
    raise exception 'authentication required' using errcode = '42501';
  end if;

  if char_length(v_name) < 2 or char_length(v_name) > 120 then
    raise exception 'organization name must contain 2 to 120 characters'
      using errcode = '22023';
  end if;

  if char_length(v_slug) < 3
     or char_length(v_slug) > 63
     or v_slug !~ '^[a-z0-9]+(-[a-z0-9]+)*$' then
    raise exception 'organization slug is invalid'
      using errcode = '22023';
  end if;

  if not exists (
    select 1
    from pg_catalog.pg_timezone_names
    where name = v_timezone
  ) then
    raise exception 'organization timezone is invalid'
      using errcode = '22023';
  end if;

  insert into public.organizations (
    name,
    slug,
    timezone,
    created_by
  )
  values (
    v_name,
    v_slug,
    v_timezone,
    v_user_id
  )
  returning id into v_organization_id;

  insert into public.organization_members (
    organization_id,
    user_id,
    role,
    status,
    joined_at
  )
  values (
    v_organization_id,
    v_user_id,
    'owner'::public.membership_role,
    'active'::public.membership_status,
    now()
  );

  insert into public.audit_logs (
    organization_id,
    actor_user_id,
    action,
    entity_type,
    entity_id,
    metadata
  )
  values (
    v_organization_id,
    v_user_id,
    'organization.created',
    'organization',
    v_organization_id,
    jsonb_build_object('slug', v_slug)
  );

  return v_organization_id;
exception
  when unique_violation then
    raise exception 'organization slug already exists'
      using errcode = '23505';
end;
$$;

revoke all on function public.create_organization(text, text, text) from public, anon;
grant execute on function public.create_organization(text, text, text) to authenticated;

comment on function public.create_organization(text, text, text) is
  'Creates an organization, active owner membership, and audit event in one transaction.';
