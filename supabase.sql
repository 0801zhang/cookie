-- 饼干 · 云端同步建表
-- 在 Supabase 控制台 → SQL Editor 里整段粘贴执行

create table if not exists public.binggan_data (
  id          text primary key,          -- 你的同步码
  payload     jsonb not null,            -- 整包数据
  updated_at  timestamptz default now(),
  device      text
);

alter table public.binggan_data enable row level security;

-- 个人自用：允许匿名读写，靠"同步码"隔离
-- （同步码只有你知道，但请设得足够随机，比如 binggan-7f3a9c2e）
drop policy if exists "anon read"   on public.binggan_data;
drop policy if exists "anon insert" on public.binggan_data;
drop policy if exists "anon update" on public.binggan_data;

create policy "anon read"   on public.binggan_data for select to anon using (true);
create policy "anon insert" on public.binggan_data for insert to anon with check (true);
create policy "anon update" on public.binggan_data for update to anon using (true);
