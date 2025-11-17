# CUR 2.0 View Field Inventory

**Generated:** 2025-11-17 00:25:24

## Overview

This comprehensive inventory catalogs all fields available in the `cur2` view for validation and dashboard development.

### Field Summary
- **Primary Key Fields:** 1
- **Dimension Groups:** 4
- **Regular Dimensions:** 166
- **Measures:** 153
- **Total Fields:** 324

---

## 1. Primary Key Fields (1)

| Field Reference | SQL Column | Label | Group Label |
|---|---|---|---|
| cur2.cur2_line_item_pk | identity_line_item_id | Line Item ID [PK] | Identity > Primary Key |

## 2. Dimension Groups (4)

Dimension groups create multiple time-based fields from a single timestamp.

| Field Reference | SQL Column | Timeframes | Group Label |
|---|---|---|---|
| cur2.billing_period_end | bill_billing_period_end_date | raw, time, date, week, month, quarter, year | Billing > Time Periods |
| cur2.billing_period_start | bill_billing_period_start_date | raw, time, date, week, month, quarter, year | Billing > Time Periods |
| cur2.line_item_usage_end | line_item_usage_end_date | raw, time, date, week, month, quarter, year | Line Items > Time Periods |
| cur2.line_item_usage_start | line_item_usage_start_date | raw, time, date, week, month, quarter, year | Line Items > Time Periods |

### Available Timeframes

**billing_period_end** creates:
  - `cur2.billing_period_end_raw`
  - `cur2.billing_period_end_time`
  - `cur2.billing_period_end_date`
  - `cur2.billing_period_end_week`
  - `cur2.billing_period_end_month`
  - `cur2.billing_period_end_quarter`
  - `cur2.billing_period_end_year`
**billing_period_start** creates:
  - `cur2.billing_period_start_raw`
  - `cur2.billing_period_start_time`
  - `cur2.billing_period_start_date`
  - `cur2.billing_period_start_week`
  - `cur2.billing_period_start_month`
  - `cur2.billing_period_start_quarter`
  - `cur2.billing_period_start_year`
**line_item_usage_end** creates:
  - `cur2.line_item_usage_end_raw`
  - `cur2.line_item_usage_end_time`
  - `cur2.line_item_usage_end_date`
  - `cur2.line_item_usage_end_week`
  - `cur2.line_item_usage_end_month`
  - `cur2.line_item_usage_end_quarter`
  - `cur2.line_item_usage_end_year`
**line_item_usage_start** creates:
  - `cur2.line_item_usage_start_raw`
  - `cur2.line_item_usage_start_time`
  - `cur2.line_item_usage_start_date`
  - `cur2.line_item_usage_start_week`
  - `cur2.line_item_usage_start_month`
  - `cur2.line_item_usage_start_quarter`
  - `cur2.line_item_usage_start_year`

## 3. Regular Dimensions (166)

Regular dimensions are groupable fields that can be used to filter query results.

### Account Information > Source

| Field Reference | SQL Column |
|---|---|
| cur2.source_account_id | source_account_id |

### Account Information > Usage

| Field Reference | SQL Column |
|---|---|
| cur2.line_item_usage_account_id | line_item_usage_account_id |
| cur2.line_item_usage_account_name | line_item_usage_account_name |

### Billing > Account Information

| Field Reference | SQL Column |
|---|---|
| cur2.payer_account_id | bill_payer_account_id |
| cur2.payer_account_name | bill_payer_account_name |

### Billing > Bill Information

| Field Reference | SQL Column |
|---|---|
| cur2.bill_type | bill_bill_type |
| cur2.billing_entity | bill_billing_entity |
| cur2.invoice_id | bill_invoice_id |
| cur2.invoicing_entity | bill_invoicing_entity |

### Billing > Time Periods

| Field Reference | SQL Column |
|---|---|
| cur2.billing_period | billing_period |

### Cost Management > Categories

| Field Reference | SQL Column |
|---|---|
| cur2.cost_category | cost_category |

### Cost Management > Discounts

| Field Reference | SQL Column |
|---|---|
| cur2.discount | discount |
| cur2.discount_bundled_discount | discount_bundled_discount |
| cur2.discount_total_discount | discount_total_discount |
| cur2.edp_discount | N/A |
| cur2.ppa_discount | N/A |

