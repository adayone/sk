.mode csv
.separator '	'
.output db/log.csv
select * from stock where time>2014-01-01;
