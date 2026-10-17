# Data Documentation

## Overview

This project uses two primary datasets to analyze marketing campaign performance and advertising effectiveness.

1. **Marketing Campaigns Dataset** — used for SQL-based campaign performance analysis, attribution analysis, and budget scenario evaluation.
2. **Marketing A/B Testing Dataset** — used for statistical analysis comparing advertising and PSA groups.

The datasets serve different analytical purposes and are not directly joined at the individual campaign level.

## Dataset 1 — Marketing Campaigns

### Purpose

The Marketing Campaigns dataset supports analysis of advertising performance across campaigns, channels, ad groups, dates, and conversion events.

### Main analytical use cases

- Campaign performance analysis.
- Channel performance comparison.
- Advertising spend and conversion value analysis.
- CTR, CPC, and cost per reported conversion.
- First-touch and last-touch attribution.
- Conversion touchpoint analysis.
- Campaign budget allocation scenarios.
- Historical versus expected conversion value comparisons.

### Processing

The source data was loaded into PostgreSQL and inspected before analytical transformations were created.

The processing workflow included:

1. Inspecting source table structures and data types.
2. Checking identifiers and duplicate records.
3. Reviewing missing values and data consistency.
4. Creating analytical dimension and fact tables.
5. Building campaign performance summaries.
6. Creating attribution and budget analysis views.
7. Validating analytical outputs against the source data.

### Analytical tables

The PostgreSQL model includes the following primary objects:

| Object | Purpose |
|---|---|
| `dim_channel` | Channel-level attributes |
| `dim_campaign` | Campaign-level attributes |
| `dim_ad_group` | Ad-group-level attributes |
| `fact_daily_performance` | Daily ad-group performance metrics |
| `fact_conversion` | Conversion-event and attribution data |
| `mart_campaign_performance` | Campaign-level performance summary |

### Analytical views

| View | Purpose |
|---|---|
| `vw_attribution_by_channel` | First-touch and last-touch attribution results by channel |
| `vw_attribution_comparison` | Comparison of attribution results across channels |
| `vw_conversion_touchpoints` | Conversion touchpoint analysis |
| `vw_campaign_budget_allocation` | Campaign budget allocation analysis |
| `vw_campaign_roas` | Campaign-level ROAS analysis |

These objects are created and maintained through the SQL workflow in the repository.

## Dataset 2 — Marketing A/B Testing

### Purpose

The A/B testing dataset supports statistical comparison of advertising and PSA groups.

The dataset contains user-level observations and includes the following fields:

| Column | Description |
|---|---|
| `user id` | Identifier for an experimental user |
| `test group` | Experimental group, such as `ad` or `psa` |
| `converted` | Binary conversion indicator |
| `total ads` | Total number of advertisements seen |
| `most ads day` | Day on which the user saw the most advertisements |
| `most ads hour` | Hour during which the user saw the most advertisements |

### Analytical use cases

- Conversion-rate comparison.
- Absolute conversion lift.
- Relative conversion lift.
- Two-proportion z-test.
- P-value and confidence interval interpretation.
- Conversion outcomes by experimental group.
- Descriptive analysis of conversion rates by advertising exposure.

### Processing

The dataset was analyzed using Python with pandas, NumPy, SciPy, and statsmodels.

The workflow included:

1. Inspecting the dataset structure.
2. Validating group sizes and conversion counts.
3. Calculating conversion rates.
4. Calculating absolute and relative lift.
5. Performing a two-proportion z-test.
6. Calculating and interpreting the confidence interval.
7. Exploring conversion behavior across advertising exposure levels.

The analysis was performed separately from the campaign-level PostgreSQL model because the dataset does not provide a suitable shared campaign identifier.

## Data Storage and Access

The source datasets may be subject to redistribution restrictions or repository size limits.

Before committing raw data files to GitHub:

- Verify the original dataset license.
- Confirm whether redistribution is permitted.
- Avoid uploading restricted or unnecessarily large source files.
- Provide source download instructions when direct redistribution is inappropriate.
- Document any transformations applied to the data.

If source files are not included in this repository, obtain them from the original dataset providers before reproducing the complete analysis.

## Dataset Sources

Complete the following fields using the original dataset pages:

### Marketing Campaigns Dataset

- **Dataset name:** Marketing Campaigns / Marketing Optimization
- **Original source:** [Insert the original dataset page]
- **License:** [Insert the documented license]
- **Format:** [Insert the actual source formats]
- **Local filename:** [Insert the filename or filenames]

### Marketing A/B Testing Dataset

- **Dataset name:** Marketing A/B Testing
- **Original source:** [Insert the original dataset page]
- **License:** [Insert the documented license]
- **Format:** Excel workbook
- **Local filename:** [Insert the actual filename]

## Related Documentation


- [`../README.md`](../README.md) — Project overview and methodology.
- [`../documentation/data_dictionary.md`](../documentation/data_dictionary.md) — Analytical data model and field definitions.
- [`../documentation/key_findings.md`](../documentation/key_findings.md) — Principal analytical findings.