### FinOps Automation > Compliance

| Field Reference | SQL Column |
|---|---|
| cur2.policy_compliance_status | N/A |

### FinOps Automation > Policy Types

| Field Reference | SQL Column |
|---|---|
| cur2.policy_type | N/A |

### FinOps Automation > Recommendations

| Field Reference | SQL Column |
|---|---|
| cur2.automation_recommendation | N/A |

### FinOps Automation > Types

| Field Reference | SQL Column |
|---|---|
| cur2.automation_type | N/A |

### FinOps Automation > Violations

| Field Reference | SQL Column |
|---|---|
| cur2.violation_severity | N/A |

### Geography > Regional

| Field Reference | SQL Column |
|---|---|
| cur2.region | N/A |
| cur2.region_country | N/A |

### Identity > Time

| Field Reference | SQL Column |
|---|---|
| cur2.identity_time_interval | identity_time_interval |

### Line Items > Costs

| Field Reference | SQL Column |
|---|---|
| cur2.line_item_blended_cost | line_item_blended_cost |
| cur2.line_item_blended_rate | line_item_blended_rate |
| cur2.line_item_net_unblended_cost | line_item_net_unblended_cost |
| cur2.line_item_net_unblended_rate | line_item_net_unblended_rate |
| cur2.line_item_unblended_cost | line_item_unblended_cost |
| cur2.line_item_unblended_rate | line_item_unblended_rate |

### Line Items > Details

| Field Reference | SQL Column |
|---|---|
| cur2.line_item_currency_code | line_item_currency_code |
| cur2.line_item_legal_entity | line_item_legal_entity |
| cur2.line_item_line_item_description | line_item_line_item_description |
| cur2.line_item_line_item_type | line_item_line_item_type |
| cur2.line_item_operation | line_item_operation |
| cur2.line_item_product_code | line_item_product_code |
| cur2.line_item_tax_type | line_item_tax_type |

### Line Items > Infrastructure

| Field Reference | SQL Column |
|---|---|
| cur2.line_item_availability_zone | line_item_availability_zone |

### Line Items > Resources

| Field Reference | SQL Column |
|---|---|
| cur2.line_item_resource_id | line_item_resource_id |

### Line Items > Usage

| Field Reference | SQL Column |
|---|---|
| cur2.line_item_normalization_factor | line_item_normalization_factor |
| cur2.line_item_normalized_usage_amount | line_item_normalized_usage_amount |
| cur2.line_item_usage_amount | line_item_usage_amount |
| cur2.line_item_usage_type | line_item_usage_type |

### Network > Geography

| Field Reference | SQL Column |
|---|---|
| cur2.destination_region | N/A |

### Network > Recommendations

| Field Reference | SQL Column |
|---|---|
| cur2.data_transfer_recommendation | N/A |

### Network > Transfer Types

| Field Reference | SQL Column |
|---|---|
| cur2.data_transfer_type | N/A |

### Pricing > Contract Terms

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_lease_contract_length | pricing_lease_contract_length |

### Pricing > Information

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_currency | pricing_currency |

### Pricing > Offering Details

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_offering_class | pricing_offering_class |

### Pricing > On-Demand Comparison

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_public_on_demand_cost | pricing_public_on_demand_cost |
| cur2.pricing_public_on_demand_rate | pricing_public_on_demand_rate |

### Pricing > Purchase Options

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_purchase_option | pricing_purchase_option |

### Pricing > Rate Details

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_rate_code | pricing_rate_code |
| cur2.pricing_rate_id | pricing_rate_id |

### Pricing > Terms

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_term | pricing_term |

### Pricing > Units

| Field Reference | SQL Column |
|---|---|
| cur2.pricing_unit | pricing_unit |

### Product > Classification

| Field Reference | SQL Column |
|---|---|
| cur2.product_product_family | product_product_family |

### Product > Fees

| Field Reference | SQL Column |
|---|---|
| cur2.product_fee_code | product_fee_code |
| cur2.product_fee_description | product_fee_description |

### Product > Identification

| Field Reference | SQL Column |
|---|---|
| cur2.product_sku | product_sku |

### Product > Information

| Field Reference | SQL Column |
|---|---|
| cur2.product_comment | product_comment |

### Product > Location

