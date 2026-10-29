-- Supabase SQL schema for Personal Finance & Budget Tracker
-- Run this in the Supabase SQL editor

-- Enable pgcrypto for gen_random_uuid()
create extension if not exists pgcrypto;

-- Users table that extends auth.users
create table if not exists users (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  preferred_currency text default 'USD',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Accounts
create table if not exists accounts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  name text not null,
  type text default 'checking',
  currency text default 'USD',
  balance numeric default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Categories
create table if not exists categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  name text not null,
  icon text,
  color text,
  is_default boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Budgets
create table if not exists budgets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  category_id uuid references categories(id),
  amount numeric not null,
  start_date date,
  end_date date,
  interval text default 'monthly',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Goals
create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  title text not null,
  target_amount numeric not null,
  saved_amount numeric default 0,
  deadline date,
  metadata jsonb,
  is_completed boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Transactions
create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references users(id) on delete cascade,
  account_id uuid references accounts(id),
  category_id uuid references categories(id),
  amount numeric not null,
  currency text default 'USD',
  type text not null check (type in ('income','expense')),
  note text,
  merchant text,
  receipt_url text,
  occurred_at timestamptz default now(),
  is_recurring boolean default false,
  recurring_rule text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Function to update updated_at timestamp
create or replace function trigger_set_timestamp()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Attach trigger to tables
create trigger set_timestamp_users before update on users for each row execute function trigger_set_timestamp();
create trigger set_timestamp_accounts before update on accounts for each row execute function trigger_set_timestamp();
create trigger set_timestamp_categories before update on categories for each row execute function trigger_set_timestamp();
create trigger set_timestamp_budgets before update on budgets for each row execute function trigger_set_timestamp();
create trigger set_timestamp_goals before update on goals for each row execute function trigger_set_timestamp();
create trigger set_timestamp_transactions before update on transactions for each row execute function trigger_set_timestamp();

-- Policy helpers: allow access only to authenticated users
-- Enable RLS
alter table accounts enable row level security;
alter table categories enable row level security;
alter table budgets enable row level security;
alter table goals enable row level security;
alter table transactions enable row level security;
alter table users enable row level security;

-- Policies: users only access their own rows
create policy "Users can manage their user row" on users
  for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "Users can access their accounts" on accounts
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users can access categories" on categories
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users can access budgets" on budgets
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users can access goals" on goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users can access transactions" on transactions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Default categories for new users: insert when auth.users row created
create or replace function public.handle_new_auth_user()
returns trigger as $$
begin
  -- create a users row
  insert into users(id, created_at, updated_at) values (new.id, now(), now()) on conflict do nothing;

  -- insert default categories for the new user
  insert into categories(id, user_id, name, icon, color, is_default, created_at) values
    (gen_random_uuid(), new.id, 'Food', 'restaurant', '#F97316', true, now()),
    (gen_random_uuid(), new.id, 'Transport', 'directions_bus', '#06B6D4', true, now()),
    (gen_random_uuid(), new.id, 'Shopping', 'shopping_cart', '#A78BFA', true, now()),
    (gen_random_uuid(), new.id, 'Utilities', 'flash_on', '#F59E0B', true, now()),
    (gen_random_uuid(), new.id, 'Income', 'attach_money', '#10B981', true, now()),
    (gen_random_uuid(), new.id, 'Others', 'more_horiz', '#9CA3AF', true, now())
  on conflict do nothing;

  return new;
end;
$$ language plpgsql security definer;

-- Trigger on auth.users
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_auth_user();

-- Indexes for performance
create index if not exists idx_transactions_user_id on transactions(user_id);
create index if not exists idx_transactions_account_id on transactions(account_id);
create index if not exists idx_transactions_category_id on transactions(category_id);
create index if not exists idx_transactions_occurred_at on transactions(occurred_at desc);
create index if not exists idx_accounts_user_id on accounts(user_id);
create index if not exists idx_budgets_user_id on budgets(user_id);

-- Full-text search index on transactions.note
create extension if not exists pg_trgm;
create index if not exists idx_transactions_note_trgm on transactions using gin (note gin_trgm_ops);
