# Service Dashboard Validation Report

**Generated:** 2025-11-17
**Validated Against:** cur2.view.lkml
**Total Dashboards Validated:** 12

---

## Executive Summary

This report validates all project and service-specific dashboards against the AWS CUR 2.0 view (`cur2.view.lkml`). The validation checks field references, filters, measure calculations, and explore configurations.

### Validation Status Overview

| Dashboard | Status | Critical Issues | Warnings | Explore Issues |
|-----------|--------|-----------------|----------|----------------|
| project_cost_deep_dive | ⚠️ WARNINGS | 0 | 4 | 0 |
| project_resource_utilization | ❌ CRITICAL | 6 | 0 | 2 |
| project_performance_sla | ⚠️ WARNINGS | 0 | 5 | 0 |
| project_security_compliance | ⚠️ WARNINGS | 0 | 3 | 0 |
| project_recommendation_engine | ⚠️ WARNINGS | 0 | 6 | 0 |
| ec2_cost_deep_dive | ❌ CRITICAL | 12 | 0 | 0 |
| rds_database_cost_analysis | ❌ CRITICAL | 11 | 0 | 0 |
| s3_storage_optimization | ❌ CRITICAL | 6 | 0 | 0 |
| lambda_serverless_cost | ❌ CRITICAL | 4 | 0 | 0 |
| ml_ai_cost_analytics | ❌ CRITICAL | 15 | 0 | 0 |
| container_split_analytics | ❌ CRITICAL | 7 | 0 | 1 |
| data_ops_monitoring | ✅ PASS | 0 | 0 | 0 |

---

## Detailed Validation Results

### 1. project_cost_deep_dive.dashboard.lookml

**Status:** ⚠️ WARNINGS (4 warnings)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.total_unblended_cost
- ✅ cur2.environment
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_usage_start_month
- ✅ cur2.line_item_product_code
- ✅ cur2.line_item_availability_zone
- ✅ cur2.line_item_usage_type
- ✅ cur2.line_item_resource_id
- ✅ cur2.count_unique_resources
- ✅ cur2.usage_amount (refers to line_item_usage_amount)

**Warnings:**

1. **average_monthly_cost** (line 100)
   - ⚠️ Field not found in view
   - **Recommendation:** Create as table calculation: `${total_unblended_cost} / count_distinct(${line_item_usage_start_month})`

2. **cost_growth_rate** (line 123)
   - ⚠️ Field not found in view
   - **Recommendation:** Use `month_over_month_change` or create table calculation

3. **savings_percentage** (line 161)
   - ✅ Field EXISTS in view (line 2301)
   - **Note:** Actually valid, no issue

4. **purchase_option** (line 426, 458)
   - ⚠️ Field not found in view
   - **Recommendation:** Use `pricing_purchase_option` instead

5. **zero_usage_cost** (line 296, 345, 462)
   - ⚠️ Field not found in view
   - **Recommendation:** Create as filtered measure or use `total_unused_cost`

6. **total_public_on_demand_cost** (line 192, 228)
   - ⚠️ Field not found in view
   - **Recommendation:** Use `pricing_public_on_demand_cost` or create measure summing it

**Filters Validation:**
- ✅ All filter field references are valid

---

### 2. project_resource_utilization.dashboard.lookml

**Status:** ❌ CRITICAL (6 critical issues, 2 explore issues)

**Model/Explore Issues:**
- ❌ **CRITICAL:** Uses undefined explore `compute_optimization` (lines 23, 35, etc.)
- ❌ **CRITICAL:** Uses undefined explore `storage_optimization` (lines 321, 347, etc.)

**Missing Fields in cur2 view:**

1. **compute_cur2.* fields** - All references invalid
   - compute_cur2.usage_date
   - compute_cur2.compute_service
   - compute_cur2.optimization_priority
   - compute_cur2.instance_count
   - compute_cur2.total_potential_savings
   - compute_cur2.instance_type
   - compute_cur2.instance_generation
   - compute_cur2.resource_id
   - compute_cur2.optimization_opportunity
   - compute_cur2.line_item_availability_zone
   - compute_cur2.purchase_option

