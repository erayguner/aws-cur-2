# Future-Proof Dashboard Architecture for AWS CUR 2.0

**Version:** 1.0
**Created:** 2025-11-17
**Validity Period:** 2025-2030 (5+ years)
**Framework Alignment:** FinOps Foundation Framework 2025

---

## Executive Summary

This architecture document defines a comprehensive, future-proof dashboard strategy for AWS Cost and Usage Report (CUR) 2.0 data, designed to remain relevant through 2030 and beyond. The design incorporates 2025 FinOps Foundation best practices, addresses emerging trends (AI/ML cost management, sustainability tracking, multi-cloud readiness), and supports all key FinOps personas across the organization.

### Key Strategic Pillars

1. **Timeless Metrics Focus** - Emphasize fundamental cost principles over trendy features
2. **Persona-Driven Design** - Six core personas with specific needs and KPIs
3. **Flexible Aggregation** - Multi-level hierarchies supporting various organizational structures
4. **Extensibility** - Design patterns that accommodate future AWS services and pricing models
5. **Sustainability Integration** - Carbon tracking and green computing metrics built-in
6. **AI/ML Readiness** - Specialized patterns for tracking AI workload costs

---

## 1. Future-Proof Design Principles

### 1.1 Timeless vs. Trendy Metrics

#### Timeless Metrics (Always Relevant)
These metrics represent fundamental cost management principles that transcend technology trends:

**Core Financial Metrics:**
- `cur2.total_unblended_cost` - True cost without blending
- `cur2.total_net_unblended_cost` - Cost after all discounts and credits
- `cur2.total_blended_cost` - Shared cost visibility
- `cur2.month_over_month_change` - Trend analysis
- `cur2.year_over_year_change` - Long-term growth patterns
- `cur2.average_daily_cost` - Normalized spending baseline

**Unit Economics (Critical for Long-Term Optimization):**
- `cur2.cost_per_resource` - Resource efficiency
- `cur2.cost_per_compute_hour` - Compute efficiency
- `cur2.cost_per_gb_storage` - Storage efficiency
- `cur2.data_transfer_cost_per_gb` - Network efficiency

**Waste Detection (Universal Optimization):**
- `cur2.total_commitment_waste` - Unused commitments
- `cur2.waste_percentage` - Overall waste ratio
- `cur2.total_ri_unused_cost` - RI waste
- `cur2.savings_plan_unused_commitment` - SP waste

#### Trendy Metrics (Include But Don't Over-Emphasize)
These metrics address current trends but may evolve:

**AI/ML Specific:**
- `cur2.sagemaker_cost` - SageMaker spending
- `cur2.bedrock_cost` - Bedrock (Generative AI) spending

**Sustainability:**
- `cur2.estimated_carbon_emissions_kg` - Carbon footprint
- `cur2.sustainability_score` - Green computing metrics
- `cur2.renewable_energy_percentage` - Green energy usage

**Gamification:**
- `cur2.cost_hero_points` - Achievement tracking
- `cur2.optimization_score` - Optimization achievements

### 1.2 Flexible Aggregation Patterns

#### Multi-Level Hierarchy Support

**Level 1: Organization (Highest)**
```
Dimensions:
- cur2.payer_account_id
- cur2.payer_account_name
Measures:
- cur2.total_unblended_cost
- cur2.count_unique_accounts
- cur2.count_unique_services
```

**Level 2: Business Unit / Division**
```
Dimensions:
- cur2.division (via tags)
- cur2.directorate (via tags)
- cur2.cost_category
Measures:
- cur2.total_unblended_cost
- cur2.team_cost_allocation
```

**Level 3: Team / Product**
```
Dimensions:
- cur2.team (via tags)
- cur2.project (via tags)
- cur2.environment
Measures:
- cur2.team_cost_allocation
- cur2.environment_production_cost
- cur2.environment_staging_cost
```

**Level 4: Resource (Lowest)**
```
Dimensions:
- cur2.line_item_resource_id
- cur2.line_item_product_code
- cur2.product_instance_type
Measures:
- cur2.cost_per_resource
- cur2.total_usage_amount
```

### 1.3 Multi-Cloud Considerations

While this dashboard focuses on AWS, design patterns enable future multi-cloud expansion:

**Cloud-Agnostic Dimensions (Future-Ready):**
- Service Category Classification
  - Compute: `line_item_product_code = 'AmazonEC2'`
  - Storage: `product_product_family = 'Storage'`
  - Database: `line_item_product_code LIKE '%RDS%'`
  - Network: `product_product_family = 'Data Transfer'`

**Standardized Metrics Across Clouds:**
- Total Cost (maps to GCP/Azure cost fields)
- Unit Cost per Resource
- Commitment Coverage %
- Waste Percentage

### 1.4 AI/ML Cost Tracking Patterns

As AI workloads are projected to exceed 50% of cloud compute by 2028, these patterns are essential:

**AI/ML Service Identification:**
```
Dimensions:
- cur2.line_item_product_code (Filter: 'AmazonSageMaker', 'AmazonBedrock', 'AmazonComprehend', etc.)
- cur2.product_instance_type (Filter: 'ml.*', 'p3.*', 'p4.*', 'g4dn.*')
- cur2.line_item_operation (Filter: Training, Inference operations)

Measures:
- cur2.sagemaker_cost
- cur2.bedrock_cost
- cur2.total_compute_spend (filtered for GPU instances)
```

**AI Workload Efficiency Metrics:**
```
Custom Calculations:
- Training Cost per Model = Total ML Cost / Number of Training Jobs
- Inference Cost per Request = Inference Cost / Request Count
- GPU Utilization Cost = GPU Cost / GPU Hours
```

### 1.5 Sustainability & Carbon Tracking

**Carbon Footprint Metrics:**
```
Measures:
- cur2.estimated_carbon_emissions_kg
- cur2.carbon_intensity_score
- cur2.carbon_efficiency_score
- cur2.renewable_energy_percentage

Dimensions for Carbon Optimization:
- cur2.product_region_code (regions have different carbon intensities)
- cur2.line_item_product_code (service-specific emissions)
- cur2.product_instance_type (efficiency ratings)
```

**Green Computing Strategies:**
```
Comparison Patterns:
- Carbon emissions by region (identify low-carbon regions)
- Energy efficiency by instance family
- Renewable energy adoption trends
```

### 1.6 Unit Economics Patterns

