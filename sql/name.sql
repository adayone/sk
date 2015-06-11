drop table if exists sh_name;
create table if not exists sh_name
(
    code varchar(6),
    name text
)
;

.mode csv
.import ./db/sh_id.csv sh_name

drop table if exists sz_name;
create table if not exists sz_name
(
    code varchar(6),
    name text
)
;

.separator ','
.mode csv
.import ./db/sz_id.csv sz_name

drop table if exists name;
create table if not exists name
(
    code varchar(6),
    name text,
    pos varchar(2) 
)
;

insert into name
select  code, name, 'sz' from sz_name
union
select code, name, 'ss' from sh_name;