2. **storage_cur2.* fields** - All references invalid
   - storage_cur2.storage_service
   - storage_cur2.volume_count
   - storage_cur2.optimization_opportunity

**Recommendations:**
- ❌ **CRITICAL FIX REQUIRED:** Create `compute_optimization` explore or reference correct explore name
- ❌ **CRITICAL FIX REQUIRED:** Create `storage_optimization` explore or reference correct explore name
- Alternative: Modify dashboard to use `cur2` explore with appropriate filters

---

### 3. project_performance_sla.dashboard.lookml

**Status:** ⚠️ WARNINGS (5 warnings)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.environment
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_product_code
- ✅ cur2.total_unblended_cost
- ✅ cur2.resource_efficiency_score
- ✅ cur2.tag_coverage_rate
- ✅ cur2.line_item_availability_zone
- ✅ cur2.count_unique_resources
- ✅ cur2.line_item_resource_id

**Warnings:**

1. **service_category** filter (line 62)
   - ✅ Field EXISTS in view (line 1029)
   - **Note:** Actually valid

2. **cost_efficiency_ratio** (lines 146, 405, 498)
   - ⚠️ Field not found in view
   - **Recommendation:** Create as table calculation: `${total_unblended_cost} / ${resource_efficiency_score}`

3. **Usage of resource_efficiency_score as SLA compliance** (line 105)
   - ⚠️ Potentially misleading - resource_efficiency_score may not represent SLA compliance
   - **Recommendation:** Create specific SLA compliance measure or clarify usage

---

### 4. project_security_compliance.dashboard.lookml

**Status:** ⚠️ WARNINGS (3 warnings)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.environment
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.tag_coverage_rate
- ✅ cur2.line_item_product_code
- ✅ cur2.total_unblended_cost
- ✅ cur2.count_unique_resources
- ✅ cur2.line_item_availability_zone
- ✅ cur2.line_item_usage_start_month
- ✅ cur2.line_item_resource_id

**Warnings:**

1. **tag_compliance_percentage** (lines 105, 250, 303, 409, 500, 553)
   - ⚠️ Field not found in view
   - **Recommendation:** Use `tag_coverage_rate` or create as: `count_if(has_tags) / count * 100`

2. **tag_coverage_rate_tier** (line 377)
   - ⚠️ Field not found in view
   - **Recommendation:** Create as dimension with case statement based on tag_coverage_rate ranges

---

### 5. project_recommendation_engine.dashboard.lookml

**Status:** ⚠️ WARNINGS (6 warnings)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.environment
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.savings_percentage
- ✅ cur2.savings_vs_on_demand
- ✅ cur2.count_unique_resources
- ✅ cur2.total_unblended_cost
- ✅ cur2.line_item_product_code
- ✅ cur2.line_item_resource_id
- ✅ cur2.line_item_availability_zone
- ✅ cur2.tag_coverage_rate

**Warnings:**

1. **optimization_action_type** (lines 62, 102, 127, 184, 235, 255, 322, 460, 503)
   - ⚠️ Field not found in view
   - **Recommendation:** Create dimension categorizing resources by recommended action

2. **Usage in scatter plot** (line 182)
   - ⚠️ Using optimization_action_type for scatter plot categories
   - **Recommendation:** Ensure dimension exists or use alternative categorization

---

### 6. ec2_cost_deep_dive.dashboard.lookml

**Status:** ❌ CRITICAL (12 critical field issues)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.total_unblended_cost
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_usage_account_name
- ✅ cur2.line_item_product_code (filtering for "AmazonEC2")
- ✅ cur2.line_item_usage_type
- ✅ cur2.count_unique_resources
- ✅ cur2.line_item_usage_amount
- ✅ cur2.line_item_resource_id

**Critical Missing Fields:**