**Essential Unit Metrics:**
```
Per-Customer Metrics:
- Total Cost / Active Customers
- Compute Cost / Active Users
- Storage Cost / Data Volume

Per-Transaction Metrics:
- Total Cost / Transaction Count
- API Cost / API Calls
- Data Transfer Cost / Requests Processed

Per-Resource Metrics:
- cur2.cost_per_resource
- cur2.cost_per_compute_hour
- cur2.cost_per_gb_storage
```

---

## 2. 2025 FinOps Personas

Based on the FinOps Foundation Framework 2025, we define six core personas with distinct dashboard needs.

### 2.1 Executive / C-Level Persona
**Roles:** CFO, CTO, CEO, VP Engineering, VP Finance

**Primary Objectives:**
- Strategic cost visibility
- Board-level reporting
- Budget variance tracking
- Long-term trend analysis
- ROI on cloud investments

**Dashboard Characteristics:**
- High-level aggregations
- Month/Quarter/Year views
- Minimal drill-down
- Executive summary format
- Trend indicators (↑↓)

### 2.2 FinOps Practitioner Persona
**Roles:** FinOps Lead, Cloud Economist, FinOps Manager, Cost Optimization Engineer

**Primary Objectives:**
- End-to-end cost management
- Optimization opportunity identification
- Commitment management (RI/SP)
- Anomaly detection
- Forecast accuracy

**Dashboard Characteristics:**
- Comprehensive metrics
- All time granularities
- Deep drill-down capabilities
- Comparison views
- Anomaly alerts

### 2.3 Engineering / DevOps Persona
**Roles:** Engineering Managers, DevOps Teams, SRE, Platform Engineers

**Primary Objectives:**
- Team/project cost attribution
- Resource optimization
- Environment cost management (dev/staging/prod)
- Right-sizing opportunities
- Tag compliance

**Dashboard Characteristics:**
- Resource-level detail
- Service-specific views
- Tag-based filtering
- Environment comparisons
- Actionable recommendations

### 2.4 Finance / Procurement Persona
**Roles:** Finance Analysts, Financial Planning, Procurement, Budget Managers

**Primary Objectives:**
- Budget tracking and forecasting
- Invoice reconciliation
- Commitment planning
- Vendor management
- Allocation accuracy

**Dashboard Characteristics:**
- Budget vs. actual views
- Invoice-level detail
- Commitment utilization
- Forecast accuracy metrics
- Chargeback/showback reports

### 2.5 Product Management Persona
**Roles:** Product Owners, Business Owners, Product Managers

**Primary Objectives:**
- Product-level cost visibility
- Unit economics tracking
- Feature cost analysis
- Customer profitability
- Cost-to-serve metrics

**Dashboard Characteristics:**
- Product-centric views
- Unit economics focus
- Customer segmentation
- Feature-level costs
- Revenue correlation

### 2.6 Security / Compliance Persona
**Roles:** CISO, Compliance Officers, Security Engineers, Governance Teams

**Primary Objectives:**
- Security service spend
- Compliance cost tracking
- Policy enforcement monitoring
- Governance automation costs
- Risk-related expenses

**Dashboard Characteristics:**
- Security service focus
- Policy compliance rates
- Automation effectiveness
- Violation tracking
- Remediation metrics

---

## 3. Core Metrics by Persona

### 3.1 Executive / C-Level Dashboards

#### Daily Metrics (Morning Brief)
```
Metrics:
- cur2.total_unblended_cost (Yesterday)
- cur2.month_over_month_change (MTD)
- cur2.total_commitment_savings (MTD)
- cur2.is_cost_anomaly (Alert count)

Dimensions:
- cur2.line_item_usage_start_date (filter: yesterday)
- cur2.line_item_product_code (top 5 services)
```

#### Weekly Metrics (Monday Dashboard)
```
Metrics:
- cur2.total_unblended_cost (Last 7 days)
- cur2.week_over_week_change
- cur2.total_savings_realized (WTD)
- cur2.commitment_coverage_percentage
- cur2.waste_percentage

Dimensions:
- cur2.line_item_usage_start_week
- cur2.line_item_usage_account_name (top 10 accounts)
- cur2.line_item_product_code (top 10 services)
```

#### Monthly Metrics (Executive Review)
```
Metrics:
- cur2.total_unblended_cost (This month vs. last month)
- cur2.month_over_month_change
- cur2.year_over_year_change
- cur2.projected_monthly_cost (forecast)
- cur2.total_commitment_savings
- cur2.effective_savings_rate
- cur2.commitment_health_score
- cur2.optimization_score

Dimensions:
- cur2.billing_period_start_month
- cur2.division (by business unit)
- cur2.line_item_product_code (service breakdown)
- cur2.cost_category (if used)

Comparison Views:
- Current month vs. previous month
- Current month vs. same month last year
- Actuals vs. budget (if available)
```

#### KPIs That Matter
1. **Total Cloud Spend** - `cur2.total_unblended_cost`
2. **Growth Rate** - `cur2.month_over_month_change`, `cur2.year_over_year_change`
3. **Savings Achieved** - `cur2.total_savings_realized`
4. **Waste Level** - `cur2.waste_percentage`
5. **Optimization Health** - `cur2.optimization_score`

### 3.2 FinOps Practitioner Dashboards

#### Daily Metrics
```
Metrics:
- cur2.total_unblended_cost (yesterday, last 7d, MTD)
- cur2.average_daily_cost
- cur2.cost_difference (day-over-day)
- cur2.is_cost_anomaly (anomaly detection)
- cur2.cost_anomaly_score
- cur2.data_freshness_hours (data quality)

Dimensions:
- cur2.line_item_usage_start_date
- cur2.line_item_usage_account_name
- cur2.line_item_product_code
- cur2.line_item_resource_id (for anomaly drill-down)
```

#### Weekly Metrics
```
Metrics:
- cur2.week_over_week_change
- cur2.ri_utilization_rate
- cur2.savings_plan_utilization_rate
- cur2.commitment_coverage_percentage
- cur2.total_ri_unused_cost
- cur2.savings_plan_unused_commitment
- cur2.right_sizing_opportunity
- cur2.tag_coverage_rate

Dimensions:
- cur2.line_item_usage_start_week
- cur2.pricing_term (On-Demand vs. Reserved vs. Savings Plan)
- cur2.product_instance_type (for right-sizing)
- cur2.team (tag-based allocation)
```

