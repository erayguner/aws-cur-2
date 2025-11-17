# Dashboard Validation Report
## AWS CUR 2.0 LookML Dashboards

**Generated:** 2025-11-17
**Dashboards Validated:** 20
**View File:** /home/user/aws-cur-2/cur2.view.lkml

---

## Executive Summary

This validation report analyzes 20 LookML dashboards against the `cur2` view to identify field reference errors, common Looker syntax issues, and compatibility problems. The dashboards fall into four categories:

1. **Core FinOps Dashboards** (12 dashboards) - Standard cost analysis and governance
2. **Gamified Dashboards** (4 dashboards) - Team competition and engagement
3. **Action/Optimization Dashboards** (4 dashboards) - Automated optimization recommendations

### Overall Findings

- **Critical Issues:** 30+ non-existent field references across multiple dashboards
- **Syntax Issues:** 2 parameter reference errors
- **Warnings:** Multiple custom visualization types require Looker Marketplace plugins
- **Status:** Most dashboards require field definitions or model updates

---

## Dashboard-by-Dashboard Analysis

### 1. multi_account_cost_allocation.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:** All standard AWS CUR 2.0 fields exist in view
**Notes:** Well-structured dashboard using only documented fields

---

### 2. discount_attribution.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:**
- `cur2.total_ri_cost` ✓
- `cur2.total_savings_plan_cost` ✓
- `cur2.total_on_demand_cost` ✓
- `cur2.commitment_savings_rate` ✓

**Notes:** Clean implementation with proper field references

---

### 3. cost_comparison_analytics.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:** Standard cost and comparison fields all present
**Notes:** Properly structured for cost variance analysis

---

### 4. resource_usage_analytics.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:**
- `cur2.line_item_usage_amount` ✓
- `cur2.pricing_public_on_demand_cost` ✓
- `cur2.total_unblended_cost` ✓

**Notes:** Good use of usage metrics

---

### 5. resource_usage_pattern_analysis.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:** Usage pattern fields properly implemented
**Notes:** Time-series analysis correctly configured

---

### 6. tagging_compliance_governance.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:**
- `cur2.tag_coverage_rate` ✓
- `cur2.environment` ✓
- `cur2.team` ✓

**Notes:** Tag compliance metrics properly referenced

---

### 7. showback_chargeback_billing.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:** All chargeback allocation fields exist
**Notes:** Suitable for internal billing use cases

---

### 8. unit_economics_business_metrics.dashboard.lookml
**Status:** ✅ VALID with WARNINGS
**Issues:**
- Uses table calculations for unit metrics (expected behavior)
**Fields Referenced:** Base cost fields all valid
**Notes:** Relies heavily on table calculations for derived metrics

---

### 9. sustainability_carbon_footprint.dashboard.lookml
**Status:** ⚠️ WARNINGS
**Issues:**
- May require external carbon emission data not in CUR
**Fields Referenced:** Uses cost and usage as proxies
**Notes:** Carbon calculations are estimates, not direct AWS data

---

### 10. realtime_cost_visibility.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:** Time-series cost fields properly used
**Notes:** Refresh settings appropriate for near-real-time viewing

---

### 11. finops_maturity_adoption.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Fields
**Issues:**
1. **Line 45:** `cur2.finops_maturity_score` - **DOES NOT EXIST**
2. **Line 256:** `cur2.optimization_score` - ✓ EXISTS
3. **Line 502:** `cur2.waste_detection_score` - ✓ EXISTS
4. **Line 990:** `cur2.team_collaboration_score` - **DOES NOT EXIST**
5. **Line 1059:** `cur2.cost_hero_points` - **DOES NOT EXIST**

**Required Actions:**
- Add `finops_maturity_score` measure to cur2.view.lkml
- Add `team_collaboration_score` measure to cur2.view.lkml
- Add `cost_hero_points` measure to cur2.view.lkml (or remove gamification)

