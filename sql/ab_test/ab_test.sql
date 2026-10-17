create table ab_test(
index int not null,
"user id" int not null,
"test group" varchar(5),
"converted" boolean,
"total ads" int,
"most ads day" text,
"mosts ads hour" int
)



--copying csv file
copy ab_test from '/tmp/ab_test/marketing_AB.csv'
delimiter ','
csv header;


select * from ab_test;

-- altering the columns
alter table ab_test 
rename "user id" to user_id;

alter table ab_test 
rename "test group" to test_group;



alter table ab_test 
rename "total ads" to total_ads;


alter table ab_test 
rename "most ads day" to most_ads_day;



alter table ab_test 
rename "mosts ads hour" to most_ads_hour;


select * from ab_test limit 10;
