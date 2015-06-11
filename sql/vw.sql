.mode csv
.output traindb/train.csv
select * from rate_train;

.mode csv
.output traindb/test.csv
select * from rate_test;

.mode csv
.output traindb/predict.csv
select * from rate_pred_index;