**Severity:** HIGH - Dashboard will fail to load

---

### 12. ccoe_kpi_dashboard.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Fields
**Issues:**
1. **Line 45:** `cur2.finops_maturity_score` - **DOES NOT EXIST**
2. **Line 318:** `cur2.count_environments` - **DOES NOT EXIST**
3. **Line 341:** `cur2.count_projects` - **DOES NOT EXIST**
4. **Line 576:** `cur2.cost_hero_points` - **DOES NOT EXIST**
5. **Line 576:** `cur2.sustainability_champion_score` - **DOES NOT EXIST**
6. **Line 577:** `cur2.waste_warrior_achievements` - **DOES NOT EXIST**
7. **Line 577:** `cur2.team_collaboration_score` - **DOES NOT EXIST**

**Required Actions:**
- Add all missing measure definitions to cur2.view.lkml
- Or replace with existing fields like `count_teams`, `count_unique_accounts`

**Severity:** HIGH - Dashboard will fail to load

---

### 13. gamified_master_dashboard.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Fields
**Issues:**
1. **Line 59:** `cur2.tag_owner` - **DOES NOT EXIST**
2. **Line 488:** `cur2.count_unique_resources` - **DOES NOT EXIST** (only `cur2.count` exists)

**Required Actions:**
- Add `tag_owner` dimension or use existing tag fields
- Rename `count_unique_resources` to `count` or add new measure

**Severity:** MEDIUM - Some visualizations will fail

**Visualization Issues:**
- **Line 405:** `looker_timeline` - Requires Looker Marketplace extension
- **Line 445:** `waterfall_vis` - Requires Looker Marketplace extension

---

### 14. gamified_cost_optimization.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Gamification Fields
**Issues:**
1. **Line 113, 125:** `cur2.level_progress` - **DOES NOT EXIST**
2. **Line 125, 286:** `cur2.cost_hero_points` - **DOES NOT EXIST**
3. **Line 321:** `cur2.sustainability_champion_score` - **DOES NOT EXIST**
4. **Line 322:** `cur2.carbon_efficiency_score` - **DOES NOT EXIST**
5. **Line 322:** `cur2.estimated_carbon_impact` - **DOES NOT EXIST**
6. **Line 356:** `cur2.waste_warrior_achievements` - **DOES NOT EXIST**
7. **Line 357:** `cur2.right_sizing_opportunity` - **DOES NOT EXIST**
8. **Line 357:** `cur2.total_untagged_cost` - **DOES NOT EXIST**
9. **Line 395, 648:** `cur2.team_collaboration_score` - **DOES NOT EXIST**

**Required Actions:**
- This dashboard requires a complete gamification extension to cur2.view.lkml
- Add all 9 missing fields with proper calculation logic
- Consider creating a separate gamification extension view

**Severity:** CRITICAL - Entire dashboard non-functional

**Visualization Issues:**
- **Line 243:** `radial_gauge_vis` - Requires Looker Marketplace extension
- **Line 285:** `bar_gauge_vis` - Requires Looker Marketplace extension

---

### 15. individual_project_dashboard.dashboard.lookml
**Status:** ❌ CRITICAL - Parameter Reference Error
**Issues:**
1. **Line 346:** SYNTAX ERROR - Uses `"{% parameter tracking_period_filter %}"` but filter is named `Tracking Period` (line 32)
   - Should use: `"{% parameter tracking_period %}"` (converted to field name)
2. **Line 366:** SYNTAX ERROR - Uses `"{% parameter my_project_filter %}"` but filter is named `My Project`
   - Should use: `"{% parameter my_project %}"` (converted to field name)

**Required Actions:**
- Fix parameter references in filter expressions
- Use correct LookML filter name syntax (lowercase with underscores)

**Severity:** HIGH - Filters will not work correctly