| Field Reference | SQL Column |
|---|---|
| cur2.product_from_location | product_from_location |
| cur2.product_from_location_type | product_from_location_type |
| cur2.product_from_region_code | product_from_region_code |
| cur2.product_location | product_location |
| cur2.product_location_type | product_location_type |
| cur2.product_region_code | product_region_code |
| cur2.product_to_location | product_to_location |
| cur2.product_to_location_type | product_to_location_type |
| cur2.product_to_region_code | product_to_region_code |

### Product > Operations

| Field Reference | SQL Column |
|---|---|
| cur2.product_operation | product_operation |

### Product > Pricing

| Field Reference | SQL Column |
|---|---|
| cur2.product_pricing_unit | product_pricing_unit |

### Product > Raw Data

| Field Reference | SQL Column |
|---|---|
| cur2.product | product |

### Product > Specifications

| Field Reference | SQL Column |
|---|---|
| cur2.product_instance_family | product_instance_family |
| cur2.product_instance_type | product_instance_type |
| cur2.product_instancesku | product_instancesku |

### Product > Usage

| Field Reference | SQL Column |
|---|---|
| cur2.product_usagetype | product_usagetype |

### Reserved Instance Details

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_amortized_upfront_cost_for_usage | reservation_amortized_upfront_cost_for_usage |
| cur2.reservation_amortized_upfront_fee_for_billing_period | reservation_amortized_upfront_fee_for_billing_period |
| cur2.reservation_availability_zone | reservation_availability_zone |
| cur2.reservation_effective_cost | reservation_effective_cost |

### Reserved Instances > Costs

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_recurring_fee_for_usage | reservation_recurring_fee_for_usage |
| cur2.reservation_upfront_value | reservation_upfront_value |

### Reserved Instances > Identification

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_reservation_a_r_n | reservation_reservation_a_r_n |
| cur2.reservation_subscription_id | reservation_subscription_id |

### Reserved Instances > Net Costs

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_net_amortized_upfront_cost_for_usage | reservation_net_amortized_upfront_cost_for_usage |
| cur2.reservation_net_amortized_upfront_fee_for_billing_period | reservation_net_amortized_upfront_fee_for_billing_period |
| cur2.reservation_net_effective_cost | reservation_net_effective_cost |
| cur2.reservation_net_recurring_fee_for_usage | reservation_net_recurring_fee_for_usage |
| cur2.reservation_net_upfront_value | reservation_net_upfront_value |

### Reserved Instances > Net Unused

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_net_unused_amortized_upfront_fee_for_billing_period | reservation_net_unused_amortized_upfront_fee_for_billing_period |
| cur2.reservation_net_unused_recurring_fee | reservation_net_unused_recurring_fee |

### Reserved Instances > Quantity

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_number_of_reservations | reservation_number_of_reservations |

### Reserved Instances > Status

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_modification_status | reservation_modification_status |

### Reserved Instances > Timing

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_end_time | reservation_end_time |
| cur2.reservation_start_time | reservation_start_time |

### Reserved Instances > Units

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_normalized_units_per_reservation | reservation_normalized_units_per_reservation |
| cur2.reservation_total_reserved_normalized_units | reservation_total_reserved_normalized_units |
| cur2.reservation_total_reserved_units | reservation_total_reserved_units |
| cur2.reservation_units_per_reservation | reservation_units_per_reservation |

### Reserved Instances > Unused

| Field Reference | SQL Column |
|---|---|
| cur2.reservation_unused_amortized_upfront_fee_for_billing_period | reservation_unused_amortized_upfront_fee_for_billing_period |
| cur2.reservation_unused_normalized_unit_quantity | reservation_unused_normalized_unit_quantity |
| cur2.reservation_unused_quantity | reservation_unused_quantity |
| cur2.reservation_unused_recurring_fee | reservation_unused_recurring_fee |

### Resource Tags

