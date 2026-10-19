DROP INDEX IF EXISTS idx_records_active_book;

EXPLAIN ANALYZE
select b.title, r.name, ar.taken_at from books b
left join (select book_id, reader_id, taken_at from records where returned_at is null) as ar on b.id = ar.book_id 
join readers r on ar.reader_id = r.id
where ar.book_id is not null;


CREATE INDEX idx_records_active_book ON records (book_id) WHERE returned_at IS NULL;

EXPLAIN ANALYZE
select b.title, r.name, ar.taken_at from books b
left join (select book_id, reader_id, taken_at from records where returned_at is null) as ar on b.id = ar.book_id 
join readers r on ar.reader_id = r.id
where ar.book_id is not null;
