-- Diccionario Jorgelina - Jordi · Videos
-- Pegalo en Supabase → SQL Editor → Run.
alter table entradas add column if not exists video text;
alter table entradas add column if not exists video_por text;

insert into storage.buckets (id, name, public, file_size_limit)
values ('videos', 'videos', true, 52428800)
on conflict (id) do nothing;

do $$ begin create policy "ver videos" on storage.objects for select to authenticated using (bucket_id = 'videos'); exception when duplicate_object then null; end $$;
do $$ begin create policy "subir videos" on storage.objects for insert to authenticated with check (bucket_id = 'videos' and es_miembro()); exception when duplicate_object then null; end $$;
do $$ begin create policy "cambiar videos" on storage.objects for update to authenticated using (bucket_id = 'videos' and es_miembro()); exception when duplicate_object then null; end $$;
do $$ begin create policy "borrar videos" on storage.objects for delete to authenticated using (bucket_id = 'videos' and es_miembro()); exception when duplicate_object then null; end $$;

notify pgrst, 'reload schema';
select id, public, file_size_limit from storage.buckets where id = 'videos';