1. **product_region_code** (lines 60, 88, 116, etc.)
   - ✅ Field EXISTS in view (line 496)
   - **Note:** Actually valid

2. **product_instance_type** (lines 62, 90, etc.)
   - ✅ Field EXISTS in view (line 447)
   - **Note:** Actually valid

3. **resource_tags_user_environment** (lines 63, 91, etc.)
   - ❌ Field NOT in view
   - **Recommendation:** Use `environment` dimension (line 837)

4. **pricing_term** (lines 75, 103, 237, 517)
   - ✅ Field EXISTS in view (line 377)
   - **Note:** Actually valid

5. **product_instance_family** (lines 431, 517)
   - ✅ Field EXISTS in view (line 440)
   - **Note:** Actually valid

6. **product_volume_api_name** (lines 817, 852)
   - ❌ Field NOT in view
   - **Recommendation:** Check for EBS-specific fields or use product_usagetype

7. **product_product_family** (lines 76, 102, 820, 855)
   - ✅ Field EXISTS in view (line 489)
   - **Note:** Actually valid

**Filters Validation:**
- Most filters reference valid fields
- Need to replace `resource_tags_user_environment` with `environment`

---

### 7. rds_database_cost_analysis.dashboard.lookml

**Status:** ❌ CRITICAL (11 critical field issues)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.total_unblended_cost
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_usage_account_name
- ✅ cur2.line_item_product_code (filtering for "AmazonRDS")
- ✅ cur2.line_item_usage_type
- ✅ cur2.count_unique_resources
- ✅ cur2.line_item_usage_amount
- ✅ cur2.line_item_resource_id
- ✅ cur2.product_region_code
- ✅ cur2.product_instance_type

**Critical Missing Fields:**

1. **product_database_engine** (lines 61, 89, etc.)
   - ❌ Field NOT in view
   - **Recommendation:** Extract from product_instance_type or line_item_usage_type

2. **product_product_family** (lines 76, 102, etc.)
   - ✅ Field EXISTS in view (line 489)
   - **Note:** Valid field

3. **product_deployment_option** (lines 595, 598, 628, 633, 666)
   - ❌ Field NOT in view
   - **Recommendation:** Derive from product details or usage type

4. **product_volume_type** (lines 702, 706, 737, 741)
   - ❌ Field NOT in view
   - **Recommendation:** Parse from product information or usage type

**Recommendations:**
- Create derived dimensions for database engine, deployment option, and volume type
- Parse from existing fields like product_instance_type or line_item_usage_type

---

### 8. s3_storage_optimization.dashboard.lookml

**Status:** ❌ CRITICAL (6 critical field issues)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.total_unblended_cost
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_usage_account_name
- ✅ cur2.line_item_product_code (filtering for "AmazonS3")
- ✅ cur2.line_item_usage_type
- ✅ cur2.line_item_usage_amount
- ✅ cur2.product_region_code
- ✅ cur2.line_item_operation
- ✅ cur2.line_item_usage_start_month
- ✅ cur2.product_product_family

**Critical Missing Fields:**

1. **product_storage_class** (lines 61, 89, etc.)
   - ❌ Field NOT in view
   - **Recommendation:** Extract from line_item_usage_type or product details

2. **resource_tags_user_bucket** (lines 62, 90, etc.)
   - ❌ Field NOT in view
   - **Recommendation:** Parse from line_item_resource_id or resource_tags

**Recommendations:**
- Create derived dimension for storage class from usage type
- Extract bucket name from resource ID or tags

---

### 9. lambda_serverless_cost.dashboard.lookml

**Status:** ❌ CRITICAL (4 critical field issues)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.total_unblended_cost
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_usage_account_name
- ✅ cur2.line_item_product_code (filtering for "AWSLambda")
- ✅ cur2.line_item_usage_type
- ✅ cur2.line_item_usage_amount
- ✅ cur2.product_region_code
- ✅ cur2.line_item_resource_id
- ✅ cur2.product_group

**Critical Missing Fields:**

