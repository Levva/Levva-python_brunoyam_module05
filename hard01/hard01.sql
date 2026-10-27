EXPLAIN ANALYZE
select b.title, r.name, ar.taken_at from books b
left join (select book_id, reader_id, taken_at from records where returned_at is null) as ar on b.id = ar.book_id 
join readers r on ar.reader_id = r.id
where ar.book_id is not null;

-- Самое очевидное решение - создать индекс для книг, которые ещё не вернули:
CREATE INDEX IF NOT EXISTS idx_records_active_book ON records (book_id) WHERE returned_at IS NULL;

-- Если рассматривать всю БД целиком, можно также проиндекировать внешние ключи
-- на сколько помню, они только в mysql индексируются автоматически
CREATE INDEX IF NOT EXISTS idx_records_book_id   ON records (book_id);
CREATE INDEX IF NOT EXISTS idx_records_reader_id ON records (reader_id);

-- Наверное есть ещё какие-то специфичные варианты, но затрудняю сказать

EXPLAIN ANALYZE
select b.title, r.name, ar.taken_at from books b
left join (select book_id, reader_id, taken_at from records where returned_at is null) as ar on b.id = ar.book_id 
join readers r on ar.reader_id = r.id
where ar.book_id is not null;

-- Выгрузила результаты с индексами и без в json, но на таких маленьких данных вряд ли можно говорить о каких-то
-- объективных результатах. Тип поиска не поменялся. Можно отключить Seq Scan принудительно и посмотреть, конечно