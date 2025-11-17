# Optimization Dashboard Validation Report

**Date:** 2025-11-17
**Validated Against:** `/home/user/aws-cur-2/cur2.view.lkml`
**Total Dashboards Validated:** 8

---

## Executive Summary

| Dashboard | Status | Critical Issues | Warnings | Total Errors |
|-----------|--------|-----------------|----------|--------------|
| ri_sp_optimization | ⚠️ **Warning** | 0 | 2 | 2 |
| storage_optimization | ❌ **Failed** | 3 | 0 | 3 |
| waste_detection | ⚠️ **Warning** | 0 | 2 | 2 |
| resource_rightsizing_waste | ✅ **Pass** | 0 | 0 | 0 |
| commitment_optimization_ri_sp | ❌ **Failed** | 15+ | 0 | 15+ |
| capacity_planning | ❌ **Failed** | 3 | 0 | 3 |
| capacity_planning_utilization | ❌ **Failed** | 20+ | 0 | 20+ |
| data_services_optimization | ❌ **Failed** | 3 | 0 | 3 |

**Overall Status:** 🔴 **FAILED** - 5 dashboards have critical issues preventing use with cur2 view

---

## Detailed Validation Results

### 1. RI/SP Optimization Dashboard
**File:** `/home/user/aws-cur-2/dashboards/ri_sp_optimization.dashboard.lookml`
**Status:** ⚠️ **Warning** (Functional with minor issues)

#### ✅ Passing Validations
- All field references use `cur2.` prefix correctly
- Core fields exist in cur2 view:
  - `cur2.line_item_usage_start_date` ✓
  - `cur2.line_item_usage_account_name` ✓
  - `cur2.line_item_product_code` ✓
  - `cur2.total_unblended_cost` ✓
  - `cur2.total_usage_amount` ✓
  - `cur2.product_instance_type` ✓
  - `cur2.line_item_availability_zone` ✓
  - `cur2.line_item_type` (filters) ✓

#### ⚠️ Warnings
1. **Undefined Filter Parameters** (Lines 117-118, 136-137, 164-165, etc.)
   - Uses `{% parameter billing_period_filter %}` but parameter not defined
   - Uses `{% parameter account_filter %}` but parameter not defined
   - **Impact:** Filters won't work; should use filter names directly

2. **Filter Field Mismatch** (Line 60)
   - Filter uses `cur2.reservation_effective_cost` for RI Utilization Threshold
   - **Issue:** This is not a utilization metric, it's a cost field
   - **Recommendation:** Should filter on `cur2.ri_utilization_rate` if available

#### 💡 Recommendations
- Replace parameter references with proper filter names:
  ```lookml
  filters:
    cur2.line_item_usage_start_date: "{{ Billing Period._value }}"
  ```
- Dynamic fields using filters are valid but should reference existing line_item_type values

---

### 2. Storage Optimization Dashboard
**File:** `/home/user/aws-cur-2/dashboards/storage_optimization.dashboard.lookml`
**Status:** ❌ **FAILED** (Critical - Wrong view/explore)

#### ❌ Critical Issues
1. **Non-existent Explore** (Lines 11, 34, 64, 78, 93)
   - References `explore: storage_optimization`
   - **Expected:** `explore: cur2`
   - **Impact:** Dashboard will not load

2. **Non-existent View Prefix** (All elements)
   - References `storage_cur2.*` fields throughout
   - **Expected:** `cur2.*` prefix
   - **Impact:** All queries will fail

3. **Missing Fields in cur2 View:**
   - `storage_cur2.total_unblended_cost` → Should be `cur2.total_unblended_cost`
   - `storage_cur2.total_potential_savings` → Does NOT exist in cur2
   - `storage_cur2.usage_date` → Does NOT exist (use `cur2.line_item_usage_start_date`)
   - `storage_cur2.storage_service` → Does NOT exist
   - `storage_cur2.optimization_priority` → Does NOT exist

#### 🔧 Required Fixes
- **Replace all instances of:**
  - `explore: storage_optimization` → `explore: cur2`
  - `storage_cur2.` → `cur2.`
- **Add missing dimensions/measures to cur2 view or use existing equivalents**
- **Update filter references to valid cur2 fields**

---

