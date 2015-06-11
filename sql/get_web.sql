drop table if exists stock_ori;
create table if not exists stock_ori
(
    code varchar(6) unique,
    pos varchar(2),
    name text,
    history text
)
;



insert into stock_ori
select *
from
(
select distinct code, pos, name, get(code, pos) as history 
from name 
)t1
where length(history) > 10
;
    