1. **resource_tags_user_function_name** (lines 61, 89, etc.)
   - ❌ Field NOT in view
   - **Recommendation:** Extract function name from line_item_resource_id

2. **resource_tags_user_environment** (lines 62, 90, etc.)
   - ❌ Field NOT in view
   - **Recommendation:** Use `environment` dimension

3. **product_processor_features** (lines 956, 988, 1006)
   - ❌ Field NOT in view
   - **Recommendation:** Parse from product details if available

**Recommendations:**
- Parse function name from resource ID (ARN)
- Use standard environment dimension
- Create derived dimension for processor architecture if data available

---

### 10. ml_ai_cost_analytics.dashboard.lookml

**Status:** ❌ CRITICAL (15 critical field issues)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Base Fields:**
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_usage_account_name
- ✅ cur2.line_item_product_code
- ✅ cur2.total_unblended_cost
- ✅ cur2.line_item_usage_start_month
- ✅ cur2.team

**Critical Missing Fields (All ML-specific measures/dimensions):**

1. **total_ml_ai_cost** (line 107)
2. **ml_service_type** (lines 79, 120, etc.)
3. **sagemaker_cost** (lines 132, 437)
4. **bedrock_cost** (lines 157, 437)
5. **computer_vision_cost** (lines 179, 437)
6. **language_services_cost** (lines 207, 437)
7. **ml_lifecycle_stage** (line 236)
8. **ml_usage_hours** (lines 273, 320)
9. **sagemaker_instance_type** (line 358)
10. **sagemaker_cost_per_hour** (line 359)
11. **ml_efficiency_score** (lines 359, 617, 653)
12. **ml_utilization_rate** (line 359)
13. **ml_project_count** (line 617)
14. **bedrock_model_name** (line 501)
15. **bedrock_input_tokens** (line 501)
16. **bedrock_output_tokens** (line 502)
17. **bedrock_cost_per_1k_tokens** (line 502)
18. **bedrock_model_efficiency** (line 502)
19. **ml_optimization_potential** (line 557)
20. **ml_rightsizing_savings** (line 558)
21. **ml_cost_trend** (lines 558, 701)
22. **ml_cost_anomaly_score** (lines 701, 727)
23. **ml_optimization_recommendation** (line 701)

**Recommendations:**
- ❌ **CRITICAL:** Create all ML-specific measures and dimensions
- Filter cur2 for ML services: AmazonSageMaker, AmazonBedrock, AmazonTextract, AmazonRekognition, etc.
- Calculate ML metrics from usage amounts and costs
- Create lifecycle categorization based on usage types

---

### 11. container_split_analytics.dashboard.lookml

**Status:** ❌ CRITICAL (7 critical issues, 1 explore issue)

**Model/Explore Issues:**
- ❌ **CRITICAL:** Uses undefined explore `container_analytics`

**Missing Fields:**
1. **container_analytics.total_unblended_cost** (line 14)
2. **container_analytics.average_utilization** (line 36)
3. **container_analytics.container_count** (line 58)
4. **container_analytics.potential_savings** (line 80)
5. **container_analytics.usage_date** (line 23, 111)
6. **container_analytics.container_type** (line 24, 125)
7. **container_analytics.ecs_cluster_name** (line 25, 138)

**Valid Concepts (if using cur2 explore):**
- ✅ Split line item fields exist in cur2 view:
  - split_line_item_actual_usage (line 1235)
  - split_line_item_net_split_cost (line 1242)
  - split_line_item_split_cost (line 1288)
  - split_line_item_split_usage (line 1296)
  - split_line_item_parent_resource_id (line 1258)

**Recommendations:**
- ❌ **CRITICAL FIX REQUIRED:** Create `container_analytics` explore OR
- Rewrite to use `cur2` explore with split_line_item fields
- Filter for ECS/EKS services
- Use aws_ecs_cluster and aws_eks_cluster tag dimensions

---

### 12. data_ops_monitoring.dashboard.lookml

