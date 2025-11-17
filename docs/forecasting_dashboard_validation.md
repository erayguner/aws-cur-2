# Forecasting and Analytics Dashboard Validation Report

**Date:** 2025-11-17
**Validated Against:** `/home/user/aws-cur-2/cur2.view.lkml`
**Total Dashboards Analyzed:** 7

---

## Executive Summary

Out of 7 forecasting and analytics dashboards validated, **2 dashboards have critical issues** requiring immediate attention, while **5 dashboards contain orphaned field references** that will cause runtime errors in Looker.

### Severity Breakdown:
- 🔴 **Critical (5 dashboards):** Reference non-existent explores or extensive orphaned fields
- 🟡 **Warning (2 dashboards):** Use table calculations but reference some invalid fields
- 🟢 **Pass (0 dashboards):** No issues found

---

## Dashboard Validation Results

### 1. forecasting_analytics.dashboard.lookml 🔴 CRITICAL

**Status:** FAIL - Major Issues
**Explore Referenced:** `forecasting_analytics`
**Issue:** The explore `forecasting_analytics` does not exist in the model

#### Orphaned Field References (100% invalid):
All fields are orphaned as the explore doesn't exist:

- `forecasting_analytics.forecast_week_date` ❌
- `forecasting_analytics.product_name` ❌
- `forecasting_analytics.account_name` ❌
- `forecasting_analytics.prediction_confidence` ❌
- `forecasting_analytics.best_model` ❌
- `forecasting_analytics.best_model_accuracy` ❌
- `forecasting_analytics.predictability_score` ❌
- `forecasting_analytics.cost_stability` ❌
- `forecasting_analytics.forecast_week_week` ❌
- `forecasting_analytics.actual_weekly_cost` ❌
- `forecasting_analytics.linear_forecast` ❌
- `forecasting_analytics.moving_avg_forecast` ❌
- `forecasting_analytics.exp_smoothing_forecast` ❌
- `forecasting_analytics.recommended_forecast` ❌
- `forecasting_analytics.linear_percentage_error` ❌
- `forecasting_analytics.moving_avg_percentage_error` ❌
- `forecasting_analytics.exp_smoothing_percentage_error` ❌
- `forecasting_analytics.linear_bias` ❌
- `forecasting_analytics.moving_avg_bias` ❌
- `forecasting_analytics.exp_smoothing_bias` ❌
- `forecasting_analytics.cost_volatility_4week` ❌
- `forecasting_analytics.trend_strength_4week` ❌
- `forecasting_analytics.optimistic_scenario` ❌
- `forecasting_analytics.pessimistic_scenario` ❌
- `forecasting_analytics.stress_test_scenario` ❌
- `forecasting_analytics.forecast_upper_bound` ❌
- `forecasting_analytics.forecast_lower_bound` ❌

#### Valid cur2 Equivalents (Recommendations):
- Use `cur2.line_item_usage_start_date` instead of `forecast_week_date`
- Use `cur2.line_item_product_code` instead of `product_name`
- Use `cur2.line_item_usage_account_name` instead of `account_name`
- Use `cur2.total_unblended_cost` for cost measures
- Create table calculations for forecasting metrics

#### Date Dimension Issues:
- ❌ `forecast_week_date` - Use `cur2.line_item_usage_start_date`
- ❌ `forecast_week_week` - Use `cur2.line_item_usage_start_week`

---

### 2. consumption_forecasting.dashboard.lookml 🔴 CRITICAL

**Status:** FAIL - Major Issues
**Explore Referenced:** `consumption_forecasting`
**Issue:** The explore `consumption_forecasting` does not exist in the model

#### Orphaned Field References (100% invalid):
All fields are orphaned as the explore doesn't exist:

- `consumption_cur2.usage_date` ❌
- `consumption_cur2.total_daily_cost` ❌
- `consumption_cur2.predicted_cost` ❌
- `consumption_cur2.cost_upper_bound` ❌
- `consumption_cur2.cost_lower_bound` ❌
- `consumption_cur2.product_name` ❌
- `consumption_cur2.account_name` ❌
- `consumption_cur2.usage_growth_rate` ❌
- `consumption_cur2.cost_growth_rate` ❌
- `consumption_cur2.predicted_usage` ❌
- `consumption_cur2.usage_week` ❌
- `consumption_cur2.total_daily_usage` ❌
- `consumption_cur2.seasonal_adjustment` ❌
- `consumption_cur2.cost_30day_moving_avg` ❌
- `consumption_cur2.cost_volatility` ❌
- `consumption_cur2.usage_month` ❌

