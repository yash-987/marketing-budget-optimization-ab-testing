select * from ab_test where 
user_id is null or 
test_group is null 
or converted is null 
or total_ads is null 
or most_ads_day is null
or most_ads_hour is null;

-- 0 null values

--creating table 
create table fact_ab_test_user as select 
user_id,
test_group,
converted,
total_ads,
most_ads_day,
most_ads_hour
from ab_test;



select * from fact_ab_test_user



--validations
select count(*) as total_rows,
count(distinct user_id) as distinct_ids,
count (*)filter (where user_id is null) as null_ids,
count(*) filter( where
test_group is null 
or converted is null 
or total_ads is null 
or most_ads_day is null
or most_ads_hour is null) as null_rows
from fact_ab_test_user


-- groups
--test groups
select test_group,count(*) from fact_ab_test_user
group by test_group;

-- -converted
select converted,count(*) from fact_ab_test_user
group by converted;

--most ads day
select most_ads_day , count(*) from fact_ab_test_user
group by most_ads_day

--total ads 
select min(total_ads) as min_ads,
max(total_ads) as max_ads
from fact_ab_test_user

--most ads hour
select min(most_ads_hour) as min_ads_hour,
max(most_ads_hour) as max_ads_hour
from fact_ab_test_user





--pkey
alter table fact_ab_test_user
add constraint pk_fact_ab_test_user
primary key (user_id)