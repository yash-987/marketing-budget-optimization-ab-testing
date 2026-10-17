# Raw Data Quality Audit

## 1. Objective

The purpose of this audit was to assess the integrity, completeness, consistency, and analytical suitability of the raw marketing campaign dataset before building the analytical data model.

The audit covered five tables:

- `channels`
- `campaigns`
- `ad_groups`
- `daily_performance`
- `conversions`

## 2. Validation Checks

The following checks were performed:

- Primary-key uniqueness and null-ID checks
- Foreign-key integrity between related tables
- Missing-value checks for important columns
- Duplicate checks at the expected data grain
- Date-range and date-consistency checks
- Negative-value and business-rule validations
- Category distributions for campaign-related attributes
- Relationship checks between campaigns, ad groups, performance records, and conversions

## 3. Key Findings

### Campaigns Without Associated Ad Groups

**Finding:** The final audit identified 84 campaign records without an associated ad group.

**Validation method:** A left join was performed from `campaigns` to `ad_groups`, filtering for campaigns without a matching ad-group record.

**Investigation:** Some campaign names appear to follow a numbered naming pattern. This could indicate repeated campaign creation or incomplete configuration, but the names alone do not establish the cause.

**Decision:** Retain these records in the raw dataset. Do not delete them or classify them as duplicates solely because they lack associated ad groups. Investigate their relevance during analytical modeling and document any exclusions from specific analyses.

### Campaigns With Missing End Dates

**Finding:** 127 campaign records have a null `ended_on` value.

**Interpretation:** A missing end date does not establish whether a campaign was still running, had ended, or had incomplete metadata.

**Decision:** Preserve the null values in the raw data. Do not infer campaign status from the missing date alone.

## 4. Data Integrity and Business-Rule Checks

The audit also checked:

- Uniqueness and null values of primary identifiers
- Referential integrity between related tables
- Duplicate records at the `ad_group_id` and `activity_date` grain in `daily_performance`
- Missing values in important performance and conversion fields
- Negative impressions, clicks, spend, conversions, or revenue
- Clicks exceeding impressions
- Positive activity recorded against zero impressions
- Conversion attribution references to valid channels
- Conversion date coverage relative to daily performance dates

Record the final results of these checks here, including any exceptions that require further investigation.

## 5. Analytical Decisions

- Raw tables remain unchanged.
- Findings are documented rather than silently corrected or deleted.
- Unmatched campaigns will be assessed according to the requirements of each analysis.
- Missing end dates remain unknown until supported by additional evidence.
- Performance aggregates and conversion-event records will be reconciled before combining metrics to avoid double-counting.
- The grain of each table will be respected when creating analytical tables and joining datasets.

## 6. Audit Status

**Status:** Complete — initial raw-data validation.

The dataset has undergone structural, referential-integrity, and business-rule checks. Any unresolved anomalies will be carried forward as documented limitations and investigated where relevant during analytical modeling.

**Next step:** Build the analytical layer while preserving the raw tables and validating metric definitions and aggregation levels.