#### Monthly Metrics
```
Metrics:
All daily/weekly metrics PLUS:
- cur2.total_commitment_waste
- cur2.commitment_health_score
- cur2.finops_maturity_score
- cur2.automation_coverage_percentage
- cur2.policy_compliance_rate
- cur2.governance_automation_savings
- cur2.total_discount_savings (EDP/PPA)

Dimensions:
- cur2.billing_period_start_month
- cur2.reservation_reservation_a_r_n (RI tracking)
- cur2.savings_plan_savings_plan_a_r_n (SP tracking)
- cur2.cost_category
```

#### KPIs That Matter
1. **Cost Optimization Score** - `cur2.optimization_score`
2. **Commitment Utilization** - `cur2.ri_utilization_rate`, `cur2.savings_plan_utilization_rate`
3. **Waste Reduction** - `cur2.waste_percentage`, `cur2.total_commitment_waste`
4. **Coverage** - `cur2.commitment_coverage_percentage`
5. **Anomaly Detection** - `cur2.is_cost_anomaly`, `cur2.cost_anomaly_score`
6. **Tag Compliance** - `cur2.tag_coverage_rate`
7. **Forecast Accuracy** - Compare `cur2.projected_monthly_cost` vs. actuals

#### Drill-Down Patterns
```
Level 1: Total Cost
  → Level 2: By Service (line_item_product_code)
    → Level 3: By Account (line_item_usage_account_name)
      → Level 4: By Region (product_region_code)
        → Level 5: By Resource (line_item_resource_id)
          → Level 6: Daily trend (line_item_usage_start_date)
```

### 3.3 Engineering / DevOps Dashboards

#### Daily Metrics
```
Metrics:
- cur2.total_unblended_cost (by team/project)
- cur2.environment_production_cost
- cur2.environment_staging_cost
- cur2.environment_development_cost
- cur2.environment_test_cost
- cur2.cost_per_resource
- cur2.total_usage_amount

Dimensions:
- cur2.team (tag-based)
- cur2.project (tag-based)
- cur2.environment (tag-based)
- cur2.line_item_product_code
- cur2.line_item_resource_id
- cur2.product_instance_type

Filters:
- cur2.line_item_usage_account_name (their team's accounts)
```

#### Weekly Metrics
```
Metrics:
- cur2.week_over_week_change (by project)
- cur2.total_on_demand_cost (right-sizing candidates)
- cur2.cost_per_compute_hour
- cur2.ec2_cost
- cur2.s3_cost
- cur2.rds_cost
- cur2.lambda_cost
- cur2.data_transfer_cost
- cur2.tag_coverage_rate (compliance)

Dimensions:
- cur2.product_instance_type (instance distribution)
- cur2.line_item_availability_zone (AZ optimization)
- cur2.pricing_term (On-Demand vs. RI/SP usage)
```

#### Monthly Metrics
```
Metrics:
- cur2.team_cost_allocation
- cur2.unallocated_team_cost (untagged resources)
- cur2.right_sizing_opportunity
- cur2.total_spot_cost (spot usage)
- cur2.resource_efficiency_score

Dimensions:
- cur2.aws_autoscaling_group
- cur2.aws_ecs_cluster
- cur2.aws_eks_cluster
- cur2.aws_cloudformation_stack
```

#### KPIs That Matter
1. **Team/Project Cost** - `cur2.team_cost_allocation`
2. **Environment Ratio** - Prod vs. Non-Prod costs
3. **Tag Compliance** - `cur2.tag_coverage_rate`
4. **Resource Efficiency** - `cur2.cost_per_resource`
5. **Unallocated Costs** - `cur2.unallocated_team_cost`

#### Drill-Down Patterns
```
Team View:
  → Environment (Prod/Staging/Dev)
    → Service (EC2/RDS/S3)
      → Resource ID
        → Daily usage trend

Service View:
  → Instance Type
    → Pricing Term (On-Demand/RI/SP)
      → Utilization metrics
```

### 3.4 Finance / Procurement Dashboards

#### Daily Metrics
```
Metrics:
- cur2.total_unblended_cost (MTD actuals)
- cur2.projected_monthly_cost (forecast)
- cur2.budget_burn_rate
- cur2.average_daily_cost

Dimensions:
- cur2.line_item_usage_start_date
- cur2.billing_period
- cur2.line_item_usage_account_name
```

#### Weekly Metrics
```
Metrics:
- cur2.total_net_unblended_cost (after credits)
- cur2.total_discount_amount
- cur2.total_edp_discount (EDP customers)
- cur2.total_ppa_discount (PPA customers)
- cur2.total_all_discounts

Dimensions:
- cur2.line_item_usage_start_week
- cur2.invoice_id (reconciliation)
```

#### Monthly Metrics
```
Metrics:
- cur2.total_unblended_cost (invoice reconciliation)
- cur2.total_tax_amount
- cur2.total_usage_cost
- cur2.total_ri_cost (commitment spend)
- cur2.total_savings_plan_cost (commitment spend)
- cur2.total_savings_plan_commitment (future obligations)
- cur2.total_commitment_savings (savings realized)

Dimensions:
- cur2.billing_period_start_month
- cur2.invoice_id
- cur2.billing_entity
- cur2.invoicing_entity
- cur2.payer_account_id
- cur2.line_item_usage_account_name (chargeback)
- cur2.cost_category (allocation)
```

#### KPIs That Matter
1. **Budget Variance** - Actual vs. Budget (% deviation)
2. **Forecast Accuracy** - `cur2.projected_monthly_cost` vs. actuals
3. **Discount Optimization** - `cur2.total_all_discounts` as % of total
4. **Commitment Utilization** - `cur2.ri_utilization_rate`, `cur2.savings_plan_utilization_rate`
5. **Invoice Accuracy** - Reconciliation rate

#### Drill-Down Patterns
```
Invoice Level:
  → Billing Account
    → Usage Account (chargeback allocation)
      → Service Category
        → Line Item Type (Usage/Fee/Tax)
```

### 3.5 Product Management Dashboards

#### Daily Metrics
```
Metrics:
- cur2.total_unblended_cost (by product)
- Cost per Active User (external metric joined)
- Cost per Transaction (external metric joined)

Dimensions:
- cur2.project (product mapping via tags)
- cur2.line_item_product_code
- cur2.environment (exclude non-prod)
```

#### Weekly Metrics
```
Metrics:
- cur2.week_over_week_change (by product)
- cur2.cost_per_resource
- cur2.ec2_cost (compute for product)
- cur2.rds_cost (database for product)
- cur2.s3_cost (storage for product)
- cur2.data_transfer_cost (bandwidth for product)

Dimensions:
- cur2.project
- cur2.product_product_family
```

