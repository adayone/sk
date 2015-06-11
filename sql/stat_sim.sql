drop table if exists sim_rate;
create table sim_rate
as
select
t1.x,
t2.rate as xv,
t1.y,
t3.rate as yv,
t2.rate - t3.rate as delta,
score
from
sim t1
join
(select * from rate where time='2015-05-04' )t2
on t1.x = t2.code
join
(select * from rate where time='2015-05-04' )t3
on
t1.y = t3.code
order by x, score
;
