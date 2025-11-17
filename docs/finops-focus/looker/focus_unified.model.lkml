# ============================================================================
# Unified Multi-Cloud FOCUS - Looker Model
# ============================================================================
# Description: LookML model definition for unified multi-cloud cost analysis
# Version: 1.0.0
# Last Updated: 2025-11-17
# ============================================================================

connection: "bigquery_finops"

# Include all view files
include: "/views/focus_unified.view.lkml"
include: "/views/focus_daily_summary.view.lkml"
include: "/views/focus_monthly_summary.view.lkml"
include: "/views/service_mapping.view.lkml"

# Include dashboard files
include: "/dashboards/*.dashboard.lkml"

# ----------------------------------------------------------------------------
# Data Group Definitions
# ----------------------------------------------------------------------------
# Define caching and refresh strategies for PDTs
# ----------------------------------------------------------------------------

datagroup: focus_daily_refresh {
  label: "FOCUS Daily Refresh"
  description: "Refreshes daily at 12:00 UTC after morning ETL completes"
  sql_trigger: SELECT MAX(DATE(ChargePeriodStart)) FROM `your-project.finops.unified_focus_materialized` ;;
  max_cache_age: "24 hours"
}

datagroup: focus_hourly_refresh {
  label: "FOCUS Hourly Refresh"
  description: "Refreshes every 6 hours for near-real-time dashboards"
  sql_trigger: SELECT FLOOR(UNIX_SECONDS(CURRENT_TIMESTAMP()) / (6 * 3600)) ;;
  max_cache_age: "6 hours"
}

datagroup: focus_monthly_refresh {
  label: "FOCUS Monthly Refresh"
  description: "Refreshes on first day of month for monthly reports"
  sql_trigger: SELECT DATE_TRUNC(CURRENT_DATE(), MONTH) ;;
  max_cache_age: "30 days"
}

# ----------------------------------------------------------------------------
# Main Cost Analysis Explore
# ----------------------------------------------------------------------------
# Primary explore for unified multi-cloud cost analysis
# ----------------------------------------------------------------------------

explore: unified_focus {
  label: "Multi-Cloud Cost Analysis"
  description: "Comprehensive view of AWS and GCP costs in FOCUS format"
  view_name: unified_focus
  
  # Always require date filter to prevent full table scans
  always_filter: {
    filters: [unified_focus.charge_period_start_date: "7 days"]
  }
  
  # Default filters for common use cases
  conditionally_filter: {
    filters: [unified_focus.charge_period_start_date: "30 days"]
    unless: [
      unified_focus.charge_period_start_month,
      unified_focus.charge_period_start_year
    ]
  }
  
  # Join with service mapping for normalized service names
  join: service_mapping {
    type: left_outer
    sql_on: ${unified_focus.provider_name} = ${service_mapping.provider_name}
        AND ${unified_focus.service_name} = ${service_mapping.original_service_name} ;;
    relationship: many_to_one
  }
  
  # Aggregated views for performance
  aggregate_table: daily_rollup {
    query: {
      dimensions: [
        charge_period_start_date,
        provider_name,
        service_category,
        service_name,
        region,
        sub_account_id
      ]
      measures: [
        total_billed_cost,
        total_effective_cost,
        total_list_cost,
        unique_resources
      ]
    }
    
    materialization: {
      datagroup_trigger: focus_daily_refresh
    }
  }
  
  aggregate_table: monthly_rollup {
    query: {
      dimensions: [
        charge_period_start_month,
        provider_name,
        service_category,
        service_name
      ]
      measures: [
        total_billed_cost,
        total_effective_cost,
        total_savings
      ]
    }
    
    materialization: {
      datagroup_trigger: focus_monthly_refresh
    }
  }
}

# ----------------------------------------------------------------------------
# Daily Summary Explore (Performance Optimized)
# ----------------------------------------------------------------------------
# Pre-aggregated daily metrics for fast dashboard performance
# ----------------------------------------------------------------------------

explore: focus_daily_summary {
  label: "Daily Cost Summary (Fast)"
  description: "Pre-aggregated daily cost metrics - optimized for dashboards"
  view_name: focus_daily_summary
  
  always_filter: {
    filters: [focus_daily_summary.charge_date_date: "30 days"]
  }
  
  # Join with service mapping
  join: service_mapping {
    type: left_outer
    sql_on: ${focus_daily_summary.provider_name} = ${service_mapping.provider_name}
        AND ${focus_daily_summary.service_name} = ${service_mapping.original_service_name} ;;
    relationship: many_to_one
  }
}

# ----------------------------------------------------------------------------
# Monthly Summary Explore (Trend Analysis)
# ----------------------------------------------------------------------------
# Pre-aggregated monthly metrics for trend analysis
# ----------------------------------------------------------------------------

explore: focus_monthly_summary {
  label: "Monthly Cost Trends"
  description: "Pre-aggregated monthly cost metrics - for trend analysis"
  view_name: focus_monthly_summary
  
  always_filter: {
    filters: [focus_monthly_summary.charge_month_month: "12 months"]
  }
  
  # Join with service mapping
  join: service_mapping {
    type: left_outer
    sql_on: ${focus_monthly_summary.provider_name} = ${service_mapping.provider_name}
        AND ${focus_monthly_summary.service_name} = ${service_mapping.original_service_name} ;;
    relationship: many_to_one
  }
}

# ----------------------------------------------------------------------------
# Commitment Analysis Explore
# ----------------------------------------------------------------------------
# Specialized explore for RI/Savings Plan/CUD analysis
# ----------------------------------------------------------------------------

