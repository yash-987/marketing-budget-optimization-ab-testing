# Key Findings

## Overview

This document summarizes the main findings from the Marketing Budget Optimization & A/B Testing project.

The analysis combines campaign performance metrics, attribution comparisons, an advertising experiment, and a proposed budget scenario.

The findings distinguish measured results from interpretations and scenario-based projections.

---

## 1. A/B Testing Results

### Conversion-rate comparison

The experiment dataset contained approximately 588,101 users across two groups.

| Metric | Advertising group | PSA group |
|---|---:|---:|
| Users | 564,577 | 23,524 |
| Converted users | 14,423 | 420 |
| Conversion rate | 2.5547% | 1.7854% |
| Average advertisements seen | 24.8234 | 24.7611 |

The advertising group had a higher observed conversion rate than the PSA group.

### Absolute conversion lift

Absolute lift is the difference between the two conversion rates.

Absolute Lift = 2.5547% − 1.7854%

**Observed absolute lift: approximately 0.7692 percentage points.**

### Relative conversion lift

Relative lift expresses the difference relative to the PSA group's conversion rate.

Relative Lift = (Advertising Rate − PSA Rate) / PSA Rate

**Observed relative lift: approximately 43.09%.**

This means the advertising group's observed conversion rate was approximately 43.09% higher than the PSA group's rate.

It does not mean advertising generated 43.09 percentage points of additional conversion rate.

### Statistical significance

A two-proportion z-test produced the following results:

| Statistical measure | Result |
|---|---:|
| Z-statistic | 7.3701 |
| P-value | Approximately 1.705 × 10⁻¹³ |
| 95% confidence interval, absolute lift | Approximately 0.5873 to 0.9360 percentage points |

The p-value is substantially below the conventional 0.05 significance threshold.

Under the assumptions of the test, the observed difference is statistically significant.

### Interpretation and limitations

The advertising group had a higher observed conversion rate, and the statistical test provides strong evidence that the rates differ.

However, the available dataset documentation did not confirm random assignment. Therefore, the analysis does not establish that advertising caused the difference.

A causal conclusion would require appropriate experimental-design evidence, including confirmation of assignment procedures and an assessment of potential sources of bias.

---

## 2. Campaign Performance

The PostgreSQL model and Power BI dashboards provide a structured view of advertising performance across campaigns and channels.

The analysis covers:

- Impressions and clicks.
- Advertising spend.
- Reported conversions.
- Reported conversion value.
- CTR and CPC.
- Cost per reported conversion.
- ROAS.
- Monthly performance trends.

The campaign comparison visuals allow campaigns to be examined according to spending and conversion-related metrics.

### Interpretation

Campaigns with high spend and relatively low reported conversion value may warrant further investigation.

Campaigns with lower CPC or stronger conversion-related metrics may also deserve further analysis.

However, campaign comparisons should consider traffic volume, attribution definitions, conversion quality, and the reliability of the underlying metrics.

The dashboard is intended to support investigation rather than automatically determine budget allocation.

---

## 3. Marketing Attribution

The SQL model includes views comparing first-touch and last-touch attribution.

These views allow analysts to investigate how attributed conversions and conversion value differ depending on the attribution method.

### Interpretation

Attribution methods assign conversion credit differently.

First-touch attribution emphasizes the first recorded channel, while last-touch attribution emphasizes the last recorded channel under the project's attribution definitions.

Differences between these views can reveal that channel contribution depends on the attribution method used.

These comparisons do not independently establish the incremental causal effect of each channel.

---

## 4. Budget Scenario Analysis

The Excel and Power BI components compare historical campaign spending with a proposed budget scenario.

The analysis includes:

- Historical spend.
- Proposed budget.
- Budget change.
- Historical conversion value.
- Expected conversion value.
- Campaign-level budget comparisons.

### Interpretation

The scenario provides a framework for evaluating how proposed campaign budgets compare with historical spending and how expected conversion value changes under the workbook's assumptions.

Expected conversion value is a scenario projection, not guaranteed revenue or profit.

The reliability of the scenario depends on the assumptions used to estimate conversion value and on the comparability of historical performance with the proposed allocation.

### Validation requirement

Before publishing specific claims about budget reallocation, confirm that the proposed budget values differ from historical spending where intended.

If the proposed budgets equal historical spend for every campaign, the scenario represents no campaign-level reallocation, even if the workbook contains budget optimization calculations.

---

## 5. Overall Conclusions

The project demonstrates how SQL, Python, Excel, and Power BI can be combined to answer different marketing analytics questions.

The main outcomes are:

1. A structured PostgreSQL model for campaign and conversion analysis.
2. Campaign and channel performance metrics suitable for interactive reporting.
3. SQL-based first-touch and last-touch attribution comparisons.
4. A statistically evaluated comparison of advertising and PSA conversion rates.
5. An Excel-based framework for comparing historical budgets with scenario assumptions.
6. A four-page Power BI report integrating executive, campaign, experiment, and budget analysis.

The A/B testing results provide a statistically significant observed difference between the groups, subject to the experiment's assumptions and design limitations.

The campaign and budget analyses provide descriptive and scenario-based evidence to support further investigation, rather than proving that a specific budget allocation will improve business outcomes.

## Summary

The project demonstrates an end-to-end analytics workflow that combines data validation, analytical modeling, statistical inference, scenario analysis, and business intelligence reporting.

It emphasizes not only calculating metrics, but also validating their definitions, interpreting results carefully, and documenting analytical limitations.
