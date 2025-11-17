# ============================================================================
# Unified Multi-Cloud FOCUS - Looker View
# ============================================================================
# Description: LookML view definition for unified FOCUS data
# Version: 1.0.0
# Last Updated: 2025-11-17
# ============================================================================

view: unified_focus {
  label: "Multi-Cloud Costs (FOCUS)"
  sql_table_name: `your-project.finops.unified_focus_materialized` ;;
  
  # ----------------------------------------------------------------------------
  # Primary Key
  # ----------------------------------------------------------------------------
  
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(
      ${provider_name}, '|',
      CAST(${charge_period_start_raw} AS STRING), '|',
      ${sub_account_id}, '|',
      ${service_name}, '|',
      COALESCE(${resource_id}, 'NONE')
    ) ;;
  }
  
  # ----------------------------------------------------------------------------
  # Time Dimensions
  # ----------------------------------------------------------------------------
  
  dimension_group: charge_period_start {
    label: "Charge Period Start"
    description: "Start of the charge period (UTC)"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      day_of_month,
      month_name
    ]
    sql: ${TABLE}.ChargePeriodStart ;;
    convert_tz: no  # Already in UTC
  }
  
  dimension_group: charge_period_end {
    label: "Charge Period End"
    description: "End of the charge period (UTC)"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.ChargePeriodEnd ;;
    convert_tz: no
  }
  
  dimension: charge_period_duration_hours {
    label: "Charge Period Duration (Hours)"
    description: "Duration of charge period in hours"
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.ChargePeriodEnd, ${TABLE}.ChargePeriodStart, HOUR) ;;
    value_format_name: decimal_2
  }
  
  # ----------------------------------------------------------------------------
  # Provider Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: provider_name {
    label: "Cloud Provider"
    description: "Cloud service provider (AWS, GCP, etc.)"
    type: string
    sql: ${TABLE}.ProviderName ;;
    
    html: 
      {% if value == 'AWS' %}
        <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" style="height: 16px; vertical-align: middle;" /> {{ value }}
      {% elsif value == 'GCP' %}
        <img src="https://www.gstatic.com/devrel-devsite/prod/v2210deb8920cd4a55bd580441aa58e7853afc04b39a9d9ac4198e1cd7fbe04ef/cloud/images/favicons/onecloud/super_cloud.png" style="height: 16px; vertical-align: middle;" /> {{ value }}
      {% else %}
        {{ value }}
      {% endif %}
    ;;
    
    drill_fields: [service_category, service_name, sub_account_name]
  }
  
  # ----------------------------------------------------------------------------
  # Account/Project Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: sub_account_id {
    label: "Account/Project ID"
    description: "AWS Account ID or GCP Project ID"
    type: string
    sql: ${TABLE}.SubAccountId ;;
    drill_fields: [sub_account_name, service_category, region]
  }
  
  dimension: sub_account_name {
    label: "Account/Project Name"
    description: "Human-readable account or project name"
    type: string
    sql: ${TABLE}.SubAccountName ;;
    drill_fields: [service_category, service_name, resource_name]
  }
  
  dimension: sub_account_type {
    label: "Account Type"
    description: "Type of account (Linked, Master, etc.)"
    type: string
    sql: ${TABLE}.SubAccountType ;;
  }
  
  # ----------------------------------------------------------------------------
  # Service Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: service_category {
    label: "Service Category"
    description: "FOCUS-compliant service category (Compute, Storage, etc.)"
    type: string
    sql: ${TABLE}.ServiceCategory ;;
    drill_fields: [service_name, region, total_effective_cost]
    
    # Conditional formatting
    html: 
      {% if value == 'Compute' %}
        <span style="color: #4285F4;">🖥️ {{ value }}</span>
      {% elsif value == 'Storage' %}
        <span style="color: #EA4335;">💾 {{ value }}</span>
      {% elsif value == 'Networking' %}
        <span style="color: #FBBC04;">🌐 {{ value }}</span>
      {% elsif value == 'Database' %}
        <span style="color: #34A853;">🗄️ {{ value }}</span>
      {% else %}
        {{ value }}
      {% endif %}
    ;;
  }
  
  dimension: service_name {
    label: "Service Name"
    description: "Provider-specific service name"
    type: string
    sql: ${TABLE}.ServiceName ;;
    drill_fields: [resource_name, region, total_effective_cost]
    
    # Suggest filters for common services
    suggestable: yes
  }
  
  # ----------------------------------------------------------------------------
  # Resource Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: resource_id {
    label: "Resource ID"
    description: "Unique resource identifier (ARN, URI, etc.)"
    type: string
    sql: ${TABLE}.ResourceId ;;
    
    # Link to provider console (if possible)
    link: {
      label: "View in {{ provider_name._value }} Console"
      url: "{% if provider_name._value == 'AWS' %}https://console.aws.amazon.com/{% elsif provider_name._value == 'GCP' %}https://console.cloud.google.com/{% endif %}"
      icon_url: "https://looker.com/favicon.ico"
    }
  }
  
  dimension: resource_name {
    label: "Resource Name"
    description: "Human-readable resource name"
    type: string
    sql: ${TABLE}.ResourceName ;;
  }
  
  dimension: resource_type {
    label: "Resource Type"
    description: "Type of cloud resource"
    type: string
    sql: ${TABLE}.ResourceType ;;
  }
  
  # ----------------------------------------------------------------------------
  # Location Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: region {
    label: "Region"
    description: "Cloud region"
    type: string
    sql: ${TABLE}.Region ;;
    drill_fields: [availability_zone, service_name, total_effective_cost]
    
    # Map view support (requires region mapping)
    map_layer_name: cloud_regions
  }
  
  dimension: availability_zone {
    label: "Availability Zone"
    description: "Availability zone within region"
    type: string
    sql: ${TABLE}.AvailabilityZone ;;
  }
  
  # ----------------------------------------------------------------------------
  # Charge Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: charge_category {
    label: "Charge Category"
    description: "FOCUS charge category (Usage, Purchase, Tax, Adjustment)"
    type: string
    sql: ${TABLE}.ChargeCategory ;;
    
    html: 
      {% if value == 'Usage' %}
        <span style="background-color: #E8F5E9; padding: 2px 6px; border-radius: 3px;">{{ value }}</span>
      {% elsif value == 'Purchase' %}
        <span style="background-color: #E3F2FD; padding: 2px 6px; border-radius: 3px;">{{ value }}</span>
      {% elsif value == 'Tax' %}
        <span style="background-color: #FFF3E0; padding: 2px 6px; border-radius: 3px;">{{ value }}</span>
      {% elsif value == 'Adjustment' %}
        <span style="background-color: #FCE4EC; padding: 2px 6px; border-radius: 3px;">{{ value }}</span>
      {% else %}
        {{ value }}
      {% endif %}
    ;;
  }
  
  dimension: charge_class {
    label: "Charge Class"
    description: "Charge class (On-Demand, Commitment, etc.)"
    type: string
    sql: ${TABLE}.ChargeClass ;;
  }
  
  dimension: charge_description {
    label: "Charge Description"
    description: "Detailed charge description"
    type: string
    sql: ${TABLE}.ChargeDescription ;;
  }
  
  dimension: charge_frequency {
    label: "Charge Frequency"
    description: "Frequency of charge (Hourly, Monthly, One-Time)"
    type: string
    sql: ${TABLE}.ChargeFrequency ;;
  }
  
  # ----------------------------------------------------------------------------
  # Cost Dimensions (for filtering)
  # ----------------------------------------------------------------------------
  
  dimension: billed_cost {
    label: "Billed Cost (Line Item)"
    description: "Invoiced cost for this line item"
    type: number
    sql: ${TABLE}.BilledCost ;;
    value_format_name: usd
    
    # Conditional formatting for cost ranges
    html: 
      {% if value < 0 %}
        <span style="color: #EA4335;">{{ rendered_value }}</span>
      {% elsif value > 1000 %}
        <span style="color: #EA4335; font-weight: bold;">{{ rendered_value }}</span>
      {% elsif value > 100 %}
        <span style="color: #FBBC04; font-weight: bold;">{{ rendered_value }}</span>
      {% else %}
        {{ rendered_value }}
      {% endif %}
    ;;
  }
  
  dimension: effective_cost {
    label: "Effective Cost (Line Item)"
    description: "Cost after all discounts and credits"
    type: number
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
  }
  
  dimension: list_cost {
    label: "List Cost (Line Item)"
    description: "On-demand list price cost"
    type: number
    sql: ${TABLE}.ListCost ;;
    value_format_name: usd
  }
  
  # ----------------------------------------------------------------------------
  # Cost Tiers (for filtering)
  # ----------------------------------------------------------------------------
  
  dimension: cost_tier {
    label: "Cost Tier"
    description: "Categorize resources by cost magnitude"
    type: tier
    tiers: [0, 1, 10, 100, 1000, 10000]
    style: integer
    sql: ${effective_cost} ;;
    value_format_name: usd
  }
  
  dimension: is_high_cost_resource {
    label: "High Cost Resource (>$1000)"
    description: "Flag for resources with effective cost > $1000"
    type: yesno
    sql: ${effective_cost} > 1000 ;;
  }
  
  # ----------------------------------------------------------------------------
  # Pricing Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: pricing_category {
    label: "Pricing Category"
    description: "Pricing model category"
    type: string
    sql: ${TABLE}.PricingCategory ;;
  }
  
  dimension: pricing_unit {
    label: "Pricing Unit"
    description: "Unit of pricing (GB, hours, requests)"
    type: string
    sql: ${TABLE}.PricingUnit ;;
  }
  
  dimension: pricing_quantity {
    label: "Pricing Quantity"
    type: number
    sql: ${TABLE}.PricingQuantity ;;
    value_format_name: decimal_2
  }
  
  dimension: usage_quantity {
    label: "Usage Quantity (Line Item)"
    description: "Quantity of usage for this line item"
    type: number
    sql: ${TABLE}.UsageQuantity ;;
    value_format_name: decimal_2
  }
  
  dimension: usage_unit {
    label: "Usage Unit"
    description: "Unit of usage measurement"
    type: string
    sql: ${TABLE}.UsageUnit ;;
  }
  
  dimension: unit_cost {
    label: "Unit Cost"
    description: "Cost per unit of usage"
    type: number
    sql: SAFE_DIVIDE(${TABLE}.EffectiveCost, NULLIF(${TABLE}.UsageQuantity, 0)) ;;
    value_format_name: usd
  }
  
  # ----------------------------------------------------------------------------
  # Commitment Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: commitment_discount_id {
    label: "Commitment ID"
    description: "Unique identifier for RI/Savings Plan/CUD"
    type: string
    sql: ${TABLE}.CommitmentDiscountId ;;
  }
  
  dimension: commitment_discount_name {
    label: "Commitment Name"
    description: "Human-readable commitment name"
    type: string
    sql: ${TABLE}.CommitmentDiscountName ;;
  }
  
  dimension: commitment_discount_type {
    label: "Commitment Type"
    description: "Type of commitment (RI, Savings Plan, CUD)"
    type: string
    sql: ${TABLE}.CommitmentDiscountType ;;
  }
  
  dimension: commitment_discount_status {
    label: "Commitment Status"
    description: "Status of commitment (Used, Unused)"
    type: string
    sql: ${TABLE}.CommitmentDiscountStatus ;;
    
    html: 
      {% if value == 'Used' %}
        <span style="background-color: #E8F5E9; color: #2E7D32; padding: 2px 8px; border-radius: 3px;">✓ {{ value }}</span>
      {% elsif value == 'Unused' %}
        <span style="background-color: #FFEBEE; color: #C62828; padding: 2px 8px; border-radius: 3px;">⚠ {{ value }}</span>
      {% else %}
        {{ value }}
      {% endif %}
    ;;
  }
  
  dimension: contracted_cost {
    label: "Contracted Cost"
    description: "Contracted commitment cost"
    type: number
    sql: ${TABLE}.ContractedCost ;;
    value_format_name: usd
  }
  
  dimension: contracted_unit_price {
    label: "Contracted Unit Price"
    type: number
    sql: ${TABLE}.ContractedUnitPrice ;;
    value_format_name: usd
  }
  
  # ----------------------------------------------------------------------------
  # Tag Dimensions (JSON Extraction)
  # ----------------------------------------------------------------------------
  
  dimension: tags {
    label: "Tags (JSON)"
    description: "Raw tags in JSON format"
    type: string
    sql: ${TABLE}.Tags ;;
    hidden: yes
  }
  
  dimension: tag_team {
    label: "Tag: Team"
    description: "Team tag value"
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Team') ;;
    group_label: "Tags"
    drill_fields: [tag_environment, tag_application, total_effective_cost]
  }
  
  dimension: tag_environment {
    label: "Tag: Environment"
    description: "Environment tag value (prod, dev, test)"
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Environment') ;;
    group_label: "Tags"
    
    html: 
      {% if value == 'prod' or value == 'production' %}
        <span style="background-color: #EA4335; color: white; padding: 2px 8px; border-radius: 3px; font-weight: bold;">{{ value }}</span>
      {% elsif value == 'dev' or value == 'development' %}
        <span style="background-color: #4285F4; color: white; padding: 2px 8px; border-radius: 3px;">{{ value }}</span>
      {% elsif value == 'test' or value == 'staging' %}
        <span style="background-color: #FBBC04; color: white; padding: 2px 8px; border-radius: 3px;">{{ value }}</span>
      {% else %}
        {{ value }}
      {% endif %}
    ;;
  }
  
  dimension: tag_owner {
    label: "Tag: Owner"
    description: "Owner tag value"
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Owner') ;;
    group_label: "Tags"
  }
  
  dimension: tag_application {
    label: "Tag: Application"
    description: "Application tag value"
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Application') ;;
    group_label: "Tags"
  }
  
  dimension: tag_cost_center {
    label: "Tag: Cost Center"
    description: "Cost center tag value"
    type: string
    sql: JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.CostCenter') ;;
    group_label: "Tags"
  }
  
  dimension: is_tagged {
    label: "Has Tags"
    description: "Whether resource has any tags"
    type: yesno
    sql: ${TABLE}.Tags IS NOT NULL ;;
    group_label: "Tags"
  }
  
  dimension: has_required_tags {
    label: "Has Required Tags"
    description: "Has Team, Environment, and Owner tags"
    type: yesno
    sql: JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Team') IS NOT NULL
         AND JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Environment') IS NOT NULL
         AND JSON_EXTRACT_SCALAR(${TABLE}.Tags, '$.Owner') IS NOT NULL ;;
    group_label: "Tags"
  }
  
  # ----------------------------------------------------------------------------
  # Metadata Dimensions
  # ----------------------------------------------------------------------------
  
  dimension: invoice_issuer_name {
    label: "Invoice Issuer"
    description: "Entity issuing the invoice"
    type: string
    sql: ${TABLE}.InvoiceIssuerName ;;
  }
  
  dimension: billing_currency {
    label: "Billing Currency"
    description: "Currency of billed amount"
    type: string
    sql: ${TABLE}.BillingCurrency ;;
  }
  
  dimension_group: etl_timestamp {
    label: "ETL"
    description: "When this data was loaded into the unified view"
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}._ETL_Timestamp ;;
    hidden: yes
  }
  
  dimension: source_table {
    label: "Source Table"
    description: "Source table (aws_cur_focus or gcp_billing_focus)"
    type: string
    sql: ${TABLE}._SourceTable ;;
    hidden: yes
  }
  
  # ----------------------------------------------------------------------------
  # Measures (Aggregations)
  # ----------------------------------------------------------------------------
  
  # --- Cost Measures ---
  
  measure: total_billed_cost {
    label: "Total Billed Cost"
    description: "Sum of invoiced costs"
    type: sum
    sql: ${TABLE}.BilledCost ;;
    value_format_name: usd
    drill_fields: [detail*]
    
    html: 
      {% if value > 100000 %}
        <span style="font-size: 18px; font-weight: bold; color: #EA4335;">{{ rendered_value }}</span>
      {% elsif value > 10000 %}
        <span style="font-size: 16px; font-weight: bold; color: #FBBC04;">{{ rendered_value }}</span>
      {% else %}
        <span style="font-size: 14px;">{{ rendered_value }}</span>
      {% endif %}
    ;;
  }
  
  measure: total_effective_cost {
    label: "Total Effective Cost"
    description: "Sum of costs after discounts and credits"
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
    drill_fields: [detail*]
  }
  
  measure: total_list_cost {
    label: "Total List Cost"
    description: "Sum of on-demand list prices"
    type: sum
    sql: ${TABLE}.ListCost ;;
    value_format_name: usd
    drill_fields: [detail*]
  }
  
  measure: total_savings {
    label: "Total Savings"
    description: "List cost minus effective cost (commitment discounts, credits)"
    type: number
    sql: ${total_list_cost} - ${total_effective_cost} ;;
    value_format_name: usd
    
    html: 
      {% if value > 0 %}
        <span style="color: #34A853; font-weight: bold;">💰 {{ rendered_value }}</span>
      {% elsif value < 0 %}
        <span style="color: #EA4335;">{{ rendered_value }}</span>
      {% else %}
        {{ rendered_value }}
      {% endif %}
    ;;
  }
  
  measure: savings_percentage {
    label: "Savings %"
    description: "Percentage savings from list price"
    type: number
    sql: SAFE_DIVIDE(${total_savings}, NULLIF(${total_list_cost}, 0)) * 100 ;;
    value_format_name: decimal_2
    html: {{ rendered_value }}% ;;
  }
  
  measure: average_daily_cost {
    label: "Average Daily Cost"
    description: "Average cost per day in selected period"
    type: number
    sql: ${total_effective_cost} / NULLIF(COUNT(DISTINCT DATE(${TABLE}.ChargePeriodStart)), 0) ;;
    value_format_name: usd
  }
  
  # --- Usage Measures ---
  
  measure: total_usage_quantity {
    label: "Total Usage Quantity"
    description: "Sum of usage quantities"
    type: sum
    sql: ${TABLE}.UsageQuantity ;;
    value_format_name: decimal_2
    drill_fields: [detail*]
  }
  
  measure: average_usage_quantity {
    label: "Average Usage Quantity"
    description: "Average usage quantity per line item"
    type: average
    sql: ${TABLE}.UsageQuantity ;;
    value_format_name: decimal_2
  }
  
  measure: average_unit_cost {
    label: "Average Unit Cost"
    description: "Average cost per unit of usage"
    type: number
    sql: SAFE_DIVIDE(${total_effective_cost}, NULLIF(${total_usage_quantity}, 0)) ;;
    value_format_name: usd
  }
  
  # --- Resource Measures ---
  
  measure: unique_resources {
    label: "Unique Resources"
    description: "Count of distinct resources"
    type: count_distinct
    sql: ${TABLE}.ResourceId ;;
    drill_fields: [resource_detail*]
  }
  
  measure: unique_accounts {
    label: "Unique Accounts/Projects"
    description: "Count of distinct accounts or projects"
    type: count_distinct
    sql: ${TABLE}.SubAccountId ;;
  }
  
  measure: unique_services {
    label: "Unique Services"
    description: "Count of distinct services used"
    type: count_distinct
    sql: ${TABLE}.ServiceName ;;
  }
  
  measure: unique_regions {
    label: "Unique Regions"
    description: "Count of distinct regions"
    type: count_distinct
    sql: ${TABLE}.Region ;;
  }
  
  # --- Line Item Measures ---
  
  measure: line_item_count {
    label: "Line Item Count"
    description: "Count of billing line items"
    type: count
    drill_fields: [detail*]
  }
  
  measure: average_line_item_cost {
    label: "Average Line Item Cost"
    description: "Average cost per line item"
    type: average
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
  }
  
  measure: max_line_item_cost {
    label: "Max Line Item Cost"
    description: "Maximum single line item cost"
    type: max
    sql: ${TABLE}.EffectiveCost ;;
    value_format_name: usd
  }
  
  # --- Commitment Measures ---
  
  measure: total_commitment_cost {
    label: "Total Commitment Cost"
    description: "Sum of commitment-based costs"
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    filters: [charge_class: "Commitment"]
    value_format_name: usd
  }
  
  measure: total_on_demand_cost {
    label: "Total On-Demand Cost"
    description: "Sum of on-demand costs"
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    filters: [charge_class: "On-Demand"]
    value_format_name: usd
  }
  
  measure: commitment_coverage_percent {
    label: "Commitment Coverage %"
    description: "Percentage of costs covered by commitments"
    type: number
    sql: SAFE_DIVIDE(
      ${total_commitment_cost},
      NULLIF(${total_commitment_cost} + ${total_on_demand_cost}, 0)
    ) * 100 ;;
    value_format_name: decimal_2
    html: 
      {% if value >= 70 %}
        <span style="color: #34A853; font-weight: bold;">{{ rendered_value }}%</span>
      {% elsif value >= 50 %}
        <span style="color: #FBBC04;">{{ rendered_value }}%</span>
      {% else %}
        <span style="color: #EA4335;">{{ rendered_value }}%</span>
      {% endif %}
    ;;
  }
  
  measure: unique_commitments {
    label: "Unique Commitments"
    description: "Count of distinct RI/Savings Plan/CUD IDs"
    type: count_distinct
    sql: ${TABLE}.CommitmentDiscountId ;;
  }
  
  # --- Provider Comparison Measures ---
  
  measure: aws_cost {
    label: "AWS Cost"
    description: "Total effective cost for AWS"
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    filters: [provider_name: "AWS"]
    value_format_name: usd
  }
  
  measure: gcp_cost {
    label: "GCP Cost"
    description: "Total effective cost for GCP"
    type: sum
    sql: ${TABLE}.EffectiveCost ;;
    filters: [provider_name: "GCP"]
    value_format_name: usd
  }
  
  measure: aws_percentage {
    label: "AWS % of Total"
    description: "AWS cost as percentage of total multi-cloud cost"
    type: number
    sql: SAFE_DIVIDE(${aws_cost}, NULLIF(${total_effective_cost}, 0)) * 100 ;;
    value_format_name: decimal_2
    html: {{ rendered_value }}% ;;
  }
  
  measure: gcp_percentage {
    label: "GCP % of Total"
    description: "GCP cost as percentage of total multi-cloud cost"
    type: number
    sql: SAFE_DIVIDE(${gcp_cost}, NULLIF(${total_effective_cost}, 0)) * 100 ;;
    value_format_name: decimal_2
    html: {{ rendered_value }}% ;;
  }
  
  # --- Time-Based Measures ---
  
  measure: cost_per_day {
    label: "Cost per Day"
    description: "Average cost per day in date range"
    type: number
    sql: ${total_effective_cost} / NULLIF(DATE_DIFF(MAX(DATE(${TABLE}.ChargePeriodStart)), MIN(DATE(${TABLE}.ChargePeriodStart)), DAY) + 1, 0) ;;
    value_format_name: usd
  }
  
  measure: projected_monthly_cost {
    label: "Projected Monthly Cost"
    description: "Current daily run rate projected to full month (30 days)"
    type: number
    sql: (${total_effective_cost} / NULLIF(COUNT(DISTINCT DATE(${TABLE}.ChargePeriodStart)), 0)) * 30 ;;
    value_format_name: usd
    html: 
      <span title="Based on daily average × 30 days">{{ rendered_value }}</span>
    ;;
  }
  
  # ----------------------------------------------------------------------------
  # Drill Field Sets
  # ----------------------------------------------------------------------------
  
  set: detail {
    fields: [
      charge_period_start_date,
      provider_name,
      service_category,
      service_name,
      sub_account_name,
      region,
      resource_name,
      charge_category,
      total_billed_cost,
      total_effective_cost,
      total_usage_quantity,
      line_item_count
    ]
  }
  
  set: resource_detail {
    fields: [
      provider_name,
      service_name,
      resource_id,
      resource_name,
      resource_type,
      region,
      sub_account_name,
      tag_team,
      tag_environment,
      total_effective_cost,
      total_usage_quantity
    ]
  }
  
  set: commitment_detail {
    fields: [
      provider_name,
      commitment_discount_type,
      commitment_discount_name,
      commitment_discount_status,
      service_category,
      total_commitment_cost,
      total_savings,
      savings_percentage
    ]
  }
}

# ============================================================================
# Usage Notes
# ============================================================================
#
# 1. Replace "your-project.finops.unified_focus_materialized" with actual table
# 2. Customize tag dimensions based on your organization's tagging standards
# 3. Add/remove dimensions and measures as needed
# 4. Configure drill fields for your specific use cases
# 5. Test all measures to ensure they perform well with your data volume
# 6. Use hidden: yes for internal/technical dimensions not needed by users
# 7. Add links to cloud consoles where applicable
# 8. Customize HTML formatting to match your organization's style
#
# ============================================================================
