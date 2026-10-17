-- first touch  vs last touch attributions
create or replace view vw_attribution_by_channel as
with a as (
select 
	'First Touch' as attribution_model,
	first_touch_channel_id as channel_id,
	conversion_id,
	revenue
from fact_conversion
union all
select 
	'Last Touch' as attribution_model,
	Last_touch_channel_id as channel_id,
	conversion_id,
	revenue
from fact_conversion
)
select  a.attribution_model,
		a.channel_id,
		count(distinct a.conversion_id) as conversions,
		sum(a.revenue) as attributed_revenue,
		ROUND(
        100.0 * SUM(a.revenue)
        / NULLIF(
            SUM(SUM(a.revenue)) OVER (
                PARTITION BY a.attribution_model
            ),
            0
        ),
        2
    	) AS revenue_share_pct
from a
join dim_channel c
on a.channel_id = c.channel_id 
group by a.attribution_model,a.channel_id



--validation 
SELECT *
FROM vw_attribution_by_channel
ORDER BY attribution_model, attributed_revenue DESC;


-- difference between attribution models

--creating the type for composite type id 
create type channel_id_identifier as (
first_touch int,
last_touch int
);


create or replace view vw_attribution_comparison as 
with first_touch as (
select 
first_touch_channel_id as channel_id,
count(distinct conversion_id) as conversions,
sum(revenue) as revenue
from fact_conversion
group by first_touch_channel_id
),
last_touch as (
select 
last_touch_channel_id as channel_id,
count(distinct conversion_id) as conversions,
sum(revenue) as revenue
from fact_conversion
group by last_touch_channel_id
)
select 
f.channel_id::int AS channel_id,
f.conversions as first_touch_conversions,
l.conversions as last_touch_conversion,
(l.conversions-f.conversions) as conversion_difference,
f.revenue as first_touch_revenue,
l.revenue as last_touch_revenue,
(l.revenue-f.revenue) as revenue_difference
from first_touch f 
full outer join last_touch l
on f.channel_id = l.channel_id



--validation
SELECT *
FROM vw_attribution_comparison
ORDER BY ABS(revenue_difference) DESC NULLS LAST;

--conversion touchpoints
CREATE OR REPLACE VIEW vw_conversion_touchpoints AS
select touch_count,
count(distinct conversion_id) as conversions,
sum(revenue) as total_revenue,
round(avg(revenue),2) as avg_revenue_per_conversion
from fact_conversion
group by touch_count

--validation
SELECT *
FROM vw_conversion_touchpoints
ORDER BY touch_count;


--marketing spend per campaign
CREATE OR REPLACE VIEW vw_campaign_budget_allocation AS
select campaign_id,
total_spend,
reported_conversions,
reported_conversion_value,
round(100.0 * total_spend/nullif(sum(total_spend) over(),0),2) as spending_share_pct
from mart_campaign_performance


--validation 
SELECT *
FROM vw_campaign_budget_allocation
ORDER BY total_spend DESC;

--campaign level roas
CREATE OR REPLACE VIEW vw_campaign_roas AS
select campaign_id,
total_spend,
reported_conversion_value,
round(reported_conversion_value/nullif(total_spend,0),4) as roas
from mart_campaign_performance;

--validation
SELECT *
FROM vw_campaign_roas
ORDER BY roas DESC NULLS LAST;

--budget reallocation
--  Campaign budget scenario inputs

SELECT
    COUNT(*) AS campaign_count,
    COUNT(*) FILTER (
        WHERE total_spend > 0
    ) AS campaigns_with_spend,
    COUNT(*) FILTER (
        WHERE total_spend > 0
          AND reported_conversion_value IS NOT NULL
    ) AS campaigns_with_spend_and_value,
    SUM(total_spend) AS total_observed_spend,
    SUM(reported_conversion_value) AS total_reported_value
FROM mart_campaign_performance;

