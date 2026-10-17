select * from conversions;

--create table 
create table fact_conversion as 
select 
	* from 
	conversions;


select * from fact_conversion;

--validation
select count(*) from fact_conversion;

select count(*) as total_rows,
		count(distinct conversion_id) as distinct_ids,
		count(*) filter(where conversion_id is null) as null_ids,
		count(*) filter(where converted_at is null or revenue is null or touch_count is null or device is null) as rows_with_missing_metrics,
		count(*) filter(where revenue<0 or touch_count <=0) as negative_values
from fact_conversion;

--reference with dim_ad_group
select count(*) as orphan_rows 
from fact_conversion c
left join dim_ad_group ad
on c.ad_group_id = ad.ad_group_id
where ad.ad_group_id is null;

--reference with channel
select count(*) as orphan_rows
from fact_conversion fc
left join dim_channel dc
on fc.first_touch_channel_id = dc.channel_id
where dc.channel_id is null;

select count(*) as orphan_rows
from fact_conversion fc
left join dim_channel dc
on fc.last_touch_channel_id = dc.channel_id
where dc.channel_id is null;

--adding pkey and fkey
alter table fact_conversion
add constraint pk_fact_conversion
primary key (conversion_id);

alter table fact_conversion
add constraint fk_fact_conversion
foreign key (ad_group_id)
references dim_ad_group(ad_group_id);

alter table fact_conversion
add constraint fk_fact_conversion_first_touch
foreign key(first_touch_channel_id)
references dim_channel (channel_id);

alter table fact_conversion
add constraint fk_fact_conversion_last_touch
foreign key(last_touch_channel_id)
references dim_channel (channel_id);