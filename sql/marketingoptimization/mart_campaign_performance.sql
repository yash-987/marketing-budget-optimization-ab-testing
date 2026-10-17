--camapaign level performance
--creating table
create table mart_campaign_performance as
with dp_ad_camp as (
select 
		ad.campaign_id,
	   sum(fd.impressions) as total_impressions,
	   sum(fd.clicks)as total_clicks,
	   sum(fd.spend)as total_spend,
	   sum(reported_conversions) as reported_conversions, 
	  sum(reported_conversion_value)as reported_conversion_value
from dim_ad_group ad
left join fact_daily_performance fd
on ad.ad_group_id = fd.ad_group_id
group by ad.campaign_id
)
select 
	c.campaign_id,
	coalesce(dp.total_impressions,0) as total_impressions,
	coalesce(dp.total_clicks,0) as total_clicks,
	coalesce(dp.total_spend,0) as total_spend,
	coalesce(dp.reported_conversions,0) as reported_conversions,
	coalesce(dp.reported_conversion_value,0) as reported_conversion_value,
	ROUND(dp.total_clicks::numeric * 100/ NULLIF(dp.total_impressions, 0), 2) AS ctr,
	ROUND(dp.total_spend/nullif(dp.total_clicks,0),2) as cpc,
	ROUND((dp.total_spend/nullif(dp.total_impressions,0))*1000,2) as cpm,
	ROUND(dp.total_spend/nullif(dp.reported_conversions,0),2) as cost_per_reported_conversion
from dim_campaign c
left join dp_ad_camp dp
on c.campaign_id = dp.campaign_id



select * from mart_campaign_performance

	
-- validations
-- row count and primary key quality
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS distinct_campaign_ids,
    COUNT(*) FILTER (
        WHERE campaign_id IS NULL
    ) AS null_campaign_ids
FROM mart_campaign_performance;


-- missing records
SELECT
    dc.campaign_id
FROM dim_campaign dc
LEFT JOIN mart_campaign_performance m
    ON dc.campaign_id = m.campaign_id
WHERE m.campaign_id IS NULL;

--campaign IDs that don't exist in the dimension
SELECT COUNT(*) AS orphan_campaign_rows
FROM mart_campaign_performance m
LEFT JOIN dim_campaign dc
    ON m.campaign_id = dc.campaign_id
WHERE dc.campaign_id IS NULL;

--missing and negative metrics
SELECT
    COUNT(*) FILTER (
        WHERE total_impressions IS NULL
           OR total_clicks IS NULL
           OR total_spend IS NULL
           OR reported_conversions IS NULL
           OR reported_conversion_value IS NULL
    ) AS rows_with_missing_metrics,

    COUNT(*) FILTER (
        WHERE total_impressions < 0
           OR total_clicks < 0
           OR total_spend < 0
           OR reported_conversions < 0
           OR reported_conversion_value < 0
    ) AS rows_with_negative_metrics,

    COUNT(*) FILTER (
        WHERE total_clicks > total_impressions
    ) AS clicks_exceeding_impressions
FROM mart_campaign_performance;


--incorrect ratios
SELECT COUNT(*) AS rows_with_incorrect_ratios
FROM mart_campaign_performance
WHERE
    (
        ctr IS DISTINCT FROM
        ROUND(
            total_clicks::numeric * 100
            / NULLIF(total_impressions, 0),
            2
        )
    )
    OR
    (
        cpc IS DISTINCT FROM
        ROUND(
            total_spend::numeric
            / NULLIF(total_clicks, 0),
            2
        )
    )
    OR
    (
        cpm IS DISTINCT FROM
        ROUND(
            total_spend::numeric * 1000
            / NULLIF(total_impressions, 0),
            2
        )
    )
    OR
    (
        cost_per_reported_conversion IS DISTINCT FROM
        ROUND(
            total_spend::numeric
            / NULLIF(reported_conversions, 0),
            2
        )
    );


-- if campaign-level sums are distinct with this record
WITH source_totals AS (
    SELECT
        ad.campaign_id,
        SUM(fd.impressions) AS total_impressions,
        SUM(fd.clicks) AS total_clicks,
        SUM(fd.spend) AS total_spend,
        SUM(fd.reported_conversions) AS reported_conversions,
        SUM(fd.reported_conversion_value) AS reported_conversion_value
    FROM dim_ad_group ad
    JOIN fact_daily_performance fd
        ON ad.ad_group_id = fd.ad_group_id
    GROUP BY ad.campaign_id
)
SELECT
    m.campaign_id
FROM mart_campaign_performance m
JOIN source_totals s
    ON m.campaign_id = s.campaign_id
WHERE m.total_impressions IS DISTINCT FROM s.total_impressions
   OR m.total_clicks IS DISTINCT FROM s.total_clicks
   OR m.total_spend IS DISTINCT FROM s.total_spend
   OR m.reported_conversions IS DISTINCT FROM s.reported_conversions
   OR m.reported_conversion_value
      IS DISTINCT FROM s.reported_conversion_value;

	  
-- pkey and fkey
ALTER TABLE mart_campaign_performance
ADD CONSTRAINT pK_mart_campaign_performance
PRIMARY KEY(campaign_id)

ALTER TABLE mart_campaign_performance
ADD CONSTRAINT fk_mart_campaign_performance
FOREIGN KEY (campaign_id)
REFERENCES dim_campaign(campaign_id);