#### Monthly Metrics
```
Metrics:
- cur2.total_unblended_cost (product level)
- cur2.month_over_month_change (product growth)
- Unit Economics (custom calculations):
  - Cost per Customer
  - Cost per Transaction
  - Infrastructure Cost as % of Revenue

Dimensions:
- cur2.project (product tags)
- cur2.team (product team)
- cur2.line_item_product_code
```

#### KPIs That Matter
1. **Product Cost** - Total infrastructure cost per product
2. **Unit Economics** - Cost per customer/transaction
3. **Growth Efficiency** - Cost growth vs. user/revenue growth
4. **Service Mix** - Compute/Storage/Network distribution
5. **Feature Costs** - Cost attribution to features

#### Drill-Down Patterns
```
Product View:
  → Feature/Component (via tags)
    → Service Type (compute/storage/database)
      → Environment
        → Resource details
```

### 3.6 Security / Compliance Dashboards

#### Daily Metrics
```
Metrics:
- Security service costs:
  - GuardDuty cost (filter line_item_product_code)
  - SecurityHub cost
  - WAF cost
  - Shield cost
  - Inspector cost
- cur2.violation_count (policy violations)
- cur2.policy_compliance_rate

Dimensions:
- cur2.line_item_product_code (security services)
- cur2.line_item_usage_account_name
- cur2.policy_type
- cur2.violation_severity
```

#### Weekly Metrics
```
Metrics:
- cur2.total_unblended_cost (security services)
- cur2.automation_coverage_percentage
- cur2.automated_actions_count
- cur2.successful_actions_count
- cur2.failed_actions_count
- cur2.policy_compliance_rate

Dimensions:
- cur2.automation_type
- cur2.policy_compliance_status
```

#### Monthly Metrics
```
Metrics:
- cur2.governance_automation_savings
- cur2.automation_roi_percentage
- cur2.automation_investment_cost
- cur2.compliant_resources_count
- cur2.non_compliant_resources_count
- cur2.time_to_remediation_hours
- cur2.workflow_efficiency_score

Dimensions:
- cur2.policy_type
- cur2.automation_recommendation
- cur2.line_item_usage_account_name
```

#### KPIs That Matter
1. **Security Spend** - Total security service costs
2. **Compliance Rate** - `cur2.policy_compliance_rate`
3. **Automation Effectiveness** - `cur2.automation_success_rate`
4. **ROI on Governance** - `cur2.automation_roi_percentage`
5. **Remediation Speed** - `cur2.time_to_remediation_hours`

---

## 4. Comparison Dashboard Patterns

### 4.1 Day-over-Day Comparisons

**Use Case:** Detect daily anomalies and unexpected spikes

**Pattern Design:**
```
Title: "Daily Cost Comparison"

Columns:
1. Date (cur2.line_item_usage_start_date)
2. Current Day Cost (cur2.total_unblended_cost)
3. Previous Day Cost (cur2.previous_day_cost - calculated)
4. Variance ($) (cur2.cost_difference)
5. Variance (%) (calculated: (Current - Previous) / Previous * 100)
6. Anomaly Flag (cur2.is_cost_anomaly)

Filters:
- Date range: Last 30 days
- Account: Multi-select
- Service: Multi-select

Sorting:
- Default: Date DESC
- Allow sort by: Variance % DESC (to find biggest changes)

Conditional Formatting:
- Variance % > 20%: Red background
- Variance % > 10%: Yellow background
- Variance % < -10%: Green background
- Anomaly Flag = Yes: Red flag icon
```

**Drill-Through:**
- Click date → Show service-level breakdown for that day
- Click anomaly → Show resource-level details

### 4.2 Week-over-Week Comparisons

**Use Case:** Identify weekly trends and patterns

**Pattern Design:**
```
Title: "Weekly Cost Trends"

Columns:
1. Week Starting (cur2.line_item_usage_start_week)
2. Current Week Cost (cur2.total_unblended_cost)
3. Previous Week Cost (cur2.previous_week_cost)
4. Variance ($) (calculated)
5. Variance (%) (cur2.week_over_week_change)
6. Service Breakdown (top 5 services contributing to change)

Filters:
- Week range: Last 12 weeks
- Account: Multi-select
- Service: Multi-select
- Environment: Multi-select

Grouping Options:
- By Account
- By Service
- By Team
- By Environment

Conditional Formatting:
- Variance % > 15%: Red
- Variance % > 5%: Yellow
- Variance % < 0%: Green (cost reduction)
```

**Sparkline Visualization:**
- Mini trend line showing last 12 weeks per row

### 4.3 Month-over-Month Comparisons

**Use Case:** Track monthly spending trends and budget performance

**Pattern Design:**
```
Title: "Monthly Cost Analysis"

Columns:
1. Month (cur2.billing_period_start_month)
2. Current Month Cost (cur2.total_unblended_cost)
3. Previous Month Cost (cur2.previous_month_cost)
4. Budget (if available - external data)
5. Variance vs. Last Month ($) (calculated)
6. Variance vs. Last Month (%) (cur2.month_over_month_change)
7. Variance vs. Budget ($) (calculated)
8. Variance vs. Budget (%) (calculated)
9. Forecast (cur2.projected_monthly_cost - for current month)

Filters:
- Month range: Last 12 months
- Account: Multi-select
- Service: Multi-select
- Cost Type: Unblended/Net Unblended/Blended

Sub-Tables (Expandable Rows):
- Click month → Show account-level breakdown
- Click account → Show service-level breakdown

Conditional Formatting:
- Over budget: Red background
- Within 5% of budget: Yellow background
- Under budget: Green background
- MoM growth > 20%: Red flag
```

**Visualization Options:**
- Bar chart: Monthly costs with trend line
- Waterfall chart: Month-over-month changes
- Area chart: Cumulative spend by service category

### 4.4 Year-over-Year Comparisons

**Use Case:** Long-term trend analysis and strategic planning

**Pattern Design:**
```
Title: "Year-over-Year Growth Analysis"

Columns:
1. Month (cur2.line_item_usage_start_month)
2. Current Year Cost (cur2.total_unblended_cost, year filter)
3. Previous Year Cost (cur2.total_unblended_cost, previous year filter)
4. Variance ($) (calculated)
5. Variance (%) (cur2.year_over_year_change)
6. CAGR (Compound Annual Growth Rate - calculated if >2 years data)

Filters:
- Years to compare: Multi-select (up to 3 years)
- Month range: All months or specific quarters
- Account: Multi-select
- Service: Multi-select

Grouping:
- By Quarter (rolled up to quarterly view)
- By Service Category
- By Business Unit

Additional Metrics:
- Total annual spend
- Average monthly spend
- Peak month and cost
- Lowest month and cost
```