#### Valid cur2 Equivalents (Recommendations):
- Use `cur2.line_item_usage_start_date` instead of `usage_date`
- Use `cur2.line_item_product_code` instead of `product_name`
- Use `cur2.line_item_usage_account_name` instead of `account_name`
- Use `cur2.total_unblended_cost` instead of `total_daily_cost`
- Use `cur2.total_usage_amount` instead of `total_daily_usage`
- Create table calculations for growth rates and forecasts

#### Date Dimension Issues:
- ❌ `usage_date` - Use `cur2.line_item_usage_start_date`
- ❌ `usage_week` - Use `cur2.line_item_usage_start_week`
- ❌ `usage_month` - Use `cur2.line_item_usage_start_month`

---

### 3. budget_forecasting.dashboard.lookml 🔴 CRITICAL

**Status:** FAIL - Major Issues
**Explore Referenced:** `budget_forecasting`
**Issue:** The explore `budget_forecasting` does not exist in the model

#### Orphaned Field References (100% invalid):
All fields are orphaned as the explore doesn't exist:

- `budget_cur2.product_name` ❌
- `budget_cur2.account_name` ❌
- `budget_cur2.budget_status` ❌
- `budget_cur2.budget_variance` ❌
- `budget_cur2.budget_variance_percent` ❌
- `budget_cur2.budget_health_score` ❌
- `budget_cur2.forecasted_monthly_budget` ❌
- `budget_cur2.budget_month_date` ❌
- `budget_cur2.budget_month_month` ❌
- `budget_cur2.actual_cost` ❌
- `budget_cur2.baseline_budget` ❌
- `budget_cur2.budget_upper_bound` ❌
- `budget_cur2.budget_lower_bound` ❌
- `budget_cur2.month_over_month_savings_percent` ❌
- `budget_cur2.seasonal_factor` ❌
- `budget_cur2.monthly_growth_rate` ❌
- `budget_cur2.cost_per_unit` ❌
- `budget_cur2.cost_volatility_6month` ❌
- `budget_cur2.forecasted_annual_budget` ❌
- `budget_cur2.ytd_budget_variance` ❌

#### Valid cur2 Equivalents (Recommendations):
- Use `cur2.line_item_product_code` instead of `product_name`
- Use `cur2.line_item_usage_account_name` instead of `account_name`
- Use `cur2.total_unblended_cost` instead of `actual_cost`
- Create table calculations for budget variance, health score, and forecasts

#### Date Dimension Issues:
- ❌ `budget_month_date` - Use `cur2.line_item_usage_start_date`
- ❌ `budget_month_month` - Use `cur2.line_item_usage_start_month`

---

### 4. predictive_cost_forecasting_p10_p50_p90.dashboard.lookml 🔴 CRITICAL

**Status:** FAIL - Major Issues
**Explore Referenced:** `cur2` ✅
**Issue:** Explore exists but all forecasting fields are orphaned

#### Orphaned Field References (95% invalid):
Extensive orphaned fields that don't exist in cur2 view:

**Forecast Measures:**
- `cur2.forecast_30d_p50_median` ❌
- `cur2.forecast_30d_p10_lower` ❌
- `cur2.forecast_30d_p90_upper` ❌
- `cur2.forecast_mape_accuracy` ❌
- `cur2.forecast_date` ❌
- `cur2.actual_cost_historical` ❌
- `cur2.forecast_p10_lower_bound` ❌
- `cur2.forecast_p50_median` ❌
- `cur2.forecast_p90_upper_bound` ❌
- `cur2.deepar_forecast` ❌
- `cur2.ets_forecast` ❌
- `cur2.prophet_forecast` ❌
- `cur2.arima_forecast` ❌
- `cur2.ensemble_forecast` ❌
- `cur2.forecast_model_type` ❌
- `cur2.forecast_rmse` ❌
- `cur2.forecast_mae` ❌

**Scenario Planning:**
- `cur2.scenario_name` ❌
- `cur2.scenario_baseline_cost` ❌
- `cur2.scenario_optimistic_10pct` ❌
- `cur2.scenario_pessimistic_10pct` ❌
- `cur2.scenario_growth_20pct` ❌
- `cur2.scenario_reduction_15pct` ❌