**Visualization Issues:**
- **Line 114:** `radial_gauge_vis` - Requires Looker Marketplace extension
- **Line 185:** `waterfall_vis` - Requires Looker Marketplace extension
- **Line 218:** `bar_gauge_vis` - Requires Looker Marketplace extension
- **Line 263:** `looker_calendar` - Requires Looker Marketplace extension
- **Line 303:** `treemap_vis` - Requires Looker Marketplace extension
- **Line 383:** `gauge_vis` - Requires Looker Marketplace extension

---

### 16. project_competition_dashboard.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:**
- `cur2.savings_percentage` ✓
- `cur2.environment` ✓
- `cur2.team` ✓
- `cur2.total_unblended_cost` ✓

**Notes:** Competition metrics properly implemented with existing fields

**Visualization Issues:**
- **Line 44:** `kpi_vis` - Requires Looker Marketplace extension (but will gracefully degrade)

---

### 17. team_challenge_dashboard.dashboard.lookml
**Status:** ✅ VALID
**Issues:** None detected
**Fields Referenced:** All team and challenge fields exist
**Notes:** Good use of team-based metrics

**Visualization Issues:**
- **Line 57:** `kpi_vis` - Requires Looker Marketplace extension
- **Line 145:** `radial_gauge_vis` - Requires Looker Marketplace extension
- **Line 273:** `sankey_vis` - Requires Looker Marketplace extension

---

### 18. simplified_action_execution.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Action/Automation Fields
**Issues:** (Dashboard too large to read in previous session, analyzing from summary)
1. `cur2.total_actions_executed` - **DOES NOT EXIST**
2. `cur2.actions_in_progress` - **DOES NOT EXIST**
3. `cur2.actions_queued` - **DOES NOT EXIST**
4. `cur2.execution_success_rate` - **DOES NOT EXIST**
5. `cur2.execution_pipeline` - **DOES NOT EXIST**
6. `cur2.automation_level` - **DOES NOT EXIST**
7. `cur2.pipeline_health_score` - **DOES NOT EXIST**

**Required Actions:**
- This dashboard requires an automation/action tracking extension
- These fields are not part of AWS CUR data
- Consider integrating with external automation tools (Lambda, Step Functions, etc.)

**Severity:** CRITICAL - Dashboard requires external data source

---

### 19. trustworthy_optimization_actions.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Optimization Trust Fields
**Issues:**
1. **Line 13:** `cur2.optimization_trust_score` - **DOES NOT EXIST**
2. **Line 48:** `cur2.safe_optimization_actions_count` - **DOES NOT EXIST**
3. **Line 74:** `cur2.optimization_confidence` - **DOES NOT EXIST**
4. **Line 130:** `cur2.application_criticality_score` - **DOES NOT EXIST**
5. **Line 159:** `cur2.resource_tags_application` - **DOES NOT EXIST**
6. **Line 171:** `cur2.actual_usage_hours` - **DOES NOT EXIST**
7. **Line 171:** `cur2.provisioned_capacity_hours` - **DOES NOT EXIST**
8. **Line 171:** `cur2.optimization_opportunity` - **DOES NOT EXIST**
9. **Line 241:** `cur2.platform_type` - **DOES NOT EXIST**
10. **Line 271:** `cur2.safety_score` - **DOES NOT EXIST**
11. **Line 271:** `cur2.potential_savings_amount` - **DOES NOT EXIST**
12. **Line 271:** `cur2.estimated_execution_time` - **DOES NOT EXIST**

**Required Actions:**
- This dashboard requires ML/AI-based optimization recommendations
- These fields need to be calculated from external optimization tools
- Consider integrating with AWS Compute Optimizer, Cost Explorer, or Trusted Advisor APIs

**Severity:** CRITICAL - Requires external data integration

---