**Visualization:**
- Line chart with multiple year lines
- Grouped bar chart (side-by-side monthly comparison)
- Heat map (month vs. year grid)

### 4.5 Variance Analysis Patterns

**Multi-Dimensional Variance Table:**
```
Title: "Cost Variance Analysis Matrix"

Rows: Service (cur2.line_item_product_code)
Columns:
- Current Period
- Previous Period
- Variance ($)
- Variance (%)
- Root Cause Category (manual or automated classification)
  - Volume Change (usage increase/decrease)
  - Rate Change (pricing change)
  - New Resources
  - Terminated Resources

Comparison Types (Tabs):
1. Day-over-Day
2. Week-over-Week
3. Month-over-Month
4. Quarter-over-Quarter
5. Year-over-Year

Filters:
- Time period
- Minimum variance threshold (e.g., only show >$100 or >10%)
- Account
- Service
- Team/Project

Drill-Down:
- Click service → Resource-level variance breakdown
- Show usage volume and rate separately
```

**Waterfall Chart Pattern:**
```
Title: "Cost Change Waterfall"

Purpose: Visualize cumulative cost changes

Structure:
- Starting Cost (Previous Period)
- + New Services
- + Volume Increases
- - Volume Decreases
- + Rate Increases
- - Rate Decreases
- + One-Time Charges
- - Credits/Discounts
- = Ending Cost (Current Period)

Dimensions Used:
- cur2.line_item_product_code (service identification)
- cur2.line_item_usage_amount (volume)
- cur2.line_item_unblended_rate (rate)
- cur2.total_discount_amount (discounts)
```

---

## 5. Table-Style Dashboard Specifications

### 5.1 Optimal Column Structures

#### Executive Summary Table
```
Table: "Executive Cost Summary"

Columns (8-10 max):
1. Category (Account/Service/Team)
2. Current Month Cost
3. Previous Month Cost
4. MoM Variance (%)
5. YTD Cost
6. Budget (if available)
7. Budget Variance (%)
8. Forecast
9. Trend (↑↓→)
10. Alerts (🔴🟡🟢)

Column Widths:
- Category: 20%
- Cost columns: 12% each
- Variance: 10% each
- Trend/Alerts: 8% each

Row Limit: 20-25 rows (top items + "Others" rollup)
```

#### FinOps Practitioner Detail Table
```
Table: "Comprehensive Cost Analysis"

Columns (12-15 max):
1. Service (line_item_product_code)
2. Account (line_item_usage_account_name)
3. Region (product_region_code)
4. Current Cost
5. Previous Cost
6. Variance (%)
7. Pricing Term (On-Demand/RI/SP)
8. Usage Amount
9. Savings Opportunity
10. Tag Coverage (%)
11. Optimization Score
12. Action Required (Yes/No)

Pagination: 50 rows per page
Export: Full data export available
```

#### Engineering Team Table
```
Table: "Team Resource Costs"

Columns (10-12 max):
1. Resource ID (line_item_resource_id)
2. Resource Type (product_instance_type)
3. Service (line_item_product_code)
4. Environment (environment tag)
5. Project (project tag)
6. Daily Cost
7. Monthly Trend
8. Pricing Term
9. Right-Sizing Opportunity
10. Tags (tag completeness)
11. Action

Row Grouping:
- Group by Project
  - Sub-group by Environment
    - List Resources

Expandable rows for drill-down
```

### 5.2 Conditional Formatting Rules

#### Color-Coded Variance Thresholds
```
Critical (Red):
- Variance > 25% or Absolute change > $10,000
- Anomaly detected (cur2.is_cost_anomaly = Yes)
- Budget exceeded by > 10%
- Tag coverage < 50%
- Commitment utilization < 70%

Warning (Yellow/Orange):
- Variance 10-25% or Absolute change $1,000-$10,000
- Budget variance ±5-10%
- Tag coverage 50-80%
- Commitment utilization 70-85%

Good (Green):
- Variance decrease (cost reduction)
- Budget under by > 5%
- Tag coverage > 80%
- Commitment utilization > 85%

Neutral (Gray):
- Variance < 10% and Absolute change < $1,000
```

#### Icon-Based Indicators
```
Trend Arrows:
- ↑↑ (Dark Red): Increase > 20%
- ↑ (Red): Increase 10-20%
- → (Gray): Change < 10%
- ↓ (Green): Decrease 10-20%
- ↓↓ (Dark Green): Decrease > 20%

Status Icons:
- 🔴 Critical: Immediate action required
- 🟡 Warning: Review recommended
- 🟢 Good: No action needed
- 🔵 Info: FYI only

Health Score (0-100):
- 0-50: Red background
- 51-75: Yellow background
- 76-90: Light green background
- 91-100: Dark green background
```

#### Progress Bars
```
Utilization Metrics (0-100%):
- RI Utilization (cur2.ri_utilization_rate)
- SP Utilization (cur2.savings_plan_utilization_rate)
- Tag Coverage (cur2.tag_coverage_rate)
- Budget Consumption (calculated)

Color Rules:
- 0-70%: Red bar
- 71-85%: Yellow bar
- 86-100%: Green bar
- >100% (over-commitment): Dark red bar
```

### 5.3 Drill-Through Patterns

#### Multi-Level Drill Architecture
```
Level 1 (Summary View):
  Dimensions: Organization/Division
  Measures: Total cost, MoM %, Top services
  Row Count: 10-20
  Actions: Click to drill to Level 2

Level 2 (Department/Team View):
  Dimensions: Team/Project/Account
  Measures: Team cost, Tag coverage, Optimization score
  Row Count: 20-50
  Actions: Click to drill to Level 3
  Breadcrumb: Level 1 > Level 2

Level 3 (Service View):
  Dimensions: Service, Region, Environment
  Measures: Service cost, Usage amount, Pricing term
  Row Count: 50-100
  Actions: Click to drill to Level 4
  Breadcrumb: Level 1 > Level 2 > Level 3

Level 4 (Resource View):
  Dimensions: Resource ID, Instance type, AZ
  Measures: Resource cost, Daily trend, Right-sizing
  Row Count: 100+
  Actions: Click to see daily time series
  Breadcrumb: Level 1 > Level 2 > Level 3 > Level 4

Level 5 (Time Series View):
  Dimensions: Date (daily granularity)
  Measures: Daily cost, Usage amount, Rate
  Visualization: Line chart + data table
  Breadcrumb: Level 1 > ... > Level 5
```

