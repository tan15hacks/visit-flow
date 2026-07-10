begin;

create extension if not exists pgtap with schema extensions;

select plan(24);

select has_table('public', 'organizations', 'organizations table exists');
select has_table('public', 'organization_members', 'organization_members table exists');
select has_table('public', 'audit_logs', 'audit_logs table exists');
select has_function(
  'public',
  'create_organization',
  array['text', 'text', 'text'],
  'transactional create_organization function exists'
);

select ok(
  (select relrowsecurity from pg_catalog.pg_class where oid = 'public.organizations'::regclass),
  'organizations has RLS enabled'
);
select ok(
  (select relrowsecurity from pg_catalog.pg_class where oid = 'public.organization_members'::regclass),
  'organization_members has RLS enabled'
);
select ok(
  (select relrowsecurity from pg_catalog.pg_class where oid = 'public.audit_logs'::regclass),
  'audit_logs has RLS enabled'
);

select ok(
  not pg_catalog.has_table_privilege('anon', 'public.organizations', 'SELECT'),
  'anonymous users cannot select organizations'
);
select ok(
  not pg_catalog.has_function_privilege(
    'anon',
    'public.create_organization(text,text,text)',
    'EXECUTE'
  ),
  'anonymous users cannot execute create_organization'
);
select ok(
  not pg_catalog.has_table_privilege('authenticated', 'public.organizations', 'INSERT'),
  'authenticated users cannot directly insert organizations'
);
select ok(
  not pg_catalog.has_table_privilege('authenticated', 'public.organization_members', 'INSERT'),
  'authenticated users cannot directly insert memberships'
);

insert into auth.users (id, email)
values
  ('10000000-0000-0000-0000-000000000001', 'owner-a@example.test'),
  ('10000000-0000-0000-0000-000000000002', 'owner-b@example.test'),
  ('10000000-0000-0000-0000-000000000003', 'employee-a@example.test');

create temporary table test_context (
  key text primary key,
  value uuid not null
);
grant all on table test_context to authenticated;

set local role authenticated;
select set_config(
  'request.jwt.claim.sub',
  '10000000-0000-0000-0000-000000000001',
  true
);

insert into test_context (key, value)
values (
  'org_a',
  public.create_organization('Organization A', 'organization-a', 'Asia/Manila')
);

select is(
  (select count(*) from public.organizations),
  1::bigint,
  'owner A sees only organization A after creation'
);
select is(
  (
    select count(*)
    from public.organization_members
    where organization_id = (select value from test_context where key = 'org_a')
      and user_id = '10000000-0000-0000-0000-000000000001'
      and role = 'owner'::public.membership_role
      and status = 'active'::public.membership_status
  ),
  1::bigint,
  'organization creation adds one active owner membership'
);
select is(
  (
    select count(*)
    from public.audit_logs
    where organization_id = (select value from test_context where key = 'org_a')
      and action = 'organization.created'
  ),
  1::bigint,
  'organization creation adds one visible audit event'
);

select throws_ok(
  $$select public.create_organization('Bad Slug', 'Bad Slug', 'Asia/Manila')$$,
  '22023',
  'organization slug is invalid',
  'invalid organization slugs are rejected'
);
select throws_ok(
  $$select public.create_organization('Duplicate', 'organization-a', 'Asia/Manila')$$,
  '23505',
  'organization slug already exists',
  'duplicate organization slugs are rejected'
);

reset role;

set local role authenticated;
select set_config(
  'request.jwt.claim.sub',
  '10000000-0000-0000-0000-000000000002',
  true
);

insert into test_context (key, value)
values (
  'org_b',
  public.create_organization('Organization B', 'organization-b', 'Asia/Manila')
);

select is(
  (select count(*) from public.organizations),
  1::bigint,
  'owner B cannot see organization A'
);
select is(
  (
    select count(*)
    from public.organizations
    where id = (select value from test_context where key = 'org_a')
  ),
  0::bigint,
  'owner B cannot enumerate organization A by identifier'
);

reset role;

insert into public.organization_members (
  organization_id,
  user_id,
  role,
  status,
  joined_at
)
values (
  (select value from test_context where key = 'org_a'),
  '10000000-0000-0000-0000-000000000003',
  'employee'::public.membership_role,
  'active'::public.membership_status,
  now()
);

set local role authenticated;
select set_config(
  'request.jwt.claim.sub',
  '10000000-0000-0000-0000-000000000003',
  true
);

select is(
  (
    select count(*)
    from public.organizations
    where id = (select value from test_context where key = 'org_a')
  ),
  1::bigint,
  'active employee can read their organization'
);
select is(
  (
    select count(*)
    from public.organization_members
    where organization_id = (select value from test_context where key = 'org_a')
  ),
  1::bigint,
  'employee can read only their own membership'
);
select is(
  (
    select count(*)
    from public.audit_logs
    where organization_id = (select value from test_context where key = 'org_a')
  ),
  0::bigint,
  'employee cannot read organization audit logs'
);
select is(
  (
    select count(*)
    from public.organizations
    where id = (select value from test_context where key = 'org_b')
  ),
  0::bigint,
  'employee cannot read another organization'
);

reset role;

update public.organization_members
set status = 'suspended'::public.membership_status
where organization_id = (select value from test_context where key = 'org_a')
  and user_id = '10000000-0000-0000-0000-000000000003';

set local role authenticated;
select set_config(
  'request.jwt.claim.sub',
  '10000000-0000-0000-0000-000000000003',
  true
);

select is(
  (
    select count(*)
    from public.organizations
    where id = (select value from test_context where key = 'org_a')
  ),
  0::bigint,
  'suspended membership immediately loses organization access'
);
select is(
  (select count(*) from public.organization_members),
  1::bigint,
  'suspended user can still read only their own membership record'
);

select * from finish();
rollback;
