-- channels --------------------------------------------------------------------------
select * from channels;
-- 9 rows 


-- duplicate pkeys
select count(*) as total_rows, count(distinct channel_id) as distinct_rows
from channels;	
--0 duplicate

-- null channel id 
select count(*) from channels where channel_id is null;
-- 0

--referential integrity with campaigns table
select * from campaigns;

select c.channel_id, cp.campaign_id from channels c
left join campaigns cp
on c.channel_id = cp.channel_id
order by channel_id;


select cp.campaign_id, c.channel_id from campaigns cp
left join channels c
on cp.channel_id = c.channel_id
where c.channel_id is null;
-- 0 rows 
-- for every campaign id there is a channel id and vice versa


--channels table is clean--------------------------------------------------------------------



--campaigns

select * from campaigns;
--600 rows


-- duplicate pkeys
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS distinct_ids,
    COUNT(*) - COUNT(DISTINCT campaign_id) AS duplicate_or_null_rows
FROM campaigns;
-- 0 duplicate pkeys

-- null campaign ids
SELECT COUNT(*) AS null_campaign_ids
FROM campaigns
WHERE campaign_id IS NULL;
-- 0 


--referential integrity
--with channels alredy done. 
--with ad_groups:

select cp.campaign_id,ad.ad_group_id from campaigns cp
left join ad_groups ad
on cp.campaign_id = ad.campaign_id
order by cp.campaign_id;
--3084 rows that means 84 campaign ids have no referenced ad group id
--also one to many relationship

SELECT
    cp.campaign_id,
    cp.campaign_name,
    cp.started_on,
    cp.ended_on,
    cp.budget
FROM campaigns cp
LEFT JOIN ad_groups ag
    ON cp.campaign_id = ag.campaign_id
WHERE ag.ad_group_id IS NULL
ORDER BY cp.campaign_id;
--these are 84 rows who have no corresponding ad_group_id
-- findings : the campaign_names who are repeated with a number : for example spring lunch uk has an ad group but spring launch  uk 2 doesn't. this suggests that a campaign which ran 2nd time might not have an ad group.


select channel_id, count(campaign_id) from campaigns
group by channel_id;
--9 distinct channel ids

---other data quality checks
--null values
select count(*) from campaigns 
where campaign_name is null
or campaign_id is null
or objective is null
or started_on is null
or ended_on is null 
or budget is null;
--only ended on date have null values, 127 rows out of 600

select * from campaigns where ended_on is null;

--negative values 
select count(*) from campaigns 
where budget <=0;

--distinct objectives
select distinct objective, count(*) from campaigns
group by objective;

select * from campaigns;

--campaign name is not blank 
SELECT *
FROM campaigns
WHERE campaign_name IS NULL
   OR BTRIM(campaign_name) = '';
 -- no blank name

--duplicate campaign name
SELECT
    campaign_name,
    COUNT(*) AS name_count
FROM campaigns
GROUP BY campaign_name
HAVING COUNT(*) > 1;
-- 0 

--invalid dates
select count(*) from campaigns where started_on>ended_on;
---campaigns table completed------------------------------------------------------------------------------------



--ad groups-------
select * from ad_groups;
--3000 rows


--duplicate pkeys
select count(*) as total_rows,
count(distinct ad_group_id) as distinct_rows,
count(*) - count(distinct ad_group_id) as duplicate_rows
from ad_groups;
--0 duplicate pkeys 

--null ad group ids
select count(*) from ad_groups where ad_group_id is null;

select campaign_id, count(ad_group_id) from ad_groups 
group by campaign_id;
--516 distinct campaign ids


--referential integrity
--with campaigns already done;
--with daily_performance:
select ad.ad_group_id, dp.performance_id
from ad_groups ad 
left join daily_performance dp
on ad.ad_group_id = dp.ad_group_id;
--260000 rows = fine

select ad.ad_group_id, dp.performance_id
from ad_groups ad 
left join daily_performance dp
on ad.ad_group_id = dp.ad_group_id
where dp.performance_id is null;
--every adgroup id has a row in daily performance

select dp.ad_group_id from 
daily_performance dp 
left join 
ad_groups ad 
on dp.ad_group_id = ad.ad_group_id
where ad.ad_group_id is null;
-- 0 rows that means every performance has a valid ad group in ad group table

--with conversions:
select ad.ad_group_id, c.conversion_id
from ad_groups ad
left join conversions c
on ad.ad_group_id = c.ad_group_id;
-- 40000 rows = fine


