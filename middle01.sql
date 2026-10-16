drop table if exists readers;

create table readers (
    id serial primary key,
    name varchar(100) not null
);

drop table if exists records;

create table records (
    id serial primary key,
    book_id int references books(id) on delete cascade,
    reader_id int references readers(id) on delete cascade,
    taken_at timestamp default current_timestamp,
    returned_at timestamp null,
    check (returned_at is null or returned_at >= taken_at)  
);