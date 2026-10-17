## Attribution Analysis & Budget Optimization

### Objective

The objective of this phase was to analyze marketing attribution across channels, evaluate campaign-level spending efficiency, and develop a budget reallocation scenario using PostgreSQL and LibreOffice Calc.

### Tools Used

- PostgreSQL — data analysis, aggregation, attribution analysis, and reusable views.
- LibreOffice Calc — budget scenario modeling and comparison.
- SQL — analytical queries and validation.

### 1. Attribution Analysis

Two attribution models were analyzed:

- **First-touch attribution:** Assigns conversion credit to the channel associated with the first recorded touchpoint.
- **Last-touch attribution:** Assigns conversion credit to the channel associated with the last recorded touchpoint.

For each model, conversions, attributed revenue, and revenue share were calculated by channel. A comparison was also performed to identify differences in attributed conversions and revenue between the two models.

This analysis helps illustrate how channel performance can appear different depending on the attribution model used.

### 2. Conversion Touchpoint Analysis

Conversions were grouped by the number of recorded touchpoints. The analysis calculated:

- Number of conversions
- Total attributed revenue
- Average revenue per conversion

This helps explore the relationship between the number of recorded touchpoints and conversion outcomes. The analysis identifies patterns but does not establish that additional touchpoints cause higher revenue.

### 3. Campaign Spending and ROAS

Campaign-level spending was analyzed using the `mart_campaign_performance` table.

The analysis included spending share by campaign and Return on Ad Spend (ROAS).

**ROAS formula:**

ROAS = Reported Conversion Value / Total Ad Spend

Key historical results:

| Metric | Result |
|---|---:|
| Total campaigns | 600 |
| Campaigns with positive spend | 355 |
| Total observed spend | 3,240,599.18 |
| Total reported conversion value | 2,524,740.59 |
| Aggregate historical ROAS | 0.7791x |

An aggregate ROAS of approximately 0.7791x means that each unit of ad spend was associated with approximately 0.7791 units of reported conversion value. This is not a profit measure because product costs, operating expenses, and other costs are not accounted for.

### 4. Budget Scenario Model

A budget scenario model was developed in LibreOffice Calc using campaign-level historical spend and ROAS.

The model includes:

- Historical campaign spend
- Historical ROAS
- Proposed campaign budget
- Assumed ROAS
- Expected conversion value
- Total budget allocation
- Scenario ROAS
- Historical-versus-scenario comparison

The total budget was held constant at 3,240,599.18.

### 5. Budget Reallocation Experiment

A test was performed by reducing the proposed budget for a campaign with a lower historical ROAS and transferring the same amount to a campaign with a higher historical ROAS.

Results:

| Metric | Before Reallocation | After Reallocation |
|---|---:|---:|
| Total budget | 3,240,599.18 | 3,240,599.18 |
| Estimated conversion value | 1,751,234.09 | 1,751,987.77 |
| Scenario ROAS | 0.5404x | 0.5406x |

The reallocation increased estimated conversion value by approximately 753.68 while keeping the total budget unchanged.

This result is an assumption-based scenario, not a verified improvement in actual campaign performance.

### 6. Limitations

- Historical reported conversion value and scenario-estimated conversion value are not fully reconciled. Some campaigns have reported conversion value despite having zero historical spend, making their historical ROAS undefined.
- Zero-spend campaigns were not assigned invented ROAS assumptions.
- The scenario assumes historical ROAS remains constant when budgets change. Actual marginal returns may differ.
- Historical ROAS alone does not prove that reallocating budget will improve real-world performance.
- The available dataset does not contain a customer identifier suitable for reliable customer-level acquisition cost (CAC), lifetime value (LTV), or LTV/CAC calculations.
- Reported conversion value is not the same as profit.

### Conclusion

This phase demonstrated how SQL-based attribution analysis can be combined with campaign efficiency metrics and scenario modeling to support marketing budget decisions.

The analysis provides a framework for comparing attribution models, evaluating historical campaign performance, and testing hypothetical budget allocations. Any real-world reallocation should be validated with additional evidence, such as controlled experiments or incremental performance data.

