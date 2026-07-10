begin;

create extension if not exists pgtap with schema extensions;

select plan(7);

insert into auth.users (id, email)
values ('20000000-0000-0000-0000-000000000001', 'onboarding-owner@example.test');

create temporary table onboarding_context (
  organization_id uuid primary key
);
grant all on table onboarding_context to authenticated;

set local role authenticated;
select set_config(
  'request.jwt.claim.sub',
  '20000000-0000-0000-0000-000000000001',
  true
);

select lives_ok(
  $$
    insert into onboarding_context (organization_id)
    values (
      public.create_organization(
        '  Acme   Main Office  ',
        'acme-main-office',
        'Asia/Manila'
      )
    )
  $$,
  'authenticated onboarding creates an organization transactionally'
);

select is(
  (
    select name
    from public.organizations
    where id = (select organization_id from onboarding_context)
  ),
  'Acme Main Office',
  'organization name is normalized before persistence'
);

select is(
  (
    select timezone
    from public.organizations
    where id = (select organization_id from onboarding_context)
  ),
  'Asia/Manila',
  'organization timezone is persisted'
);

select is(
  (
    select count(*)
    from public.organization_members
    where organization_id = (select organization_id from onboarding_context)
      and user_id = '20000000-0000-0000-0000-000000000001'
      and role = 'owner'::public.membership_role
      and status = 'active'::public.membership_status
  ),
  1::bigint,
  'onboarding creates one active owner membership'
);

select is(
  (
    select count(*)
    from public.audit_logs
    where organization_id = (select organization_id from onboarding_context)
      and action = 'organization.created'
  ),
  1::bigint,
  'onboarding creates one organization audit event'
);

select throws_ok(
  $$
    select public.create_organization(
      'Duplicate Workspace',
      'acme-main-office',
      'Asia/Manila'
    )
  $$,
  '23505',
  'organization slug already exists',
  'duplicate workspace slugs are rejected'
);

select is(
  (select count(*) from public.organizations),
  1::bigint,
  'failed duplicate onboarding does not create a partial organization'
);

select * from finish();
rollback;