**Seasonality:**
- `cur2.trend_component` ❌
- `cur2.seasonal_component` ❌
- `cur2.residual_component` ❌
- `cur2.month_name` ❌
- `cur2.seasonal_index` ❌
- `cur2.seasonal_strength_score` ❌

**Budget Analysis:**
- `cur2.budget_category` ❌
- `cur2.current_budget` ❌
- `cur2.budget_variance` ❌
- `cur2.budget_variance_percentage` ❌
- `cur2.worst_case_variance` ❌
- `cur2.risk_level` ❌

**Filters:**
- `cur2.forecast_horizon_days` ❌
- `cur2.confidence_level_percentage` ❌

#### Valid Fields Found (5% valid):
- `cur2.line_item_product_code` ✅
- `cur2.current_monthly_cost` ⚠️ (Not standard, likely needs to be calculated)
- `cur2.forecast_growth_rate` ❌
- `cur2.forecast_confidence_score` ❌

#### Valid cur2 Equivalents (Recommendations):
- Use `cur2.total_unblended_cost` for cost measures
- Use `cur2.line_item_usage_start_date` for date filtering
- Create table calculations for all forecasting logic
- Implement forecasting using Looker's native functions or external models

#### Date Dimension Issues:
- ❌ `forecast_date` - Use `cur2.line_item_usage_start_date`

---

### 5. cost_anomaly_detection.dashboard.lookml 🟡 WARNING

**Status:** PARTIAL PASS - Minor Issues
**Explore Referenced:** `cur2` ✅
**Issue:** Mostly valid, uses table calculations for anomaly detection

#### Valid Field References:
- `cur2.line_item_usage_start_date` ✅
- `cur2.total_unblended_cost` ✅
- `cur2.line_item_product_code` ✅
- `cur2.line_item_usage_account_name` ✅
- `cur2.line_item_resource_id` ✅

#### Table Calculations Used (Appropriate):
- `daily_cost_change` - Calculated from `total_unblended_cost` ✅
- `anomaly_count` - Count calculation ✅
- `highest_spike` - Max calculation ✅
- `largest_drop` - Min calculation ✅
- `moving_average_7d` - Calculated using Looker functions ✅
- `upper_bound` - Statistical calculation ✅
- `lower_bound` - Statistical calculation ✅
- `anomaly_flag` - Conditional logic ✅
- `cost_z_score` - Statistical calculation ✅
- `anomaly_type` - Case statement ✅
- `investigation_priority` - Business logic ✅

#### Filter Syntax Issues:
- Uses parameter references: `{% parameter billing_period_filter %}` ⚠️
- Uses parameter references: `{% parameter account_filter %}` ⚠️
- Uses parameter references: `{% parameter anomaly_threshold %}` ⚠️
- Uses constant references: `@{COST_THRESHOLD_HIGH}` ⚠️

**Note:** These parameters and constants need to be defined in the LookML model.

#### Standard Deviation Calculation Issue:
Line 72 uses `${cur2.total_unblended_cost:standard_deviation}` which requires a derived field. Verify this exists.

#### Recommendations:
1. ✅ Dashboard structure is sound
2. ⚠️ Define all parameters in the model file
3. ⚠️ Define all constants used (COST_THRESHOLD_HIGH, COST_THRESHOLD_MEDIUM)
4. ✅ Table calculations are appropriate for anomaly detection
5. ⚠️ Consider adding min/max filters for anomaly thresholds

---

### 6. ml_anomaly_detection_advanced.dashboard.lookml 🔴 CRITICAL

**Status:** FAIL - Major Issues
**Explore Referenced:** `cur2` ✅
**Issue:** Explore exists but all ML fields are orphaned

#### Orphaned Field References (100% of ML fields invalid):

**Anomaly Detection Fields:**
- `cur2.cost_anomaly_count` ❌
- `cur2.anomaly_severity` ❌
- `cur2.total_anomalous_cost` ❌
- `cur2.cost_anomaly_score` ❌
- `cur2.avg_anomaly_score` ❌
- `cur2.anomaly_detection_accuracy` ❌
- `cur2.mean_time_to_detect_hours` ❌
- `cur2.false_positive_rate` ❌
- `cur2.true_positive_rate` ❌
- `cur2.precision_score` ❌
- `cur2.recall_score` ❌

**Root Cause Analysis:**
- `cur2.anomaly_impact_percentage` ❌
- `cur2.root_cause_category` ❌
- `cur2.anomaly_trend` ❌
- `cur2.estimated_waste_amount` ❌