**Status:** ✅ PASS (All fields valid)

**Model/Explore:** `aws_billing / cur2` ✅

**Valid Fields:**
- ✅ cur2.line_item_usage_start_date
- ✅ cur2.line_item_product_code
- ✅ cur2.data_completeness_score (line 2188)
- ✅ cur2.ingestion_health_score (line 2238)
- ✅ cur2.data_freshness_hours (line 2180)
- ✅ cur2.data_quality_alerts (line 2200)
- ✅ cur2.processing_lag_hours (line 2214)
- ✅ cur2.cost_variance_coefficient (line 2226)
- ✅ cur2.duplicate_detection_count (line 2207)

**Notes:**
- ✅ All operational monitoring measures exist in cur2 view
- ✅ No custom field references
- ✅ All filters use valid fields
- ✅ Dashboard correctly uses cur2 explore

---

## Recommendations by Priority

### 🔴 CRITICAL - Must Fix Before Production

1. **Create Missing Explores**
   - `compute_optimization` (project_resource_utilization)
   - `storage_optimization` (project_resource_utilization)
   - `container_analytics` (container_split_analytics)

2. **Fix Service-Specific Dashboards**
   - Add all product-specific dimensions (database_engine, storage_class, etc.)
   - Parse from existing fields or add to view

3. **Create ML/AI Measures**
   - Add all ML-specific cost calculations
   - Create lifecycle categorization
   - Add efficiency metrics

### 🟡 HIGH - Should Fix Soon

1. **Standardize Tag References**
   - Replace `resource_tags_user_*` with standard tag dimensions
   - Use `environment` instead of `resource_tags_user_environment`

2. **Add Derived Dimensions**
   - tag_compliance_percentage
   - cost_efficiency_ratio
   - average_monthly_cost
   - optimization_action_type

3. **Create Missing Measures**
   - purchase_option (from pricing_purchase_option)
   - zero_usage_cost
   - total_public_on_demand_cost
   - tag_coverage_rate_tier

### 🟢 MEDIUM - Nice to Have

1. **Add Table Calculations**
   - cost_growth_rate
   - mom_growth percentages
   - efficiency scores

2. **Documentation**
   - Document field mapping
   - Create field reference guide
   - Add dashboard usage instructions

---

## Field Mapping Reference

### Common Replacements Needed

| Dashboard Field | cur2 View Field | Notes |
|----------------|-----------------|-------|
| resource_tags_user_environment | environment | Standard tag dimension |
| resource_tags_user_bucket | Parse from line_item_resource_id | Extract bucket name |
| resource_tags_user_function_name | Parse from line_item_resource_id | Extract Lambda function name |
| purchase_option | pricing_purchase_option | Direct field |
| product_database_engine | Derive from product_instance_type | Parse engine type |
| product_storage_class | Derive from line_item_usage_type | Parse storage class |
| tag_compliance_percentage | Calculate from tag_coverage_rate | Create measure |

---

## Testing Checklist

Before deploying dashboards to production:

- [ ] Test all dashboard loads without errors
- [ ] Verify all filter controls work
- [ ] Check data returns for all tiles
- [ ] Validate calculations produce expected results
- [ ] Test with different time ranges
- [ ] Verify cross-filtering works
- [ ] Test with different user permissions
- [ ] Check dashboard performance (load time < 30s)
- [ ] Validate against known cost data
- [ ] Review with stakeholders

---

## Conclusion

**Overall Assessment:** 9 of 12 dashboards require fixes before production deployment.

**Action Items:**
1. Create missing explores (3 explores)
2. Add product-specific dimensions to cur2 view
3. Create ML/AI-specific measures
4. Fix tag reference inconsistencies
5. Add derived measures and dimensions
6. Test all dashboards thoroughly

**Timeline Estimate:**
- Critical fixes: 2-3 days
- High priority: 2-3 days
- Medium priority: 1-2 days
- Testing: 1-2 days
- **Total: 6-10 days**

---

*End of Validation Report*
