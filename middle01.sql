drop table if exists readers;

create table readers (
    id serial primary key,
    name varchar(100) not null
);

-- Insert data into 'readers' table
insert into readers (name) values ('Alice Cooper'), ('Bob Marley'), ('Charlie Puth');

drop table if exists records;

create table records (
    id serial primary key,
    book_id int references books(id) on delete cascade,
    reader_id int references readers(id) on delete cascade,
    taken_at timestamp default current_timestamp,
    returned_at timestamp null,
    check (returned_at is null or returned_at >= taken_at)  
);

-- Insert data into 'records' table
insert into records (book_id, reader_id, taken_at, returned_at) values
(1, 1, '2024-01-10 10:00:00', '2024-01-20 15:30:00'),
(2, 2, '2024-02-05 14:00:00', null),
(3, 3, '2024-03-12 09:30:00', '2024-03-22 11:45:00'),
(4, 1, '2024-04-01 16:15:00', null),
(5, 2, '2024-05-18 13:45:00', '2024-05-28 10:20:00');

select b.title, r.name, ar.taken_at from books b
left join (select book_id, reader_id, taken_at from records where returned_at is null) as ar on b.id = ar.book_id 
join readers r on ar.reader_id = r.id where ar.book_id is not null;

select b.title, count(b.title) as borrowed_books_count from books b
left join (select book_id, taken_at from records) as ar on b.id = ar.book_id
where ar.book_id is not null
group by b.title;