| Field Reference | SQL Column |
|---|---|
| cur2.aws_application | N/A |
| cur2.aws_autoscaling_group | N/A |
| cur2.aws_cloudformation_stack | N/A |
| cur2.aws_created_by | N/A |
| cur2.aws_ecs_cluster | N/A |
| cur2.aws_ecs_service | N/A |
| cur2.aws_eks_cluster | N/A |
| cur2.cost_center | N/A |
| cur2.created_by | N/A |
| cur2.directorate | N/A |
| cur2.division | N/A |
| cur2.env | N/A |
| cur2.environment | N/A |
| cur2.has_environment_tag | N/A |
| cur2.has_tags | resource_tags |
| cur2.has_team_tag | N/A |
| cur2.ml_wspace_no | N/A |
| cur2.name | N/A |
| cur2.proj | N/A |
| cur2.project | N/A |
| cur2.project_lead | N/A |
| cur2.project_owner | N/A |
| cur2.tag_completeness | N/A |
| cur2.tag_count | N/A |
| cur2.team | N/A |

### Resource Tags > Raw Data

| Field Reference | SQL Column |
|---|---|
| cur2.resource_tags | resource_tags |

### Savings Plans > Commitments

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_amortized_upfront_commitment_for_billing_period | savings_plan_amortized_upfront_commitment_for_billing_period |
| cur2.savings_plan_recurring_commitment_for_billing_period | savings_plan_recurring_commitment_for_billing_period |
| cur2.savings_plan_total_commitment_to_date | savings_plan_total_commitment_to_date |

### Savings Plans > Costs

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_savings_plan_effective_cost | savings_plan_savings_plan_effective_cost |

### Savings Plans > Identification

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_savings_plan_a_r_n | savings_plan_savings_plan_a_r_n |

### Savings Plans > Location

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_region | savings_plan_region |

### Savings Plans > Net Commitments

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_net_amortized_upfront_commitment_for_billing_period | savings_plan_net_amortized_upfront_commitment_for_billing_period |
| cur2.savings_plan_net_recurring_commitment_for_billing_period | savings_plan_net_recurring_commitment_for_billing_period |

### Savings Plans > Net Costs

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_net_savings_plan_effective_cost | savings_plan_net_savings_plan_effective_cost |

### Savings Plans > Plan Details

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_offering_type | savings_plan_offering_type |
| cur2.savings_plan_payment_option | savings_plan_payment_option |
| cur2.savings_plan_purchase_term | savings_plan_purchase_term |

### Savings Plans > Rates

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_savings_plan_rate | savings_plan_savings_plan_rate |

### Savings Plans > Specifications

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_instance_type_family | savings_plan_instance_type_family |

### Savings Plans > Timing

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_end_time | savings_plan_end_time |
| cur2.savings_plan_start_time | savings_plan_start_time |

### Savings Plans > Usage

| Field Reference | SQL Column |
|---|---|
| cur2.savings_plan_used_commitment | savings_plan_used_commitment |

### Split Line Items > Costs

| Field Reference | SQL Column |
|---|---|
| cur2.split_line_item_split_cost | split_line_item_split_cost |
| cur2.split_line_item_unused_cost | split_line_item_unused_cost |

### Split Line Items > Net Costs

| Field Reference | SQL Column |
|---|---|
| cur2.split_line_item_net_split_cost | split_line_item_net_split_cost |
| cur2.split_line_item_net_unused_cost | split_line_item_net_unused_cost |

### Split Line Items > Public Costs

| Field Reference | SQL Column |
|---|---|
| cur2.split_line_item_public_on_demand_split_cost | split_line_item_public_on_demand_split_cost |
| cur2.split_line_item_public_on_demand_unused_cost | split_line_item_public_on_demand_unused_cost |

### Split Line Items > Ratios

| Field Reference | SQL Column |
|---|---|
| cur2.split_line_item_split_usage_ratio | split_line_item_split_usage_ratio |

### Split Line Items > Resources

| Field Reference | SQL Column |
|---|---|
| cur2.split_line_item_parent_resource_id | split_line_item_parent_resource_id |

### Split Line Items > Usage

| Field Reference | SQL Column |
|---|---|
| cur2.split_line_item_actual_usage | split_line_item_actual_usage |
| cur2.split_line_item_reserved_usage | split_line_item_reserved_usage |
| cur2.split_line_item_split_usage | split_line_item_split_usage |

### Sustainability > Recommendations

| Field Reference | SQL Column |
|---|---|
| cur2.sustainability_recommendation | N/A |

### System > Additional Data

| Field Reference | SQL Column |
|---|---|
| cur2.data | data |

### System > Report Information

| Field Reference | SQL Column |
|---|---|
| cur2.report_name | report_name |

### Ungrouped