**ML Model Performance:**
- `cur2.actual_cost` ❌
- `cur2.predicted_cost_baseline` ❌
- `cur2.confidence_upper_bound` ❌
- `cur2.confidence_lower_bound` ❌

**Investigation Fields:**
- `cur2.line_item_usage_start_time` ❌
- `cur2.expected_cost_range` ❌
- `cur2.cost_deviation_percentage` ❌
- `cur2.recommended_action` ❌

**Pattern Analysis:**
- `cur2.cost_volatility_score` ❌
- `cur2.line_item_usage_start_day_of_week` ❌
- `cur2.line_item_usage_start_hour` ❌

#### Valid Fields Found:
- `cur2.line_item_usage_start_date` ✅
- `cur2.total_unblended_cost` ✅
- `cur2.line_item_product_code` ✅
- `cur2.line_item_usage_account_name` ✅
- `cur2.line_item_resource_id` ✅

#### Valid cur2 Equivalents (Recommendations):
- Use `cur2.total_unblended_cost` for cost measures
- Create derived table or view for ML predictions
- Implement anomaly detection using table calculations or external ML models
- Use statistical functions for variance and outlier detection

---

### 7. budget_tracking_predictive_alerts.dashboard.lookml 🟡 WARNING

**Status:** PARTIAL PASS - Uses Table Calculations
**Explore Referenced:** `cur2` ✅
**Issue:** Relies heavily on table calculations for budget tracking

#### Valid Field References:
- `cur2.total_unblended_cost` ✅
- `cur2.line_item_usage_start_date` ✅
- `cur2.line_item_usage_account_name` ✅
- `cur2.line_item_product_code` ✅
- `cur2.team` ✅
- `cur2.environment` ✅
- `cur2.line_item_usage_start_month` ✅

#### Table Calculations Used (Appropriate):
- `budget_utilization` - Hardcoded budget comparison ⚠️
- `daily_burn_rate` - Simple division ✅
- `budget_variance` - Hardcoded budget comparison ⚠️
- `overrun_risk` - Case statement ✅
- `remaining_budget` - Hardcoded budget comparison ⚠️
- `days_until_exhaustion` - Calculation ✅
- `allocated_budget` - Hardcoded value ⚠️
- `variance_pct` - Percentage calculation ✅
- `budget_limit` - Hardcoded value ⚠️
- `threshold_50/75/90/100` - Threshold calculations ✅
- `alert_status` - Case statement ✅
- `budget_target` - Hardcoded value ⚠️
- `forecast_p50/p90/p10` - Simple projections ✅
- `predicted_eom_cost` - Linear projection ✅
- `monthly_budget` - Hardcoded value ⚠️
- `variance` - Calculation ✅
- `cumulative_variance` - Running total ✅

#### Issues:
1. ⚠️ **Hardcoded Budget Values:** All budget comparisons use hardcoded values (e.g., 100000, 15000, 10000)
   - Should be replaced with dynamic budget lookups or parameters

2. ⚠️ **Duplicate value_format entries:** Lines 53, 58, 269, 274, etc. have duplicate `value_format` keys
   - LookML will use the last one, but this creates confusion

3. ✅ **Good use of table calculations** for forecasting and variance analysis

4. ⚠️ **Line 54 syntax error:** Missing closing quote or brace in visualization_config

#### Date Dimension Issues:
- All date references are valid ✅

#### Recommendations:
1. Replace hardcoded budgets with:
   - Parameters that users can set
   - Separate budget dimension table
   - Resource tags containing budget information
2. Fix duplicate value_format entries
3. Add validation for division by zero in burn rate calculations
4. Consider adding confidence intervals to forecasts

---

## Summary of Issues by Category

### 1. Date Dimension References

#### ❌ Invalid Date Fields:
- `forecast_week_date` (forecasting_analytics)
- `forecast_week_week` (forecasting_analytics)
- `usage_date` (consumption_forecasting)
- `usage_week` (consumption_forecasting)
- `usage_month` (consumption_forecasting)
- `budget_month_date` (budget_forecasting)
- `budget_month_month` (budget_forecasting)
- `forecast_date` (predictive_cost_forecasting)