### 3. Waste Detection Dashboard
**File:** `/home/user/aws-cur-2/dashboards/waste_detection.dashboard.lookml`
**Status:** ⚠️ **Warning** (Functional with minor issues)

#### ✅ Passing Validations
- All field references use `cur2.` prefix correctly
- Core fields validated:
  - `cur2.line_item_usage_start_date` ✓
  - `cur2.line_item_usage_account_name` ✓
  - `cur2.line_item_product_code` ✓
  - `cur2.line_item_resource_id` ✓
  - `cur2.total_unblended_cost` ✓
  - `cur2.total_usage_amount` ✓
  - `cur2.environment` ✓
  - `cur2.product_instance_type` ✓
  - `cur2.line_item_availability_zone` ✓
  - `cur2.pricing_unit` ✓

#### ⚠️ Warnings
1. **Undefined Filter Parameters** (Lines 136-137, 163-164, etc.)
   - Uses `{% parameter billing_period_filter %}` - parameter not defined
   - Uses `{% parameter account_filter %}` - parameter not defined
   - Uses `{% parameter waste_threshold_filter %}` - parameter not defined
   - **Impact:** Filters won't apply correctly

2. **Filter on Non-existent Field** (Line 72)
   - References `cur2.environment` in filter - field EXISTS ✓
   - But this is a tag-derived field, may be NULL for many resources

#### 💡 Recommendations
- Define filter parameters or use standard filter syntax
- Add NULL handling for tag-based dimensions
- Dynamic fields and table calculations are well-structured

---

### 4. Resource Rightsizing & Waste Reduction Dashboard
**File:** `/home/user/aws-cur-2/dashboards/resource_rightsizing_waste.dashboard.lookml`
**Status:** ✅ **PASSED** (All validations successful)

#### ✅ Passing Validations
- All field references use `cur2.` prefix correctly ✓
- All referenced fields exist in cur2 view:
  - `cur2.right_sizing_opportunity` ✓
  - `cur2.total_unblended_cost` ✓
  - `cur2.total_usage_amount` ✓
  - `cur2.count_unique_resources` ✓
  - `cur2.line_item_usage_start_date` ✓
  - `cur2.line_item_usage_account_name` ✓
  - `cur2.line_item_product_code` ✓
  - `cur2.environment` ✓
  - `cur2.line_item_resource_id` ✓
  - `cur2.product_instance_type` ✓
  - `cur2.product_instance_family` ✓
  - `cur2.line_item_availability_zone` ✓
  - `cur2.service_category` ✓
  - `cur2.has_tags` ✓
  - `cur2.tag_count` ✓
  - `cur2.data_transfer_cost` ✓
  - `cur2.data_transfer_gb` ✓

- Dynamic fields properly structured ✓
- Conditional formatting correctly configured ✓
- Filters reference valid cur2 fields ✓

#### 🎯 Best Practices Observed
- Comprehensive use of existing cur2 measures
- Well-structured table calculations
- Proper filter dependencies
- Effective use of conditional formatting for waste categorization

---

### 5. Commitment Optimization Dashboard (RI/SP)
**File:** `/home/user/aws-cur-2/dashboards/commitment_optimization_ri_sp.dashboard.lookml`
**Status:** ❌ **FAILED** (Critical - Extensive missing fields)

#### ❌ Critical Issues - Non-existent Fields