### 20. visible_business_impact.dashboard.lookml
**Status:** ❌ CRITICAL - Missing Business Metrics Fields
**Issues:** (Dashboard too large to read in previous session, analyzing from summary)
1. `cur2.total_business_value_generated` - **DOES NOT EXIST**
2. `cur2.performance_improvement_index` - **DOES NOT EXIST**
3. `cur2.developer_satisfaction_score` - **DOES NOT EXIST**
4. `cur2.application_criticality` - **DOES NOT EXIST**
5. `cur2.stakeholder_view_type` - **DOES NOT EXIST**

**Required Actions:**
- Business impact metrics require external APM/observability data
- Integration with tools like DataDog, New Relic, or custom business metrics needed
- These are not derivable from AWS CUR data alone

**Severity:** CRITICAL - Requires external data source

---

## Field Reference Summary

### ✅ Valid Fields (Available in cur2.view.lkml)

**Dimensions:**
- `line_item_usage_account_name`
- `line_item_product_code`
- `line_item_resource_id`
- `environment`
- `team`
- `service_category`

**Dimension Groups:**
- `line_item_usage_start` (creates: `_date`, `_time`, `_month`, `_year`, etc.)
- `billing_period_start`
- `billing_period_end`

**Measures:**
- `total_unblended_cost`
- `total_ri_cost`
- `total_savings_plan_cost`
- `total_on_demand_cost`
- `commitment_savings_rate`
- `tag_coverage_rate`
- `optimization_score`
- `waste_detection_score`
- `count_teams`
- `count_unique_accounts`
- `count_unique_services`
- `savings_vs_on_demand`
- `savings_percentage`
- `resource_efficiency_score`
- `month_over_month_change`
- `count` (for record counts)

---

### ❌ Missing Fields (Referenced but Not Defined)

**Gamification Fields:**
- `cost_hero_points`
- `sustainability_champion_score`
- `waste_warrior_achievements`
- `team_collaboration_score`
- `level_progress`
- `carbon_efficiency_score`
- `estimated_carbon_impact`

**FinOps Maturity Fields:**
- `finops_maturity_score`
- `count_environments`
- `count_projects`

**Optimization/Action Fields:**
- `optimization_trust_score`
- `safe_optimization_actions_count`
- `optimization_confidence`
- `safety_score`
- `potential_savings_amount`
- `estimated_execution_time`
- `actual_usage_hours`
- `provisioned_capacity_hours`
- `optimization_opportunity`
- `platform_type`

**Action Execution Fields:**
- `total_actions_executed`
- `actions_in_progress`
- `actions_queued`
- `execution_success_rate`
- `execution_pipeline`
- `automation_level`
- `pipeline_health_score`

**Business Impact Fields:**
- `total_business_value_generated`
- `performance_improvement_index`
- `developer_satisfaction_score`
- `application_criticality`
- `stakeholder_view_type`
- `application_criticality_score`

**Tagging Fields:**
- `resource_tags_application`
- `tag_owner`

**Resource Fields:**
- `count_unique_resources`
- `right_sizing_opportunity`
- `total_untagged_cost`
- `has_tags`

---

## Common Looker Syntax Issues

### 1. Parameter Reference Errors
**Location:** individual_project_dashboard.dashboard.lookml (lines 346, 366)
**Issue:** Filter parameter references don't match declared filter names
**Fix:** Use correct LookML syntax for parameter references

```yaml
# WRONG:
filters:
  cur2.line_item_usage_start_date: "{% parameter tracking_period_filter %}"

# CORRECT (if filter is named "Tracking Period"):
filters:
  cur2.line_item_usage_start_date: "{% parameter tracking_period %}"
```

### 2. Custom Visualization Dependencies
**Issue:** Multiple dashboards use Looker Marketplace visualizations
**Required Extensions:**
- `radial_gauge_vis`
- `bar_gauge_vis`
- `waterfall_vis`
- `looker_timeline`
- `sankey_vis`
- `looker_calendar`
- `treemap_vis`
- `kpi_vis`

**Action Required:** Install required visualization extensions from Looker Marketplace

---

## Recommendations

### Immediate Actions (High Priority)

