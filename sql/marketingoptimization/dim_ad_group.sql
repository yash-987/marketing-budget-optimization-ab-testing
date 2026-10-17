select * from ad_groups;


--creating the table
create table dim_ad_group as 
select ad_group_id,
campaign_id,
ad_group_name,
target_audience,
status
from ad_groups;

--validate
select count(*) from dim_ad_group;

select 
count(*) as total_rows,
count(distinct ad_group_id) as distinct_ids,
count(*) filter(where ad_group_id is null) as null_ids,
count(*) filter (where target_audience is null) as null_audiences
from dim_ad_group;

-- Checking missing campaign references
SELECT COUNT(*) AS null_campaign_ids
FROM dim_ad_group
WHERE campaign_id IS NULL;

-- Checking ad groups referencing nonexistent campaigns
SELECT ag.ad_group_id, ag.campaign_id
FROM dim_ad_group ag
LEFT JOIN dim_campaign c
    ON ag.campaign_id = c.campaign_id
WHERE c.campaign_id IS NULL;

-- one row per ad group  per day
SELECT
    ad_group_id,
    activity_date,
    COUNT(*) AS row_count
FROM fact_daily_performance
GROUP BY ad_group_id, activity_date
HAVING COUNT(*) > 1;


-- distinct status
select status, count(*) from dim_ad_group
group by status;


--adding pkeys and fkeys
alter table dim_ad_group
add constraint pk_dim_ad_group
primary key(ad_group_id);

alter table dim_ad_group
add constraint fk_dim_ad_group
foreign key (campaign_id)
references dim_campaign(campaign_id);