#### ✅ Valid Date Fields in cur2:
- `line_item_usage_start_date` (dimension_group)
- `line_item_usage_start_time`
- `line_item_usage_start_week`
- `line_item_usage_start_month`
- `line_item_usage_start_quarter`
- `line_item_usage_start_year`
- `line_item_usage_end_date` (dimension_group)
- `billing_period_start_date` (dimension_group)
- `billing_period_end_date` (dimension_group)

---

### 2. Measure Aggregations

#### ❌ Invalid Measures Referenced:
**Forecasting Measures:**
- All forecasting fields (forecast_p10, forecast_p50, forecast_p90, etc.)
- All model accuracy measures (mape_accuracy, rmse, mae, etc.)
- All predicted cost measures (predicted_cost, predicted_usage, etc.)
- All growth rate measures (usage_growth_rate, cost_growth_rate, etc.)

**Budget Measures:**
- All budget-specific measures (budget_variance, budget_health_score, etc.)
- All budget forecasting measures (forecasted_monthly_budget, etc.)

**Anomaly Detection Measures:**
- All ML-based anomaly measures (cost_anomaly_score, anomaly_severity, etc.)
- All ML performance metrics (detection_accuracy, false_positive_rate, etc.)

#### ✅ Valid Measures in cur2:
- `total_unblended_cost` ✅
- `total_blended_cost` ✅
- `total_net_unblended_cost` ✅
- `total_usage_amount` ✅
- `total_discount_amount` ✅
- `total_tax_amount` ✅
- `count_unique_resources` ✅
- `count_unique_accounts` ✅
- `count_unique_services` ✅
- `average_daily_cost` ✅
- `month_over_month_change` ✅
- `year_over_year_change` ✅
- `previous_month_cost` ✅
- `cost_difference` ✅
- `week_over_week_change` ✅

---

### 3. Filter Syntax Issues

#### Valid Filter Patterns:
```yaml
filters:
  cur2.line_item_usage_start_date: '7 days'
  cur2.line_item_product_code: 'AmazonEC2'
```

#### Issues Found:

**cost_anomaly_detection.dashboard.lookml:**
- Uses parameter filters: `{% parameter billing_period_filter %}` ⚠️
  - These parameters must be defined in the dashboard
- Uses constants: `@{COST_THRESHOLD_HIGH}` ⚠️
  - These constants must be defined in the model manifest

**Other dashboards:**
- Standard filter syntax appears correct ✅

---

### 4. Orphaned Field Summary

| Dashboard | Total Fields | Valid Fields | Orphaned Fields | Orphan Rate |
|-----------|--------------|--------------|-----------------|-------------|
| forecasting_analytics | 27 | 0 | 27 | 100% |
| consumption_forecasting | 16 | 0 | 16 | 100% |
| budget_forecasting | 20 | 0 | 20 | 100% |
| predictive_cost_forecasting_p10_p50_p90 | 45 | 2 | 43 | 96% |
| cost_anomaly_detection | 10 | 10 | 0 | 0% |
| ml_anomaly_detection_advanced | 35 | 5 | 30 | 86% |
| budget_tracking_predictive_alerts | 12 | 12 | 0 | 0% |

---

## Recommended Actions

### Immediate (Critical):

1. **Create Missing Explores** (for dashboards 1-3):
   - Create `forecasting_analytics` explore with proper joins
   - Create `consumption_forecasting` explore
   - Create `budget_forecasting` explore
   - OR: Update dashboards to use `cur2` explore with table calculations

2. **Add Missing Fields to cur2 view** (for dashboards 4, 6):
   - Add forecast dimension groups for P10/P50/P90 calculations
   - Add anomaly detection measures using statistical functions
   - Add ML model performance measures
   - OR: Implement as table calculations in dashboards

3. **Fix Parameter References** (dashboard 5):
   - Define `billing_period_filter` parameter
   - Define `account_filter` parameter
   - Define `anomaly_threshold` parameter
   - Define `COST_THRESHOLD_HIGH` constant in manifest

### Short-term (Important):

4. **Update Date References:**
   - Replace all custom date fields with `line_item_usage_start_*` equivalents
   - Ensure proper dimension_group usage

5. **Implement Forecasting Logic:**
   - Create derived tables for forecasting calculations
   - Use Looker's liquid templating for dynamic forecasts
   - Consider external ML model integration

6. **Add Budget Tracking:**
   - Create budget dimension table
   - Join budget data to cur2
   - Replace hardcoded budget values

### Long-term (Enhancement):

7. **Standardize Field Naming:**
   - Use consistent naming convention across all explores
   - Document field definitions