| Field Reference | SQL Column |
|---|---|
| cur2.cost_type | N/A |
| cur2.has_discount | N/A |
| cur2.is_tax | N/A |
| cur2.is_usage | N/A |
| cur2.service_category | N/A |

## 4. Measures (153)

Measures are aggregated fields that calculate values across selected dimensions.

### Anomaly Detection > Flags

| Field Reference | SQL Calculation |
|---|---|
| cur2.is_cost_anomaly | Aggregation-based |

### Anomaly Detection > Statistical

| Field Reference | SQL Calculation |
|---|---|
| cur2.cost_z_score | Aggregation-based |

### Basic Measures > Cost Types

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_tax_amount | Aggregation-based |
| cur2.total_usage_cost | Aggregation-based |

### Basic Measures > Discounts

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_discount_amount | Aggregation-based |

### Basic Measures > Primary Costs

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_blended_cost | Aggregation-based |
| cur2.total_net_unblended_cost | Aggregation-based |
| cur2.total_unblended_cost | Aggregation-based |

### Basic Measures > Record Counts

| Field Reference | SQL Calculation |
|---|---|
| cur2.count | Aggregation-based |
| cur2.count_unique_accounts | Aggregation-based |
| cur2.count_unique_regions | Aggregation-based |
| cur2.count_unique_resources | Aggregation-based |
| cur2.count_unique_services | Aggregation-based |

### Basic Measures > Usage

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_usage_amount | Aggregation-based |

### By Account > Discounts

| Field Reference | SQL Calculation |
|---|---|
| cur2.account_discount_amount | Aggregation-based |

### By Account > Reserved Instances

| Field Reference | SQL Calculation |
|---|---|
| cur2.account_ri_cost | Aggregation-based |

### By Account > Savings Plans

| Field Reference | SQL Calculation |
|---|---|
| cur2.account_savings_plan_cost | Aggregation-based |

### Chargeback > Team Allocation

| Field Reference | SQL Calculation |
|---|---|
| cur2.team_cost_allocation | Aggregation-based |

### Chargeback > Unallocated

| Field Reference | SQL Calculation |
|---|---|
| cur2.unallocated_team_cost | Aggregation-based |

### Commitment Discounts > Coverage

| Field Reference | SQL Calculation |
|---|---|
| cur2.commitment_coverage_percentage | Aggregation-based |
| cur2.commitment_savings_rate | Aggregation-based |
| cur2.total_commitment_covered_cost | Aggregation-based |

### Commitment Discounts > Reserved Instances

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_ri_cost | Aggregation-based |

### Commitment Discounts > Reserved Instances > Costs

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_ri_effective_cost | Aggregation-based |

### Commitment Discounts > Reserved Instances > Usage

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_ri_usage | Aggregation-based |

### Commitment Discounts > Reserved Instances > Utilization

| Field Reference | SQL Calculation |
|---|---|
| cur2.ri_utilization_rate | Aggregation-based |

### Commitment Discounts > Reserved Instances > Waste

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_ri_unused_cost | Aggregation-based |

### Commitment Discounts > Savings

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_commitment_savings | Aggregation-based |

### Commitment Discounts > Savings Plans

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_savings_plan_cost | Aggregation-based |

### Commitment Discounts > Savings Plans > Commitments

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_savings_plan_commitment | Aggregation-based |

### Commitment Discounts > Savings Plans > Coverage

| Field Reference | SQL Calculation |
|---|---|
| cur2.sp_coverage_gap | Aggregation-based |

### Commitment Discounts > Savings Plans > Usage

| Field Reference | SQL Calculation |
|---|---|
| cur2.sp_over_usage | Aggregation-based |
| cur2.total_savings_plan_usage | Aggregation-based |
| cur2.total_sp_eligible_usage | Aggregation-based |

### Commitment Discounts > Savings Plans > Utilization

| Field Reference | SQL Calculation |
|---|---|
| cur2.actual_vs_commitment_ratio | Aggregation-based |
| cur2.savings_plan_utilization_rate | Aggregation-based |
| cur2.total_savings_plan_utilized | Aggregation-based |

### Commitment Discounts > Savings Plans > Waste

| Field Reference | SQL Calculation |
|---|---|
| cur2.savings_plan_unused_commitment | Aggregation-based |

### Cost Analytics > Efficiency

