-- Marketing Campaigns
--
-- Channels, campaigns, ad groups and two years of daily performance for a multi-channel marketing program.
--
-- Run this from the directory holding the data files:
--   duckdb -c ".read marketing_campaigns.schema.sql"

CREATE TABLE channels (
  channel_id INTEGER NOT NULL,
  channel_name VARCHAR NOT NULL,
  medium VARCHAR NOT NULL,
  is_paid BOOLEAN NOT NULL,
  PRIMARY KEY (channel_id)
);

CREATE TABLE campaigns (
  campaign_id INTEGER NOT NULL,
  campaign_name VARCHAR NOT NULL,
  channel_id INTEGER NOT NULL,
  objective VARCHAR NOT NULL,
  started_on DATE NOT NULL,
  ended_on DATE,
  budget DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (campaign_id),
  FOREIGN KEY (channel_id) REFERENCES channels (channel_id)
);

CREATE TABLE ad_groups (
  ad_group_id INTEGER NOT NULL,
  campaign_id INTEGER NOT NULL,
  ad_group_name VARCHAR NOT NULL,
  target_audience VARCHAR NOT NULL,
  status VARCHAR NOT NULL,
  PRIMARY KEY (ad_group_id),
  FOREIGN KEY (campaign_id) REFERENCES campaigns (campaign_id)
);

CREATE TABLE daily_performance (
  performance_id INTEGER NOT NULL,
  ad_group_id INTEGER NOT NULL,
  activity_date DATE NOT NULL,
  impressions INTEGER NOT NULL,
  clicks INTEGER NOT NULL,
  spend DECIMAL(12,2) NOT NULL,
  conversions INTEGER NOT NULL,
  conversion_value DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (performance_id),
  FOREIGN KEY (ad_group_id) REFERENCES ad_groups (ad_group_id)
);

CREATE TABLE conversions (
  conversion_id INTEGER NOT NULL,
  ad_group_id INTEGER NOT NULL,
  first_touch_channel_id INTEGER NOT NULL,
  last_touch_channel_id INTEGER NOT NULL,
  converted_at TIMESTAMP NOT NULL,
  revenue DECIMAL(12,2) NOT NULL,
  touch_count INTEGER NOT NULL,
  device VARCHAR NOT NULL,
  PRIMARY KEY (conversion_id),
  FOREIGN KEY (ad_group_id) REFERENCES ad_groups (ad_group_id),
  FOREIGN KEY (first_touch_channel_id) REFERENCES channels (channel_id),
  FOREIGN KEY (last_touch_channel_id) REFERENCES channels (channel_id)
);


CREATE EXTENSION pg_parquet;
copy channels from '/tmp/marketing/channels.parquet' with (format 'parquet')
copy campaigns from '/tmp/marketing/campaigns.parquet' with (format 'parquet')
copy ad_groups from '/tmp/marketing/ad_groups.parquet' with (format 'parquet')
copy daily_performance from '/tmp/marketing/daily_performance.parquet' with (format 'parquet')
copy conversions from '/tmp/marketing/conversions.parquet' with (format 'parquet');



-- verifying tables and associated rows 
SELECT 'channels' AS table_name, COUNT(*) AS row_count
FROM channels

UNION ALL

SELECT 'campaigns', COUNT(*) FROM campaigns

UNION ALL

SELECT 'ad_groups', COUNT(*) FROM ad_groups

UNION ALL

SELECT 'daily_performance', COUNT(*) FROM daily_performance

UNION ALL

SELECT 'conversions', COUNT(*) FROM conversions;
