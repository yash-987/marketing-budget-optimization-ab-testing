# Data Dictionary

## 1. Overview

This document describes the analytical data model used in the Marketing Budget Optimization & A/B Testing project.

The PostgreSQL model contains dimension tables, fact tables, campaign-level summary data, and analytical views.

The A/B testing dataset is analyzed separately in Python.

The model is designed to support campaign performance analysis, attribution comparisons, and budget scenario evaluation.

## 2. Data Model Overview

### Dimension tables

| Table | Intended grain | Purpose |
|---|---|---|
| `dim_channel` | One row per channel | Channel attributes |
| `dim_campaign` | One row per campaign | Campaign attributes and budget information |
| `dim_ad_group` | One row per ad group | Ad-group attributes and campaign association |

### Fact and summary tables

| Table | Intended grain | Purpose |
|---|---|---|
| `fact_daily_performance` | One row per ad group per activity date | Daily advertising performance |
| `fact_conversion` | One row per conversion event | Conversion values, timestamps, and attribution information |
| `mart_campaign_performance` | One row per campaign | Aggregated campaign performance |
| `fact_ab_test_user` | One row per experimental user | User-level A/B testing analysis |

## 3. Dimension Tables

### 3.1 `dim_channel`

**Grain:** One row per channel.

**Purpose:** Provides channel-level information for comparing marketing performance across acquisition channels.

| Column | Description |
|---|---|
| `channel_id` | Channel identifier and primary key |
| `channel_name` | Human-readable channel name |

Additional columns should be documented if present in the final SQL table.

### 3.2 `dim_campaign`

**Grain:** One row per campaign.

**Purpose:** Stores campaign-level attributes used for performance reporting and budget analysis.

| Column | Description |
|---|---|
| `campaign_id` | Campaign identifier and primary key |
| `campaign_name` | Human-readable campaign name |
| Campaign attributes | Additional descriptive fields available in the source |
| Budget attributes | Campaign budget-related fields available in the model |
| Duration attributes | Campaign duration information where available |

Use the actual SQL schema to document the exact names and data types of the additional columns.

### 3.3 `dim_ad_group`

**Grain:** One row per ad group.

**Purpose:** Represents ad groups and their relationships to campaigns.

| Column | Description |
|---|---|
| Ad group identifier | Unique ad group key |
| Campaign identifier | Associated campaign key |
| Additional attributes | Descriptive ad-group fields available in the source |

Replace the descriptive labels above with the exact column names from PostgreSQL.

## 4. Fact Tables

### 4.1 `fact_daily_performance`

**Grain:** One row per ad group per activity date.

**Purpose:** Stores daily advertising performance metrics.

| Column | Description |
|---|---|
| Ad group identifier | Identifies the ad group |
| Activity date | Date of the performance record |
| `impressions` | Number of recorded impressions |
| `clicks` | Number of recorded clicks |
| `spend` | Recorded advertising spend |
| `reported_conversions` | Number of reported conversions |
| `reported_conversion_value` | Recorded value associated with reported conversions |

The identifier and date columns should be documented using their exact names from the SQL schema.

**Key analytical consideration:** This table supports time-series analysis and date-filtered Power BI metrics.

### 4.2 `fact_conversion`

**Grain:** One row per conversion event.

**Purpose:** Supports conversion-event analysis and attribution comparisons.

| Column | Description |
|---|---|
| Conversion identifier | Identifies the conversion event, if present |
| `first_touch_channel` | First-touch channel attribution |
| `last_touch_channel` | Last-touch channel attribution |
| `converted_at` | Conversion timestamp |
| `revenue` | Revenue or conversion value associated with the event |
| `touch_count` | Number of recorded touchpoints |
| `device` | Device information, where available |

Use the actual SQL column names if the first-touch and last-touch fields are stored as identifiers rather than channel names.

**Key analytical consideration:** Conversion-event counts should not automatically be treated as unique customers. The table's grain is a conversion event, not necessarily a person.

### 4.3 `mart_campaign_performance`

**Grain:** One row per campaign.

**Purpose:** Provides a campaign-level summary of advertising performance.