| Field Reference | SQL Calculation |
|---|---|
| cur2.cost_per_resource | Aggregation-based |

### Cost Analytics > Time-Based

| Field Reference | SQL Calculation |
|---|---|
| cur2.average_daily_cost | Aggregation-based |
| cur2.cost_difference | Aggregation-based |
| cur2.month_over_month_change | Aggregation-based |
| cur2.previous_month_cost | Aggregation-based |
| cur2.previous_week_cost | Aggregation-based |
| cur2.week_over_week_change | Aggregation-based |
| cur2.year_over_year_change | Aggregation-based |

### Cost Analytics > Unit Costs

| Field Reference | SQL Calculation |
|---|---|
| cur2.cost_per_compute_hour | Aggregation-based |
| cur2.cost_per_gb_storage | Aggregation-based |

### Cost Analytics > Variance

| Field Reference | SQL Calculation |
|---|---|
| cur2.cost_variance_pct | Aggregation-based |

### Data Quality > Freshness

| Field Reference | SQL Calculation |
|---|---|
| cur2.data_freshness_hours | Aggregation-based |

### Discounts > EDP

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_edp_discount | Aggregation-based |

### Discounts > Overall

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_all_discounts | Aggregation-based |

### Discounts > PPA

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_ppa_discount | Aggregation-based |

### Discounts > Savings

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_discount_savings | Aggregation-based |

### Environment Analysis > Non-Production

| Field Reference | SQL Calculation |
|---|---|
| cur2.environment_development_cost | Aggregation-based |
| cur2.environment_staging_cost | Aggregation-based |
| cur2.environment_test_cost | Aggregation-based |

### Environment Analysis > Production

| Field Reference | SQL Calculation |
|---|---|
| cur2.environment_production_cost | Aggregation-based |

### FinOps > Anomaly Detection

| Field Reference | SQL Calculation |
|---|---|
| cur2.cost_anomaly_score | Aggregation-based |

### FinOps > Maturity Assessment

| Field Reference | SQL Calculation |
|---|---|
| cur2.finops_maturity_score | Aggregation-based |

### FinOps > Optimization Opportunities

| Field Reference | SQL Calculation |
|---|---|
| cur2.right_sizing_opportunity | Aggregation-based |

### FinOps > Overall Scores

| Field Reference | SQL Calculation |
|---|---|
| cur2.optimization_score | Aggregation-based |

### FinOps > Waste Management

| Field Reference | SQL Calculation |
|---|---|
| cur2.waste_detection_score | Aggregation-based |

### FinOps Automation > Actions

| Field Reference | SQL Calculation |
|---|---|
| cur2.automated_actions_count | Aggregation-based |
| cur2.failed_actions_count | Aggregation-based |
| cur2.successful_actions_count | Aggregation-based |

### FinOps Automation > Compliance

| Field Reference | SQL Calculation |
|---|---|
| cur2.policy_compliance_rate | Aggregation-based |

### FinOps Automation > Coverage

| Field Reference | SQL Calculation |
|---|---|
| cur2.automation_coverage_percentage | Aggregation-based |

### FinOps Automation > Performance

| Field Reference | SQL Calculation |
|---|---|
| cur2.automation_success_rate | Aggregation-based |
| cur2.time_to_remediation_hours | Aggregation-based |
| cur2.workflow_efficiency_score | Aggregation-based |

### FinOps Automation > ROI

| Field Reference | SQL Calculation |
|---|---|
| cur2.automation_investment_cost | Aggregation-based |
| cur2.automation_roi_percentage | Aggregation-based |
| cur2.governance_automation_savings | Aggregation-based |

### FinOps Automation > Remediation

| Field Reference | SQL Calculation |
|---|---|
| cur2.auto_remediated_count | Aggregation-based |
| cur2.manual_intervention_required | Aggregation-based |

### FinOps Automation > Resource Counts

| Field Reference | SQL Calculation |
|---|---|
| cur2.compliant_resources_count | Aggregation-based |
| cur2.non_compliant_resources_count | Aggregation-based |

### FinOps Automation > Violations

| Field Reference | SQL Calculation |
|---|---|
| cur2.violation_count | Aggregation-based |

### Gamification > Achievement Points

| Field Reference | SQL Calculation |
|---|---|
| cur2.cost_hero_points | Aggregation-based |