#### Cross-Dimensional Drill
```
From ANY level, allow drill to:
1. Time dimension (date → week → month → quarter → year)
2. Geography (region → AZ → location)
3. Organization (account → team → project → resource)
4. Service (category → service → operation → resource type)

Maintain context filters when drilling across dimensions
```

#### Drill-Through Actions
```
Action Menu per Row:
1. "View Details" → Drill down one level
2. "View Time Series" → Show daily trend for this item
3. "Compare" → Add to comparison basket
4. "View Similar Resources" → Filter by same attributes
5. "Export This Row" → Download details to CSV
6. "Create Alert" → Set up anomaly alert for this item
7. "View Tags" → Show all tags for this resource/account
8. "Optimization Opportunities" → Show recommendations
```

### 5.4 Export-Friendly Designs

#### CSV Export Structure
```
Export Format: Flat table (denormalized)

Include Columns:
- All visible dimensions
- All visible measures
- Hidden context columns:
  - Payer Account ID
  - Invoice ID
  - Resource ARN (if applicable)
  - All tags (comma-separated)
  - Report generation timestamp

Filename Convention:
  {ReportName}_{Persona}_{DateRange}_{Timestamp}.csv
  Example: CostSummary_Executive_2025-10-01_2025-10-31_20251101_143022.csv

Row Limit:
  - Web display: 1000 rows
  - Export: Unlimited (or 100,000 max)

Formatting:
  - Currency: Decimal format (no symbols in CSV)
  - Dates: ISO 8601 (YYYY-MM-DD)
  - Percentages: Decimal (0.15 for 15%)
```

#### Excel Export Enhancements
```
Multi-Sheet Workbook:

Sheet 1: "Summary"
  - Formatted table with conditional formatting
  - Preserved colors and icons
  - Frozen headers
  - Auto-filters enabled

Sheet 2: "Detail"
  - All rows (no pagination)
  - Formulas preserved (variance calculations)
  - Data validation on filters

Sheet 3: "Charts"
  - Embedded pivot charts
  - Trend visualizations
  - Comparison charts

Sheet 4: "Metadata"
  - Report parameters (date range, filters)
  - Generation timestamp
  - Data source information
  - Field definitions

Filename Convention:
  {ReportName}_{Persona}_{DateRange}_{Timestamp}.xlsx
```

#### PDF Export Design
```
Layout: Portrait or Landscape (auto-detect based on columns)

Components:
1. Header Section:
   - Report title
   - Organization logo (if configured)
   - Date range
   - Generation timestamp
   - Filters applied

2. Executive Summary Box:
   - Total cost (large font)
   - Key variance metrics
   - Traffic light indicators

3. Main Table:
   - Paginated (auto page breaks)
   - Repeated headers on each page
   - Conditional formatting preserved
   - Page numbers

4. Footer:
   - "Generated by AWS CUR 2.0 Dashboard"
   - Page X of Y
   - Confidential notice

Charts:
   - Include up to 3 charts per report
   - Full-width placement
```

#### Scheduled Export Features
```
Delivery Schedule:
  - Daily: 6 AM (yesterday's data)
  - Weekly: Monday 8 AM (last week's data)
  - Monthly: 1st of month, 9 AM (last month's data)

Recipients:
  - Email list (persona-based)
  - S3 bucket (for archival)
  - Slack/Teams integration (summary only)

Format Options:
  - CSV (for data processing)
  - Excel (for analysis)
  - PDF (for distribution)

Delivery Message:
  - Executive summary text
  - Key highlights (top 3 changes)
  - Link to interactive dashboard
  - Attachment (report file)
```

---

## 6. Advanced Dashboard Features

### 6.1 Real-Time Anomaly Detection

**Implementation:**
```
Anomaly Detection Dashboard

Metrics:
- cur2.is_cost_anomaly (boolean flag)
- cur2.cost_anomaly_score (0-100)
- cur2.cost_z_score (statistical measure)

Columns:
1. Timestamp (detected anomaly time)
2. Account/Service/Resource
3. Current Cost
4. Expected Cost (based on historical pattern)
5. Variance ($)
6. Variance (%)
7. Anomaly Score
8. Severity (Critical/High/Medium/Low)
9. Status (New/Investigating/Resolved/Ignored)
10. Assigned To

Filters:
- Date range: Last 7/30/90 days
- Severity: Multi-select
- Status: Multi-select
- Service: Multi-select

Actions:
- Acknowledge anomaly
- Assign to team member
- Mark as resolved
- Add notes
- Create Jira/ServiceNow ticket
```

### 6.2 Commitment Management Dashboard

**Reserved Instance Tracking:**
```
RI Utilization Table

Dimensions:
- cur2.reservation_reservation_a_r_n
- cur2.product_instance_type
- cur2.line_item_availability_zone
- cur2.pricing_lease_contract_length
- cur2.reservation_start_time
- cur2.reservation_end_time

Measures:
- cur2.total_ri_cost
- cur2.ri_utilization_rate
- cur2.total_ri_unused_cost
- cur2.reservation_number_of_reservations
- Days until expiration (calculated)

Conditional Formatting:
- Utilization < 70%: Red (under-utilized)
- Expiring in < 30 days: Orange (renewal required)
- Expiring in < 7 days: Red (urgent)

Actions:
- "Renew RI" → Link to AWS Console
- "Modify RI" → Link to modification workflow
- "Alert on utilization drop" → Create alert
```

**Savings Plan Tracking:**
```
SP Utilization Table

Dimensions:
- cur2.savings_plan_savings_plan_a_r_n
- cur2.savings_plan_offering_type (Compute/EC2/SageMaker)
- cur2.savings_plan_payment_option
- cur2.savings_plan_purchase_term
- cur2.savings_plan_start_time
- cur2.savings_plan_end_time

Measures:
- cur2.savings_plan_utilization_rate
- cur2.total_savings_plan_commitment
- cur2.savings_plan_unused_commitment
- cur2.total_savings_plan_cost
- cur2.sp_coverage_gap
- Days until expiration

Comparison:
- Actual usage vs. commitment (hourly/daily)
- On-Demand equivalent cost
- Savings realized
```

### 6.3 Tag Governance Dashboard

