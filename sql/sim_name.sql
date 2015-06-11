drop table if exists sim_name;
create table if not exists sim_name
(
    x varchar(6),
    xname string,
    y varchar(6),
    yname string,
    score
)
;

insert into sim_name
select
t1.x, t2.name, t1.y, t3.name, score
from
sim t1
join
name t2
on t1.x = t2.code
join
name t3
on
t1.y = t3.code
;

drop table if exists sim_index;
create table if not exists sim_index
(
    x varchar(6),
    ylist text
)
;

insert into sim_index
select x, trim(group_concat(y, ','), ',')
from sim
group by x
;