### Network > CDN

| Field Reference | SQL Calculation |
|---|---|
| cur2.cdn_optimization_percentage | Aggregation-based |
| cur2.cloudfront_cost | Aggregation-based |

### Network > Core Metrics

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_data_transfer_cost | Aggregation-based |
| cur2.total_data_transfer_gb | Aggregation-based |

### Network > Efficiency

| Field Reference | SQL Calculation |
|---|---|
| cur2.bandwidth_utilization_score | Aggregation-based |

### Network > Efficiency Metrics

| Field Reference | SQL Calculation |
|---|---|
| cur2.data_transfer_cost_per_gb | Aggregation-based |

### Network > Infrastructure

| Field Reference | SQL Calculation |
|---|---|
| cur2.load_balancer_cost | Aggregation-based |
| cur2.nat_gateway_cost | Aggregation-based |
| cur2.vpc_endpoint_cost | Aggregation-based |

### Network > Optimization

| Field Reference | SQL Calculation |
|---|---|
| cur2.bandwidth_optimization_potential | Aggregation-based |
| cur2.transfer_optimization_savings | Aggregation-based |

### Network > Overall Performance

| Field Reference | SQL Calculation |
|---|---|
| cur2.network_efficiency_score | Aggregation-based |

### Network > Transfer Types

| Field Reference | SQL Calculation |
|---|---|
| cur2.inter_region_cost | Aggregation-based |
| cur2.internet_egress_cost | Aggregation-based |

### Network > Usage Patterns

| Field Reference | SQL Calculation |
|---|---|
| cur2.average_bandwidth_usage | Aggregation-based |
| cur2.peak_bandwidth_usage | Aggregation-based |

### Overall > Health

| Field Reference | SQL Calculation |
|---|---|
| cur2.commitment_health_score | Aggregation-based |

### Overall > Savings

| Field Reference | SQL Calculation |
|---|---|
| cur2.effective_savings_rate | Aggregation-based |
| cur2.total_savings_realized | Aggregation-based |

### Overall > Spend Summary

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_compute_spend | Aggregation-based |

### Pricing Models > On-Demand

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_on_demand_cost | Aggregation-based |
| cur2.total_on_demand_spend | Aggregation-based |

### Pricing Models > Spot

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_spot_cost | Aggregation-based |

### Regional Analysis > EU Regions

| Field Reference | SQL Calculation |
|---|---|
| cur2.eu_west_1_cost | Aggregation-based |

### Regional Analysis > US Regions

| Field Reference | SQL Calculation |
|---|---|
| cur2.us_east_1_cost | Aggregation-based |
| cur2.us_west_2_cost | Aggregation-based |

### Service Analysis > Top Contributors

| Field Reference | SQL Calculation |
|---|---|
| cur2.top_10_services_cost | Aggregation-based |

### Service Costs > AI/ML

| Field Reference | SQL Calculation |
|---|---|
| cur2.bedrock_cost | Aggregation-based |
| cur2.sagemaker_cost | Aggregation-based |

### Service Costs > Compute

| Field Reference | SQL Calculation |
|---|---|
| cur2.ec2_cost | Aggregation-based |

### Service Costs > Database

| Field Reference | SQL Calculation |
|---|---|
| cur2.rds_cost | Aggregation-based |

### Service Costs > Networking

| Field Reference | SQL Calculation |
|---|---|
| cur2.data_transfer_cost | Aggregation-based |

### Service Costs > Serverless

| Field Reference | SQL Calculation |
|---|---|
| cur2.lambda_cost | Aggregation-based |

### Service Costs > Storage

| Field Reference | SQL Calculation |
|---|---|
| cur2.s3_cost | Aggregation-based |

### Service Usage > Data Transfer

| Field Reference | SQL Calculation |
|---|---|
| cur2.data_transfer_gb | Aggregation-based |

### Sustainability > Adoption

| Field Reference | SQL Calculation |
|---|---|
| cur2.green_computing_adoption_rate | Aggregation-based |

### Sustainability > Carbon Footprint

| Field Reference | SQL Calculation |
|---|---|
| cur2.carbon_intensity_score | Aggregation-based |
| cur2.estimated_carbon_emissions_kg | Aggregation-based |

### Sustainability > Carbon Impact

