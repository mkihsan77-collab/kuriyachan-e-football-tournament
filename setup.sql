
-- AD13 Season 1: run this whole script in Supabase SQL Editor.
create table if not exists public.tournament_admins (
  email text primary key
);
create table if not exists public.tournament_state (
  id text primary key,
  state jsonb not null default '{"players":["","","","","","","",""],"scores":{}}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.tournament_admins enable row level security;
alter table public.tournament_state enable row level security;

create or replace function public.is_tournament_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.tournament_admins
    where lower(email) = lower(coalesce(auth.jwt()->>'email',''))
  );
$$;
revoke all on function public.is_tournament_admin() from public;
grant execute on function public.is_tournament_admin() to authenticated;

drop policy if exists "Admins can view admin list" on public.tournament_admins;
create policy "Admins can view admin list" on public.tournament_admins
for select to authenticated using (public.is_tournament_admin());

drop policy if exists "Anyone can read tournament" on public.tournament_state;
create policy "Anyone can read tournament" on public.tournament_state
for select to anon, authenticated using (true);

drop policy if exists "Admins can insert tournament" on public.tournament_state;
create policy "Admins can insert tournament" on public.tournament_state
for insert to authenticated with check (public.is_tournament_admin());

drop policy if exists "Admins can update tournament" on public.tournament_state;
create policy "Admins can update tournament" on public.tournament_state
for update to authenticated using (public.is_tournament_admin()) with check (public.is_tournament_admin());

insert into public.tournament_state (id,state)
values ('season-1','{"players":["","","","","","","",""],"scores":{}}'::jsonb)
on conflict (id) do nothing;

-- Enable realtime updates for the public bracket.
do $$ begin
  alter publication supabase_realtime add table public.tournament_state;
exception when duplicate_object then null;
when undefined_object then null;
end $$;
