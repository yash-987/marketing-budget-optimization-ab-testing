select * from channels;

create table dim_channel as select channel_id, channel_name, medium as channel_medium  , is_paid 
from channels;

--channels table was fairly clean so that's it.
select * from dim_channel;




--validate
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT channel_id) AS distinct_ids,
    COUNT(*) FILTER (WHERE channel_id IS NULL) AS null_ids
FROM dim_channel;


--pkey
alter table dim_channel
add constraint pk_dim_channel
primary key (channel_id);