| Field Reference | SQL Calculation |
|---|---|
| cur2.estimated_carbon_impact | Aggregation-based |

### Sustainability > Compliance

| Field Reference | SQL Calculation |
|---|---|
| cur2.esg_compliance_score | Aggregation-based |

### Sustainability > Efficiency

| Field Reference | SQL Calculation |
|---|---|
| cur2.carbon_efficiency_score | Aggregation-based |

### Sustainability > Green Energy

| Field Reference | SQL Calculation |
|---|---|
| cur2.renewable_energy_percentage | Aggregation-based |

### Sustainability > Optimization

| Field Reference | SQL Calculation |
|---|---|
| cur2.carbon_reduction_potential_kg | Aggregation-based |

### Sustainability > Performance

| Field Reference | SQL Calculation |
|---|---|
| cur2.carbon_cost_efficiency | Aggregation-based |
| cur2.sustainability_score | Aggregation-based |

### Tag Analytics > Cost Distribution

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_tagged_cost | Aggregation-based |
| cur2.total_untagged_cost | Aggregation-based |

### Tag Analytics > Coverage Metrics

| Field Reference | SQL Calculation |
|---|---|
| cur2.tag_coverage_rate | Aggregation-based |

### Tag Analytics > Environment Metrics

| Field Reference | SQL Calculation |
|---|---|
| cur2.count_environments | Aggregation-based |

### Tag Analytics > Project Metrics

| Field Reference | SQL Calculation |
|---|---|
| cur2.count_projects | Aggregation-based |

### Tag Analytics > Team Metrics

| Field Reference | SQL Calculation |
|---|---|
| cur2.count_teams | Aggregation-based |

### Ungrouped

| Field Reference | SQL Calculation |
|---|---|
| cur2.budget_burn_rate | Aggregation-based |
| cur2.cost_variance_coefficient | Aggregation-based |
| cur2.data_completeness_score | Aggregation-based |
| cur2.data_quality_alerts | Aggregation-based |
| cur2.duplicate_detection_count | Aggregation-based |
| cur2.growth_forecast_90d | Aggregation-based |
| cur2.ingestion_health_score | Aggregation-based |
| cur2.level_progress | Aggregation-based |
| cur2.processing_lag_hours | Aggregation-based |
| cur2.projected_monthly_cost | Aggregation-based |
| cur2.resource_efficiency_score | Aggregation-based |
| cur2.savings_percentage | Aggregation-based |
| cur2.savings_vs_on_demand | Aggregation-based |
| cur2.seasonal_forecast_30d | Aggregation-based |
| cur2.sustainability_champion_score | Aggregation-based |
| cur2.team_collaboration_score | Aggregation-based |
| cur2.trend_forecast_7d | Aggregation-based |
| cur2.unit_cost_trend | Aggregation-based |
| cur2.usage_pattern_forecast | Aggregation-based |
| cur2.waste_warrior_achievements | Aggregation-based |

### Waste > Commitments

| Field Reference | SQL Calculation |
|---|---|
| cur2.total_commitment_waste | Aggregation-based |

### Waste > Overall

| Field Reference | SQL Calculation |
|---|---|
| cur2.waste_percentage | Aggregation-based |

---

## Appendix: Field Reference Guide

### How to Reference Fields in Dashboards

All fields can be referenced using the format: `cur2.field_name`

**Examples:**
- Dimension: `cur2.line_item_product_code`
- Dimension Group: `cur2.billing_period_end_date`
- Measure: `cur2.total_unblended_cost`

### Field Type Definitions

- **Primary Key:** Unique identifier for each row in the table
- **Dimension Group:** Time-based field that generates multiple timeframe fields (raw, time, date, week, month, quarter, year)
- **Dimension:** Categorical field used for filtering and grouping
- **Measure:** Aggregated numerical field (sum, count, average, etc.)

### Common Grouping Patterns

Fields are organized by logical groups:
- **Identity > Primary Key:** Primary identifiers
- **Identity > Time:** Time-related identity fields
- **Billing > ...:** Billing-related fields
- **Line Items > ...:** Line item-specific fields
- **Pricing > ...:** Pricing-related fields
- **Product > ...:** AWS product-related fields
- **Reservation > ...:** Reservation/RI-related fields
- **Basic Measures > ...:** Core cost and usage measures
