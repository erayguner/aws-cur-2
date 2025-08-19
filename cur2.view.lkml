# The name of this view in Looker is "Cur2"
view: cur2 {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: @{AWS_SCHEMA_NAME}.@{AWS_TABLE_NAME} ;;
  drill_fields: [cur2_line_item_pk]
  suggestions: no

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: cur2_line_item_pk {
    primary_key: yes
    label: "Line Item ID [PK]"
    group_label: "Identity > Primary Key"
    type: string
    sql: ${TABLE}.identity_line_item_id ;;
    description: "Unique identifier for each line item in the CUR report - Primary Key"
  }

  dimension: identity_time_interval {
    group_label: "Identity > Time"
    type: string
    sql: ${TABLE}.identity_time_interval ;;
    description: "Time interval for the identity/billing period"
  }
  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Bill Bill Type" in Explore.

  dimension: bill_type {
    group_label: "Billing > Bill Information"
    type: string
    sql: ${TABLE}.bill_bill_type ;;
    description: "Type of bill (Anniversary, Purchase, Refund, etc.)"
  }

  dimension: billing_entity {
    group_label: "Billing > Bill Information"
    type: string
    sql: ${TABLE}.bill_billing_entity ;;
    description: "Entity responsible for billing (AWS, AWS Marketplace, etc.)"
  }
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: billing_period_end {
    group_label: "Billing > Time Periods"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.bill_billing_period_end_date ;;
    description: "End date of the billing period"
  }

  dimension_group: billing_period_start {
    group_label: "Billing > Time Periods"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.bill_billing_period_start_date ;;
    description: "Start date of the billing period"
  }

  dimension: invoice_id {
    group_label: "Billing > Bill Information"
    type: string
    sql: ${TABLE}.bill_invoice_id ;;
    description: "Invoice ID associated with this line item"
  }

  dimension: invoicing_entity {
    group_label: "Billing > Bill Information"
    type: string
    sql: ${TABLE}.bill_invoicing_entity ;;
    description: "Legal entity that issued the invoice"
  }

  dimension: payer_account_id {
    group_label: "Billing > Account Information"
    type: string
    sql: ${TABLE}.bill_payer_account_id ;;
    description: "AWS Account ID of the payer account (management account)"
  }

  dimension: payer_account_name {
    group_label: "Billing > Account Information"
    type: string
    sql: ${TABLE}.bill_payer_account_name ;;
    description: "Name of the payer account (management account)"
  }

  dimension: billing_period {
    group_label: "Billing > Time Periods"
    type: string
    sql: ${TABLE}.billing_period ;;
    description: "Billing period in YYYY-MM format"
  }

  dimension: cost_category {
    group_label: "Cost Management > Categories"
    type: string
    sql: ${TABLE}.cost_category ;;
    description: "Cost category classification"
  }

  dimension: data {
    group_label: "System > Additional Data"
    type: string
    sql: ${TABLE}.data ;;
    description: "Additional data fields"
  }

  dimension: discount {
    group_label: "Cost Management > Discounts"
    type: string
    sql: ${TABLE}.discount ;;
    description: "Discount information JSON"
  }

  dimension: edp_discount {
    group_label: "Cost Management > Discounts"
    type: string
    sql: element_at(${TABLE}.discount, 'edp_discount') ;;
    description: "EDP Discount"
  }

  dimension: ppa_discount {
    group_label: "Cost Management > Discounts"
    type: string
    sql:  element_at(${TABLE}.discount, 'private_rate_discount') ;;
    description: "PPA Discount"
  }

  dimension: discount_bundled_discount {
    group_label: "Cost Management > Discounts"
    type: number
    sql: ${TABLE}.discount_bundled_discount ;;
    description: "Bundled discount amount"
  }

  dimension: discount_total_discount {
    group_label: "Cost Management > Discounts"
    type: number
    sql: ${TABLE}.discount_total_discount ;;
    description: "Total discount amount applied"
  }

  dimension: line_item_availability_zone {
    group_label: "Line Items > Infrastructure"
    type: string
    sql: ${TABLE}.line_item_availability_zone ;;
    description: "Availability zone for this line item"
  }

  dimension: line_item_blended_cost {
    group_label: "Line Items > Costs"
    type: number
    sql: ${TABLE}.line_item_blended_cost ;;
    description: "Blended cost for this line item"
    value_format_name: "usd"
  }

  dimension: line_item_blended_rate {
    group_label: "Line Items > Costs"
    type: string
    sql: ${TABLE}.line_item_blended_rate ;;
    description: "Blended rate for this line item"
  }

  dimension: line_item_currency_code {
    group_label: "Line Items > Details"
    type: string
    sql: ${TABLE}.line_item_currency_code ;;
    description: "Currency code for costs (USD, EUR, etc.)"
  }

  dimension: line_item_legal_entity {
    group_label: "Line Items > Details"
    type: string
    sql: ${TABLE}.line_item_legal_entity ;;
    description: "Legal entity responsible for this charge"
  }

  dimension: line_item_line_item_description {
    group_label: "Line Items > Details"
    type: string
    sql: ${TABLE}.line_item_line_item_description ;;
    description: "Detailed description of the line item"
  }

  dimension: line_item_line_item_type {
    group_label: "Line Items > Details"
    type: string
    sql: ${TABLE}.line_item_line_item_type ;;
    description: "Type of line item (Usage, Fee, Tax, etc.)"
  }

  dimension: line_item_net_unblended_cost {
    group_label: "Line Items > Costs"
    type: number
    sql: ${TABLE}.line_item_net_unblended_cost ;;
    description: "Net unblended cost (after credits)"
    value_format_name: "usd"
  }

  dimension: line_item_net_unblended_rate {
    group_label: "Line Items > Costs"
    type: string
    sql: ${TABLE}.line_item_net_unblended_rate ;;
    description: "Net unblended rate (after credits)"
  }

  dimension: line_item_normalization_factor {
    group_label: "Line Items > Usage"
    type: number
    sql: ${TABLE}.line_item_normalization_factor ;;
    description: "Normalization factor for usage amounts"
  }

  dimension: line_item_normalized_usage_amount {
    group_label: "Line Items > Usage"
    type: number
    sql: ${TABLE}.line_item_normalized_usage_amount ;;
    description: "Normalized usage amount"
  }

  dimension: line_item_operation {
    group_label: "Line Items > Details"
    type: string
    sql: ${TABLE}.line_item_operation ;;
    description: "Operation performed (e.g., RunInstances, PutObject)"
  }

  dimension: line_item_product_code {
    group_label: "Line Items > Details"
    label: "Product Code [Service]"
    type: string
    sql: ${TABLE}.line_item_product_code ;;
    description: "AWS service product code"
  }

  dimension: line_item_resource_id {
    group_label: "Line Items > Resources"
    label: "Resource ID [Resource]"
    type: string
    sql: ${TABLE}.line_item_resource_id ;;
    description: "Unique identifier for the AWS resource"
  }

  dimension: line_item_tax_type {
    group_label: "Line Items > Details"
    type: string
    sql: ${TABLE}.line_item_tax_type ;;
    description: "Type of tax applied to this line item"
  }

  dimension: line_item_unblended_cost {
    group_label: "Line Items > Costs"
    type: number
    sql: ${TABLE}.line_item_unblended_cost ;;
    description: "Unblended cost for this line item"
    value_format_name: "usd"
  }

  dimension: line_item_unblended_rate {
    group_label: "Line Items > Costs"
    type: string
    sql: ${TABLE}.line_item_unblended_rate ;;
    description: "Unblended rate for this line item"
  }

  dimension: line_item_usage_account_id {
    group_label: "Account Information > Usage"
    label: "Account ID [Account]"
    type: string
    sql: ${TABLE}.line_item_usage_account_id ;;
    description: "AWS Account ID where usage occurred"
  }

  dimension: line_item_usage_account_name {
    group_label: "Account Information > Usage"
    type: string
    sql: ${TABLE}.line_item_usage_account_name ;;
    description: "AWS Account name where usage occurred"
  }

  dimension: line_item_usage_amount {
    group_label: "Line Items > Usage"
    type: number
    sql: ${TABLE}.line_item_usage_amount ;;
    description: "Usage amount for this line item"
  }

  dimension_group: line_item_usage_end {
    group_label: "Line Items > Time Periods"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.line_item_usage_end_date ;;
    description: "End date/time of usage for this line item"
  }

  dimension_group: line_item_usage_start {
    group_label: "Line Items > Time Periods"
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: ${TABLE}.line_item_usage_start_date ;;
    description: "Start date/time of usage for this line item"
  }

  dimension: line_item_usage_type {
    group_label: "Line Items > Usage"
    type: string
    sql: ${TABLE}.line_item_usage_type ;;
    description: "Type of usage (e.g., BoxUsage:m5.large)"
  }

  dimension: pricing_currency {
    group_label: "Pricing > Information"
    type: string
    sql: ${TABLE}.pricing_currency ;;
    description: "Currency for pricing (USD, EUR, etc.)"
  }

  dimension: pricing_lease_contract_length {
    group_label: "Pricing > Contract Terms"
    type: string
    sql: ${TABLE}.pricing_lease_contract_length ;;
    description: "Lease contract length for pricing"
  }

  dimension: pricing_offering_class {
    group_label: "Pricing > Offering Details"
    type: string
    sql: ${TABLE}.pricing_offering_class ;;
    description: "Offering class (Standard, Convertible, etc.)"
  }

  dimension: pricing_public_on_demand_cost {
    group_label: "Pricing > On-Demand Comparison"
    type: number
    sql: ${TABLE}.pricing_public_on_demand_cost ;;
    description: "Public on-demand cost for comparison"
    value_format_name: "usd"
  }

  dimension: pricing_public_on_demand_rate {
    group_label: "Pricing > On-Demand Comparison"
    type: string
    sql: ${TABLE}.pricing_public_on_demand_rate ;;
    description: "Public on-demand rate for comparison"
  }

  dimension: pricing_purchase_option {
    group_label: "Pricing > Purchase Options"
    type: string
    sql: ${TABLE}.pricing_purchase_option ;;
    description: "Purchase option (All Upfront, Partial Upfront, etc.)"
  }

  dimension: pricing_rate_code {
    group_label: "Pricing > Rate Details"
    type: string
    sql: ${TABLE}.pricing_rate_code ;;
    description: "Pricing rate code identifier"
  }

  dimension: pricing_rate_id {
    group_label: "Pricing > Rate Details"
    type: string
    sql: ${TABLE}.pricing_rate_id ;;
    description: "Pricing rate ID identifier"
  }

  dimension: pricing_term {
    group_label: "Pricing > Terms"
    type: string
    sql: ${TABLE}.pricing_term ;;
    description: "Pricing term (OnDemand, Reserved, etc.)"
  }

  dimension: pricing_unit {
    group_label: "Pricing > Units"
    type: string
    sql: ${TABLE}.pricing_unit ;;
    description: "Unit of pricing (Hrs, GB-Month, etc.)"
  }

  dimension: product {
    group_label: "Product > Raw Data"
    type: string
    sql: ${TABLE}.product ;;
    description: "Product information JSON"
  }

  dimension: product_comment {
    group_label: "Product > Information"
    type: string
    sql: ${TABLE}.product_comment ;;
    description: "Product comment or description"
  }

  dimension: product_fee_code {
    group_label: "Product > Fees"
    type: string
    sql: ${TABLE}.product_fee_code ;;
    description: "Product fee code"
  }

  dimension: product_fee_description {
    group_label: "Product > Fees"
    type: string
    sql: ${TABLE}.product_fee_description ;;
    description: "Description of product fee"
  }

  dimension: product_from_location {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_from_location ;;
    description: "Source location for data transfer"
  }

  dimension: product_from_location_type {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_from_location_type ;;
    description: "Type of source location"
  }

  dimension: product_from_region_code {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_from_region_code ;;
    description: "Source region code for data transfer"
  }

  dimension: product_instance_family {
    group_label: "Product > Specifications"
    type: string
    sql: ${TABLE}.product_instance_family ;;
    description: "EC2 instance family (e.g., m5, c5, r5)"
  }

  dimension: product_instance_type {
    group_label: "Product > Specifications"
    type: string
    sql: ${TABLE}.product_instance_type ;;
    description: "EC2 instance type (e.g., m5.large, c5.xlarge)"
  }

  dimension: product_instancesku {
    group_label: "Product > Specifications"
    type: string
    sql: ${TABLE}.product_instancesku ;;
    description: "Product instance SKU identifier"
  }

  dimension: product_location {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_location ;;
    description: "Geographic location of the product or service"
  }

  dimension: product_location_type {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_location_type ;;
    description: "Type of location (AWS Region, Edge Location, etc.)"
  }

  dimension: product_operation {
    group_label: "Product > Operations"
    type: string
    sql: ${TABLE}.product_operation ;;
    description: "Product operation type (RunInstances, CreateSnapshot, etc.)"
  }

  dimension: product_pricing_unit {
    group_label: "Product > Pricing"
    type: string
    sql: ${TABLE}.product_pricing_unit ;;
    description: "Unit of measurement for pricing (Hrs, GB-Month, Requests, etc.)"
  }

  dimension: product_product_family {
    group_label: "Product > Classification"
    type: string
    sql: ${TABLE}.product_product_family ;;
    description: "Product family classification (Compute Instance, Storage, Data Transfer, etc.)"
  }

  dimension: product_region_code {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_region_code ;;
    description: "AWS region code where the product is located (us-east-1, eu-west-1, etc.)"
  }

  dimension: product_servicecode {
    group_label: "Product > Classification"
    type: string
    sql: ${TABLE}.product_servicecode ;;
    description: "AWS service code identifier (AmazonEC2, AmazonS3, etc.)"
  }

  dimension: product_sku {
    group_label: "Product > Identification"
    type: string
    sql: ${TABLE}.product_sku ;;
    description: "Stock Keeping Unit identifier for the product"
  }

  dimension: product_to_location {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_to_location ;;
    description: "Destination location for data transfer operations"
  }

  dimension: product_to_location_type {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_to_location_type ;;
    description: "Type of destination location for data transfer"
  }

  dimension: product_to_region_code {
    group_label: "Product > Location"
    type: string
    sql: ${TABLE}.product_to_region_code ;;
    description: "Destination region code for data transfer operations"
  }

  dimension: product_usagetype {
    group_label: "Product > Usage"
    type: string
    sql: ${TABLE}.product_usagetype ;;
    description: "Usage type classification for the product"
  }

  dimension: report_name {
    group_label: "System > Report Information"
    type: string
    sql: ${TABLE}.report_name ;;
    description: "Name of the Cost and Usage Report"
  }

  dimension: reservation_amortized_upfront_cost_for_usage {
    group_label: "Reserved Instance Details"
    type: number
    sql: ${TABLE}.reservation_amortized_upfront_cost_for_usage ;;
    description: "Amortized upfront cost allocated to usage"
    value_format_name: "usd"
  }

  dimension: reservation_amortized_upfront_fee_for_billing_period {
    group_label: "Reserved Instance Details"
    type: number
    sql: ${TABLE}.reservation_amortized_upfront_fee_for_billing_period ;;
    description: "Amortized upfront fee for billing period"
    value_format_name: "usd"
  }

  dimension: reservation_availability_zone {
    group_label: "Reserved Instance Details"
    type: string
    sql: ${TABLE}.reservation_availability_zone ;;
    description: "Availability zone for Reserved Instance"
  }

  dimension: reservation_effective_cost {
    group_label: "Reserved Instance Details"
    type: number
    sql: ${TABLE}.reservation_effective_cost ;;
    description: "Effective cost including RI benefits"
    value_format_name: "usd"
  }

  dimension: reservation_end_time {
    group_label: "Reserved Instances > Timing"
    type: string
    sql: ${TABLE}.reservation_end_time ;;
    description: "End time of the reservation period"
  }

  dimension: reservation_modification_status {
    group_label: "Reserved Instances > Status"
    type: string
    sql: ${TABLE}.reservation_modification_status ;;
    description: "Modification status of the reservation"
  }

  dimension: reservation_net_amortized_upfront_cost_for_usage {
    group_label: "Reserved Instances > Net Costs"
    type: number
    sql: ${TABLE}.reservation_net_amortized_upfront_cost_for_usage ;;
    description: "Net amortized upfront cost allocated to usage after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_net_amortized_upfront_fee_for_billing_period {
    group_label: "Reserved Instances > Net Costs"
    type: number
    sql: ${TABLE}.reservation_net_amortized_upfront_fee_for_billing_period ;;
    description: "Net amortized upfront fee for billing period after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_net_effective_cost {
    group_label: "Reserved Instances > Net Costs"
    type: number
    sql: ${TABLE}.reservation_net_effective_cost ;;
    description: "Net effective cost including RI benefits after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_net_recurring_fee_for_usage {
    group_label: "Reserved Instances > Net Costs"
    type: number
    sql: ${TABLE}.reservation_net_recurring_fee_for_usage ;;
    description: "Net recurring fee for usage after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_net_unused_amortized_upfront_fee_for_billing_period {
    group_label: "Reserved Instances > Net Unused"
    type: number
    sql: ${TABLE}.reservation_net_unused_amortized_upfront_fee_for_billing_period ;;
    description: "Net unused amortized upfront fee for billing period after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_net_unused_recurring_fee {
    group_label: "Reserved Instances > Net Unused"
    type: number
    sql: ${TABLE}.reservation_net_unused_recurring_fee ;;
    description: "Net unused recurring fee after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_net_upfront_value {
    group_label: "Reserved Instances > Net Costs"
    type: number
    sql: ${TABLE}.reservation_net_upfront_value ;;
    description: "Net upfront value of reservation after discounts"
    value_format_name: "usd"
  }

  dimension: reservation_normalized_units_per_reservation {
    group_label: "Reserved Instances > Units"
    type: string
    sql: ${TABLE}.reservation_normalized_units_per_reservation ;;
    description: "Number of normalized units per reservation"
  }

  dimension: reservation_number_of_reservations {
    group_label: "Reserved Instances > Quantity"
    type: string
    sql: ${TABLE}.reservation_number_of_reservations ;;
    description: "Number of reservations"
  }

  dimension: reservation_recurring_fee_for_usage {
    group_label: "Reserved Instances > Costs"
    type: number
    sql: ${TABLE}.reservation_recurring_fee_for_usage ;;
    description: "Recurring fee for usage"
    value_format_name: "usd"
  }

  dimension: reservation_reservation_a_r_n {
    group_label: "Reserved Instances > Identification"
    type: string
    sql: ${TABLE}.reservation_reservation_a_r_n ;;
    description: "Amazon Resource Name (ARN) of the reservation"
  }

  dimension: reservation_start_time {
    group_label: "Reserved Instances > Timing"
    type: string
    sql: ${TABLE}.reservation_start_time ;;
    description: "Start time of the reservation period"
  }

  dimension: reservation_subscription_id {
    group_label: "Reserved Instances > Identification"
    type: string
    sql: ${TABLE}.reservation_subscription_id ;;
    description: "Subscription ID for the reservation"
  }

  dimension: reservation_total_reserved_normalized_units {
    group_label: "Reserved Instances > Units"
    type: string
    sql: ${TABLE}.reservation_total_reserved_normalized_units ;;
    description: "Total reserved normalized units"
  }

  dimension: reservation_total_reserved_units {
    group_label: "Reserved Instances > Units"
    type: string
    sql: ${TABLE}.reservation_total_reserved_units ;;
    description: "Total reserved units"
  }

  dimension: reservation_units_per_reservation {
    group_label: "Reserved Instances > Units"
    type: string
    sql: ${TABLE}.reservation_units_per_reservation ;;
    description: "Number of units per reservation"
  }

  dimension: reservation_unused_amortized_upfront_fee_for_billing_period {
    group_label: "Reserved Instances > Unused"
    type: number
    sql: ${TABLE}.reservation_unused_amortized_upfront_fee_for_billing_period ;;
    description: "Unused amortized upfront fee for billing period"
    value_format_name: "usd"
  }

  dimension: reservation_unused_normalized_unit_quantity {
    group_label: "Reserved Instances > Unused"
    type: number
    sql: ${TABLE}.reservation_unused_normalized_unit_quantity ;;
    description: "Unused normalized unit quantity"
  }

  dimension: reservation_unused_quantity {
    group_label: "Reserved Instances > Unused"
    type: number
    sql: ${TABLE}.reservation_unused_quantity ;;
    description: "Unused quantity of reserved instances"
  }

  dimension: reservation_unused_recurring_fee {
    group_label: "Reserved Instances > Unused"
    type: number
    sql: ${TABLE}.reservation_unused_recurring_fee ;;
    description: "Unused recurring fee"
    value_format_name: "usd"
  }

  dimension: reservation_upfront_value {
    group_label: "Reserved Instances > Costs"
    type: number
    sql: ${TABLE}.reservation_upfront_value ;;
    description: "Upfront value of the reservation"
    value_format_name: "usd"
  }

  dimension: resource_tags {
    group_label: "Resource Tags > Raw Data"
    type: string
    sql: ${TABLE}.resource_tags ;;
    description: "Raw JSON object containing all resource tags"
  }

# =====================================================
# RESOURCE TAG DIMENSIONS (COST ALLOCATION TAGS)
# =====================================================

  dimension: environment {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'Environment') ;;
    description: "Environment tag"
  }

  dimension: created_by {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'CreatedBy') ;;
    description: "CreatedBy tag"
  }

  dimension: env {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'Env') ;;
    description: "Env tag"
  }

  dimension: name {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'Name') ;;
    description: "Name tag"
  }

  dimension: proj {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'Proj') ;;
    description: "Project tag"
  }

  dimension: team {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'Team') ;;
    description: "Team tag"
  }

  dimension: aws_application {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'awsApplication') ;;
    description: "AWS Application tag"
  }

  dimension: directorate {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'directorate') ;;
    description: "Directorate tag"
  }

  dimension: division {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'division') ;;
    description: "Division tag"
  }

  dimension: ml_wspace_no {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'ml_wspace_no') ;;
    description: "ML Workspace Number tag"
  }

  dimension: project_lead {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'project_lead') ;;
    description: "Project Lead tag"
  }

  dimension: project_owner {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'project_owner') ;;
    description: "Project Owner tag"
  }

  dimension: aws_autoscaling_group {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'aws:autoscaling:groupName') ;;
    description: "Autoscaling Group Name tag"
  }

  dimension: aws_cloudformation_stack {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'aws:cloudformation:stack-name') ;;
    description: "CloudFormation Stack Name tag"
  }

  dimension: aws_created_by {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'aws:createdBy') ;;
    description: "AWS CreatedBy tag"
  }

  dimension: aws_ecs_cluster {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'aws:ecs:clusterName') ;;
    description: "ECS Cluster Name tag"
  }

  dimension: aws_ecs_service {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'aws:ecs:serviceName') ;;
    description: "ECS Service Name tag"
  }

  dimension: aws_eks_cluster {
    group_label: "Resource Tags"
    type: string
    sql: element_at(${TABLE}.resource_tags, 'aws:eks:cluster-name') ;;
    description: "EKS Cluster Name tag"
  }

  # =====================================================
  # ADDITIONAL RESOURCE TAG HELPERS
  # =====================================================

  dimension: has_tags {
    group_label: "Resource Tags"
    type: yesno
    sql: ${TABLE}.resource_tags IS NOT NULL AND cardinality(${TABLE}.resource_tags) > 0 ;;
    description: "Whether the resource has any tags"
  }

  dimension: tag_count {
    group_label: "Resource Tags"
    type: number
    sql: cardinality(${TABLE}.resource_tags) ;;
    description: "Number of tags on this resource"
  }

  dimension: has_environment_tag {
    group_label: "Resource Tags"
    type: yesno
    sql: element_at(${TABLE}.resource_tags, 'user_environment') IS NOT NULL ;;
    description: "Whether resource has environment tag"
  }

  dimension: has_team_tag {
    group_label: "Resource Tags"
    type: yesno
    sql: element_at(${TABLE}.resource_tags, 'user_team') IS NOT NULL ;;
    description: "Whether resource has team tag"
  }

  dimension: tag_completeness {
    group_label: "Resource Tags"
    type: string
    sql:
      CASE
        WHEN cardinality(${TABLE}.resource_tags) = 0 THEN 'No Tags'
        WHEN element_at(${TABLE}.resource_tags, 'user_environment') IS NOT NULL
             AND element_at(${TABLE}.resource_tags, 'user_team') IS NOT NULL
             AND element_at(${TABLE}.resource_tags, 'user_name') IS NOT NULL
        THEN 'Fully Tagged'
        WHEN cardinality(${TABLE}.resource_tags) >= 2 THEN 'Partially Tagged'
        ELSE 'Minimally Tagged'
      END ;;
    description: "Tag completeness assessment"
  }

  # =====================================================
  # DERIVED DIMENSIONS FOR ANALYTICS
  # =====================================================

  dimension: service_category {
    type: string
    sql: CASE
      WHEN ${line_item_product_code} IN ('AmazonEC2', 'Amazon Elastic Compute Cloud') THEN 'Compute'
      WHEN ${line_item_product_code} IN ('AmazonRDS', 'AmazonDynamoDB', 'AmazonRedshift', 'AmazonElastiCache') THEN 'Database'
      WHEN ${line_item_product_code} IN ('AmazonS3', 'Amazon Simple Storage Service') THEN 'Storage'
      WHEN ${line_item_product_code} IN ('AmazonEBS', 'Amazon Elastic Block Store') THEN 'Storage'
      WHEN ${line_item_product_code} IN ('AmazonCloudFront', 'AmazonVPC', 'AmazonRoute53', 'AWSDataTransfer') THEN 'Networking'
      WHEN ${line_item_product_code} IN ('AWSLambda', 'AmazonECS', 'AmazonEKS') THEN 'Containers & Serverless'
      WHEN ${line_item_product_code} IN ('AmazonSageMaker', 'AmazonBedrock', 'AmazonTextract', 'AmazonRekognition') THEN 'AI/ML'
      WHEN ${line_item_product_code} IN ('AmazonAthena', 'AWSGlue', 'AmazonEMR', 'AmazonRedshift') THEN 'Analytics'
      WHEN ${line_item_product_code} IN ('awskms', 'AWSKeyManagementService') THEN 'Security'
      WHEN ${line_item_product_code} IN ('AWSCloudTrail', 'AWSConfig', 'AmazonCloudWatch') THEN 'Management & Governance'
      WHEN ${line_item_product_code} IN ('AWSAppSync', 'AmazonAPIGateway') THEN 'Application Integration'
      WHEN ${line_item_product_code} = 'AWSDeepRacer' THEN 'Machine Learning'
      WHEN ${line_item_product_code} LIKE 'Amazon%' THEN 'Other AWS Services'
      WHEN ${line_item_product_code} LIKE 'AWS%' THEN 'Other AWS Services'
      ELSE 'Other Services'
    END ;;
    description: "Service category grouping"
  }

  dimension: cost_type {
    type: string
    sql: CASE
      WHEN ${line_item_line_item_type} = 'DiscountedUsage' THEN 'Reserved Instance'
      WHEN ${savings_plan_savings_plan_a_r_n} IS NOT NULL THEN 'Savings Plan'
      WHEN ${line_item_usage_type} LIKE '%Spot%' THEN 'Spot Instance'
      WHEN ${line_item_line_item_type} = 'Usage' THEN 'On-Demand'
      WHEN ${line_item_line_item_type} = 'Fee' THEN 'Fees'
      WHEN ${line_item_line_item_type} = 'Tax' THEN 'Tax'
      WHEN ${line_item_line_item_type} = 'Credit' THEN 'Credit'
      ELSE 'Other'
    END ;;
    description: "Cost type by pricing model"
  }

  dimension: is_usage {
    type: yesno
    sql: ${line_item_line_item_type} = 'Usage' ;;
    description: "Whether this is a usage line item"
  }

  dimension: is_tax {
    type: yesno
    sql: ${line_item_line_item_type} = 'Tax' ;;
    description: "Whether this is a tax line item"
  }

  dimension: has_discount {
    type: yesno
    sql: ${discount_total_discount} != 0 ;;
    description: "Whether this line item has a discount"
  }

  # =====================================================
  # SAVINGS PLAN DIMENSIONS
  # =====================================================

  dimension: savings_plan_amortized_upfront_commitment_for_billing_period {
    group_label: "Savings Plans > Commitments"
    type: number
    sql: ${TABLE}.savings_plan_amortized_upfront_commitment_for_billing_period ;;
    description: "Amortized upfront commitment for billing period"
    value_format_name: "usd"
  }

  dimension: savings_plan_end_time {
    group_label: "Savings Plans > Timing"
    type: string
    sql: ${TABLE}.savings_plan_end_time ;;
    description: "End time of the savings plan period"
  }

  dimension: savings_plan_instance_type_family {
    group_label: "Savings Plans > Specifications"
    type: string
    sql: ${TABLE}.savings_plan_instance_type_family ;;
    description: "Instance type family covered by savings plan"
  }

  dimension: savings_plan_net_amortized_upfront_commitment_for_billing_period {
    group_label: "Savings Plans > Net Commitments"
    type: number
    sql: ${TABLE}.savings_plan_net_amortized_upfront_commitment_for_billing_period ;;
    description: "Net amortized upfront commitment for billing period after discounts"
    value_format_name: "usd"
  }

  dimension: savings_plan_net_recurring_commitment_for_billing_period {
    group_label: "Savings Plans > Net Commitments"
    type: number
    sql: ${TABLE}.savings_plan_net_recurring_commitment_for_billing_period ;;
    description: "Net recurring commitment for billing period after discounts"
    value_format_name: "usd"
  }

  dimension: savings_plan_net_savings_plan_effective_cost {
    group_label: "Savings Plans > Net Costs"
    type: number
    sql: ${TABLE}.savings_plan_net_savings_plan_effective_cost ;;
    description: "Net effective cost with savings plan benefits after discounts"
    value_format_name: "usd"
  }

  dimension: savings_plan_offering_type {
    group_label: "Savings Plans > Plan Details"
    type: string
    sql: ${TABLE}.savings_plan_offering_type ;;
    description: "Type of savings plan offering (Compute, EC2 Instance, etc.)"
  }

  dimension: savings_plan_payment_option {
    group_label: "Savings Plans > Plan Details"
    type: string
    sql: ${TABLE}.savings_plan_payment_option ;;
    description: "Payment option for savings plan (All Upfront, Partial Upfront, No Upfront)"
  }

  dimension: savings_plan_purchase_term {
    group_label: "Savings Plans > Plan Details"
    type: string
    sql: ${TABLE}.savings_plan_purchase_term ;;
    description: "Purchase term for savings plan (1yr, 3yr)"
  }

  dimension: savings_plan_recurring_commitment_for_billing_period {
    group_label: "Savings Plans > Commitments"
    type: number
    sql: ${TABLE}.savings_plan_recurring_commitment_for_billing_period ;;
    description: "Recurring commitment for billing period"
    value_format_name: "usd"
  }

  dimension: savings_plan_region {
    group_label: "Savings Plans > Location"
    type: string
    sql: ${TABLE}.savings_plan_region ;;
    description: "Region where savings plan applies"
  }

  dimension: savings_plan_savings_plan_a_r_n {
    group_label: "Savings Plans > Identification"
    type: string
    sql: ${TABLE}.savings_plan_savings_plan_a_r_n ;;
    description: "Amazon Resource Name (ARN) of the savings plan"
  }

  dimension: savings_plan_savings_plan_effective_cost {
    group_label: "Savings Plans > Costs"
    type: number
    sql: ${TABLE}.savings_plan_savings_plan_effective_cost ;;
    description: "Effective cost with savings plan benefits"
    value_format_name: "usd"
  }

  dimension: savings_plan_savings_plan_rate {
    group_label: "Savings Plans > Rates"
    type: number
    sql: ${TABLE}.savings_plan_savings_plan_rate ;;
    description: "Savings plan rate"
  }

  dimension: savings_plan_start_time {
    group_label: "Savings Plans > Timing"
    type: string
    sql: ${TABLE}.savings_plan_start_time ;;
    description: "Start time of the savings plan period"
  }

  dimension: savings_plan_total_commitment_to_date {
    group_label: "Savings Plans > Commitments"
    type: number
    sql: ${TABLE}.savings_plan_total_commitment_to_date ;;
    description: "Total commitment to date"
    value_format_name: "usd"
  }

  dimension: savings_plan_used_commitment {
    group_label: "Savings Plans > Usage"
    type: number
    sql: ${TABLE}.savings_plan_used_commitment ;;
    description: "Used commitment amount"
    value_format_name: "usd"
  }

  dimension: source_account_id {
    group_label: "Account Information > Source"
    type: string
    sql: ${TABLE}.source_account_id ;;
    description: "Source account ID for cross-account resource usage"
  }

  dimension: split_line_item_actual_usage {
    group_label: "Split Line Items > Usage"
    type: number
    sql: ${TABLE}.split_line_item_actual_usage ;;
    description: "Actual usage for split line items"
  }

  dimension: split_line_item_net_split_cost {
    group_label: "Split Line Items > Net Costs"
    type: number
    sql: ${TABLE}.split_line_item_net_split_cost ;;
    description: "Net split cost after discounts"
    value_format_name: "usd"
  }

  dimension: split_line_item_net_unused_cost {
    group_label: "Split Line Items > Net Costs"
    type: number
    sql: ${TABLE}.split_line_item_net_unused_cost ;;
    description: "Net unused cost after discounts"
    value_format_name: "usd"
  }

  dimension: split_line_item_parent_resource_id {
    group_label: "Split Line Items > Resources"
    type: string
    sql: ${TABLE}.split_line_item_parent_resource_id ;;
    description: "Parent resource ID for split line items"
  }

  dimension: split_line_item_public_on_demand_split_cost {
    group_label: "Split Line Items > Public Costs"
    type: number
    sql: ${TABLE}.split_line_item_public_on_demand_split_cost ;;
    description: "Public on-demand split cost"
    value_format_name: "usd"
  }

  dimension: split_line_item_public_on_demand_unused_cost {
    group_label: "Split Line Items > Public Costs"
    type: number
    sql: ${TABLE}.split_line_item_public_on_demand_unused_cost ;;
    description: "Public on-demand unused cost"
    value_format_name: "usd"
  }

  dimension: split_line_item_reserved_usage {
    group_label: "Split Line Items > Usage"
    type: number
    sql: ${TABLE}.split_line_item_reserved_usage ;;
    description: "Reserved usage for split line items"
  }

  dimension: split_line_item_split_cost {
    group_label: "Split Line Items > Costs"
    type: number
    sql: ${TABLE}.split_line_item_split_cost ;;
    description: "Split cost for line item"
    value_format_name: "usd"
  }

  dimension: split_line_item_split_usage {
    group_label: "Split Line Items > Usage"
    type: number
    sql: ${TABLE}.split_line_item_split_usage ;;
    description: "Split usage amount"
  }

  dimension: split_line_item_split_usage_ratio {
    group_label: "Split Line Items > Ratios"
    type: number
    sql: ${TABLE}.split_line_item_split_usage_ratio ;;
    description: "Usage ratio for split allocation"
  }

  dimension: split_line_item_unused_cost {
    group_label: "Split Line Items > Costs"
    type: number
    sql: ${TABLE}.split_line_item_unused_cost ;;
    description: "Unused cost for split line items"
    value_format_name: "usd"
  }

  # =====================================================
  # MEASURES
  # =====================================================

  measure: count {
    group_label: "Basic Measures > Record Counts"
    type: count
    filters: [line_item_line_item_type: "-null"]
    drill_fields: [cur2_line_item_pk, payer_account_name, line_item_usage_account_name, report_name]
    description: "Count of non-null line items"
  }

  measure: total_unblended_cost {
    group_label: "Basic Measures > Primary Costs"
    type: sum
    sql: ${line_item_unblended_cost} ;;
    value_format: "$#,##0.00"
    description: "Total unblended cost"
    drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
  }

  measure: total_blended_cost {
    group_label: "Basic Measures > Primary Costs"
    type: sum
    sql: ${line_item_blended_cost} ;;
    value_format: "$#,##0.00"
    description: "Total blended cost"
  }

  measure: total_net_unblended_cost {
    group_label: "Basic Measures > Primary Costs"
    type: sum
    sql: ${line_item_net_unblended_cost} ;;
    value_format: "$#,##0.00"
    description: "Total net unblended cost (after discounts)"
  }

  measure: total_usage_amount {
    group_label: "Basic Measures > Usage"
    type: sum
    sql: ${line_item_usage_amount} ;;
    value_format: "#,##0.000"
    description: "Total usage amount"
  }

  measure: total_discount_amount {
    group_label: "Basic Measures > Discounts"
    type: sum
    sql: ABS(${discount_total_discount}) ;;
    value_format: "$#,##0.00"
    description: "Total discount amount"
  }

  measure: total_tax_amount {
    group_label: "Basic Measures > Cost Types"
    type: sum
    sql: CASE WHEN ${is_tax} THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total tax amount"
  }

  measure: total_usage_cost {
    group_label: "Basic Measures > Cost Types"
    type: sum
    sql: CASE WHEN ${is_usage} THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total usage costs (excluding tax and fees)"
  }

  # Tag-related measures
  measure: total_tagged_cost {
    group_label: "Tag Analytics > Cost Distribution"
    type: sum
    sql: CASE WHEN ${has_tags} THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost for tagged resources"
  }

  measure: total_untagged_cost {
    group_label: "Tag Analytics > Cost Distribution"
    type: sum
    sql: CASE WHEN NOT ${has_tags} THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost for untagged resources"
  }

  measure: tag_coverage_rate {
    group_label: "Tag Analytics > Coverage Metrics"
    type: number
    sql: (${total_tagged_cost} / NULLIF(${total_unblended_cost}, 0)) * 100 ;;
    value_format: "#,##0.1"
    description: "Percentage of costs that are tagged"
  }

  measure: count_unique_resources {
    group_label: "Basic Measures > Record Counts"
    type: count_distinct
    sql: ${line_item_resource_id} ;;
    description: "Count of unique resources"
  }

  measure: count_unique_accounts {
    group_label: "Basic Measures > Record Counts"
    type: count_distinct
    sql: ${line_item_usage_account_id} ;;
    description: "Count of unique accounts"
  }

  measure: count_unique_services {
    group_label: "Basic Measures > Record Counts"
    type: count_distinct
    sql: ${line_item_product_code} ;;
    description: "Count of unique AWS services"
  }

  measure: count_environments {
    group_label: "Tag Analytics > Environment Metrics"
    type: count_distinct
    sql: ${environment} ;;
    description: "Count of unique environments"
  }

  measure: count_teams {
    group_label: "Tag Analytics > Team Metrics"
    type: count_distinct
    sql: ${team} ;;
    description: "Count of unique teams"
  }

  # =====================================================
  # ADVANCED COST ANALYSIS MEASURES
  # =====================================================

  measure: average_daily_cost {
    group_label: "Cost Analytics > Time-Based"
    type: number
    sql: ${total_unblended_cost} / NULLIF(COUNT(DISTINCT ${line_item_usage_start_date}), 0) ;;
    value_format: "$#,##0.00"
    description: "Average daily cost for the selected period"
  }

  measure: cost_per_resource {
    group_label: "Cost Analytics > Efficiency"
    type: number
    sql: ${total_unblended_cost} / NULLIF(${count_unique_resources}, 0) ;;
    value_format: "$#,##0.00"
    description: "Average cost per unique resource"
  }

  measure: cost_variance_pct {
    group_label: "Cost Analytics > Variance"
    type: percent_of_total
    sql: ${total_unblended_cost} ;;
    description: "Percentage of total cost variance"
  }

  # Reservation and Savings Plan measures
  measure: total_ri_cost {
    group_label: "Commitment Discounts > Reserved Instances"
    type: sum
    sql: CASE WHEN ${cost_type} = 'Reserved Instance' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total Reserved Instance cost"
  }

  measure: total_savings_plan_cost {
    group_label: "Commitment Discounts > Savings Plans"
    type: sum
    sql: CASE WHEN ${cost_type} = 'Savings Plan' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total Savings Plan cost"
  }

  measure: total_on_demand_cost {
    group_label: "Pricing Models > On-Demand"
    type: sum
    sql: CASE WHEN ${cost_type} = 'On-Demand' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total On-Demand cost"
  }

  measure: total_spot_cost {
    group_label: "Pricing Models > Spot"
    type: sum
    sql: CASE WHEN ${cost_type} = 'Spot Instance' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total Spot Instance cost"
  }

  measure: commitment_savings_rate {
    group_label: "Commitment Discounts > Coverage"
    type: number
    sql: 
      CASE 
        WHEN (${total_ri_cost} + ${total_savings_plan_cost} + ${total_on_demand_cost}) > 0 
        THEN ((${total_ri_cost} + ${total_savings_plan_cost}) / 
              (${total_ri_cost} + ${total_savings_plan_cost} + ${total_on_demand_cost})) * 100
        ELSE 0 
      END ;;
    value_format: "#,##0.1"
    description: "Percentage of compute costs covered by commitments"
  }

  # Cost efficiency measures
  measure: cost_per_gb_storage {
    group_label: "Cost Analytics > Unit Costs"
    type: number
    sql: 
      CASE 
        WHEN ${service_category} = 'Storage' AND ${total_usage_amount} > 0
        THEN ${total_unblended_cost} / ${total_usage_amount}
        ELSE NULL 
      END ;;
    value_format: "$#,##0.0000"
    description: "Cost per GB for storage services"
  }

  measure: cost_per_compute_hour {
    group_label: "Cost Analytics > Unit Costs"
    type: number
    sql: 
      CASE 
        WHEN ${service_category} = 'Compute' AND ${total_usage_amount} > 0
        THEN ${total_unblended_cost} / ${total_usage_amount}
        ELSE NULL 
      END ;;
    value_format: "$#,##0.0000"
    description: "Cost per compute hour"
  }

  # Time-based analysis measures
  measure: month_over_month_change {
    group_label: "Cost Analytics > Time-Based"
    type: percent_of_previous
    sql: ${total_unblended_cost} ;;
    description: "Month-over-month cost change percentage"
  }

  measure: year_over_year_change {
    group_label: "Cost Analytics > Time-Based"
    type: number
    sql: 
      (${total_unblended_cost} - 
       LAG(${total_unblended_cost}, 12) OVER (ORDER BY ${line_item_usage_start_month})) /
       NULLIF(LAG(${total_unblended_cost}, 12) OVER (ORDER BY ${line_item_usage_start_month}), 0) * 100 ;;
    value_format: "#,##0.1"
    description: "Year-over-year cost change percentage"
  }

  measure: previous_month_cost {
    group_label: "Cost Analytics > Time-Based"
    type: number
    sql: LAG(${total_unblended_cost}, 1) OVER (ORDER BY ${line_item_usage_start_month}) ;;
    value_format: "$#,##0.00"
    description: "Previous month total cost for comparison"
  }

  measure: cost_difference {
    group_label: "Cost Analytics > Time-Based"
    type: number
    sql: ${total_unblended_cost} - ${previous_month_cost} ;;
    value_format: "$#,##0.00"
    description: "Absolute cost difference from previous month"
  }

  measure: week_over_week_change {
    group_label: "Cost Analytics > Time-Based"
    type: percent_of_previous
    sql: ${total_unblended_cost} ;;
    dimension: line_item_usage_start_week
    value_format: "#,##0.1%"
    description: "Week-over-week cost change percentage"
  }

  measure: previous_week_cost {
    group_label: "Cost Analytics > Time-Based"
    type: number
    sql: LAG(${total_unblended_cost}, 1) OVER (ORDER BY ${line_item_usage_start_week}) ;;
    value_format: "$#,##0.00"
    description: "Previous week total cost for comparison"
  }

  # Service-specific measures
  measure: ec2_cost {
    group_label: "Service Costs > Compute"
    type: sum
    sql: CASE WHEN ${line_item_product_code} IN ('AmazonEC2', 'Amazon Elastic Compute Cloud') THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total EC2 cost"
  }

  measure: s3_cost {
    group_label: "Service Costs > Storage"
    type: sum
    sql: CASE WHEN ${line_item_product_code} IN ('AmazonS3', 'Amazon Simple Storage Service') THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total S3 cost"
  }

  measure: rds_cost {
    group_label: "Service Costs > Database"
    type: sum
    sql: CASE WHEN ${line_item_product_code} = 'AmazonRDS' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total RDS cost"
  }

  measure: lambda_cost {
    group_label: "Service Costs > Serverless"
    type: sum
    sql: CASE WHEN ${line_item_product_code} = 'AWSLambda' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total Lambda cost"
  }

  # Data transfer measures
  measure: data_transfer_cost {
    group_label: "Service Costs > Networking"
    type: sum
    sql: CASE WHEN ${line_item_product_code} = 'AWSDataTransfer' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total data transfer cost"
  }

  measure: data_transfer_gb {
    group_label: "Service Usage > Data Transfer"
    type: sum
    sql: CASE WHEN ${line_item_product_code} = 'AWSDataTransfer' THEN ${line_item_usage_amount} ELSE 0 END ;;
    value_format: "#,##0.000"
    description: "Total data transfer in GB"
  }

  # AI/ML cost measures
  measure: sagemaker_cost {
    group_label: "Service Costs > AI/ML"
    type: sum
    sql: CASE WHEN ${line_item_product_code} = 'AmazonSageMaker' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total SageMaker cost"
  }

  measure: bedrock_cost {
    group_label: "Service Costs > AI/ML"
    type: sum
    sql: CASE WHEN ${line_item_product_code} = 'AmazonBedrock' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total Bedrock cost"
  }

  # Top cost contributors
  measure: top_10_services_cost {
    group_label: "Service Analysis > Top Contributors"
    type: sum
    sql: ${line_item_unblended_cost} ;;
    filters: [line_item_product_code: "{% assign services = 'AmazonEC2,AmazonS3,AmazonRDS,AWSLambda,AmazonCloudFront,AmazonVPC,AmazonEBS,AmazonDynamoDB,AmazonRedshift,AmazonEKS' | split: ',' %}{{ services | join: ',' }}"]
    value_format: "$#,##0.00"
    description: "Cost for top 10 services by usage"
  }

  # Forecast measures (for trending analysis)
  measure: projected_monthly_cost {
    group_label: "Forecasting > Short-Term"
    type: number
    sql: 
      CASE 
        WHEN EXTRACT(DAY FROM CURRENT_DATE) > 0
        THEN (${total_unblended_cost} / EXTRACT(DAY FROM CURRENT_DATE)) * 
             EXTRACT(DAY FROM LAST_DAY(CURRENT_DATE))
        ELSE ${total_unblended_cost}
      END ;;
    value_format: "$#,##0.00"
    description: "Projected cost for current month based on daily average"
  }

  # Cost anomaly detection helpers
  measure: cost_z_score {
    group_label: "Anomaly Detection > Statistical"
    type: number
    sql: 
      (${total_unblended_cost} - AVG(${total_unblended_cost}) OVER()) / 
      NULLIF(STDDEV(${total_unblended_cost}) OVER(), 0) ;;
    value_format: "#,##0.00"
    description: "Z-score for cost anomaly detection"
  }

  measure: is_cost_anomaly {
    group_label: "Anomaly Detection > Flags"
    type: yesno
    sql: ABS(${cost_z_score}) > 2 ;;
    description: "Whether cost is an anomaly (2+ standard deviations)"
  }

  # Regional cost distribution
  measure: us_east_1_cost {
    group_label: "Regional Analysis > US Regions"
    type: sum
    sql: CASE WHEN ${product_region_code} = 'us-east-1' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost in US East 1 region"
  }

  measure: us_west_2_cost {
    group_label: "Regional Analysis > US Regions"
    type: sum
    sql: CASE WHEN ${product_region_code} = 'us-west-2' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost in US West 2 region"
  }

  measure: eu_west_1_cost {
    group_label: "Regional Analysis > EU Regions"
    type: sum
    sql: CASE WHEN ${product_region_code} = 'eu-west-1' THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost in EU West 1 region"
  }

  # =====================================================
  # COST ALLOCATION AND CHARGEBACK MEASURES
  # =====================================================

  measure: environment_production_cost {
    group_label: "Environment Analysis > Production"
    type: sum
    sql: CASE WHEN LOWER(${environment}) IN ('prod', 'production', 'prd') THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost for production environments"
  }

  measure: environment_development_cost {
    group_label: "Environment Analysis > Non-Production"
    type: sum
    sql: CASE WHEN LOWER(${environment}) IN ('dev', 'development', 'develop') THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost for development environments"
  }

  measure: environment_staging_cost {
    group_label: "Environment Analysis > Non-Production"
    type: sum
    sql: CASE WHEN LOWER(${environment}) IN ('stage', 'staging', 'stg') THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost for staging environments"
  }

  measure: environment_test_cost {
    group_label: "Environment Analysis > Non-Production"
    type: sum
    sql: CASE WHEN LOWER(${environment}) IN ('test', 'testing', 'qa') THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost for test environments"
  }

  # Team-based cost allocation
  measure: team_cost_allocation {
    group_label: "Chargeback > Team Allocation"
    type: sum
    sql: CASE WHEN ${team} IS NOT NULL THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost allocated to teams"
  }

  measure: unallocated_team_cost {
    group_label: "Chargeback > Unallocated"
    type: sum
    sql: CASE WHEN ${team} IS NULL THEN ${line_item_unblended_cost} ELSE 0 END ;;
    value_format: "$#,##0.00"
    description: "Total cost not allocated to any team"
  }

  # =====================================================
  # SUSTAINABILITY AND CARBON METRICS
  # =====================================================

  measure: estimated_carbon_impact {
    group_label: "Sustainability > Carbon Impact"
    type: number
    sql: 
      CASE 
        WHEN ${service_category} = 'Compute' THEN ${total_usage_amount} * 0.5
        WHEN ${service_category} = 'Storage' THEN ${total_usage_amount} * 0.1
        WHEN ${service_category} = 'Database' THEN ${total_usage_amount} * 0.3
        ELSE ${total_usage_amount} * 0.2
      END ;;
    value_format: "#,##0.00"
    description: "Estimated carbon impact (kg CO2) - rough calculation"
  }

  measure: carbon_efficiency_score {
    group_label: "Sustainability > Efficiency"
    type: number
    sql: 
      CASE 
        WHEN ${total_unblended_cost} > 0 
        THEN ${estimated_carbon_impact} / ${total_unblended_cost}
        ELSE 0 
      END ;;
    value_format: "#,##0.0000"
    description: "Carbon efficiency (kg CO2 per dollar)"
  }

  # =====================================================
  # ADVANCED FINOPS MEASURES
  # =====================================================

  measure: waste_detection_score {
    group_label: "FinOps > Waste Management"
    type: number
    sql: 
      CASE
        WHEN ${right_sizing_opportunity} = 0 AND ${total_untagged_cost} = 0 THEN 100
        WHEN ${right_sizing_opportunity} / NULLIF(${total_unblended_cost}, 0) < 0.05 AND ${total_untagged_cost} / NULLIF(${total_unblended_cost}, 0) < 0.1 THEN 80
        WHEN ${right_sizing_opportunity} / NULLIF(${total_unblended_cost}, 0) < 0.1 AND ${total_untagged_cost} / NULLIF(${total_unblended_cost}, 0) < 0.2 THEN 60
        WHEN ${right_sizing_opportunity} / NULLIF(${total_unblended_cost}, 0) < 0.2 AND ${total_untagged_cost} / NULLIF(${total_unblended_cost}, 0) < 0.3 THEN 40
        ELSE 20
      END ;;
    value_format: "#,##0"
    description: "Waste detection score based on right-sizing opportunities and untagged resources"
  }

  measure: finops_maturity_score {
    group_label: "FinOps > Maturity Assessment"
    type: number
    sql: 
      CASE
        WHEN ${tag_coverage_rate} >= 80 AND ${commitment_savings_rate} >= 60 AND ${waste_detection_score} >= 70 THEN 90
        WHEN ${tag_coverage_rate} >= 60 AND ${commitment_savings_rate} >= 40 AND ${waste_detection_score} >= 50 THEN 70
        WHEN ${tag_coverage_rate} >= 40 AND ${commitment_savings_rate} >= 20 AND ${waste_detection_score} >= 30 THEN 50
        ELSE 30
      END ;;
    value_format: "#,##0"
    description: "FinOps maturity score based on tagging, commitments, and waste detection"
  }

  measure: cost_anomaly_score {
    group_label: "FinOps > Anomaly Detection"
    type: number
    sql:
      CASE
        WHEN ABS(${total_unblended_cost} - LAG(${total_unblended_cost}, 1) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
          ORDER BY ${line_item_usage_start_date}
        )) / NULLIF(LAG(${total_unblended_cost}, 1) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
          ORDER BY ${line_item_usage_start_date}
        ), 0) > 0.5 THEN 100
        WHEN ABS(${total_unblended_cost} - LAG(${total_unblended_cost}, 1) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
          ORDER BY ${line_item_usage_start_date}
        )) / NULLIF(LAG(${total_unblended_cost}, 1) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
          ORDER BY ${line_item_usage_start_date}
        ), 0) > 0.25 THEN 60
        ELSE 0
      END ;;
    value_format: "#,##0"
    description: "Cost anomaly detection score (0-100)"
  }

  measure: right_sizing_opportunity {
    group_label: "FinOps > Optimization Opportunities"
    type: number
    sql:
      CASE
        WHEN ${service_category} = 'Compute' AND ${total_usage_amount} > 0
        THEN CASE
          WHEN AVG(${total_usage_amount}) OVER (
            PARTITION BY ${line_item_resource_id} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ) < ${total_usage_amount} * 0.3 THEN ${total_unblended_cost} * 0.4
          WHEN AVG(${total_usage_amount}) OVER (
            PARTITION BY ${line_item_resource_id} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ) < ${total_usage_amount} * 0.5 THEN ${total_unblended_cost} * 0.25
          ELSE 0
        END
        ELSE 0
      END ;;
    value_format: "$#,##0.00"
    description: "Potential savings from right-sizing based on usage patterns"
  }

  measure: optimization_score {
    group_label: "FinOps > Overall Scores"
    type: number
    sql:
      (CASE WHEN ${commitment_savings_rate} >= 70 THEN 25 ELSE ${commitment_savings_rate} * 0.357 END) +
      (CASE WHEN ${tag_coverage_rate} >= 90 THEN 20 ELSE ${tag_coverage_rate} * 0.222 END) +
      (CASE WHEN ${waste_detection_score} >= 80 THEN 25 ELSE ${waste_detection_score} * 0.3125 END) +
      (CASE WHEN ${right_sizing_opportunity} = 0 THEN 30 ELSE GREATEST(0, 30 - (${right_sizing_opportunity} / ${total_unblended_cost} * 100)) END) ;;
    value_format: "#,##0.0"
    description: "Overall optimization score (0-100)"
  }

  measure: unit_cost_trend {
    type: number
    sql:
      CASE 
        WHEN ${total_usage_amount} > 0 AND LAG(${total_usage_amount}, 1) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
          ORDER BY ${line_item_usage_start_date}
        ) > 0
        THEN ((${total_unblended_cost} / ${total_usage_amount}) - 
              (LAG(${total_unblended_cost}, 1) OVER (
                PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
                ORDER BY ${line_item_usage_start_date}
              ) / LAG(${total_usage_amount}, 1) OVER (
                PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
                ORDER BY ${line_item_usage_start_date}
              ))) / NULLIF((LAG(${total_unblended_cost}, 1) OVER (
                PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
                ORDER BY ${line_item_usage_start_date}
              ) / LAG(${total_usage_amount}, 1) OVER (
                PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
                ORDER BY ${line_item_usage_start_date}
              )), 0) * 100
        ELSE 0
      END ;;
    value_format: "#,##0.1"
    description: "Unit cost change percentage period over period"
  }

  # =====================================================
  # GAMIFICATION MEASURES
  # =====================================================

  measure: cost_hero_points {
    group_label: "Gamification > Achievement Points"
    type: number
    sql:
      CASE
        WHEN ${month_over_month_change} < -20 THEN 1000
        WHEN ${month_over_month_change} < -10 THEN 500
        WHEN ${month_over_month_change} < -5 THEN 200
        WHEN ${month_over_month_change} < 0 THEN 100
        WHEN ${month_over_month_change} = 0 THEN 50
        ELSE 0
      END +
      CASE
        WHEN ${tag_coverage_rate} >= 95 THEN 500
        WHEN ${tag_coverage_rate} >= 80 THEN 200
        WHEN ${tag_coverage_rate} >= 60 THEN 100
        ELSE 0
      END +
      CASE
        WHEN ${commitment_savings_rate} >= 80 THEN 600
        WHEN ${commitment_savings_rate} >= 60 THEN 300
        WHEN ${commitment_savings_rate} >= 40 THEN 150
        ELSE 0
      END ;;
    value_format: "#,##0"
    description: "Gamification points for cost optimization achievements"
  }

  measure: sustainability_champion_score {
    type: number
    sql:
      CASE
        WHEN ${carbon_efficiency_score} <= 0.1 THEN 100
        WHEN ${carbon_efficiency_score} <= 0.2 THEN 80
        WHEN ${carbon_efficiency_score} <= 0.3 THEN 60
        WHEN ${carbon_efficiency_score} <= 0.5 THEN 40
        ELSE 20
      END +
      CASE
        WHEN ${service_category} IN ('Serverless', 'Containers & Serverless') THEN 50
        WHEN ${cost_type} = 'Spot Instance' THEN 30
        ELSE 0
      END ;;
    value_format: "#,##0"
    description: "Sustainability champion score based on carbon efficiency"
  }

  measure: waste_warrior_achievements {
    type: number
    sql:
      CASE
        WHEN ${right_sizing_opportunity} = 0 AND ${total_unblended_cost} > 100 THEN 200
        WHEN ${right_sizing_opportunity} < ${total_unblended_cost} * 0.05 THEN 100
        WHEN ${right_sizing_opportunity} < ${total_unblended_cost} * 0.1 THEN 50
        ELSE 0
      END +
      CASE
        WHEN ${total_untagged_cost} = 0 THEN 150
        WHEN ${total_untagged_cost} < ${total_unblended_cost} * 0.05 THEN 75
        ELSE 0
      END ;;
    value_format: "#,##0"
    description: "Waste warrior achievement points for eliminating waste"
  }

  measure: team_collaboration_score {
    type: number
    sql:
      CASE
        WHEN COUNT(DISTINCT ${team}) OVER (PARTITION BY ${line_item_usage_account_id}) > 5 AND 
             ${tag_coverage_rate} > 80 THEN 100
        WHEN COUNT(DISTINCT ${team}) OVER (PARTITION BY ${line_item_usage_account_id}) > 3 AND 
             ${tag_coverage_rate} > 60 THEN 75
        WHEN COUNT(DISTINCT ${team}) OVER (PARTITION BY ${line_item_usage_account_id}) > 1 AND 
             ${tag_coverage_rate} > 40 THEN 50
        ELSE 25
      END ;;
    value_format: "#,##0"
    description: "Team collaboration score based on multi-team tagging discipline"
  }

  measure: level_progress {
    type: number
    sql: (${cost_hero_points} + ${sustainability_champion_score} + ${waste_warrior_achievements}) / 50 ;;
    value_format: "#,##0"
    description: "Overall level progress in cost optimization gamification"
  }

  # =====================================================
  # FORECASTING MEASURES
  # =====================================================

  measure: trend_forecast_7d {
    group_label: "Forecasting > Trend-Based"
    type: number
    sql:
      CASE
        WHEN COUNT(*) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
          ORDER BY ${line_item_usage_start_date} 
          ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) >= 7
        THEN
          AVG(${total_unblended_cost}) OVER (
            PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ) +
          (AVG(${total_unblended_cost}) OVER (
            PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
          ) -
           AVG(${total_unblended_cost}) OVER (
            PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 6 PRECEDING AND 4 PRECEDING
          )) * 7
        ELSE NULL
      END ;;
    value_format: "$#,##0.00"
    description: "7-day trend-based cost forecast"
  }

  measure: seasonal_forecast_30d {
    type: number
    sql:
      CASE
        WHEN COUNT(*) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id}, 
          DATE_PART('dow', ${line_item_usage_start_date})
          ORDER BY ${line_item_usage_start_date} 
          ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ) >= 5
        THEN
          AVG(${total_unblended_cost}) OVER (
            PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id}, 
            DATE_PART('dow', ${line_item_usage_start_date})
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
          ) * 30
        ELSE NULL
      END ;;
    value_format: "$#,##0.00"
    description: "30-day seasonal pattern-based forecast"
  }

  measure: growth_forecast_90d {
    type: number
    sql:
      CASE
        WHEN COUNT(*) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
          ORDER BY ${line_item_usage_start_date} 
          ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
        ) >= 30
        THEN
          (${total_unblended_cost} * 
           POWER(1 + (
             (AVG(${total_unblended_cost}) OVER (
               PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
               ORDER BY ${line_item_usage_start_date} 
               ROWS BETWEEN 9 PRECEDING AND CURRENT ROW
             ) -
             AVG(${total_unblended_cost}) OVER (
               PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
               ORDER BY ${line_item_usage_start_date} 
               ROWS BETWEEN 29 PRECEDING AND 20 PRECEDING
             )) / 
             NULLIF(AVG(${total_unblended_cost}) OVER (
               PARTITION BY ${line_item_product_code}, ${line_item_usage_account_id} 
               ORDER BY ${line_item_usage_start_date} 
               ROWS BETWEEN 29 PRECEDING AND 20 PRECEDING
             ), 0)
           ), 3)) * 90
        ELSE NULL
      END ;;
    value_format: "$#,##0.00"
    description: "90-day growth-based forecast"
  }

  measure: usage_pattern_forecast {
    type: number
    sql:
      CASE
        WHEN ${total_usage_amount} > 0 AND COUNT(*) OVER (
          PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
          ORDER BY ${line_item_usage_start_date} 
          ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
        ) >= 14
        THEN
          (AVG(${total_usage_amount}) OVER (
            PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
          ) * 
          (${total_unblended_cost} / NULLIF(${total_usage_amount}, 0))) +
          (STDDEV(${total_usage_amount}) OVER (
            PARTITION BY ${line_item_product_code}, ${line_item_usage_type} 
            ORDER BY ${line_item_usage_start_date} 
            ROWS BETWEEN 13 PRECEDING AND CURRENT ROW
          ) * 
          (${total_unblended_cost} / NULLIF(${total_usage_amount}, 0)) * 0.5)
        ELSE NULL
      END ;;
    value_format: "$#,##0.00"
    description: "Usage pattern-based cost forecast with variance"
  }

  measure: budget_burn_rate {
    type: number
    sql:
      CASE
        WHEN DATE_PART('day', ${line_item_usage_start_date}) > 0
        THEN (${total_unblended_cost} * 
              (DATE_PART('day', DATE_TRUNC('month', ${line_item_usage_start_date}) + INTERVAL '1 month' - INTERVAL '1 day')) /
              DATE_PART('day', ${line_item_usage_start_date}))
        ELSE NULL
      END ;;
    value_format: "$#,##0.00"
    description: "Projected month-end spend based on current burn rate"
  }

  # =====================================================
  # DATA OPERATIONS MONITORING
  # =====================================================

  measure: data_freshness_hours {
    group_label: "Data Quality > Freshness"
    type: number
    sql: EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(${line_item_usage_start_raw}))) / 3600 ;;
    value_format: "#,##0.0"
    description: "Hours since latest data in the dataset"
  }

  measure: data_completeness_score {
    type: number
    sql:
      (CASE WHEN COUNT(${identity_line_item_id}) > 0 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_unblended_cost} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 95 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_usage_account_id} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 98 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_product_code} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 98 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_usage_start_date} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 99 THEN 20 ELSE 0 END) ;;
    value_format: "#,##0"
    description: "Data completeness score (0-100) based on key field availability"
  }

  measure: data_quality_alerts {
    type: count
    filters: [line_item_unblended_cost: "<0"]
    description: "Count of data quality issues (negative costs, etc.)"
  }

  measure: duplicate_detection_count {
    type: count
    sql: ${identity_line_item_id} ;;
    filters: [identity_line_item_id: ">1"]
    description: "Count of potential duplicate records"
  }

  measure: processing_lag_hours {
    type: number
    sql: 
      CASE
        WHEN MAX(${line_item_usage_end_raw}) IS NOT NULL
        THEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(${line_item_usage_end_raw}))) / 3600
        ELSE NULL
      END ;;
    value_format: "#,##0.0"
    description: "Processing lag in hours from usage end to current time"
  }

  measure: cost_variance_coefficient {
    type: number
    sql:
      CASE
        WHEN AVG(${total_unblended_cost}) > 0 AND COUNT(*) > 1
        THEN STDDEV(${total_unblended_cost}) / NULLIF(AVG(${total_unblended_cost}), 0)
        ELSE 0
      END ;;
    value_format: "#,##0.000"
    description: "Coefficient of variation for cost data quality assessment"
  }

  measure: ingestion_health_score {
    type: number
    sql:
      CASE
        WHEN ${data_freshness_hours} <= 6 AND ${data_completeness_score} >= 80 AND ${data_quality_alerts} = 0 THEN 100
        WHEN ${data_freshness_hours} <= 12 AND ${data_completeness_score} >= 70 AND ${data_quality_alerts} <= 5 THEN 80
        WHEN ${data_freshness_hours} <= 24 AND ${data_completeness_score} >= 60 AND ${data_quality_alerts} <= 20 THEN 60
        ELSE 40
      END ;;
    value_format: "#,##0"
    description: "Overall data ingestion health score (40-100)"
  }

  # =====================================================
  # RESOURCE EFFICIENCY MEASURES
  # =====================================================

  measure: resource_efficiency_score {
    type: number
    sql:
      CASE
        WHEN ${service_category} = 'Compute' THEN
          CASE
            WHEN ${cost_type} = 'Spot Instance' THEN 95
            WHEN ${cost_type} IN ('Reserved Instance', 'Savings Plan') THEN 85
            WHEN ${total_usage_amount} > 0 AND AVG(${total_usage_amount}) OVER (
              PARTITION BY ${line_item_resource_id} 
              ORDER BY ${line_item_usage_start_date} 
              ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ) / ${total_usage_amount} >= 0.8 THEN 80
            WHEN ${total_usage_amount} > 0 AND AVG(${total_usage_amount}) OVER (
              PARTITION BY ${line_item_resource_id} 
              ORDER BY ${line_item_usage_start_date} 
              ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
            ) / ${total_usage_amount} >= 0.5 THEN 60
            ELSE 30
          END
        WHEN ${service_category} = 'Storage' THEN
          CASE
            WHEN ${line_item_usage_type} LIKE '%IA%' OR ${line_item_usage_type} LIKE '%Glacier%' THEN 90
            WHEN ${line_item_usage_type} LIKE '%Standard%' THEN 70
            ELSE 50
          END
        ELSE 70
      END ;;
    value_format: "#,##0"
    description: "Resource efficiency score based on usage patterns and pricing models"
  }

  measure: savings_vs_on_demand {
    type: number
    sql:
      CASE
        WHEN ${cost_type} IN ('Reserved Instance', 'Savings Plan') THEN
          (${pricing_public_on_demand_cost} - ${total_unblended_cost})
        WHEN ${cost_type} = 'Spot Instance' THEN
          (${pricing_public_on_demand_cost} - ${total_unblended_cost})
        ELSE 0
      END ;;
    value_format: "$#,##0.00"
    description: "Savings compared to On-Demand pricing"
  }

  measure: savings_percentage {
    type: number
    sql:
      CASE
        WHEN ${pricing_public_on_demand_cost} > 0 AND ${cost_type} IN ('Reserved Instance', 'Savings Plan', 'Spot Instance')
        THEN ((${pricing_public_on_demand_cost} - ${total_unblended_cost}) / ${pricing_public_on_demand_cost}) * 100
        ELSE 0
      END ;;
    value_format: "#,##0.1"
    description: "Percentage savings vs On-Demand pricing"
  }
}