select ad.ad_group_id, c.conversion_id
from ad_groups ad
left join conversions c
on ad.ad_group_id = c.ad_group_id
where c.conversion_id is null;
-- 0 null that means for every ad_group id there exist a row in conversions

--reverse
select c.ad_group_id
from conversions c 
left join ad_groups ad
on c.ad_group_id = ad.ad_group_id
where ad.ad_group_id is null;
-- 0 that means for every conversion point to a valid entry in ad groups table



--other data quality checks
--null values 
select count(*) from ad_groups where
ad_group_name is null or
target_audience is null 
or status is null;
--0 null values

--distinct target audience
select target_audience, count(*) from ad_groups 
group by target_audience;
--382 are interest, 249 are custom_list, 777 are broad, 464 are in_market, 543 are remarketing, 585 are lookalike

--distinct status
select status,count(*) from ad_groups 
group by status;
-- 243 archived, 2112 active and 645 paused


---ad groups completed---------------------------------------------------------------------------------------------------



--daily performance---------------------
select * from daily_performance;
-- 260000 rows

--duplicate pkeys
select count(distinct performance_id) from daily_performance;
--260000 rows = no duplicate values

-- null performance id 
select count(*) from daily_performance where performance_id is null;
--0


select ad_group_id, count(performance_id) from daily_performance 
group by ad_group_id;
---3000 rows = fine


SELECT
    ad_group_id,
    activity_date,
    COUNT(*) AS row_count
FROM daily_performance
GROUP BY ad_group_id, activity_date
HAVING COUNT(*) > 1;
-- 0 rows with same ad group id and same activity date: activity date is different for each row


-- referential integrity check 
-- with ad_group done already done above.
-- with conversions: no relation. so no need for referential integrity check for daily performance


--other data quality checks
-- null values 
select count(*) from daily_performance where
ad_group_id is null or
activity_date is null or 
Impressions is null or 
clicks is null or
spend is null or 
conversions is null
or conversion_value is null;
-- 0 null values;

--negative values
select count(*) from daily_performance where
impressions <0 or clicks <0 or spend < 0 or conversions< 0 or conversion_value <0
-- no negative values

--invalid value
select count(*) from daily_performance where
clicks = 0 and conversion_value >0;
-- no invalid value

select count(*) from daily_performance where
(impressions = 0 and clicks >0
)
or (impressions = 0 and spend>0) 
or (impressions = 0 and conversions >0);
-- 0

select * from daily_performance 
where clicks > impressions;
-- 0 rows

--date ranges
select min(activity_date) as min_activity_date,max(activity_date) as max_activity_date
from daily_performance;
-- min : 9/1/2024, max : 31/12/2025

---daily performance completed---------------------------------------------------------------------------------------------------


---conversions -----------------------
select * from conversions;
--40000 rows

--duplicate pkeys
select count(*) as total_rows,
count(distinct conversion_id) as distinct_conversions,
count(*) - count(distinct conversion_id) as duplicate_conversions
from conversions;
-- 40000 that means 0 duplicate pkeys

-- null conversion id
select count(*) from conversions where conversion_id is null;
--0 

select ad_group_id, count(conversion_id) from conversions
group by ad_group_id;
--- 3000 rows = fine


---referential integrity check
-- with ad_groups : already done in adgroups part
-- with channel : 
SELECT
    c.conversion_id,
    c.first_touch_channel_id
FROM conversions c
LEFT JOIN channels ch
    ON c.first_touch_channel_id = ch.channel_id
WHERE ch.channel_id IS NULL;
-- 0 rows

SELECT
    c.conversion_id,
    c.last_touch_channel_id
FROM conversions c
LEFT JOIN channels ch
    ON c.last_touch_channel_id = ch.channel_id
WHERE ch.channel_id IS NULL;
-- 0 rows

---other data quality checks
--null values
select count(*) from conversions where first_touch_channel_id is null or 
last_touch_channel_id is null 
or converted_at is null 
or revenue is null 
or touch_count is null
or device is null;
-- 0 null values

-- negative values 
select count(*) from conversions where 
first_touch_channel_id <0 or 
last_touch_channel_id <0 
or revenue <0 
or touch_count <=0;
-- 0 rows 


--distinct device
select device, count(*) from conversions 
group by device;
-- 3 distinct device
-- mobile 21595
-- desktop 14439
-- tablet 3966

-- min and max conversion date
select min(converted_at) as earliest_converion, max(converted_at) as latest_conversion from conversions;
-- earliest : 01/01/2024 , latest : 31/12/2025
--conversions completed--------------------------------------------------------------------------------------