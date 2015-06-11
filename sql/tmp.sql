drop table if  exists rate_pred_index;
create table if not exists rate_pred_index
as
select
code,
group_concat(delta, ' ') as rate_list
from
rate_pred
group by code
order by code, rate asc
;
    
