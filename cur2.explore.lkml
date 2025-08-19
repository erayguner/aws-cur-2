# =====================================================
# AWS CUR 2.0 COMPREHENSIVE EXPLORE DEFINITIONS
# =====================================================
# This file contains explore definitions for AWS Cost and Usage Report 2.0
# Designed for comprehensive cost analysis and optimization
# 
# Author: Claude Swarm View/Explore Generator Agent
# Last Updated: 2025-08-18
# =====================================================

# Primary explore for all AWS cost analysis
explore: cur2 {
  label: "AWS Cost & Usage Report"
  description: "Comprehensive analysis of AWS costs, usage, and resource allocation"
  
  # Default time-based filtering
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01') 
    AND ${cur2.line_item_usage_start_date} < CURRENT_DATE() ;;

  # Performance optimization - limit large queries
  sql_always_having: 
    {% if cur2.total_unblended_cost._is_selected %}
      ${cur2.total_unblended_cost} > 0
    {% else %}
      1=1 
    {% endif %} ;;

  # Default suggested dimensions for quick analysis
  conditionally_filter: {
    filters: [cur2.line_item_usage_start_date: "last 30 days"]
    unless: [cur2.line_item_usage_start_month, cur2.bill_billing_period_start_month]
  }

  # Pre-built analysis sets for common use cases
  set: cost_analysis_drill_fields {
    fields: [
      cur2.line_item_usage_account_name,
      cur2.line_item_product_code,
      cur2.service_category,
      cur2.line_item_usage_type,
      cur2.cost_type,
      cur2.total_unblended_cost,
      cur2.total_usage_amount,
      cur2.count
    ]
  }

  set: resource_analysis_drill_fields {
    fields: [
      cur2.line_item_resource_id,
      cur2.line_item_availability_zone,
      cur2.product_region_code,
      cur2.product_instance_type,
      cur2.environment,
      cur2.team,
      cur2.total_unblended_cost,
      cur2.line_item_usage_start_date
    ]
  }

  set: tag_governance_drill_fields {
    fields: [
      cur2.line_item_usage_account_name,
      cur2.tag_completeness,
      cur2.environment,
      cur2.team,
      cur2.project_owner,
      cur2.total_unblended_cost,
      cur2.total_untagged_cost,
      cur2.tag_coverage_rate
    ]
  }

  set: savings_analysis_drill_fields {
    fields: [
      cur2.cost_type,
      cur2.reservation_reservation_a_r_n,
      cur2.savings_plan_savings_plan_a_r_n,
      cur2.reservation_effective_cost,
      cur2.savings_plan_savings_plan_effective_cost,
      cur2.total_discount_amount,
      cur2.pricing_public_on_demand_cost
    ]
  }
}

# Specialized explore for cost optimization analysis
explore: cost_optimization {
  extends: [cur2]
  label: "Cost Optimization"
  description: "Focus on cost savings opportunities and optimization recommendations"
  
  # Filter to only usage-related costs for optimization
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.is_usage} = true
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  # Focus on high-impact optimization areas
  conditionally_filter: {
    filters: [
      cur2.service_category: "Compute,Database,Storage",
      cur2.line_item_usage_start_date: "last 90 days"
    ]
  }
}

# Tag governance and compliance explore
explore: tag_governance {
  extends: [cur2]
  label: "Tag Governance"
  description: "Analyze resource tagging compliance and governance metrics"
  
  # Focus on resources that should be tagged
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.line_item_line_item_type} = 'Usage'
    AND ${cur2.line_item_resource_id} IS NOT NULL
    AND ${cur2.line_item_resource_id} != '' ;;

  conditionally_filter: {
    filters: [cur2.line_item_usage_start_date: "last 30 days"]
  }
}

# Reserved Instance and Savings Plan analysis
explore: commitment_analysis {
  extends: [cur2]
  label: "RI & Savings Plans"
  description: "Analyze Reserved Instance and Savings Plan utilization and effectiveness"
  
  # Focus on commitment-related costs
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND (
      ${cur2.cost_type} IN ('Reserved Instance', 'Savings Plan')
      OR ${cur2.reservation_reservation_a_r_n} IS NOT NULL
      OR ${cur2.savings_plan_savings_plan_a_r_n} IS NOT NULL
    ) ;;

  conditionally_filter: {
    filters: [cur2.line_item_usage_start_date: "last 90 days"]
  }
}

# Service-specific deep dive explores
explore: ec2_analysis {
  extends: [cur2]
  label: "EC2 Cost Analysis"
  description: "Deep dive into EC2 costs, instance types, and utilization"
  
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.line_item_product_code} IN ('AmazonEC2', 'Amazon Elastic Compute Cloud')
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  conditionally_filter: {
    filters: [
      cur2.line_item_usage_start_date: "last 60 days",
      cur2.line_item_line_item_type: "Usage"
    ]
  }
}

explore: storage_analysis {
  extends: [cur2]
  label: "Storage Cost Analysis"
  description: "Analyze storage costs across S3, EBS, and other storage services"
  
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.service_category} = 'Storage'
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  conditionally_filter: {
    filters: [
      cur2.line_item_usage_start_date: "last 60 days",
      cur2.line_item_line_item_type: "Usage"
    ]
  }
}

explore: database_analysis {
  extends: [cur2]
  label: "Database Cost Analysis" 
  description: "Analyze RDS, DynamoDB, and other database service costs"
  
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.service_category} = 'Database'
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  conditionally_filter: {
    filters: [
      cur2.line_item_usage_start_date: "last 60 days",
      cur2.line_item_line_item_type: "Usage"
    ]
  }
}

# Account and billing analysis
explore: account_billing {
  extends: [cur2]
  label: "Account & Billing"
  description: "Cross-account billing analysis and chargebacks"
  
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  conditionally_filter: {
    filters: [cur2.bill_billing_period_start_date: "last 3 months"]
  }
}

# Data transfer and networking costs
explore: network_analysis {
  extends: [cur2]
  label: "Network Analysis"
  description: "Analyze networking costs, data transfer charges, and bandwidth usage"
  
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.service_category} = 'Networking'
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  conditionally_filter: {
    filters: [
      cur2.line_item_usage_start_date: "last 60 days",
      cur2.line_item_line_item_type: "Usage"
    ]
  }
}

# AI/ML and analytics costs
explore: aiml_analytics {
  extends: [cur2]
  label: "AI/ML & Analytics"
  description: "Analyze costs for SageMaker, Bedrock, EMR, and other AI/ML services"
  
  sql_always_where: 
    ${cur2.line_item_usage_start_date} >= DATE('2024-01-01')
    AND ${cur2.service_category} IN ('AI/ML', 'Analytics')
    AND ${cur2.line_item_unblended_cost} > 0 ;;

  conditionally_filter: {
    filters: [
      cur2.line_item_usage_start_date: "last 90 days",
      cur2.line_item_line_item_type: "Usage"
    ]
  }
}

# =====================================================
# Note: Dashboard definitions have been moved to separate .dashboard.lkml files
# for better organization and LAMS compliance
# =====================================================