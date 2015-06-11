-- pair
drop table if exists rate_pair_vw;
create table if not exists rate_pair_vw
as
select
'pair' as code, 
t1.label_time,
t1.rate_list as x,
t2.rate_list as y,
t1.label_rate - t2.label_rate as rate_delta
from
rate_train 
t1
join
rate_train 
t2
on t1.label_time = t2.label_time
and random()/9223372036854775807 < 0.01
and (t1.label_rate - t2.label_rate) > 0.01
;


--pair(t1.rate_list, t2.rate_list) as pair