**Tag Compliance Monitoring:**
```
Tag Coverage Table

Dimensions:
- cur2.line_item_usage_account_name
- cur2.line_item_product_code
- cur2.has_tags (Yes/No)
- cur2.has_environment_tag (Yes/No)
- cur2.has_team_tag (Yes/No)

Measures:
- cur2.tag_coverage_rate
- cur2.tag_completeness (custom score)
- cur2.total_tagged_cost
- cur2.total_untagged_cost
- cur2.count_unique_resources (total resources)
- Tagged resources count (calculated)
- Untagged resources count (calculated)

Drill-Down:
- Click account → Show untagged resources
- Click service → Show tagging requirements

Actions:
- "Export Untagged Resources" → CSV list
- "Notify Account Owner" → Send email
- "Create Tagging Task" → Jira ticket
```

**Tag Value Analysis:**
```
Tag Usage Table

Dimensions:
- Tag Key (environment, team, project, cost_center, etc.)
- Tag Value
- cur2.line_item_usage_account_name

Measures:
- cur2.total_unblended_cost (by tag value)
- Resource count
- % of total cost

Use Cases:
- Cost allocation by tag
- Tag standardization (find variants: "prod", "production", "Prod")
- Orphaned tags (tags on deleted resources)
```

### 6.4 Sustainability Dashboard

**Carbon Footprint Tracking:**
```
Sustainability Metrics Table

Measures:
- cur2.estimated_carbon_emissions_kg
- cur2.carbon_intensity_score
- cur2.carbon_efficiency_score
- cur2.renewable_energy_percentage
- cur2.sustainability_score
- cur2.carbon_reduction_potential_kg
- cur2.green_computing_adoption_rate

Dimensions:
- cur2.product_region_code (carbon intensity by region)
- cur2.line_item_product_code (service emissions)
- cur2.product_instance_type (instance efficiency)

Visualizations:
- Carbon emissions trend (monthly)
- Emissions by region (bar chart)
- Emissions by service (pie chart)
- Carbon intensity heat map (region x service)

Recommendations:
- "Switch to greener regions" (suggest low-carbon regions)
- "Use ARM-based instances" (better efficiency)
- "Schedule batch jobs in off-peak hours" (renewable energy alignment)
```

### 6.5 AI/ML Cost Optimization Dashboard

**AI Workload Cost Tracking:**
```
AI/ML Cost Table

Service Filters:
- SageMaker (cur2.sagemaker_cost)
- Bedrock (cur2.bedrock_cost)
- Comprehend, Rekognition, Textract, etc.

Dimensions:
- cur2.line_item_product_code (AI service)
- cur2.line_item_operation (Training vs. Inference)
- cur2.product_instance_type (GPU instance types: p3, p4, g4dn, etc.)
- cur2.line_item_resource_id (model endpoints, training jobs)

Measures:
- cur2.total_unblended_cost
- cur2.total_usage_amount
- Training cost (filtered by operation)
- Inference cost (filtered by operation)
- Cost per training job (calculated)
- Cost per inference request (calculated)

Optimization Opportunities:
- "Spot instances for training" (cost savings)
- "Right-size inference endpoints" (over-provisioned detection)
- "Use Inferentia/Graviton instances" (cost efficiency)
- "Enable auto-scaling" (reduce idle time)
```

---

## 7. Dashboard Design Best Practices

### 7.1 Performance Optimization

**Query Optimization:**
```
1. Limit date ranges to necessary periods
   - Default: Last 30 days
   - Maximum: 12 months (for YoY comparisons)

2. Use incremental aggregations
   - Pre-aggregate daily summaries
   - Avoid full table scans

3. Implement caching
   - Cache expensive calculations (MoM, YoY)
   - Refresh cache: hourly for current day, daily for historical

4. Partition-aware queries
   - Filter on partition keys: billing_period, line_item_usage_start_date
   - Push down partition filters early
```

**Row Limits:**
```
Web Display:
- Executive dashboards: 20-50 rows max
- Practitioner dashboards: 100-500 rows with pagination
- Detail views: 1000 rows with virtualized scrolling

Export:
- CSV: Unlimited (or 100K row limit)
- Excel: 100K rows (Excel limit ~1M)
- PDF: 500 rows per report (paginated)
```

### 7.2 User Experience Guidelines

**Dashboard Load Time Targets:**
```
- Initial load: < 3 seconds
- Drill-down: < 2 seconds
- Filter application: < 1 second
- Export generation: < 10 seconds (for 10K rows)

If exceeding targets:
- Show loading spinner
- Display progress indicator
- Allow background export with email notification
```

**Responsive Design:**
```
Desktop (> 1200px):
- Full table with all columns
- Side-by-side charts
- Detailed drill-downs

Tablet (768px - 1200px):
- Reduced columns (priority columns only)
- Stacked charts
- Simplified drill-downs

Mobile (< 768px):
- Card-based layout (not tables)
- Single metric per card
- Swipe navigation
- Essential metrics only
```

**Accessibility:**
```
- Color-blind friendly palettes (not just red/green)
- ARIA labels for screen readers
- Keyboard navigation support
- High contrast mode
- Font size: Minimum 12px, default 14px
- Alt text for all icons
```

### 7.3 Data Freshness Indicators

**Freshness Metadata:**
```
Display on every dashboard:
- "Data as of: 2025-11-17 06:00 UTC"
- "Data freshness: 6 hours ago"
- Color indicator:
  - Green: < 24 hours
  - Yellow: 24-48 hours
  - Red: > 48 hours

Measures:
- cur2.data_freshness_hours (calculated)
- cur2.processing_lag_hours (pipeline delay)

Warning:
"Current month data is preliminary and may change as AWS finalizes billing."
```

### 7.4 Documentation Integration

**Inline Help:**
```
Every metric/dimension should have:
- Tooltip with description
- "?" icon linking to detailed documentation
- Example values
- Calculation formula (for measures)

Example:
Field: total_unblended_cost
Tooltip: "Unblended cost represents the actual cost before any blending adjustments. This is the most accurate cost for chargeback."
Formula: SUM(line_item_unblended_cost)
Link: [Learn more about cost types]
```

---

## 8. Implementation Roadmap

### Phase 1: Foundation (Months 1-2)
**Objective:** Deploy core dashboards for all personas

**Deliverables:**
1. Executive Dashboard (Summary)
2. FinOps Practitioner Dashboard (Comprehensive)
3. Engineering Dashboard (Team view)
4. Finance Dashboard (Budget tracking)
5. Basic data quality checks