8. **Add Data Validation:**
   - Add row-level security
   - Implement data quality checks
   - Add measure validation

9. **Performance Optimization:**
   - Create aggregate awareness
   - Implement PDTs for complex calculations
   - Add indexes on join keys

---

## Alternative Approaches

### Option 1: Fix Explores (Recommended for Production)
Create proper explore definitions with all required fields as derived tables or native dimensions.

**Pros:**
- Sustainable long-term solution
- Better performance
- Reusable across dashboards

**Cons:**
- Requires significant development time
- May need external data sources for ML predictions

### Option 2: Use Table Calculations (Quick Fix)
Convert all orphaned fields to table calculations within each dashboard.

**Pros:**
- Quick to implement
- No model changes required
- Flexible for testing

**Cons:**
- Performance limitations
- Not reusable
- Harder to maintain

### Option 3: Hybrid Approach (Balanced)
Create critical fields as dimensions/measures in views, use table calculations for complex/experimental metrics.

**Pros:**
- Balance of performance and flexibility
- Incremental development
- Test before committing to model

**Cons:**
- Requires careful planning
- May still have some performance issues

---

## Validation Checklist

Use this checklist when creating or updating forecasting dashboards:

### Date Dimensions:
- [ ] All date fields use `line_item_usage_start_*` or other valid dimension_groups
- [ ] No custom date fields without proper dimension_group definition
- [ ] Date filters use proper timeframe syntax

### Measures:
- [ ] All measures exist in the view or are properly calculated
- [ ] Aggregation types are appropriate (sum, avg, count, etc.)
- [ ] No division by zero in calculated measures

### Dimensions:
- [ ] All referenced dimensions exist in view
- [ ] Product/service fields use `line_item_product_code`
- [ ] Account fields use `line_item_usage_account_name`

### Filters:
- [ ] All filter fields exist in view
- [ ] Parameter filters are properly defined
- [ ] Constants are defined in manifest

### Syntax:
- [ ] No duplicate keys in YAML
- [ ] Proper indentation
- [ ] All strings properly quoted
- [ ] All arrays properly formatted

---

## Appendix: Valid cur2 Fields Reference

### Key Dimensions:
```yaml
# Account & Billing
line_item_usage_account_id
line_item_usage_account_name
payer_account_id
payer_account_name
bill_type
billing_entity

# Services & Products
line_item_product_code
product_product_family
product_instance_type
product_region_code
region

# Resources
line_item_resource_id
line_item_operation
line_item_usage_type

# Tags
team
environment
project
cost_center
name
created_by

# Cost Classification
service_category
cost_type
is_usage
is_tax
has_discount
```

### Key Measures:
```yaml
# Primary Cost Measures
total_unblended_cost
total_blended_cost
total_net_unblended_cost
total_usage_amount

# Derived Cost Measures
total_discount_amount
total_tax_amount
total_tagged_cost
total_untagged_cost

# Commitment Measures
total_ri_cost
total_savings_plan_cost
total_on_demand_cost
total_spot_cost

# Efficiency Measures
tag_coverage_rate
cost_per_resource
commitment_savings_rate

# Trend Measures
average_daily_cost
month_over_month_change
year_over_year_change
week_over_week_change
previous_month_cost
cost_difference

# Count Measures
count
count_unique_resources
count_unique_accounts
count_unique_services
```

### Valid Date Dimension Groups:
```yaml
# Line Item Dates
line_item_usage_start_{date|week|month|quarter|year}
line_item_usage_end_{date|week|month|quarter|year}

# Billing Period Dates
billing_period_start_{date|week|month|quarter|year}
billing_period_end_{date|week|month|quarter|year}
```

---

## Conclusion

The majority of forecasting dashboards require significant rework to function properly with the cur2 view. Only 2 out of 7 dashboards are currently functional, and even those have minor issues that should be addressed.

**Priority Actions:**
1. Decide on implementation approach (Option 1, 2, or 3)
2. Create missing explore definitions or update dashboards to use table calculations
3. Add budget tracking infrastructure
4. Implement forecasting logic (derived tables or external ML)
5. Test thoroughly before deploying to production

**Estimated Effort:**
- **Quick Fix (Table Calculations):** 2-3 days
- **Proper Implementation (New Explores):** 2-3 weeks
- **Full ML Integration:** 4-6 weeks

---

**Report Generated:** 2025-11-17
**Validated By:** Claude Code Agent
**Next Review:** After implementing fixes
