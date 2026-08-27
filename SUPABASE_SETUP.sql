create table if not exists public.review_states (
  user_id uuid primary key references auth.users(id) on delete cascade,
  payload jsonb not null default '{}'::jsonb,
  client_updated_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.review_states enable row level security;

drop policy if exists "review_states_select_own" on public.review_states;
create policy "review_states_select_own"
on public.review_states for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "review_states_insert_own" on public.review_states;
create policy "review_states_insert_own"
on public.review_states for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "review_states_update_own" on public.review_states;
create policy "review_states_update_own"
on public.review_states for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
