select * from ab_test;

--creating table 
create table mart_ab_test_summary as 
with cte1 as (
select test_group, 
count(user_id) as user_count, 
count(*) filter(where converted = 'true') as converted_users,
round(avg(total_ads),2) as ads_seen 
from ab_test 
group by test_group
)
select test_group,
user_count,
converted_users,
round(converted_users*100.0/user_count,2)as conversion_rate,
ads_seen
from cte1


select * from mart_ab_test_summary;

-- validations
-- Row count and primary key quality
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT test_group) AS distinct_groups,
    COUNT(*) FILTER (WHERE test_group IS NULL) AS null_groups
FROM mart_ab_test_summary;

-- Check summary calculations against the user-level table
SELECT
    test_group,
    COUNT(*) AS expected_user_count,
    COUNT(*) FILTER (WHERE converted = TRUE) AS expected_converted_users,
    ROUND(
        COUNT(*) FILTER (WHERE converted = TRUE) * 100.0 / COUNT(*),
        2
    ) AS expected_conversion_rate,
    ROUND(AVG(total_ads), 2) AS expected_ads_seen
FROM fact_ab_test_user
GROUP BY test_group;



-- Check for impossible values
SELECT *
FROM mart_ab_test_summary
WHERE user_count <= 0
   OR converted_users < 0
   OR converted_users > user_count
   OR conversion_rate < 0
   OR conversion_rate > 100
   OR ads_seen < 0;
 -- 0 rows

--pkey
ALTER TABLE mart_ab_test_summary
ADD CONSTRAINT pk_mart_ab_test_summary
PRIMARY KEY (test_group);