**Missing Commitment Metrics (15+ fields):**
1. `cur2.commitment_coverage_rate` - Line 70, 239
2. `cur2.commitment_utilization_rate` - Line 107, 239
3. `cur2.potential_commitment_savings` - Line 144, 376
4. `cur2.expiring_commitment_count` - Line 171
5. `cur2.commitment_expiration_days` - Line 173, 491
6. `cur2.commitment_savings_rate` - Line 204
7. `cur2.ri_coverage_rate` - Line 240
8. `cur2.sp_coverage_rate` - Line 242
9. `cur2.ri_savings` - Line 321
10. `cur2.sp_savings` - Line 322
11. `cur2.total_cost` - Line 373 (should be `total_unblended_cost`)
12. `cur2.on_demand_cost` - Line 374
13. `cur2.commitment_cost` - Line 375
14. `cur2.commitment_savings` - Line 376
15. `cur2.recommendation_type` - Line 429
16. `cur2.recommended_commitment_amount` - Line 430
17. `cur2.estimated_monthly_savings` - Line 431
18. `cur2.estimated_roi_percentage` - Line 432
19. `cur2.payback_period_months` - Line 432
20. `cur2.recommendation_confidence_score` - Line 433
21. `cur2.recommended_term` - Line 433
22. `cur2.reservation_arn` - Line 487
23. `cur2.commitment_start_date` - Line 488
24. `cur2.commitment_end_date` - Line 488
25. `cur2.commitment_monthly_cost` - Line 489
26. `cur2.commitment_expiration_bucket` - Line 515
27. `cur2.expiring_commitment_value` - Line 516
28. `cur2.average_utilization_rate` - Line 516
29. `cur2.renewal_recommendation` - Line 517
30. `cur2.commitment_term_length` - Line 571
31. `cur2.total_commitment_cost` - Line 571
32. `cur2.total_on_demand_equivalent_cost` - Line 572
33. `cur2.total_savings` - Line 572
34. `cur2.roi_percentage` - Line 573
35. `cur2.cost_allocation_type` - Line 653

#### ✅ Fields That DO Exist
- `cur2.line_item_usage_start_date` ✓
- `cur2.line_item_usage_account_name` ✓
- `cur2.line_item_product_code` ✓
- `cur2.total_commitment_savings` ✓

#### 🔧 Required Fixes
**Option 1: Add Missing Measures to cur2.view.lkml**
Create calculated fields for:
- Coverage rates (RI/SP/overall)
- Utilization rates
- Commitment tracking (expiration, ARN, dates)
- ROI calculations
- Recommendation engine outputs

**Option 2: Redesign Dashboard**
Use existing cur2 fields:
- `total_ri_cost`
- `total_savings_plan_cost`
- `total_on_demand_cost`
- `ri_utilization_rate`
- `savings_plan_utilization_rate`
- `commitment_coverage_percentage`
- `commitment_savings_rate`
- `effective_savings_rate`

---

### 6. Capacity Planning Dashboard
**File:** `/home/user/aws-cur-2/dashboards/capacity_planning.dashboard.lookml`
**Status:** ❌ **FAILED** (Critical - Wrong explore)

#### ❌ Critical Issues
1. **Non-existent Explore** (Throughout)
   - References `explore: capacity_planning`
   - **Expected:** `explore: cur2`
   - **Impact:** Dashboard will not load

2. **Non-existent View Prefix** (All elements)
   - References `capacity_planning.*` fields
   - **Expected:** `cur2.*` prefix
   - **Impact:** All queries will fail

3. **Missing Fields** (30+ fields)
   - `capacity_planning.product_name` → Use `cur2.line_item_product_code`
   - `capacity_planning.account_name` → Use `cur2.line_item_usage_account_name`
   - `capacity_planning.availability_zone` → Use `cur2.line_item_availability_zone`
   - `capacity_planning.scaling_recommendation` → Does NOT exist
   - `capacity_planning.days_to_capacity_limit` → Does NOT exist
   - `capacity_planning.estimated_cost_impact` → Does NOT exist
   - `capacity_planning.volatility_risk` → Does NOT exist
   - `capacity_planning.usage_date` → Use `cur2.line_item_usage_start_date`
   - `capacity_planning.avg_resource_utilization` → Does NOT exist
   - `capacity_planning.peak_resource_utilization` → Does NOT exist
   - `capacity_planning.p95_utilization` → Does NOT exist
   - `capacity_planning.p80_utilization` → Does NOT exist
   - And 20+ more capacity-specific fields

#### 🔧 Required Fixes
- **Replace:** `explore: capacity_planning` → `explore: cur2`
- **Replace:** All `capacity_planning.*` → `cur2.*`
- **Add capacity metrics to cur2 view** OR redesign dashboard with available usage metrics

---

### 7. Capacity Planning & Utilization Dashboard
**File:** `/home/user/aws-cur-2/dashboards/capacity_planning_utilization.dashboard.lookml`
**Status:** ❌ **FAILED** (Critical - Extensive missing fields)

#### ❌ Critical Issues - Non-existent Fields

