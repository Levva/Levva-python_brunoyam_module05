drop table if exists books;

create table books (
    id serial primary key,
    title varchar(100) not null,
    author varchar(50),
    year int null,
    genre varchar(30) default 'Не указан',
    is_available boolean default true
);