**Success Metrics:**
- All 4 dashboards deployed
- < 3 second load time
- 90% user adoption

### Phase 2: Advanced Features (Months 3-4)
**Objective:** Add optimization and governance features

**Deliverables:**
1. Anomaly detection dashboard
2. Commitment management dashboard
3. Tag governance dashboard
4. Comparison views (DoD, WoW, MoM, YoY)
5. Drill-through implementation

**Success Metrics:**
- 50% of anomalies detected automatically
- 80% tag coverage
- 15% cost reduction identified

### Phase 3: Sustainability & AI/ML (Months 5-6)
**Objective:** Future-proof with emerging trends

**Deliverables:**
1. Sustainability dashboard (carbon tracking)
2. AI/ML cost optimization dashboard
3. Product management dashboard (unit economics)
4. Security/compliance dashboard

**Success Metrics:**
- Carbon footprint visibility for 100% of workloads
- AI/ML cost visibility
- Unit economics tracked

### Phase 4: Automation & Intelligence (Months 7-12)
**Objective:** Automate and optimize

**Deliverables:**
1. Automated alerting (anomalies, budget, commitments)
2. Recommendation engine integration
3. Scheduled exports and reports
4. API access for programmatic usage
5. FinOps maturity scoring

**Success Metrics:**
- 70% of alerts auto-resolved
- 25% total cost reduction
- FinOps maturity: "Run" level

---

## 9. Governance & Maintenance

### 9.1 Dashboard Lifecycle Management

**Quarterly Reviews:**
- Review usage analytics (which dashboards are used most)
- Gather user feedback
- Retire unused dashboards
- Optimize slow-performing queries

**Annual Updates:**
- Align with FinOps Framework updates
- Incorporate new AWS services
- Update cost allocation tags
- Refresh benchmarks

### 9.2 Version Control

**Dashboard Versioning:**
```
Version naming: v{Year}.{Quarter}.{Revision}
Example: v2025.Q4.1

Change log:
- v2025.Q4.1: Initial release
- v2025.Q4.2: Added sustainability metrics
- v2026.Q1.1: Added AI/ML cost tracking
```

**Rollback Plan:**
- Maintain previous version for 1 quarter
- Provide rollback option for users
- Document breaking changes

### 9.3 Access Control

**Role-Based Access:**
```
Executive:
- Read: All dashboards (summary level)
- Edit: None
- Export: Summary only

FinOps Practitioner:
- Read: All dashboards (full detail)
- Edit: All dashboards
- Export: Full data

Engineering:
- Read: Own team's data only
- Edit: None
- Export: Own team's data

Finance:
- Read: All financial data
- Edit: Budget data
- Export: Full financial data

Security:
- Read: Security/compliance dashboards
- Edit: Policy configurations
- Export: Compliance reports
```

---

## 10. Appendix

### 10.1 Complete Field Reference

All fields used in this architecture are documented in:
`/home/user/aws-cur-2/docs/cur2_field_inventory.md`

**Field Categories:**
- Primary Keys: 1 field
- Dimension Groups: 4 (time-based)
- Dimensions: 166 fields
- Measures: 153 fields
- **Total: 324 fields**

### 10.2 FinOps Framework Alignment

**Framework Elements Covered:**

**Domains:**
1. ✅ Understanding Cloud Usage and Cost
2. ✅ Performance Tracking and Benchmarking
3. ✅ Real-Time Decision Making
4. ✅ Cloud Rate Optimization
5. ✅ Cloud Usage Optimization
6. ✅ Organizational Alignment

**Capabilities Supported:**
- Cost Allocation (Tag governance)
- Forecasting (Projected costs)
- Budget Management (Variance tracking)
- Anomaly Detection (Automated alerts)
- Commitment Discounts (RI/SP management)
- Waste Reduction (Optimization opportunities)
- Unit Economics (Cost per metric tracking)

**Maturity Levels:**
- Crawl: Basic dashboards (Phase 1)
- Walk: Optimization features (Phase 2)
- Run: Automation and intelligence (Phase 4)

### 10.3 AWS Service Coverage

**Fully Supported Services:**
- Compute: EC2, Lambda, ECS, EKS
- Storage: S3, EBS, EFS, Glacier
- Database: RDS, DynamoDB, Redshift
- Network: VPC, CloudFront, Route53, Load Balancers
- AI/ML: SageMaker, Bedrock, Comprehend, Rekognition
- Security: GuardDuty, SecurityHub, WAF, Shield
- Analytics: Athena, Glue, EMR, Kinesis

**Future Services:**
Extensible design accommodates new AWS services automatically through:
- `line_item_product_code` (service identification)
- `product_product_family` (categorization)
- Dynamic service cost measures

### 10.4 Glossary

**Key Terms:**

- **Unblended Cost:** Actual cost before any organizational blending
- **Net Unblended Cost:** Cost after credits and discounts
- **Blended Cost:** Cost averaged across accounts in a consolidated billing family
- **Commitment Coverage:** % of usage covered by RIs or Savings Plans
- **Utilization Rate:** % of purchased commitments actually used
- **Waste:** Unused commitments or inefficient resource usage
- **Unit Economics:** Cost per business metric (customer, transaction, etc.)
- **Anomaly:** Statistical deviation from expected cost pattern
- **Tag Coverage:** % of resources with required tags
- **FinOps Maturity:** Level of FinOps practice sophistication (Crawl/Walk/Run)

---

## Conclusion

This future-proof dashboard architecture provides a comprehensive framework for AWS CUR 2.0 cost visibility and optimization, designed to remain relevant through 2030. By focusing on timeless metrics, persona-driven design, and extensible patterns, organizations can build dashboards that adapt to changing cloud trends while maintaining consistency and usability.

**Key Success Factors:**
1. Start with core personas and essential metrics
2. Implement comparison patterns for trend analysis
3. Prioritize tag governance for accurate allocation
4. Build in sustainability and AI/ML tracking early
5. Automate anomaly detection and alerting
6. Maintain flexibility for future AWS services and pricing models

**Next Steps:**
1. Review this architecture with stakeholders
2. Prioritize personas and dashboards for Phase 1
3. Validate field availability in your CUR 2.0 data
4. Begin dashboard development using the specifications provided
5. Iterate based on user feedback and FinOps maturity progression

---

**Document Metadata:**
- **Author:** AWS CUR 2.0 Dashboard Architecture Team
- **Last Updated:** 2025-11-17
- **Version:** 1.0
- **Review Cycle:** Quarterly
- **Next Review:** 2026-02-17