**Missing Capacity/Utilization Metrics (25+ fields):**
1. `cur2.total_provisioned_capacity` - Line 13
2. `cur2.capacity_metric_type` - Lines 28, 68, etc.
3. `cur2.utilization_threshold_filter` - Lines 29, 69, etc.
4. `cur2.resource_tier` - Lines 31, 71, etc.
5. `cur2.current_utilization_rate` - Line 42
6. `cur2.capacity_headroom_percentage` - Line 82
7. `cur2.projected_capacity_need_30d` - Line 118
8. `cur2.line_item_usage_start_hour` - Line 142
9. `cur2.cpu_utilization` - Line 142
10. `cur2.memory_utilization` - Line 142
11. `cur2.disk_utilization` - Line 142
12. `cur2.network_utilization` - Line 142
13. `cur2.utilization_percentage` - Line 224
14. `cur2.forecast_date` - Line 260
15. `cur2.current_capacity` - Line 260, 377
16. `cur2.projected_demand` - Line 260
17. `cur2.recommended_capacity` - Line 260, 377
18. `cur2.capacity_gap` - Line 260
19. `cur2.line_item_usage_account_id` - Line 311
20. `cur2.average_utilization_rate` - Line 311, 377
21. `cur2.peak_utilization_rate` - Line 311
22. `cur2.capacity_efficiency_score` - Line 311
23. `cur2.optimization_type` - Line 377
24. `cur2.potential_capacity_savings` - Line 377
25. `cur2.implementation_effort` - Line 377
26. `cur2.business_impact_risk` - Line 377
27. `cur2.optimization_opportunity` - Line 380
28. `cur2.scaling_event_timestamp` - Line 475
29. `cur2.scaling_action` - Line 475
30. `cur2.capacity_before` - Line 475
31. `cur2.capacity_after` - Line 475
32. `cur2.scaling_trigger` - Line 475
33. `cur2.scaling_duration_minutes` - Line 475

#### ✅ Fields That DO Exist
- `cur2.line_item_usage_start_date` ✓
- `cur2.line_item_product_code` ✓
- `cur2.line_item_usage_account_name` ✓
- `cur2.line_item_resource_id` ✓
- `cur2.environment` ✓
- `cur2.total_usage_amount` ✓

#### 🔧 Required Fixes
**This dashboard requires extensive cur2 view enhancements:**
- Add capacity tracking dimensions and measures
- Add utilization metrics (CPU, memory, disk, network)
- Add forecasting/projection measures
- Add scaling event tracking
- Consider integration with CloudWatch metrics

**Alternative:** Redesign to use existing usage_amount patterns

---

### 8. Data Services Optimization Dashboard
**File:** `/home/user/aws-cur-2/dashboards/data_services_optimization.dashboard.lookml`
**Status:** ❌ **FAILED** (Critical - Wrong view/explore)

#### ❌ Critical Issues
1. **Non-existent Explore** (Lines 11, 34, 64, 78, 93)
   - References `explore: data_services_optimization`
   - **Expected:** `explore: cur2`
   - **Impact:** Dashboard will not load

2. **Non-existent View Prefix** (All elements)
   - References `data_services_cur2.*` fields
   - **Expected:** `cur2.*` prefix
   - **Impact:** All queries will fail

3. **Missing Fields:**
   - `data_services_cur2.total_unblended_cost` → Should be `cur2.total_unblended_cost`
   - `data_services_cur2.total_potential_savings` → Does NOT exist
   - `data_services_cur2.usage_date` → Use `cur2.line_item_usage_start_date`
   - `data_services_cur2.data_service` → Does NOT exist
   - `data_services_cur2.optimization_priority` → Does NOT exist

#### 🔧 Required Fixes
- **Replace all instances of:**
  - `explore: data_services_optimization` → `explore: cur2`
  - `data_services_cur2.` → `cur2.`
- **Filter for data services:**
  ```lookml
  filters:
    cur2.line_item_product_code: "AmazonRDS,AmazonDynamoDB,AmazonElastiCache"
  ```
- **Add missing optimization metrics to cur2 view**

---

## Common Validation Issues

### 1. Filter Parameter References
**Affected Dashboards:** ri_sp_optimization, waste_detection

