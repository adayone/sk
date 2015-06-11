create table if not exists stock
(
    code varchar(6),
    name text,
    pos varchar(2),
    time text,
    open float,
    high float,
    low float,
    close float,
    vol float,
    adj float,
PRIMARY KEY (code, time)

)
;


drop table if exists sim;
create table if not exists sim
(
    x varchar(6),
    y varchar(6),
    score float
)
;

