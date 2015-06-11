---- predict
drop table if exists rate_pred;
create table if not exists rate_pred
as
    select code,  time,
    printf('%d:%s', julianday('now') - julianday(time), rate) as delta
from rate
where
julianday('now') - julianday(time) <= 180 
order by code, time 
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

.mode csv
.output traindb/predict.csv
select * from rate_predict;
