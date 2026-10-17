select * from daily_performance;


--create table
create table fact_daily_performance as 
select performance_id,
ad_group_id,
activity_date,
impressions,
clicks,
spend
conversions as reported_conversions,
conversion_value as reported_conversion_value
from daily_performance;

select * from fact_daily_performance;


--validation
select count(*) from fact_daily_performance;

select 
	count(*) as total_rows,
	count(distinct performance_id) as distinct_ids,
	 COUNT(*) FILTER (
        WHERE performance_id IS NULL
    ) AS null_ids,
	COUNT(*) FILTER (
        WHERE impressions IS NULL
           OR clicks IS NULL
           OR spend IS NULL
           OR reported_conversions IS NULL
           OR reported_conversion_value IS NULL
    ) AS rows_with_missing_metrics,
	count(*) filter(where  impressions<clicks) as invalid_values,
	count(*) filter(where impressions<0 or clicks<0 or spend<0 or reported_conversions<0 or reported_conversion_value <0) as negative_values
from fact_daily_performance;

--reference with dim_ad_group
SELECT COUNT(*) AS orphan_ad_group_rows
FROM fact_daily_performance f
LEFT JOIN dim_ad_group ag
    ON f.ad_group_id = ag.ad_group_id
WHERE ag.ad_group_id IS NULL;
-- clear



--adding pkey and fkey
alter table fact_daily_performance
add constraint pk_fact_daily_performance
primary key(performance_id);


alter table fact_daily_performance
add constraint fk_fact_daily_performance
foreign key(ad_group_id)
references dim_ad_group(ad_group_id);



