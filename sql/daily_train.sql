-- train
drop table if exists rate_delta;
create table if not exists rate_delta
as
select
t1.code as code, 
t1.time as label_time,
t1.rate as label_rate,
t2.time as time,  
t2.rate as rate
from
(
select code, time, rate
from
rate
where 
time <= date('now', '-7 day')
and time >= date('now', '-35 day') 
)
t1
join
rate t2
on t1.code = t2.code
and t2.time < t1.time
and julianday(t1.time) - julianday(t2.time) <= 240
order by code, time desc
;

drop table if exists rate_train;
create table if not exists rate_train
as
select
code, label_time, label_rate,
group_concat(delta, ' ') as rate_list
from
(
    select code, label_time, label_rate, time,
    printf('%d:%s', julianday(label_time) - julianday(time), rate) as delta
    from rate_delta
    where 
    (label_rate > 0.01 or label_rate < -0.01)
    and
    (
        label_time = date('now', '-28 day', 'weekday 4')
        or
        label_time = date('now', '-35 day', 'weekday 4')
    )
)t1
group by code, label_time, label_rate
;

---- test
drop table if exists rate_test;
create table if not exists rate_test
as
select
code, label_time, label_rate,
group_concat(delta, ' ') as rate_list
from
(
    select code, label_time, label_rate, time,
    printf('%d:%s', julianday(label_time) - julianday(time), rate) as delta
    from rate_delta
    where 
    (label_rate > 0.01 or label_rate < -0.01)
    and
    (
        label_time = date('now', '-24 day', 'weekday 4')
        or
        label_time = date('now', '-44 day', 'weekday 4')
        or
        label_time = date('now', '-7 day', 'weekday 4')
    )
)t1
group by code, label_time, label_rate
;


---- predict
drop table if exists rate_pred;
create table if not exists rate_pred
as
select code,  time,
printf('%d:%s', julianday('now') - julianday(time), rate) as delta
from rate
where
julianday('now') - julianday(time) <= 180
order by code, time desc
;

drop table if  exists rate_pred_index;
create table if not exists rate_pred_index
as
select
code, 
group_concat(delta, ' ') as rate_list
from
rate_pred
group by code 
;

