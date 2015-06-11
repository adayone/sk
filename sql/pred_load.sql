drop table if exists daily_pred;
create table if not exists
daily_pred
(
    code varchar(6),
    prob float
);

.mode csv
.separator \t
.import traindb/pred_final daily_pred
