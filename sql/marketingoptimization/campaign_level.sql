select * from campaigns;

--creating the table
create table dim_campaign as 
select campaign_id,
campaign_name, 
channel_id,
objective,
started_on,
ended_on,
budget,
ended_on::DATE - started_on::DATE as duration_days
from campaigns;


--validate
SELECT COUNT(*) FROM dim_campaign;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS distinct_ids,
    COUNT(*) FILTER (WHERE campaign_id IS NULL) AS null_ids,
    COUNT(*) FILTER (WHERE ended_on IS NULL) AS unknown_end_dates,
    COUNT(*) FILTER (WHERE duration_days IS NULL) AS unknown_durations
FROM dim_campaign;


--adding pkey and fkey
alter table dim_campaign
add constraint pk_dim_campaign
primary key(campaign_id);


alter table dim_campaign
add constraint fk_dim_campaign
foreign key (channel_id)
references dim_channel(channel_id);