**Issue:** Using undefined Liquid parameters like `{% parameter billing_period_filter %}`

**Fix:**
```lookml
# Instead of:
filters:
  cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"

# Use:
filters:
  cur2.line_item_usage_start_date: "1 months ago for 1 months"
# OR reference the filter by name in listen blocks
```

### 2. Wrong Explore/View References
**Affected Dashboards:** storage_optimization, capacity_planning, data_services_optimization

**Issue:** Referencing non-existent explores and view prefixes

**Fix:**
```lookml
# Change from:
explore: storage_optimization
fields: [storage_cur2.total_cost]

# To:
explore: cur2
fields: [cur2.total_unblended_cost]
```

### 3. Missing Calculated Fields
**Affected Dashboards:** commitment_optimization_ri_sp, capacity_planning_utilization

**Issue:** Referencing measures/dimensions that don't exist in cur2 view

**Fix Options:**
1. Add missing fields to `/home/user/aws-cur-2/cur2.view.lkml`
2. Use dynamic_fields in dashboard (for simple calculations)
3. Redesign dashboards to use existing cur2 fields

---

## Dimension Group Timeframe Validation

### ✅ Valid Dimension Groups in cur2.view.lkml
- `cur2.billing_period_end_date` (timeframes: date, week, month, quarter, year)
- `cur2.billing_period_start_date` (timeframes: date, week, month, quarter, year)
- `cur2.line_item_usage_end_date` (timeframes: date, week, month, quarter, year)
- `cur2.line_item_usage_start_date` (timeframes: date, week, month, quarter, year)

### Dashboard Usage Analysis

| Dashboard | Timeframe References | Explicit? | Valid? |
|-----------|---------------------|-----------|--------|
| ri_sp_optimization | `line_item_usage_start_date` | ❌ No (defaults used) | ⚠️ Works but implicit |
| storage_optimization | `usage_date` (wrong field) | N/A | ❌ Invalid field |
| waste_detection | `line_item_usage_start_date` | ❌ No | ⚠️ Works but implicit |
| resource_rightsizing_waste | `line_item_usage_start_date` | ❌ No | ⚠️ Works but implicit |
| commitment_optimization_ri_sp | `line_item_usage_start_date` | ❌ No | ⚠️ Works but implicit |
| capacity_planning | `usage_date` (wrong field) | N/A | ❌ Invalid field |
| capacity_planning_utilization | `line_item_usage_start_date`, `line_item_usage_start_hour` | ❌ No | ⚠️ Partial (hour not available) |
| data_services_optimization | `usage_date` (wrong field) | N/A | ❌ Invalid field |

**Recommendation:** Make timeframes explicit in all dashboard references:
```lookml
# Instead of:
fields: [cur2.line_item_usage_start_date]

# Use explicit timeframe:
fields: [cur2.line_item_usage_start_date_date]
# OR
fields: [cur2.line_item_usage_start_date_month]
```

---

## Field Existence Summary

### ✅ Commonly Used Fields (Validated Present)
- `cur2.line_item_usage_start_date` ✓
- `cur2.line_item_usage_account_name` ✓
- `cur2.line_item_product_code` ✓
- `cur2.line_item_resource_id` ✓
- `cur2.line_item_availability_zone` ✓
- `cur2.total_unblended_cost` ✓
- `cur2.total_usage_amount` ✓
- `cur2.product_instance_type` ✓
- `cur2.environment` ✓
- `cur2.service_category` ✓
- `cur2.right_sizing_opportunity` ✓
- `cur2.data_transfer_cost` ✓
- `cur2.data_transfer_gb` ✓

### ❌ Missing Fields (Need to be Added)

**Commitment/Savings Fields:**
- `commitment_coverage_rate`
- `commitment_utilization_rate`
- `potential_commitment_savings`
- `expiring_commitment_count`
- `commitment_expiration_days`
- `ri_coverage_rate`
- `sp_coverage_rate`
- `recommendation_*` fields (type, amount, ROI, etc.)

**Capacity Planning Fields:**
- All capacity/utilization metrics
- Scaling event tracking
- Forecast/projection fields

**Service-Specific Fields:**
- `storage_service`
- `data_service`
- `optimization_priority`

---

## Recommendations

### Immediate Actions Required