| Column | Description |
|---|---|
| `campaign_id` | Campaign identifier |
| `total_impressions` | Total recorded impressions |
| `total_clicks` | Total recorded clicks |
| `total_spend` | Total advertising spend |
| `reported_conversions` | Total reported conversions |
| `reported_conversion_value` | Total reported conversion value |
| `ctr` | Click-through rate |
| `cpc` | Cost per click |
| `cpm` | Cost per thousand impressions |
| `cost_per_reported_conversion` | Spend per reported conversion |

**Key analytical consideration:** This mart is an aggregate of performance data. Do not add its totals to the corresponding daily fact totals, as they represent the same underlying activity at different levels of detail.

### 4.4 `fact_ab_test_user`

**Grain:** One row per experimental user.

**Purpose:** Supports the comparison of advertising and PSA groups.

| Column | Description |
|---|---|
| `user id` | Experimental user identifier |
| `test group` | Group assignment label |
| `converted` | Binary conversion indicator |
| `total ads` | Total advertisements seen |
| `most ads day` | Day associated with the user's highest ad exposure |
| `most ads hour` | Hour associated with the user's highest ad exposure |

This table is analyzed separately from the campaign performance model because it has no suitable campaign identifier for a direct join.

## 5. Analytical Views

### 5.1 `vw_attribution_by_channel`

**Purpose:** Summarizes attributed conversion and conversion-value metrics by channel under the first-touch and last-touch attribution approaches.

### 5.2 `vw_attribution_comparison`

**Purpose:** Compares channel-level results between attribution approaches.

### 5.3 `vw_conversion_touchpoints`

**Purpose:** Supports analysis of the number and pattern of recorded touchpoints associated with conversions.

### 5.4 `vw_campaign_budget_allocation`

**Purpose:** Supports campaign-level budget allocation analysis.

### 5.5 `vw_campaign_roas`

**Purpose:** Provides campaign-level ROAS calculations using the fields defined in the view.

The exact columns and calculation logic for each view should be documented from the corresponding SQL definitions.

## 6. Core Metric Definitions

### Click-Through Rate (CTR)

CTR measures the proportion of impressions that resulted in clicks.

CTR = Total Clicks / Total Impressions

### Cost Per Click (CPC)

CPC measures advertising spend per recorded click.

CPC = Total Advertising Spend / Total Clicks

### Cost Per Thousand Impressions (CPM)

CPM measures advertising spend per thousand recorded impressions.

CPM = (Total Advertising Spend / Total Impressions) × 1,000

### Cost Per Reported Conversion

Cost Per Reported Conversion = Total Advertising Spend / Total Reported Conversions

This is not necessarily customer acquisition cost because a reported conversion may not represent a unique newly acquired customer.

### Return on Ad Spend (ROAS)

ROAS = Reported Conversion Value / Advertising Spend

ROAS measures reported conversion value relative to advertising spend. It does not account for all costs and should not be interpreted as profit.

### Conversion Rate

For the A/B testing dataset:

Conversion Rate = Converted Users / Total Users

### Absolute Conversion Lift

Absolute Lift = Advertising Conversion Rate − PSA Conversion Rate

The difference is reported in percentage points when both conversion rates are expressed as percentages.

### Relative Conversion Lift

Relative Lift = (Advertising Conversion Rate − PSA Conversion Rate) / PSA Conversion Rate

This expresses the conversion-rate difference relative to the PSA group's baseline rate.

## 7. Data Modeling Considerations

- Dimension tables provide descriptive attributes for analytical filtering.
- Daily performance facts support date-based metrics.
- Campaign performance marts support campaign-level summaries.
- Conversion facts support conversion-event and attribution analysis.
- The A/B testing dataset remains separate from campaign tables.
- Historical and proposed budget values should be reconciled with the Excel scenario workbook.
- Measures from different levels of detail should not be summed together when they represent the same underlying activity.

## 8. Validation Requirements

Before using the model for additional analysis, validate:

- Primary key uniqueness.
- Foreign key consistency.
- Table grain.
- Missing values and data types.
- Reconciliation of campaign-level summaries with daily facts.
- Reconciliation of budget scenario values with Excel.
- Consistency of metric definitions across SQL, Python, Excel, and Power BI.