explore: commitment_analysis {
  label: "Commitment & Savings Analysis"
  description: "Analyze Reserved Instances, Savings Plans, and Committed Use Discounts"
  view_name: unified_focus
  
  # Filter to only commitment-related charges
  sql_always_where: ${unified_focus.charge_class} = 'Commitment' ;;
  
  always_filter: {
    filters: [unified_focus.charge_period_start_date: "30 days"]
  }
  
  # Extended fields for commitment analysis
  fields: [
    ALL_FIELDS*,
    -unified_focus.tags  # Exclude tags from commitment view
  ]
}

# ----------------------------------------------------------------------------
# Tag-Based Chargeback Explore
# ----------------------------------------------------------------------------
# Cost allocation by teams using tags
# ----------------------------------------------------------------------------

explore: tag_chargeback {
  label: "Tag-Based Cost Allocation"
  description: "Chargeback and showback reporting using resource tags"
  view_name: unified_focus
  
  # Only include tagged resources
  sql_always_where: ${unified_focus.tags} IS NOT NULL ;;
  
  always_filter: {
    filters: [unified_focus.charge_period_start_date: "30 days"]
  }
  
  # Extended fields specific to tag analysis
  fields: [
    unified_focus.charge_period_start_date,
    unified_focus.charge_period_start_month,
    unified_focus.provider_name,
    unified_focus.service_category,
    unified_focus.service_name,
    unified_focus.sub_account_name,
    unified_focus.region,
    unified_focus.tag_team,
    unified_focus.tag_environment,
    unified_focus.tag_owner,
    unified_focus.tag_application,
    unified_focus.total_billed_cost,
    unified_focus.total_effective_cost,
    unified_focus.unique_resources
  ]
}

# ----------------------------------------------------------------------------
# Resource-Level Analysis Explore
# ----------------------------------------------------------------------------
# Granular resource-level cost analysis
# ----------------------------------------------------------------------------

explore: resource_analysis {
  label: "Resource-Level Cost Analysis"
  description: "Detailed cost analysis at individual resource level"
  view_name: unified_focus
  
  # Only include rows with resource IDs
  sql_always_where: ${unified_focus.resource_id} IS NOT NULL ;;
  
  always_filter: {
    filters: [unified_focus.charge_period_start_date: "7 days"]
  }
  
  # Resource-specific fields
  fields: [
    unified_focus.charge_period_start_date,
    unified_focus.provider_name,
    unified_focus.service_name,
    unified_focus.resource_id,
    unified_focus.resource_name,
    unified_focus.resource_type,
    unified_focus.region,
    unified_focus.sub_account_name,
    unified_focus.total_billed_cost,
    unified_focus.total_effective_cost,
    unified_focus.total_usage_quantity,
    unified_focus.line_item_count
  ]
}

# ----------------------------------------------------------------------------
# Cross-Cloud Service Comparison Explore
# ----------------------------------------------------------------------------
# Compare equivalent services across cloud providers
# ----------------------------------------------------------------------------

explore: cross_cloud_comparison {
  label: "Cross-Cloud Service Comparison"
  description: "Compare costs of equivalent services across AWS and GCP"
  from: unified_focus
  view_name: unified_focus
  
  # Require service mapping join
  join: service_mapping {
    type: inner  # Inner join to only include mapped services
    sql_on: ${unified_focus.provider_name} = ${service_mapping.provider_name}
        AND ${unified_focus.service_name} = ${service_mapping.original_service_name} ;;
    relationship: many_to_one
  }
  
  always_filter: {
    filters: [unified_focus.charge_period_start_date: "30 days"]
  }
  
  # Comparison-specific fields
  fields: [
    unified_focus.charge_period_start_month,
    unified_focus.provider_name,
    service_mapping.normalized_service_name,
    service_mapping.service_category,
    service_mapping.service_family,
    unified_focus.region,
    unified_focus.total_billed_cost,
    unified_focus.total_effective_cost,
    unified_focus.total_usage_quantity,
    unified_focus.unique_resources
  ]
}

# ----------------------------------------------------------------------------
# Model Configuration
# ----------------------------------------------------------------------------

# Enable query caching for better performance
persist_with: focus_daily_refresh

# Access grants (customize based on your organization)
access_grant: finops_team {
  user_attribute: department
  allowed_values: ["Finance", "FinOps", "Engineering"]
}

access_grant: executive_access {
  user_attribute: role
  allowed_values: ["Executive", "Director", "VP", "CFO", "CTO"]
}

# Label configuration
label: "Multi-Cloud FinOps"

# Fiscal calendar (customize for your organization)
fiscal_month_offset: 0  # 0 = January start, 1 = February start, etc.

# ----------------------------------------------------------------------------
# Named Value Formats
# ----------------------------------------------------------------------------

named_value_format: usd_currency {
  value_format: "$#,##0.00"
}

named_value_format: usd_large {
  value_format: "$#,##0"
}

named_value_format: percentage_2 {
  value_format: "0.00%"
}

named_value_format: decimal_2 {
  value_format: "#,##0.00"
}

# ----------------------------------------------------------------------------
# Week Start Day
# ----------------------------------------------------------------------------

week_start_day: monday

# ----------------------------------------------------------------------------
# Case Sensitive (for BigQuery)
# ----------------------------------------------------------------------------

case_sensitive: no

# ============================================================================
# Usage Notes
# ============================================================================
# 
# 1. Update the connection name to match your BigQuery connection
# 2. Customize access grants based on your organization's structure
# 3. Adjust datagroup triggers to match your ETL schedule
# 4. Set fiscal_month_offset if your fiscal year doesn't start in January
# 5. Configure user attributes in Looker admin for access grants
# 6. Test aggregate tables to verify they improve performance
# 7. Monitor PDT build times and adjust as needed
#
# ============================================================================