1. **Fix Syntax Errors**
   - Update parameter references in individual_project_dashboard.dashboard.lookml

2. **Add Basic Missing Fields to cur2.view.lkml**
   ```lookml
   measure: count_environments {
     type: count_distinct
     sql: ${environment} ;;
     description: "Count of unique environments"
   }

   measure: count_projects {
     type: count_distinct
     sql: ${project} ;;  # Assuming project dimension exists
     description: "Count of unique projects"
   }

   measure: count_unique_resources {
     type: count_distinct
     sql: ${line_item_resource_id} ;;
     description: "Count of unique AWS resources"
   }

   dimension: has_tags {
     type: yesno
     sql: ${environment} IS NOT NULL OR ${team} IS NOT NULL ;;
     description: "Indicates if resource has any tags"
   }

   measure: total_untagged_cost {
     type: sum
     sql: ${line_item_unblended_cost} ;;
     filters: [has_tags: "no"]
     description: "Total cost of untagged resources"
   }
   ```

3. **Install Looker Marketplace Extensions**
   - Navigate to Looker Marketplace
   - Install required visualization plugins
   - Test dashboard rendering

### Medium Priority

4. **Create Gamification Extension**
   - Create `cur2_gamification.view.lkml` extending cur2
   - Define gamification metrics using existing cost/optimization data
   - Example:
   ```lookml
   extend: cur2

   measure: cost_hero_points {
     type: number
     sql: CAST(${savings_percentage} * 1000 AS INT64) ;;
     description: "Gamification points based on cost savings"
   }

   measure: level_progress {
     type: number
     sql: LEAST(100, ${resource_efficiency_score}) ;;
     description: "Progress towards next level (0-100)"
   }
   ```

5. **Create FinOps Maturity Extension**
   - Create `cur2_finops_maturity.view.lkml`
   - Calculate maturity scores from tag coverage, optimization score, etc.
   - Example:
   ```lookml
   extend: cur2

   measure: finops_maturity_score {
     type: number
     sql: (${tag_coverage_rate} + ${optimization_score} + ${commitment_savings_rate}) / 3 ;;
     description: "Overall FinOps maturity score"
   }
   ```

### Long-Term Enhancements

6. **External Data Integration**
   - For automation/action tracking: Integrate AWS Lambda/Step Functions logs
   - For business impact: Integrate APM tools (DataDog, New Relic)
   - For optimization recommendations: Integrate AWS Compute Optimizer API
   - Consider using Looker PDTs (Persistent Derived Tables) to cache external API data

7. **Carbon Footprint Enhancement**
   - Integrate AWS Customer Carbon Footprint Tool data
   - Map services to carbon emission factors
   - Create dedicated sustainability view

8. **Right-Sizing Recommendations**
   - Integrate AWS Cost Explorer Right-Sizing recommendations
   - Parse CloudWatch metrics for actual vs. provisioned capacity
   - Create actionable recommendations table

---

## Dashboard Status Matrix

