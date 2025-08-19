# =====================================================
# AWS CUR 2.0 LOOKER MODEL DEFINITION
# =====================================================
# Main model file for AWS Cost and Usage Report 2.0 analysis
# 
# Author: Claude Swarm View/Explore Generator Agent
# Last Updated: 2025-08-18
# =====================================================

connection: "@{AWS_BILLING_CONNECTION}"

include: "cur2.view.lkml"
include: "cur2.explore.lkml"
include: "explores/legacy/aws_summary_cur2.explore.lkml"

# Model-level configuration
datagroup: cur_default_datagroup {
  sql_trigger: SELECT MAX(bill_billing_period_end_date) FROM @{AWS_SCHEMA_NAME}.@{AWS_TABLE_NAME} ;;
  max_cache_age: "4 hours"
  description: "Triggered when new billing data is available"
}

persist_with: cur_default_datagroup

# Model-level access control
access_grant: cur2_full_access {
  user_attribute: cur2_access_level
  allowed_values: ["admin", "full"]
}

access_grant: cur2_read_only {
  user_attribute: cur2_access_level
  allowed_values: ["admin", "full", "read_only"]
}

# Model settings for performance
fiscal_month_offset: 0
week_start_day: monday

# Named value formats for consistency
named_value_format: currency_format {
  value_format: "$#,##0.00"
}

named_value_format: large_currency_format {
  value_format: "$#,##0"
}

named_value_format: percentage_format {
  value_format: "#,##0.1%"
}

named_value_format: decimal_format {
  value_format: "#,##0.000"
}

# Map layers for geographic analysis
map_layer: aws_regions {
  url: "https://raw.githubusercontent.com/awslabs/aws-icons-for-plantuml/main/dist/AWSGeography/AWSRegions.json"
  property_key: "region_code"
  format: topojson
}

# Model-level label and description
label: "AWS Cost & Usage Report 2.0"
description: "Comprehensive cost analysis and optimization for AWS resources using CUR 2.0 data"