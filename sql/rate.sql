drop table if exists rate; 
create table if not exists rate
(
    code string,
    name string,
    pos string,
    time string,
    rate double
)
;

insert into rate   
select
distinct
code, 
name,
pos,
time,  
round((close - open)/close, 3)  as rate
from stock
where time <= '2015-05-06'
and time > date('2015-05-06', '-120 day') 
;



drop table if exists rate_index;
create table if not exists rate_index 
(
    code string,
    name string,
    pos string,
    rate_list string,
    num int
)
;

insert into rate_index 
select code,  name, pos,  
trim(group_concat(',', rate), ',') as rate_list,
count(*) as num 
from rate
group by code 
order by num;

drop table if exists rate_index_clean;
create table if not exists rate_index_clean 
(
    code  string,
    name string,
    pos string,
    rate_list string,
    num int
)
;

insert into rate_index_clean
select t1.code, t1.name, t1.pos, t1.rate_list, t1.num from 
rate_index t1 
inner join
(select num, count(*) as fre from rate_index group by num order by fre DESC limit 1)t2 
on t1.num = t2.num
;