#### 🔴 Critical - Fix Before Deployment
1. **Fix explore/view references in 3 dashboards:**
   - storage_optimization.dashboard.lookml
   - capacity_planning.dashboard.lookml
   - data_services_optimization.dashboard.lookml

2. **Add missing fields to cur2.view.lkml for:**
   - commitment_optimization_ri_sp.dashboard.lookml (15+ fields)
   - capacity_planning_utilization.dashboard.lookml (25+ fields)

#### 🟡 Medium Priority - Fix for Full Functionality
3. **Replace parameter references with proper filter syntax:**
   - ri_sp_optimization.dashboard.lookml
   - waste_detection.dashboard.lookml

4. **Make dimension_group timeframes explicit** in all dashboards

### Long-term Improvements

1. **Standardize Dashboard Patterns:**
   - Use consistent filter naming
   - Standardize explore references
   - Create reusable LookML patterns

2. **Enhance cur2.view.lkml:**
   - Add commitment tracking measures
   - Add capacity/utilization metrics
   - Add service-specific categorization

3. **Create Derived Tables:**
   - Consider PDTs for complex calculations
   - Pre-aggregate capacity metrics
   - Build recommendation engines

4. **Documentation:**
   - Document all custom measures
   - Create field mapping guide
   - Build dashboard user guides

---

## Testing Checklist

### Before Deploying Dashboards
- [ ] Validate all `explore:` references point to `cur2`
- [ ] Confirm all field prefixes use `cur2.*`
- [ ] Test all filters with actual data
- [ ] Verify dimension_group timeframes
- [ ] Validate dynamic_fields syntax
- [ ] Test conditional formatting rules
- [ ] Verify drill-down functionality
- [ ] Check dashboard permissions
- [ ] Test with multiple user roles
- [ ] Validate performance with large datasets

### After Deployment
- [ ] Monitor dashboard load times
- [ ] Check for query errors
- [ ] Validate data accuracy
- [ ] Gather user feedback
- [ ] Track usage metrics
- [ ] Identify optimization opportunities

---

## Validation Methodology

**Tools Used:**
- Manual code review of all 8 dashboard files
- Field existence validation against cur2.view.lkml
- Pattern matching for common issues
- LookML syntax validation

**Validation Criteria:**
1. ✅ All field references use "cur2." prefix
2. ✅ Dimension group timeframes are explicit (recommended)
3. ✅ Filter fields exist in cur2 view
4. ✅ No references to non-existent views
5. ✅ Measure aggregations are valid

**Files Validated:**
- `/home/user/aws-cur-2/cur2.view.lkml` (39,962 tokens, 3,467 lines)
- `/home/user/aws-cur-2/dashboards/ri_sp_optimization.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/storage_optimization.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/waste_detection.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/resource_rightsizing_waste.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/commitment_optimization_ri_sp.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/capacity_planning.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/capacity_planning_utilization.dashboard.lookml`
- `/home/user/aws-cur-2/dashboards/data_services_optimization.dashboard.lookml`

---

## Conclusion

**Dashboards Ready for Use:** 1/8
- ✅ resource_rightsizing_waste.dashboard.lookml

**Dashboards Requiring Minor Fixes:** 2/8
- ⚠️ ri_sp_optimization.dashboard.lookml (filter parameter fixes)
- ⚠️ waste_detection.dashboard.lookml (filter parameter fixes)

**Dashboards Requiring Major Fixes:** 5/8
- ❌ storage_optimization.dashboard.lookml (wrong explore/view)
- ❌ commitment_optimization_ri_sp.dashboard.lookml (15+ missing fields)
- ❌ capacity_planning.dashboard.lookml (wrong explore/view)
- ❌ capacity_planning_utilization.dashboard.lookml (25+ missing fields)
- ❌ data_services_optimization.dashboard.lookml (wrong explore/view)

**Overall Assessment:** Significant work required to make these dashboards compatible with the cur2 view. The resource_rightsizing_waste dashboard is well-designed and ready to use. The other dashboards will require either extensive cur2 view enhancements or complete redesigns to function properly.

---

**Report Generated:** 2025-11-17
**Analyst:** Claude Code Validation Engine
**Next Steps:** Address critical issues before production deployment