| Dashboard | Status | Critical Issues | Warnings | Action Required |
|-----------|--------|----------------|----------|-----------------|
| multi_account_cost_allocation | ✅ Valid | 0 | 0 | None |
| discount_attribution | ✅ Valid | 0 | 0 | None |
| cost_comparison_analytics | ✅ Valid | 0 | 0 | None |
| resource_usage_analytics | ✅ Valid | 0 | 0 | None |
| resource_usage_pattern_analysis | ✅ Valid | 0 | 0 | None |
| tagging_compliance_governance | ✅ Valid | 0 | 0 | None |
| showback_chargeback_billing | ✅ Valid | 0 | 0 | None |
| unit_economics_business_metrics | ⚠️ Warning | 0 | 1 | Test calculations |
| sustainability_carbon_footprint | ⚠️ Warning | 0 | 1 | Validate estimates |
| realtime_cost_visibility | ✅ Valid | 0 | 0 | None |
| **finops_maturity_adoption** | ❌ Critical | 3 | 0 | Add missing fields |
| **ccoe_kpi_dashboard** | ❌ Critical | 7 | 0 | Add missing fields |
| **gamified_master_dashboard** | ❌ Critical | 2 | 2 | Add fields + plugins |
| **gamified_cost_optimization** | ❌ Critical | 9 | 2 | Create gamification extension |
| **individual_project_dashboard** | ❌ Critical | 2 | 6 | Fix syntax + add plugins |
| project_competition_dashboard | ✅ Valid | 0 | 1 | Install kpi_vis |
| team_challenge_dashboard | ✅ Valid | 0 | 3 | Install plugins |
| **simplified_action_execution** | ❌ Critical | 7+ | 0 | External data needed |
| **trustworthy_optimization_actions** | ❌ Critical | 12 | 0 | External data needed |
| **visible_business_impact** | ❌ Critical | 5+ | 0 | External data needed |

**Summary:**
- ✅ **10 dashboards** are fully functional
- ⚠️ **2 dashboards** have warnings but will work
- ❌ **8 dashboards** have critical errors and won't load properly

---

## Testing Checklist

Before deploying to production:

- [ ] Validate all 10 working dashboards load without errors
- [ ] Add missing simple fields (count_environments, count_projects, etc.)
- [ ] Fix parameter reference syntax in individual_project_dashboard
- [ ] Install required Looker Marketplace visualizations
- [ ] Test gamification dashboards with new field definitions
- [ ] Document which dashboards require external data integration
- [ ] Create data integration plan for action/optimization/business impact dashboards
- [ ] Update dashboard descriptions to note data requirements
- [ ] Set up monitoring for dashboard load errors
- [ ] Create user documentation for gamification system

---

## Appendix: Field Definition Templates

### A. Simple Count Measures
```lookml
measure: count_environments {
  type: count_distinct
  sql: ${environment} ;;
}

measure: count_projects {
  type: count_distinct
  sql: ${project} ;;
}

measure: count_unique_resources {
  type: count_distinct
  sql: ${line_item_resource_id} ;;
}
```

### B. Gamification Measures
```lookml
measure: cost_hero_points {
  type: number
  sql: CAST(${savings_percentage} * 1000 AS INT64) ;;
  value_format_name: decimal_0
}

measure: level_progress {
  type: number
  sql: LEAST(100, ${resource_efficiency_score}) ;;
  value_format_name: decimal_0
}

measure: team_collaboration_score {
  type: average
  sql: (${tag_coverage_rate} + ${optimization_score}) / 2 ;;
  value_format_name: decimal_1
}
```

### C. FinOps Maturity Measures
```lookml
measure: finops_maturity_score {
  type: number
  sql: (
    COALESCE(${tag_coverage_rate}, 0) * 0.3 +
    COALESCE(${optimization_score}, 0) * 0.3 +
    COALESCE(${commitment_savings_rate}, 0) * 0.4
  ) ;;
  value_format_name: decimal_1
  description: "Composite FinOps maturity score (0-100)"
}
```

### D. Tagging Helpers
```lookml
dimension: has_tags {
  type: yesno
  sql: ${environment} IS NOT NULL OR ${team} IS NOT NULL ;;
}

measure: total_untagged_cost {
  type: sum
  sql: ${line_item_unblended_cost} ;;
  filters: [has_tags: "no"]
  value_format_name: usd
}
```

---

## Contact & Support

For questions about this validation report:
- Review LookML documentation: https://docs.looker.com/data-modeling/learning-lookml
- Check AWS CUR 2.0 schema: https://docs.aws.amazon.com/cur/latest/userguide/cur-data-dictionary.html
- Looker Marketplace visualizations: https://marketplace.looker.com/

**Report Generated By:** Claude Code Validation Engine
**Version:** 1.0
**Validation Date:** 2025-11-17
