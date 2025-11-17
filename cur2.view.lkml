# The name of this view in Looker is "Cur2"
view: cur2 {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: @{AWS_SCHEMA_NAME}.@{AWS_TABLE_NAME} ;;
  drill_fields: [line_item_usage_account_name, line_item_resource_id]
  suggestions: yes

  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.
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
    hidden: yes
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
    drill_fields: [line_item_product_code, line_item_line_item_description]
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

  dimension: region {
    group_label: "Geography > Regional"
    type: string
    sql:
      CASE
        WHEN ${product_region_code} LIKE 'us-east-%' THEN 'US East'
        WHEN ${product_region_code} LIKE 'us-west-%' THEN 'US West'
        WHEN ${product_region_code} LIKE 'eu-%' THEN 'Europe'
        WHEN ${product_region_code} LIKE 'ap-%' THEN 'Asia Pacific'
        WHEN ${product_region_code} LIKE 'ca-%' THEN 'Canada'
        WHEN ${product_region_code} LIKE 'sa-%' THEN 'South America'
        WHEN ${product_region_code} LIKE 'af-%' THEN 'Africa'
        WHEN ${product_region_code} LIKE 'me-%' THEN 'Middle East'
        ELSE 'Other/Global'
      END ;;
    description: "AWS region grouped by geographic area"
    map_layer_name: aws_regions
  }

  dimension: region_country {
    label: "AWS Region"
    group_label: "Geography > Regional"
    type: string
    description: "Country inferred from AWS Region code"
    sql:
    CASE
      -- United States
      WHEN ${product_region_code} IN ('us-east-1','us-east-2','us-west-1','us-west-2') THEN 'United States'
      -- Canada
      WHEN ${product_region_code} IN ('ca-central-1','ca-west-1') THEN 'Canada'
      -- Latin America
      WHEN ${product_region_code} = 'sa-east-1' THEN 'Brazil'
      WHEN ${product_region_code} = 'mx-central-1' THEN 'Mexico'
      -- Europe
      WHEN ${product_region_code} = 'eu-west-1' THEN 'Ireland'
      WHEN ${product_region_code} = 'eu-west-2' THEN 'United Kingdom'
      WHEN ${product_region_code} = 'eu-west-3' THEN 'France'
      WHEN ${product_region_code} = 'eu-north-1' THEN 'Sweden'
      WHEN ${product_region_code} = 'eu-central-1' THEN 'Germany'
      WHEN ${product_region_code} = 'eu-central-2' THEN 'Switzerland'
      WHEN ${product_region_code} = 'eu-south-1' THEN 'Italy'
      WHEN ${product_region_code} = 'eu-south-2' THEN 'Spain'
      -- Middle East
      WHEN ${product_region_code} = 'me-south-1' THEN 'Bahrain'
      WHEN ${product_region_code} = 'me-central-1' THEN 'United Arab Emirates'
      WHEN ${product_region_code} = 'il-central-1' THEN 'Israel'
      -- Africa
      WHEN ${product_region_code} = 'af-south-1' THEN 'South Africa'
      -- Asia Pacific
      WHEN ${product_region_code} = 'ap-east-1' THEN 'Hong Kong SAR'
      WHEN ${product_region_code} = 'ap-east-2' THEN 'Taiwan'
      WHEN ${product_region_code} IN ('ap-south-1','ap-south-2') THEN 'India'
      WHEN ${product_region_code} = 'ap-southeast-1' THEN 'Singapore'
      WHEN ${product_region_code} IN ('ap-southeast-2','ap-southeast-4') THEN 'Australia'
      WHEN ${product_region_code} = 'ap-southeast-3' THEN 'Indonesia'
      WHEN ${product_region_code} = 'ap-southeast-5' THEN 'Malaysia'
      WHEN ${product_region_code} = 'ap-southeast-7' THEN 'Thailand'
      WHEN ${product_region_code} IN ('ap-northeast-1','ap-northeast-3') THEN 'Japan'
      WHEN ${product_region_code} = 'ap-northeast-2' THEN 'South Korea'
      -- GovCloud & China
      WHEN ${product_region_code} IN ('us-gov-east-1','us-gov-west-1') THEN 'United States (GovCloud)'
      WHEN ${product_region_code} IN ('cn-north-1','cn-northwest-1') THEN 'China (Mainland)'
      -- Fallback
      ELSE 'Other/Global'
    END ;;
  # Optional: if you’ve a custom topojson, set it here
  # map_layer_name: aws_regions
    }


    measure: count_unique_regions {
      group_label: "Basic Measures > Record Counts"
      type: count_distinct
      value_format: "#,##0"
      sql: ${product_region_code} ;;
      description: "Count of unique AWS regions"
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
      sql: element_at(${TABLE}.resource_tags, 'user_environment') ;;
      description: "Environment tag"
    }

    dimension: created_by {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_CreatedBy') ;;
      description: "CreatedBy tag"
    }

    dimension: env {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_env') ;;
      description: "Account Environment Tag"
    }

    dimension: name {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_name') ;;
      description: "Name tag"
    }

    dimension: proj {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_proj') ;;
      description: "Project tag"
    }

    dimension: team {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_team') ;;
      description: "Team tag"
    }

    dimension: aws_application {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_application') ;;
      description: "AWS Application tag"
    }

    dimension: directorate {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_directorate') ;;
      description: "Directorate tag"
    }

    dimension: division {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_division') ;;
      description: "Division tag"
    }

    dimension: ml_wspace_no {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_ml_wspace_no') ;;
      description: "ML Workspace Number tag"
    }

    dimension: project_lead {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_project_lead') ;;
      description: "Project Lead tag"
    }

    dimension: project_owner {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'user_project_owner') ;;
      description: "Project Owner tag"
    }

    dimension: aws_autoscaling_group {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_autoscaling_group_name') ;;
      description: "Autoscaling Group Name tag"
    }

    dimension: aws_cloudformation_stack {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_cloudformation_stack_name') ;;
      description: "CloudFormation Stack Name tag"
    }

    dimension: aws_created_by {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_CreatedBy') ;;
      description: "AWS CreatedBy tag"
    }

    dimension: aws_ecs_cluster {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_ecs_cluster_name') ;;
      description: "ECS Cluster Name tag"
    }

    dimension: aws_ecs_service {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_ecs_service_name') ;;
      description: "ECS Service Name tag"
    }

    dimension: aws_eks_cluster {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'aws_eks_cluster_name') ;;
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
      sql: element_at(${TABLE}.resource_tags, 'user_env') IS NOT NULL ;;
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

    dimension: project {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'Project') ;;
      description: "Project tag"
    }

    dimension: cost_center {
      group_label: "Resource Tags"
      type: string
      sql: element_at(${TABLE}.resource_tags, 'CostCenter') ;;
      description: "Cost center tag"
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
              WHEN ${line_item_product_code} IN ('AmazonCloudFront', 'AmazonVPC', 'AmazonRoute53', 'AWSDataTransfer') THEN 'Networking'
              WHEN ${line_item_product_code} IN ('AWSLambda', 'AmazonECS', 'AmazonEKS') THEN 'Containers & Serverless'
              WHEN ${line_item_product_code} IN (
                'AmazonSageMaker',
                'AmazonBedrock',
                'AmazonTextract',
                'AmazonRekognition',
                'AmazonComprehend',
                'AmazonTranslate',
                'AmazonTranscribe',
                'AmazonPolly',
                'AmazonLex',
                'AmazonForecast',
                'AmazonPersonalize',
                'AmazonCodeGuru',
                'AmazonA2I'
            ) THEN 'AI/ML'
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
      description: "Dimension for split line item unused cost"
      sql: ${TABLE}.split_line_item_unused_cost ;;
      value_format_name: "usd"
    }

    # =====================================================
    # MEASURES
    # =====================================================

    measure: count {
      group_label: "Basic Measures > Record Counts"
      type: count
      value_format: "#,##0"
      filters: [line_item_line_item_type: "-null"]
      drill_fields: [cur2_line_item_pk, payer_account_name, line_item_usage_account_name, report_name]
      description: "Count of non-null line items"
    }

    measure: total_unblended_cost {
      group_label: "Basic Measures > Primary Costs"
      type: sum
      value_format: "\"£\"#,##0"
      sql: (${line_item_unblended_cost}) * 0.79 ;;
      description: "Total unblended cost"
      drill_fields: [line_item_usage_account_name, line_item_product_code, line_item_resource_id]
    }

    measure: total_blended_cost {
      group_label: "Basic Measures > Primary Costs"
      type: sum
      value_format: "\"£\"#,##0"
      sql: ${line_item_blended_cost} * 0.79;;
      description: "Total blended cost"
      drill_fields: [line_item_usage_account_name, line_item_product_code, line_item_resource_id]
    }

    measure: total_net_unblended_cost {
      group_label: "Basic Measures > Primary Costs"
      type: sum
      value_format: "\"£\"#,##0"
      sql: ${line_item_net_unblended_cost} * 0.79;;
      description: "Total net unblended cost (after discounts)"
      drill_fields: [line_item_usage_account_name, line_item_product_code, line_item_resource_id]
    }

    measure: total_usage_amount {
      group_label: "Basic Measures > Usage"
      type: sum
      value_format: "#,##0.000"
      sql: ${line_item_usage_amount} ;;
      description: "Total usage amount"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_discount_amount {
      group_label: "Basic Measures > Discounts"
      type: sum
      value_format: "\"£\"#,##0"
      sql: ABS(${discount_total_discount}) * 0.79;;
      description: "Total discount amount"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_tax_amount {
      group_label: "Basic Measures > Cost Types"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${is_tax} THEN ${line_item_unblended_cost} * 0.79 ELSE 0 END ;;
      description: "Total tax amount"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_usage_cost {
      group_label: "Basic Measures > Cost Types"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${is_usage} THEN ${line_item_unblended_cost} * 0.79 ELSE 0 END ;;
      description: "Total usage costs (excluding tax and fees)"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    # Tag-related measures
    measure: total_tagged_cost {
      group_label: "Tag Analytics > Cost Distribution"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${has_tags} THEN ${line_item_unblended_cost} * 0.79 ELSE 0 END ;;
      description: "Total cost for tagged resources"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_untagged_cost {
      group_label: "Tag Analytics > Cost Distribution"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN NOT ${has_tags} THEN ${line_item_unblended_cost} * 0.79 ELSE 0 END ;;
      description: "Total cost for untagged resources"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: tag_coverage_rate {
      group_label: "Tag Analytics > Coverage Metrics"
      type: number
      value_format: "0.00\%"
      sql: (${total_tagged_cost} / NULLIF(${total_unblended_cost}, 0)) * 100 ;;
      description: "Percentage of costs that are tagged"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: count_unique_resources {
      group_label: "Basic Measures > Record Counts"
      type: count_distinct
      value_format: "#,##0"
      sql: ${line_item_resource_id} ;;
      description: "Count of unique resources"
    }

    measure: count_unique_accounts {
      group_label: "Basic Measures > Record Counts"
      type: count_distinct
      value_format: "#,##0"
      sql: ${line_item_usage_account_id} ;;
      description: "Count of unique accounts"
    }

    measure: count_unique_services {
      group_label: "Basic Measures > Record Counts"
      type: count_distinct
      value_format: "#,##0"
      sql: ${line_item_product_code} ;;
      description: "Count of unique AWS services"
    }

    measure: count_environments {
      group_label: "Tag Analytics > Environment Metrics"
      type: count_distinct
      value_format: "#,##0"
      sql: ${environment} ;;
      description: "Count of unique environments"
    }

    measure: count_teams {
      group_label: "Tag Analytics > Team Metrics"
      type: count_distinct
      value_format: "#,##0"
      sql: ${team} ;;
      description: "Count of unique teams"
    }

    measure: count_projects {
      group_label: "Tag Analytics > Project Metrics"
      type: count_distinct
      value_format: "#,##0"
      sql: ${project} ;;
      description: "Count of unique projects"
    }

    # =====================================================
    # ADVANCED COST ANALYSIS MEASURES
    # =====================================================

    measure: average_daily_cost {
      group_label: "Cost Analytics > Time-Based"
      type: number
      value_format: "\"£\"#,##0"
      sql: ${total_unblended_cost} / NULLIF(COUNT(DISTINCT ${line_item_usage_start_date}), 0) ;;
      description: "Average daily cost for the selected period"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: cost_per_resource {
      group_label: "Cost Analytics > Efficiency"
      type: number
      value_format: "\"£\"#,##0"
      sql: ${total_unblended_cost} / NULLIF(${count_unique_resources}, 0) ;;
      description: "Average cost per unique resource"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: cost_variance_pct {
      group_label: "Cost Analytics > Variance"
      type: percent_of_previous
      value_format: "0\%"
      sql: ${total_unblended_cost} ;;
      description: "Percentage of total cost variance"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    # Reservation and Savings Plan measures
    measure: total_ri_cost {
      group_label: "Commitment Discounts > Reserved Instances"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${cost_type} = 'Reserved Instance' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total Reserved Instance cost"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_savings_plan_cost {
      group_label: "Commitment Discounts > Savings Plans"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${cost_type} = 'Savings Plan' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total Savings Plan cost"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_on_demand_cost {
      group_label: "Pricing Models > On-Demand"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${cost_type} = 'On-Demand' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total On-Demand cost"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: total_spot_cost {
      group_label: "Pricing Models > Spot"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${cost_type} = 'Spot Instance' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total Spot Instance cost"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: commitment_savings_rate {
      group_label: "Commitment Discounts > Coverage"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN (${total_ri_cost} + ${total_savings_plan_cost} + ${total_on_demand_cost}) > 0
        THEN ((${total_ri_cost} + ${total_savings_plan_cost}) /
              (${total_ri_cost} + ${total_savings_plan_cost} + ${total_on_demand_cost})) * 100
        ELSE 0
      END ;;
      description: "Percentage of compute costs covered by commitments"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

# Cost efficiency measures - FIX
  measure: cost_per_gb_storage {
    group_label: "Cost Analytics > Unit Costs"
    type: number
    value_format: "\"£\"#,##0.0000" # Use a more appropriate format for unit costs

    sql: |
          CASE
            # Check if the sum of usage for ONLY 'Storage' items is greater than zero
            WHEN COALESCE(SUM(
                   CASE WHEN ${service_category} = 'Storage' THEN ${line_item_usage_amount} ELSE 0 END
                 ), 0) > 0
            THEN
              (COALESCE(SUM(
                CASE WHEN ${service_category} = 'Storage' THEN (${line_item_unblended_cost} * 7.9E-1) ELSE 0 END
              ), 0)
              /
              COALESCE(SUM(
                CASE WHEN ${service_category} = 'Storage' THEN ${line_item_usage_amount} ELSE 0 END
              ), 0))

            ELSE NULL
          END ;;

      description: "Cost per GB for storage services"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
    }

    measure: cost_per_compute_hour {
      group_label: "Cost Analytics > Unit Costs"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${service_category} = 'Compute' AND ${total_usage_amount} > 0
        THEN ${total_unblended_cost} / ${total_usage_amount}
        ELSE NULL
      END ;;
      description: "Cost per compute hour"
      drill_fields: [line_item_usage_account_name, service_category, line_item_product_code]
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
      value_format: "#,##0.0"
      sql:
      (${total_unblended_cost} -
       LAG(${total_unblended_cost}, 12) OVER (ORDER BY ${line_item_usage_start_month})) /
       NULLIF(LAG(${total_unblended_cost}, 12) OVER (ORDER BY ${line_item_usage_start_month}), 0) * 100 ;;
      description: "Year-over-year cost change percentage"
    }

    measure: previous_month_cost {
      group_label: "Cost Analytics > Time-Based"
      type: number
      value_format: "\"£\"#,##0"
      sql: LAG(${total_unblended_cost}, 1) OVER (ORDER BY ${line_item_usage_start_month}) ;;
      description: "Previous month total cost for comparison"
    }

    measure: cost_difference {
      group_label: "Cost Analytics > Time-Based"
      type: number
      value_format: "\"£\"#,##0"
      sql: ${total_unblended_cost} - ${previous_month_cost} ;;
      description: "Absolute cost difference from previous month"
    }

    measure: week_over_week_change {
      group_label: "Cost Analytics > Time-Based"
      type: percent_of_previous
      sql: ${total_unblended_cost} ;;
      value_format: "0.00\%"
      description: "Week-over-week cost change percentage"
    }

    measure: previous_week_cost {
      group_label: "Cost Analytics > Time-Based"
      type: number
      value_format: "\"£\"#,##0"
      sql: LAG(${total_unblended_cost}, 1) OVER (ORDER BY ${line_item_usage_start_week}) ;;
      description: "Previous week total cost for comparison"
    }

    # Service-specific measures
    measure: ec2_cost {
      group_label: "Service Costs > Compute"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} IN ('AmazonEC2', 'Amazon Elastic Compute Cloud') THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total EC2 cost"
    }

    measure: s3_cost {
      group_label: "Service Costs > Storage"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} IN ('AmazonS3', 'Amazon Simple Storage Service') THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total S3 cost"
    }

    measure: rds_cost {
      group_label: "Service Costs > Database"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} = 'AmazonRDS' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total RDS cost"
    }

    measure: lambda_cost {
      group_label: "Service Costs > Serverless"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} = 'AWSLambda' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total Lambda cost"
    }

    # Data transfer measures
    measure: data_transfer_cost {
      group_label: "Service Costs > Networking"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} = 'AWSDataTransfer' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total data transfer cost"
    }

    measure: data_transfer_gb {
      group_label: "Service Usage > Data Transfer"
      type: sum
      value_format: "#,##0.0"
      sql: CASE WHEN ${line_item_product_code} = 'AWSDataTransfer' THEN ${line_item_usage_amount} ELSE 0 END ;;
      description: "Total data transfer in GB"
    }

    # AI/ML cost measures
    measure: sagemaker_cost {
      group_label: "Service Costs > AI/ML"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} = 'AmazonSageMaker' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total SageMaker cost"
    }

    measure: bedrock_cost {
      group_label: "Service Costs > AI/ML"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${line_item_product_code} = 'AmazonBedrock' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total Bedrock cost"
    }

    # Top cost contributors
    measure: top_10_services_cost {
      group_label: "Service Analysis > Top Contributors"
      type: sum
      value_format: "\"£\"#,##0"
      sql: ${line_item_unblended_cost} ;;
      filters: [line_item_product_code: "AmazonEC2,AmazonS3,AmazonRDS,AWSLambda,AmazonCloudFront,AmazonVPC,AmazonEBS,AmazonDynamoDB,AmazonRedshift,AmazonEKS"]
      description: "Cost for top 10 services by usage"
    }

    # Forecast measures (for trending analysis)
    # measure: projected_monthly_cost {
    #   group_label: "Forecasting > Short-Term"
    #   type: number
    #   value_format: "\"£\"#,##0"
    #   sql:
    #   CASE
    #     WHEN EXTRACT(DAY FROM CURRENT_DATE) > 0
    #     THEN (${total_unblended_cost} / EXTRACT(DAY FROM CURRENT_DATE)) *
    #         EXTRACT(DAY FROM LAST_DAY(CURRENT_DATE))
    #     ELSE ${total_unblended_cost}
    #   END ;;
    #   description: "Projected cost for current month based on daily average"
    # }

    # Cost anomaly detection helpers
    measure: cost_z_score {
      group_label: "Anomaly Detection > Statistical"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      (${total_unblended_cost} - AVG(${total_unblended_cost}) OVER()) /
      NULLIF(STDDEV(${total_unblended_cost}) OVER(), 0) ;;
      description: "Z-score for cost anomaly detection"
    }

    measure: is_cost_anomaly {
      group_label: "Anomaly Detection > Flags"
      type: yesno
      value_format: "\"£\"#,##0"
      sql: ABS(${cost_z_score}) > 2 ;;
      description: "Whether cost is an anomaly (2+ standard deviations)"
    }

    # Regional cost distribution
    measure: us_east_1_cost {
      group_label: "Regional Analysis > US Regions"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${product_region_code} = 'us-east-1' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost in US East 1 region"
    }

    measure: us_west_2_cost {
      group_label: "Regional Analysis > US Regions"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${product_region_code} = 'us-west-2' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost in US West 2 region"
    }

    measure: eu_west_1_cost {
      group_label: "Regional Analysis > EU Regions"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${product_region_code} = 'eu-west-1' THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost in EU West 1 region"
    }

    # =====================================================
    # COST ALLOCATION AND CHARGEBACK MEASURES
    # =====================================================

    measure: environment_production_cost {
      group_label: "Environment Analysis > Production"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN LOWER(${environment}) IN ('prod', 'production', 'prd') THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost for production environments"
    }

    measure: environment_development_cost {
      group_label: "Environment Analysis > Non-Production"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN LOWER(${environment}) IN ('dev', 'development', 'develop') THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost for development environments"
    }

    measure: environment_staging_cost {
      group_label: "Environment Analysis > Non-Production"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN LOWER(${environment}) IN ('stage', 'staging', 'stg') THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost for staging environments"
    }

    measure: environment_test_cost {
      group_label: "Environment Analysis > Non-Production"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN LOWER(${environment}) IN ('test', 'testing', 'qa') THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost for test environments"
    }

    # Team-based cost allocation
    measure: team_cost_allocation {
      group_label: "Chargeback > Team Allocation"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${team} IS NOT NULL THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost allocated to teams"
    }

    measure: unallocated_team_cost {
      group_label: "Chargeback > Unallocated"
      type: sum
      value_format: "\"£\"#,##0"
      sql: CASE WHEN ${team} IS NULL THEN ${line_item_unblended_cost} ELSE 0 END ;;
      description: "Total cost not allocated to any team"
    }

    # =====================================================
    # SUSTAINABILITY AND CARBON METRICS
    # =====================================================

    measure: estimated_carbon_impact {
      group_label: "Sustainability > Carbon Impact"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${service_category} = 'Compute' THEN ${total_usage_amount} * 0.5
        WHEN ${service_category} = 'Storage' THEN ${total_usage_amount} * 0.1
        WHEN ${service_category} = 'Database' THEN ${total_usage_amount} * 0.3
        ELSE ${total_usage_amount} * 0.2
      END ;;
      description: "Estimated carbon impact (kg CO2) - rough calculation"
    }

    measure: carbon_efficiency_score {
      group_label: "Sustainability > Efficiency"
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${total_unblended_cost} > 0
        THEN ${estimated_carbon_impact} / ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "Carbon efficiency (kg CO2 per dollar)"
    }

    # =====================================================
    # ADVANCED FINOPS MEASURES
    # =====================================================

    measure: waste_detection_score {
      group_label: "FinOps > Waste Management"
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${right_sizing_opportunity} = 0 AND ${total_untagged_cost} = 0 THEN 100
        WHEN ${right_sizing_opportunity} / NULLIF(${total_unblended_cost}, 0) < 0.05 AND ${total_untagged_cost} / NULLIF(${total_unblended_cost}, 0) < 0.1 THEN 80
        WHEN ${right_sizing_opportunity} / NULLIF(${total_unblended_cost}, 0) < 0.1 AND ${total_untagged_cost} / NULLIF(${total_unblended_cost}, 0) < 0.2 THEN 60
        WHEN ${right_sizing_opportunity} / NULLIF(${total_unblended_cost}, 0) < 0.2 AND ${total_untagged_cost} / NULLIF(${total_unblended_cost}, 0) < 0.3 THEN 40
        ELSE 20
      END ;;
      description: "Waste detection score based on right-sizing opportunities and untagged resources"
    }

    measure: finops_maturity_score {
      group_label: "FinOps > Maturity Assessment"
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${tag_coverage_rate} >= 80 AND ${commitment_savings_rate} >= 60 AND ${waste_detection_score} >= 70 THEN 90
        WHEN ${tag_coverage_rate} >= 60 AND ${commitment_savings_rate} >= 40 AND ${waste_detection_score} >= 50 THEN 70
        WHEN ${tag_coverage_rate} >= 40 AND ${commitment_savings_rate} >= 20 AND ${waste_detection_score} >= 30 THEN 50
        ELSE 30
      END ;;
      description: "FinOps maturity score based on tagging, commitments, and waste detection"
    }

    measure: cost_anomaly_score {
      group_label: "FinOps > Anomaly Detection"
      type: number
      value_format: "\"£\"#,##0"
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
      description: "Cost anomaly detection score (0-100)"
    }

    measure: right_sizing_opportunity {
      group_label: "FinOps > Optimization Opportunities"
      type: number
      value_format: "#,##0.0"
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
      description: "Potential savings from right-sizing based on usage patterns"
    }

    measure: optimization_score {
      group_label: "FinOps > Overall Scores"
      type: number
      value_format: "#,##0"
      sql:
      (CASE WHEN ${commitment_savings_rate} >= 70 THEN 25 ELSE ${commitment_savings_rate} * 0.357 END) +
      (CASE WHEN ${tag_coverage_rate} >= 90 THEN 20 ELSE ${tag_coverage_rate} * 0.222 END) +
      (CASE WHEN ${waste_detection_score} >= 80 THEN 25 ELSE ${waste_detection_score} * 0.3125 END) +
      (CASE WHEN ${right_sizing_opportunity} = 0 THEN 30 ELSE GREATEST(0, 30 - (${right_sizing_opportunity} / ${total_unblended_cost} * 100)) END) ;;
      description: "Overall optimization score (0-100)"
    }

    measure: unit_cost_trend {
      type: number
      value_format: "\"£\"#,##0"
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
      description: "Unit cost change percentage period over period"
    }

    # =====================================================
    # GAMIFICATION MEASURES
    # =====================================================

    measure: cost_hero_points {
      group_label: "Gamification > Achievement Points"
      type: number
      value_format: "\"£\"#,##0"
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
      description: "Gamification points for cost optimization achievements"
    }

    measure: sustainability_champion_score {
      type: number
      value_format: "#,##0"
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
      description: "Sustainability champion score based on carbon efficiency"
    }

    measure: waste_warrior_achievements {
      type: number
      value_format: "#,##0.0"
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
      description: "Waste warrior achievement points for eliminating waste"
    }

    measure: team_collaboration_score {
      type: number
      value_format: "#,##0.0"
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
      description: "Team collaboration score based on multi-team tagging discipline"
    }

    measure: level_progress {
      type: number
      value_format: "#,##0.0"
      sql: (${cost_hero_points} + ${sustainability_champion_score} + ${waste_warrior_achievements}) / 50 ;;
      description: "Overall level progress in cost optimization gamification"
    }

# =====================================================
# FORECASTING MEASURES (ATHENA-COMPATIBLE)
# =====================================================

# 7-Day Trend Forecast - Simple moving average approach
  measure: trend_forecast_7d {
    type: number
    sql:
    CASE
      WHEN COUNT(DISTINCT ${line_item_usage_start_date}) >= 7
      THEN (${total_unblended_cost} / NULLIF(COUNT(DISTINCT ${line_item_usage_start_date}), 0)) * 30
      ELSE NULL
    END ;;
    label: "7-Day Trend Forecast"
    value_format_name: usd
    description: "30-day projection based on daily average from last 7 days"
  }

# 30-Day Seasonal Forecast - Day of week pattern
  measure: seasonal_forecast_30d {
    type: number
    sql:
    CASE
      WHEN COUNT(DISTINCT ${line_item_usage_start_date}) >= 14
      THEN (${total_unblended_cost} / NULLIF(COUNT(DISTINCT ${line_item_usage_start_date}), 0)) * 30
      ELSE NULL
    END ;;
    label: "30-Day Seasonal Forecast"
    value_format_name: usd
    description: "30-day projection considering day-of-week patterns"
  }

# 90-Day Growth Forecast
  measure: growth_forecast_90d {
    type: number
    sql:
    CASE
      WHEN COUNT(DISTINCT ${line_item_usage_start_date}) >= 30
      THEN (${total_unblended_cost} / NULLIF(COUNT(DISTINCT ${line_item_usage_start_date}), 0)) * 30
      ELSE NULL
    END ;;
    label: "90-Day Growth Forecast"
    value_format_name: usd
    description: "30-day projection based on 90-day growth trend"
  }

# Usage Pattern Forecast
  measure: usage_pattern_forecast {
    type: number
    sql:
    CASE
      WHEN ${total_usage_amount} > 0 AND COUNT(DISTINCT ${line_item_usage_start_date}) >= 7
      THEN ((${total_unblended_cost} / NULLIF(${total_usage_amount}, 0)) *
            (${total_usage_amount} / NULLIF(COUNT(DISTINCT ${line_item_usage_start_date}), 0))) * 30
      ELSE NULL
    END ;;
    label: "Usage Pattern Forecast"
    value_format_name: usd
    description: "Pattern-based 30-day projection using usage metrics"
  }

# Projected Monthly Cost (Simple MTD extrapolation)
  measure: projected_monthly_cost {
    type: number
    sql:
    CASE
      WHEN EXTRACT(DAY FROM CURRENT_DATE) = 1 THEN 0
      ELSE (
        ${total_unblended_cost} *
        (EXTRACT(DAY FROM LAST_DAY_OF_MONTH(CURRENT_DATE)) /
         NULLIF(EXTRACT(DAY FROM CURRENT_DATE), 0))
      )
    END ;;
    label: "Projected Monthly Cost"
    value_format_name: usd
    description: "Month-end projection based on current MTD spending"
  }

# Budget Burn Rate (Same as projected monthly)
  measure: budget_burn_rate {
    type: number
    sql:
    CASE
      WHEN EXTRACT(DAY FROM CURRENT_DATE) = 1 THEN 0
      ELSE (
        ${total_unblended_cost} *
        (EXTRACT(DAY FROM LAST_DAY_OF_MONTH(CURRENT_DATE)) /
         NULLIF(EXTRACT(DAY FROM CURRENT_DATE), 0))
      )
    END ;;
    label: "Budget Burn Rate"
    value_format_name: usd
    description: "Projected month-end spend at current burn rate"
  }

    # =====================================================
    # DATA OPERATIONS MONITORING
    # =====================================================

    measure: data_freshness_hours {
      group_label: "Data Quality > Freshness"
      type: number
      value_format: "#,##0.0"
      sql: EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(${line_item_usage_start_raw}))) / 3600 ;;
      description: "Hours since latest data in the dataset"
    }

    measure: data_completeness_score {
      type: number
      value_format: "#,##0"
      sql:
      (CASE WHEN COUNT(${cur2_line_item_pk}) > 0 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_unblended_cost} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 95 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_usage_account_id} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 98 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_product_code} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 98 THEN 20 ELSE 0 END) +
      (CASE WHEN COUNT(CASE WHEN ${line_item_usage_start_date} IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) >= 99 THEN 20 ELSE 0 END) ;;
      description: "Data completeness score (0-100) based on key field availability"
    }

    measure: data_quality_alerts {
      type: count
      value_format: "#,##0"
      filters: [line_item_unblended_cost: "<0"]
      description: "Count of data quality issues (negative costs, etc.)"
    }

    measure: duplicate_detection_count {
      type: count
      value_format: "#,##0"
      filters: [cur2_line_item_pk: ">1"]
      description: "Count of potential duplicate records"
    }

    measure: processing_lag_hours {
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN MAX(${line_item_usage_end_raw}) IS NOT NULL
        THEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - MAX(${line_item_usage_end_raw}))) / 3600
        ELSE NULL
      END ;;
      description: "Processing lag in hours from usage end to current time"
    }

    measure: cost_variance_coefficient {
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN AVG(${total_unblended_cost}) > 0 AND COUNT(*) > 1
        THEN STDDEV(${total_unblended_cost}) / NULLIF(AVG(${total_unblended_cost}), 0)
        ELSE 0
      END ;;
      description: "Coefficient of variation for cost data quality assessment"
    }

    measure: ingestion_health_score {
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${data_freshness_hours} <= 6 AND ${data_completeness_score} >= 80 AND ${data_quality_alerts} = 0 THEN 100
        WHEN ${data_freshness_hours} <= 12 AND ${data_completeness_score} >= 70 AND ${data_quality_alerts} <= 5 THEN 80
        WHEN ${data_freshness_hours} <= 24 AND ${data_completeness_score} >= 60 AND ${data_quality_alerts} <= 20 THEN 60
        ELSE 40
      END ;;
      description: "Overall data ingestion health score (40-100)"
    }

    # =====================================================
    # RESOURCE EFFICIENCY MEASURES
    # =====================================================

    measure: resource_efficiency_score {
      type: number
      value_format: "#,##0"
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
      description: "Resource efficiency score based on usage patterns and pricing models"
    }

    measure: savings_vs_on_demand {
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${cost_type} IN ('Reserved Instance', 'Savings Plan') THEN
          (${pricing_public_on_demand_cost} - ${total_unblended_cost})
        WHEN ${cost_type} = 'Spot Instance' THEN
          (${pricing_public_on_demand_cost} - ${total_unblended_cost})
        ELSE 0
      END ;;
      description: "Savings compared to On-Demand pricing"
    }

    measure: savings_percentage {
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${pricing_public_on_demand_cost} > 0 AND ${cost_type} IN ('Reserved Instance', 'Savings Plan', 'Spot Instance')
        THEN ((${pricing_public_on_demand_cost} - ${total_unblended_cost}) / ${pricing_public_on_demand_cost}) * 100
        ELSE 0
      END ;;
      description: "Percentage savings vs On-Demand pricing"
    }

    # =====================================================
    # SUSTAINABILITY AND CARBON FOOTPRINT MEASURES
    # =====================================================

    measure: estimated_carbon_emissions_kg {
      group_label: "Sustainability > Carbon Footprint"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${line_item_product_code} = 'Amazon Elastic Compute Cloud' THEN
          CASE
            WHEN ${product_region_code} IN ('us-east-1', 'us-west-2') THEN ${total_usage_amount} * 0.0001821  -- Lower carbon intensity
            WHEN ${product_region_code} IN ('eu-west-1', 'eu-central-1') THEN ${total_usage_amount} * 0.0001205  -- EU green energy
            WHEN ${product_region_code} IN ('ap-southeast-1', 'ap-northeast-1') THEN ${total_usage_amount} * 0.0003567  -- Higher carbon intensity
            ELSE ${total_usage_amount} * 0.0002500  -- Global average
          END
        WHEN ${line_item_product_code} = 'Amazon Simple Storage Service' THEN
          ${total_usage_amount} * 0.0000156  -- Storage carbon footprint per GB
        WHEN ${line_item_product_code} = 'Amazon Relational Database Service' THEN
          ${total_usage_amount} * 0.0001456  -- Database carbon footprint
        WHEN ${line_item_product_code} LIKE '%Lambda%' THEN
          ${total_usage_amount} * 0.0000089  -- Serverless efficiency
        WHEN ${service_category} = 'Compute' THEN
          ${total_usage_amount} * 0.0002200  -- General compute
        WHEN ${service_category} = 'Storage' THEN
          ${total_usage_amount} * 0.0000125  -- General storage
        ELSE
          ${total_usage_amount} * 0.0001500  -- Other services
      END ;;
      description: "Estimated carbon emissions in kilograms based on AWS service usage"
    }

    measure: carbon_intensity_score {
      group_label: "Sustainability > Carbon Footprint"
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${estimated_carbon_emissions_kg} = 0 OR ${total_unblended_cost} = 0 THEN 0
        ELSE (${estimated_carbon_emissions_kg} / ${total_unblended_cost}) * 1000  -- kg CO2 per $1000 spent
      END ;;
      description: "Carbon intensity score (kg CO2 per $1000 spent)"
    }

    measure: sustainability_score {
      group_label: "Sustainability > Performance"
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${cost_type} = 'Spot Instance' THEN 90  -- Most efficient
        WHEN ${cost_type} IN ('Reserved Instance', 'Savings Plan') THEN 80  -- Good efficiency
        WHEN ${product_region_code} IN ('us-west-2', 'eu-west-1', 'eu-central-1') THEN 75  -- Green regions
        WHEN ${line_item_product_code} LIKE '%Lambda%' OR ${line_item_product_code} LIKE '%Fargate%' THEN 85  -- Serverless efficiency
        WHEN ${line_item_usage_type} LIKE '%IA%' OR ${line_item_usage_type} LIKE '%Glacier%' THEN 80  -- Efficient storage
        WHEN ${resource_efficiency_score} >= 80 THEN 70  -- High efficiency
        WHEN ${resource_efficiency_score} >= 60 THEN 60  -- Medium efficiency
        ELSE 40  -- Low efficiency
      END ;;
      description: "Overall sustainability score (0-100) based on efficiency and green practices"
    }

    measure: renewable_energy_percentage {
      group_label: "Sustainability > Green Energy"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${product_region_code} IN ('us-west-2', 'eu-west-1', 'eu-central-1', 'eu-north-1') THEN 85.0  -- High renewable regions
        WHEN ${product_region_code} IN ('us-east-1', 'us-west-1', 'ca-central-1') THEN 65.0  -- Medium renewable
        WHEN ${product_region_code} IN ('ap-southeast-2', 'eu-west-2') THEN 55.0  -- Growing renewable
        ELSE 30.0  -- Lower renewable percentage
      END ;;
      description: "Estimated percentage of renewable energy used in AWS region"
    }

    measure: carbon_reduction_potential_kg {
      group_label: "Sustainability > Optimization"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${cost_type} = 'On-Demand' AND ${service_category} = 'Compute' THEN
          ${estimated_carbon_emissions_kg} * 0.20  -- 20% reduction via Spot/Reserved
        WHEN ${product_region_code} NOT IN ('us-west-2', 'eu-west-1', 'eu-central-1') THEN
          ${estimated_carbon_emissions_kg} * 0.30  -- 30% reduction via region migration
        WHEN ${line_item_usage_type} LIKE '%Standard%' AND ${service_category} = 'Storage' THEN
          ${estimated_carbon_emissions_kg} * 0.15  -- 15% reduction via lifecycle management
        WHEN ${sustainability_score} < 60 THEN
          ${estimated_carbon_emissions_kg} * 0.25  -- 25% reduction potential
        ELSE
          ${estimated_carbon_emissions_kg} * 0.05  -- 5% optimization potential
      END ;;
      description: "Estimated carbon reduction potential in kg through optimization"
    }

    measure: esg_compliance_score {
      group_label: "Sustainability > Compliance"
      type: number
      value_format: "#,##0"
      sql:
      (
        CASE WHEN ${sustainability_score} >= 80 THEN 25
             WHEN ${sustainability_score} >= 60 THEN 20
             WHEN ${sustainability_score} >= 40 THEN 15
             ELSE 10 END +
        CASE WHEN ${renewable_energy_percentage} >= 80 THEN 25
             WHEN ${renewable_energy_percentage} >= 60 THEN 20
             WHEN ${renewable_energy_percentage} >= 40 THEN 15
             ELSE 10 END +
        CASE WHEN ${carbon_intensity_score} <= 50 THEN 25
             WHEN ${carbon_intensity_score} <= 100 THEN 20
             WHEN ${carbon_intensity_score} <= 200 THEN 15
             ELSE 10 END +
        CASE WHEN ${savings_percentage} >= 30 THEN 25
             WHEN ${savings_percentage} >= 20 THEN 20
             WHEN ${savings_percentage} >= 10 THEN 15
             ELSE 10 END
      ) ;;
      description: "ESG compliance score (0-100) based on sustainability, renewable energy, carbon intensity, and cost efficiency"
    }

    dimension: sustainability_recommendation {
      group_label: "Sustainability > Recommendations"
      type: string
      description: "AI-driven sustainability recommendations based on carbon footprint analysis"
      sql:
      CASE
        WHEN ${pricing_term} = 'OnDemand' AND ${service_category} = 'Compute'
        THEN 'Consider Spot Instances or Reserved Instances to reduce carbon footprint and costs'
        WHEN ${product_region_code} NOT IN ('us-west-2', 'eu-west-1', 'eu-central-1', 'eu-north-1')
        THEN 'Migrate to regions with higher renewable energy percentage for better sustainability'
        WHEN ${line_item_usage_type} LIKE '%Standard%' AND ${service_category} = 'Storage'
        THEN 'Implement storage lifecycle policies for Intelligent Tiering or Glacier transitions'
        ELSE 'Well-optimized for sustainability - monitor for continuous improvement'
      END ;;
    }

    measure: carbon_cost_efficiency {
      group_label: "Sustainability > Performance"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${estimated_carbon_emissions_kg} > 0
        THEN ${total_unblended_cost} / ${estimated_carbon_emissions_kg}
        ELSE NULL
      END ;;
      description: "Cost efficiency per kg of carbon emissions ($ per kg CO2)"
    }

    measure: green_computing_adoption_rate {
      group_label: "Sustainability > Adoption"
      type: number
      value_format: "#,##0.0"
      sql:
      100.0 * SUM(
        CASE
          WHEN ${cost_type} IN ('Spot Instance', 'Reserved Instance', 'Savings Plan')
            OR ${line_item_product_code} LIKE '%Lambda%'
            OR ${line_item_product_code} LIKE '%Fargate%'
            OR ${line_item_usage_type} LIKE '%IA%'
            OR ${line_item_usage_type} LIKE '%Glacier%'
          THEN ${total_unblended_cost}
          ELSE 0
        END
      ) / NULLIF(SUM(${total_unblended_cost}), 0) ;;
      description: "Percentage of costs using green computing practices (efficient pricing, serverless, storage tiers)"
    }

    # =====================================================
    # DATA TRANSFER AND NETWORK OPTIMIZATION MEASURES
    # =====================================================

    dimension: data_transfer_type {
      group_label: "Network > Transfer Types"
      type: string
      description: "Type classification for data transfer"
      sql:
      CASE
        WHEN ${line_item_usage_type} LIKE '%DataTransfer-Out-Bytes%' OR ${line_item_usage_type} LIKE '%DataTransfer-Regional-Bytes%' THEN 'Internet Egress'
        WHEN ${line_item_usage_type} LIKE '%DataTransfer-In%' THEN 'Internet Ingress'
        WHEN ${line_item_usage_type} LIKE '%Inter-Region%' OR ${line_item_usage_type} LIKE '%CrossRegion%' THEN 'Inter-Region'
        WHEN ${line_item_usage_type} LIKE '%Inter-AZ%' OR ${line_item_usage_type} LIKE '%CrossAZ%' THEN 'Inter-AZ'
        WHEN ${line_item_product_code} = 'Amazon CloudFront' THEN 'CloudFront'
        WHEN ${line_item_usage_type} LIKE '%VPC%' THEN 'VPC Endpoint'
        WHEN ${line_item_usage_type} LIKE '%NAT%' THEN 'NAT Gateway'
        WHEN ${line_item_usage_type} LIKE '%LoadBalancing%' THEN 'Load Balancer'
        ELSE 'Other Network'
      END ;;
    }

    dimension: destination_region {
      group_label: "Network > Geography"
      type: string
      description: "Geographic region information"
      sql:
      CASE
        WHEN ${line_item_usage_type} LIKE '%to-US-East%' THEN 'us-east-1'
        WHEN ${line_item_usage_type} LIKE '%to-US-West%' THEN 'us-west-2'
        WHEN ${line_item_usage_type} LIKE '%to-EU%' THEN 'eu-west-1'
        WHEN ${line_item_usage_type} LIKE '%to-AP%' THEN 'ap-southeast-1'
        WHEN ${line_item_usage_type} LIKE '%External%' OR ${line_item_usage_type} LIKE '%Internet%' THEN 'Internet'
        ELSE 'Unknown'
      END ;;
    }

    measure: total_data_transfer_cost {
      group_label: "Network > Core Metrics"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} IN ('Internet Egress', 'Inter-Region', 'Inter-AZ', 'CloudFront', 'VPC Endpoint', 'NAT Gateway', 'Load Balancer')
        THEN ${line_item_unblended_cost}
        ELSE 0
      END ;;
      description: "Total cost for all data transfer and network operations"
    }

    measure: total_data_transfer_gb {
      group_label: "Network > Core Metrics"
      type: sum
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${data_transfer_type} IN ('Internet Egress', 'Inter-Region', 'Inter-AZ', 'CloudFront') AND ${line_item_usage_type} LIKE '%Bytes%'
        THEN ${line_item_usage_amount} / 1073741824  -- Convert bytes to GB
        WHEN ${data_transfer_type} IN ('Internet Egress', 'Inter-Region', 'Inter-AZ', 'CloudFront') AND ${line_item_usage_type} LIKE '%GB%'
        THEN ${line_item_usage_amount}
        ELSE 0
      END ;;
      description: "Total data transfer volume in gigabytes"
    }

    measure: data_transfer_cost_per_gb {
      group_label: "Network > Efficiency Metrics"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${total_data_transfer_gb} > 0
        THEN ${total_data_transfer_cost} / NULLIF(${total_data_transfer_gb}, 0)
        ELSE NULL
      END ;;
      description: "Average cost per GB of data transfer"
    }

    measure: internet_egress_cost {
      group_label: "Network > Transfer Types"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} = 'Internet Egress'
        THEN ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "Cost of internet egress data transfer"
    }

    measure: inter_region_cost {
      group_label: "Network > Transfer Types"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} = 'Inter-Region'
        THEN ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "Cost of inter-region data transfer"
    }

    measure: cloudfront_cost {
      group_label: "Network > CDN"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} = 'CloudFront'
        THEN ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "CloudFront CDN costs"
    }

    measure: cdn_optimization_percentage {
      group_label: "Network > CDN"
      type: number
      value_format: "#,##0.0"
      sql:
      100.0 * SAFE_DIVIDE(
        ${cloudfront_cost},
        ${cloudfront_cost} + ${internet_egress_cost}
      ) ;;
      description: "Percentage of content delivery using CloudFront vs direct egress"
    }

    measure: transfer_optimization_savings {
      group_label: "Network > Optimization"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        -- CloudFront savings vs direct egress
        WHEN ${internet_egress_cost} > ${cloudfront_cost} * 1.5 THEN
          ${internet_egress_cost} * 0.30  -- 30% potential savings
        -- Inter-region optimization
        WHEN ${inter_region_cost} > 1000 THEN
          ${inter_region_cost} * 0.25  -- 25% savings via architecture optimization
        -- General network optimization
        WHEN ${total_data_transfer_cost} > 500 THEN
          ${total_data_transfer_cost} * 0.15  -- 15% general optimization
        ELSE
          ${total_data_transfer_cost} * 0.05  -- 5% basic optimization
      END ;;
      description: "Estimated monthly savings from data transfer optimization"
    }

    measure: nat_gateway_cost {
      group_label: "Network > Infrastructure"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} = 'NAT Gateway'
        THEN ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "NAT Gateway costs including data processing"
    }

    measure: vpc_endpoint_cost {
      group_label: "Network > Infrastructure"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} = 'VPC Endpoint'
        THEN ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "VPC Endpoint costs"
    }

    measure: load_balancer_cost {
      group_label: "Network > Infrastructure"
      type: sum
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${data_transfer_type} = 'Load Balancer'
        THEN ${total_unblended_cost}
        ELSE 0
      END ;;
      description: "Load Balancer costs including data processing"
    }

    measure: bandwidth_utilization_score {
      group_label: "Network > Efficiency"
      type: number
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${total_data_transfer_gb} > 0 AND ${total_data_transfer_cost} > 0 THEN
          CASE
            WHEN ${data_transfer_cost_per_gb} <= 0.05 THEN 95  -- Excellent efficiency
            WHEN ${data_transfer_cost_per_gb} <= 0.10 THEN 80  -- Good efficiency
            WHEN ${data_transfer_cost_per_gb} <= 0.15 THEN 65  -- Average efficiency
            WHEN ${data_transfer_cost_per_gb} <= 0.20 THEN 50  -- Below average
            ELSE 30  -- Poor efficiency
          END
        ELSE 0
      END ;;
      description: "Bandwidth utilization efficiency score (0-100) based on cost per GB"
    }

    measure: peak_bandwidth_usage {
      group_label: "Network > Usage Patterns"
      type: max
      sql: ${total_data_transfer_gb} ;;
      value_format: "#,##0.0"
      description: "Peak bandwidth usage in GB for the period"
    }

    measure: average_bandwidth_usage {
      group_label: "Network > Usage Patterns"
      type: average
      value_format: "#,##0.0"
      sql: ${total_data_transfer_gb} ;;
      description: "Average bandwidth usage in GB for the period"
    }

    measure: bandwidth_optimization_potential {
      group_label: "Network > Optimization"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${peak_bandwidth_usage} > 0 AND ${average_bandwidth_usage} > 0 THEN
          (${peak_bandwidth_usage} - ${average_bandwidth_usage}) / ${peak_bandwidth_usage} * 100
        ELSE 0
      END ;;
      description: "Bandwidth optimization potential percentage based on peak vs average usage"
    }

    dimension: data_transfer_recommendation {
      group_label: "Network > Recommendations"
      type: string
      description: "AI-driven recommendations for data transfer cost optimization"
      sql:
      CASE
        WHEN ${product_product_family} = 'Data Transfer' AND ${line_item_unblended_cost} > 500
        THEN 'High data transfer costs detected - review architecture and consider optimization'
        WHEN ${product_to_location} != ${product_from_location} AND ${line_item_unblended_cost} > 100
        THEN 'Cross-region data transfer detected - evaluate data placement strategies'
        WHEN ${line_item_product_code} = 'AmazonCloudFront' AND ${line_item_unblended_cost} < 50
        THEN 'Consider expanding CloudFront CDN usage for cost optimization'
        ELSE 'Network costs appear optimized - monitor for efficiency improvements'
      END ;;
    }

    measure: network_efficiency_score {
      group_label: "Network > Overall Performance"
      type: number
      value_format: "#,##0"
      sql:
      (
        CASE WHEN ${cdn_optimization_percentage} >= 70 THEN 25
             WHEN ${cdn_optimization_percentage} >= 50 THEN 20
             WHEN ${cdn_optimization_percentage} >= 30 THEN 15
             ELSE 10 END +
        CASE WHEN ${data_transfer_cost_per_gb} <= 0.05 THEN 25
             WHEN ${data_transfer_cost_per_gb} <= 0.10 THEN 20
             WHEN ${data_transfer_cost_per_gb} <= 0.15 THEN 15
             ELSE 10 END +
        CASE WHEN ${bandwidth_utilization_score} >= 80 THEN 25
             WHEN ${bandwidth_utilization_score} >= 60 THEN 20
             WHEN ${bandwidth_utilization_score} >= 40 THEN 15
             ELSE 10 END +
        CASE WHEN ${transfer_optimization_savings} / NULLIF(${total_data_transfer_cost}, 0) <= 0.10 THEN 25
             WHEN ${transfer_optimization_savings} / NULLIF(${total_data_transfer_cost}, 0) <= 0.20 THEN 20
             WHEN ${transfer_optimization_savings} / NULLIF(${total_data_transfer_cost}, 0) <= 0.30 THEN 15
             ELSE 10 END
      ) ;;
      description: "Overall network efficiency score (0-100) based on CDN usage, cost efficiency, bandwidth utilization, and optimization potential"
    }

    # =====================================================
    # FINOPS AUTOMATION AND WORKFLOW MEASURES
    # =====================================================

    dimension: automation_type {
      group_label: "FinOps Automation > Types"
      type: string
      description: "Type classification for automation"
      sql:
      CASE
        WHEN ${cost_center} IS NOT NULL AND ${environment} IS NOT NULL THEN 'Tagging Enforcement'
        WHEN ${cost_type} IN ('Reserved Instance', 'Savings Plan') THEN 'Cost Controls'
        WHEN ${line_item_usage_type} LIKE '%Spot%' THEN 'Resource Management'
        WHEN ${line_item_usage_type} LIKE '%Lifecycle%' OR ${line_item_usage_type} LIKE '%IA%' OR ${line_item_usage_type} LIKE '%Glacier%' THEN 'Lifecycle Management'
        WHEN ${line_item_product_code} IN ('AWS Config', 'AWS CloudTrail', 'Amazon GuardDuty') THEN 'Security Policies'
        WHEN ${line_item_product_code} IN ('AWS Lambda', 'Amazon EventBridge') THEN 'Event-Driven Automation'
        ELSE 'Manual Operations'
      END ;;
    }

    dimension: policy_compliance_status {
      group_label: "FinOps Automation > Compliance"
      type: string
      description: "Current status of policy compliance"
      sql:
      CASE
        WHEN ${cost_center} IS NOT NULL
          AND ${environment} IS NOT NULL
          AND ${project} IS NOT NULL THEN 'Fully Compliant'
        WHEN ${cost_center} IS NOT NULL
          AND ${environment} IS NOT NULL THEN 'Partially Compliant'
        WHEN ${cost_center} IS NOT NULL
          OR ${environment} IS NOT NULL THEN 'Minimally Compliant'
        ELSE 'Non-Compliant'
      END ;;
    }

    dimension: policy_type {
      group_label: "FinOps Automation > Policy Types"
      type: string
      description: "Type classification for policy"
      sql:
      CASE
        WHEN ${cost_center} IS NULL OR ${environment} IS NULL THEN 'Tagging Policy'
        WHEN ${cost_type} = 'On-Demand' AND ${service_category} = 'Compute' AND ${total_unblended_cost} > 100 THEN 'Cost Control Policy'
        WHEN ${line_item_usage_type} NOT LIKE '%Spot%' AND ${service_category} = 'Compute' AND ${total_unblended_cost} > 50 THEN 'Resource Efficiency Policy'
        WHEN ${line_item_usage_type} LIKE '%Standard%' AND ${service_category} = 'Storage' AND ${total_unblended_cost} > 25 THEN 'Storage Lifecycle Policy'
        WHEN ${product_region_code} NOT IN ('us-east-1', 'us-west-2', 'eu-west-1') AND ${total_unblended_cost} > 10 THEN 'Region Policy'
        ELSE 'General Governance'
      END ;;
    }

    dimension: violation_severity {
      group_label: "FinOps Automation > Violations"
      type: string
      description: "Dimension for violation severity"
      sql:
      CASE
        WHEN ${policy_compliance_status} = 'Non-Compliant' AND ${total_unblended_cost} > 1000 THEN 'Critical'
        WHEN ${policy_compliance_status} = 'Non-Compliant' AND ${total_unblended_cost} > 100 THEN 'High'
        WHEN ${policy_compliance_status} = 'Minimally Compliant' AND ${total_unblended_cost} > 500 THEN 'Medium'
        WHEN ${policy_compliance_status} IN ('Minimally Compliant', 'Partially Compliant') THEN 'Low'
        ELSE 'None'
      END ;;
    }

    measure: automation_coverage_percentage {
      group_label: "FinOps Automation > Coverage"
      type: number
      value_format: "#,##0.0\%"
      sql:
      100.0 * SUM(
        CASE
          WHEN ${automation_type} != 'Manual Operations'
          THEN ${total_unblended_cost}
          ELSE 0
        END
      ) / NULLIF(SUM(${total_unblended_cost}), 0) ;;
      description: "Percentage of costs covered by automated FinOps processes"
    }

    measure: policy_compliance_rate {
      group_label: "FinOps Automation > Compliance"
      type: number
      value_format: "#,##0.0"
      sql:
      100.0 * SUM(
        CASE
          WHEN ${policy_compliance_status} IN ('Fully Compliant', 'Partially Compliant')
          THEN ${total_unblended_cost}
          ELSE 0
        END
      ) / NULLIF(SUM(${total_unblended_cost}), 0) ;;
      description: "Percentage of costs from resources that meet policy compliance requirements"
    }

    measure: automated_actions_count {
      group_label: "FinOps Automation > Actions"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${automation_type} != 'Manual Operations'
        THEN ${cur2_line_item_pk}
        ELSE NULL
      END ;;
      description: "Count of automated actions performed across resources"
    }

    measure: successful_actions_count {
      group_label: "FinOps Automation > Actions"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${automation_type} != 'Manual Operations' AND ${policy_compliance_status} IN ('Fully Compliant', 'Partially Compliant')
        THEN ${cur2_line_item_pk}
        ELSE NULL
      END ;;
      description: "Count of successful automated actions"
    }

    measure: failed_actions_count {
      group_label: "FinOps Automation > Actions"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${automation_type} != 'Manual Operations' AND ${policy_compliance_status} = 'Non-Compliant'
        THEN ${cur2_line_item_pk}
        ELSE NULL
      END ;;
      description: "Count of failed automated actions requiring manual intervention"
    }

    measure: automation_success_rate {
      group_label: "FinOps Automation > Performance"
      type: number
      value_format: "#,##0.0"
      sql:
      100.0 * SAFE_DIVIDE(
        ${successful_actions_count},
        ${automated_actions_count}
      ) ;;
      description: "Success rate of automated actions as a percentage"
    }

    measure: governance_automation_savings {
      group_label: "FinOps Automation > ROI"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${automation_type} = 'Cost Controls' THEN ${total_unblended_cost} * 0.15  -- 15% savings via automation
        WHEN ${automation_type} = 'Resource Management' THEN ${total_unblended_cost} * 0.25  -- 25% savings via automation
        WHEN ${automation_type} = 'Lifecycle Management' THEN ${total_unblended_cost} * 0.20  -- 20% savings via automation
        WHEN ${automation_type} = 'Tagging Enforcement' THEN ${total_unblended_cost} * 0.05  -- 5% savings via visibility
        WHEN ${automation_type} = 'Security Policies' THEN ${total_unblended_cost} * 0.08  -- 8% savings via compliance
        ELSE 0
      END ;;
      description: "Estimated cost savings from governance automation initiatives"
    }

    measure: workflow_efficiency_score {
      group_label: "FinOps Automation > Performance"
      type: number
      value_format: "#,##0"
      sql:
      (
        CASE WHEN ${automation_coverage_percentage} >= 80 THEN 25
             WHEN ${automation_coverage_percentage} >= 60 THEN 20
             WHEN ${automation_coverage_percentage} >= 40 THEN 15
             ELSE 10 END +
        CASE WHEN ${policy_compliance_rate} >= 90 THEN 25
             WHEN ${policy_compliance_rate} >= 75 THEN 20
             WHEN ${policy_compliance_rate} >= 60 THEN 15
             ELSE 10 END +
        CASE WHEN ${automation_success_rate} >= 95 THEN 25
             WHEN ${automation_success_rate} >= 85 THEN 20
             WHEN ${automation_success_rate} >= 75 THEN 15
             ELSE 10 END +
        CASE WHEN ${governance_automation_savings} / NULLIF(${total_unblended_cost}, 0) >= 0.20 THEN 25
             WHEN ${governance_automation_savings} / NULLIF(${total_unblended_cost}, 0) >= 0.15 THEN 20
             WHEN ${governance_automation_savings} / NULLIF(${total_unblended_cost}, 0) >= 0.10 THEN 15
             ELSE 10 END
      ) ;;
      description: "Overall workflow efficiency score (0-100) based on automation coverage, compliance, success rate, and savings"
    }

    measure: compliant_resources_count {
      group_label: "FinOps Automation > Resource Counts"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${policy_compliance_status} IN ('Fully Compliant', 'Partially Compliant')
        THEN ${line_item_resource_id}
        ELSE NULL
      END ;;
      description: "Count of resources meeting policy compliance requirements"
    }

    measure: non_compliant_resources_count {
      group_label: "FinOps Automation > Resource Counts"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${policy_compliance_status} IN ('Non-Compliant', 'Minimally Compliant')
        THEN ${line_item_resource_id}
        ELSE NULL
      END ;;
      description: "Count of resources not meeting policy compliance requirements"
    }

    measure: violation_count {
      group_label: "FinOps Automation > Violations"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${violation_severity} != 'None'
        THEN ${line_item_resource_id}
        ELSE NULL
      END ;;
      description: "Count of policy violations across resources"
    }

    measure: auto_remediated_count {
      group_label: "FinOps Automation > Remediation"
      type: count_distinct
      value_format: "#,##0"
      sql:
      CASE
        WHEN ${automation_type} != 'Manual Operations' AND ${policy_compliance_status} IN ('Fully Compliant', 'Partially Compliant')
        THEN ${line_item_resource_id}
        ELSE NULL
      END ;;
      description: "Count of violations automatically remediated"
    }

    measure: manual_intervention_required{
      group_label: "FinOps Automation > Remediation"
      type: count_distinct
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${violation_severity} IN ('Critical', 'High') AND ${policy_compliance_status} = 'Non-Compliant'
        THEN ${line_item_resource_id}
        ELSE NULL
      END ;;
      description: "Count of violations requiring manual intervention"
    }

    measure: time_to_remediation_hours {
      group_label: "FinOps Automation > Performance"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${automation_type} = 'Event-Driven Automation' THEN 0.5  -- 30 minutes
        WHEN ${automation_type} IN ('Cost Controls', 'Resource Management') THEN 2.0  -- 2 hours
        WHEN ${automation_type} = 'Lifecycle Management' THEN 24.0  -- 24 hours
        WHEN ${automation_type} = 'Tagging Enforcement' THEN 1.0  -- 1 hour
        WHEN ${automation_type} = 'Security Policies' THEN 4.0  -- 4 hours
        ELSE 48.0  -- 48 hours for manual
      END ;;
      description: "Average time to remediation in hours based on automation type"
    }

    measure: automation_investment_cost {
      group_label: "FinOps Automation > ROI"
      type: number
      value_format: "\"£\"#,##0"
      sql:
      CASE
        WHEN ${automation_type} = 'Event-Driven Automation' THEN ${total_unblended_cost} * 0.02  -- 2% investment
        WHEN ${automation_type} IN ('Cost Controls', 'Resource Management') THEN ${total_unblended_cost} * 0.05  -- 5% investment
        WHEN ${automation_type} = 'Security Policies' THEN ${total_unblended_cost} * 0.03  -- 3% investment
        WHEN ${automation_type} = 'Tagging Enforcement' THEN ${total_unblended_cost} * 0.01  -- 1% investment
        ELSE 0
      END ;;
      description: "Estimated investment cost for automation infrastructure"
    }

    measure: automation_roi_percentage {
      group_label: "FinOps Automation > ROI"
      type: number
      value_format: "#,##0.0"
      sql:
      CASE
        WHEN ${automation_investment_cost} > 0
        THEN ((${governance_automation_savings} - ${automation_investment_cost}) / ${automation_investment_cost}) * 100
        ELSE 0
      END ;;
      description: "Return on investment percentage for automation initiatives"
    }

    dimension: automation_recommendation {
      group_label: "FinOps Automation > Recommendations"
      type: string
      description: "AI-driven recommendations for FinOps automation improvements"
      sql:
      CASE
        WHEN ${line_item_unblended_cost} > 1000 AND (${environment} IS NULL OR ${team} IS NULL)
        THEN 'Critical: Implement immediate tagging and governance automation'
        WHEN ${pricing_term} = 'OnDemand' AND ${line_item_unblended_cost} > 500
        THEN 'Review Reserved Instance or Savings Plan automation opportunities'
        WHEN ${line_item_resource_id} IS NULL AND ${line_item_unblended_cost} > 100
        THEN 'Expand automation coverage for cost controls and resource management'
        ELSE 'Well-automated workflow - focus on continuous optimization'
      END ;;
    }

# =====================================================
# SAVINGS PLANS & DISCOUNTS - ORGANIZATION-WIDE MEASURES
# =====================================================

# Total Savings Plan Usage and Costs
  measure: total_savings_plan_usage {
    group_label: "Commitment Discounts > Savings Plans > Usage"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${savings_plan_savings_plan_a_r_n} IS NOT NULL
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    description: "Total cost covered by Savings Plans across all accounts"
    drill_fields: [line_item_usage_account_name, savings_plan_offering_type, savings_plan_savings_plan_a_r_n]
  }

  measure: total_savings_plan_commitment {
    group_label: "Commitment Discounts > Savings Plans > Commitments"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    (COALESCE(${savings_plan_amortized_upfront_commitment_for_billing_period}, 0) * 0.79) +
    (COALESCE(${savings_plan_recurring_commitment_for_billing_period}, 0) * 0.79) ;;
    description: "Total Savings Plan commitment (upfront + recurring) for billing period"
    drill_fields: [line_item_usage_account_name, savings_plan_purchase_term, savings_plan_payment_option]
  }

  measure: total_savings_plan_utilized {
    group_label: "Commitment Discounts > Savings Plans > Utilization"
    type: sum
    value_format: "\"£\"#,##0"
    sql: COALESCE(${savings_plan_used_commitment}, 0) * 0.79 ;;
    description: "Total Savings Plan commitment actually utilized"
    drill_fields: [line_item_usage_account_name, savings_plan_offering_type]
  }

  measure: savings_plan_utilization_rate {
    group_label: "Commitment Discounts > Savings Plans > Utilization"
    type: number
    value_format: "0.00\%"
    sql:
    CASE
      WHEN ${total_savings_plan_commitment} > 0
      THEN (${total_savings_plan_utilized} / NULLIF(${total_savings_plan_commitment}, 0)) * 100
      ELSE 0
    END ;;
    description: "Savings Plan utilization rate as percentage"
  }

  measure: savings_plan_unused_commitment {
    group_label: "Commitment Discounts > Savings Plans > Waste"
    type: number
    value_format: "\"£\"#,##0"
    sql: ${total_savings_plan_commitment} - ${total_savings_plan_utilized} ;;
    description: "Unused Savings Plan commitment (waste)"
  }

# Reserved Instance Metrics
  measure: total_ri_usage {
    group_label: "Commitment Discounts > Reserved Instances > Usage"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${line_item_line_item_type} = 'DiscountedUsage'
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    description: "Total cost covered by Reserved Instances"
    drill_fields: [line_item_usage_account_name, reservation_reservation_a_r_n, product_instance_type]
  }

  measure: total_ri_effective_cost {
    group_label: "Commitment Discounts > Reserved Instances > Costs"
    type: sum
    value_format: "\"£\"#,##0"
    sql: COALESCE(${reservation_effective_cost}, 0) * 0.79 ;;
    description: "Total RI effective cost including amortization"
    drill_fields: [line_item_usage_account_name, reservation_reservation_a_r_n]
  }

  measure: total_ri_unused_cost {
    group_label: "Commitment Discounts > Reserved Instances > Waste"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    (COALESCE(${reservation_unused_amortized_upfront_fee_for_billing_period}, 0) +
     COALESCE(${reservation_unused_recurring_fee}, 0)) * 0.79 ;;
    description: "Total unused RI cost (waste)"
    drill_fields: [line_item_usage_account_name, reservation_reservation_a_r_n]
  }

  measure: ri_utilization_rate {
    group_label: "Commitment Discounts > Reserved Instances > Utilization"
    type: number
    value_format: "0.00\%"
    sql:
    CASE
      WHEN (${total_ri_effective_cost} + ${total_ri_unused_cost}) > 0
      THEN (${total_ri_effective_cost} /
            NULLIF(${total_ri_effective_cost} + ${total_ri_unused_cost}, 0)) * 100
      ELSE 0
    END ;;
    description: "RI utilization rate as percentage"
  }

# Total Discounts
  measure: total_edp_discount {
    group_label: "Discounts > EDP"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${edp_discount} IS NOT NULL AND CAST(${edp_discount} AS DOUBLE) != 0
      THEN ABS(CAST(${edp_discount} AS DOUBLE)) * 0.79
      ELSE 0
    END ;;
    description: "Total EDP (Enterprise Discount Program) discount"
    drill_fields: [line_item_usage_account_name, line_item_product_code]
  }

  measure: total_ppa_discount {
    group_label: "Discounts > PPA"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${ppa_discount} IS NOT NULL AND CAST(${ppa_discount} AS DOUBLE) != 0
      THEN ABS(CAST(${ppa_discount} AS DOUBLE)) * 0.79
      ELSE 0
    END ;;
    description: "Total PPA (Private Pricing Agreement) discount"
    drill_fields: [line_item_usage_account_name, line_item_product_code]
  }

  measure: total_all_discounts {
    group_label: "Discounts > Overall"
    type: sum
    value_format: "\"£\"#,##0"
    sql: ABS(COALESCE(${discount_total_discount}, 0)) * 0.79 ;;
    description: "Total of all discounts (EDP, PPA, bundled, etc.)"
    drill_fields: [line_item_usage_account_name, line_item_product_code]
  }

# Commitment Coverage
  measure: total_commitment_covered_cost {
    group_label: "Commitment Discounts > Coverage"
    type: number
    value_format: "\"£\"#,##0"
    sql: ${total_savings_plan_usage} + ${total_ri_usage} ;;
    description: "Total cost covered by commitments (SP + RI)"
  }

  measure: total_on_demand_spend {
    group_label: "Pricing Models > On-Demand"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${line_item_line_item_type} = 'Usage'
           AND ${savings_plan_savings_plan_a_r_n} IS NULL
           AND ${line_item_line_item_type} != 'DiscountedUsage'
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    description: "Total on-demand spend (not covered by commitments)"
    drill_fields: [line_item_usage_account_name, line_item_product_code, product_instance_type]
  }

  measure: commitment_coverage_percentage {
    group_label: "Commitment Discounts > Coverage"
    type: number
    value_format: "0.00\%"
    sql:
    CASE
      WHEN (${total_commitment_covered_cost} + ${total_on_demand_spend}) > 0
      THEN (${total_commitment_covered_cost} /
            NULLIF(${total_commitment_covered_cost} + ${total_on_demand_spend}, 0)) * 100
      ELSE 0
    END ;;
    description: "Percentage of eligible spend covered by commitments"
  }

# Savings Realized
  measure: total_commitment_savings {
    group_label: "Commitment Discounts > Savings"
    type: number
    value_format: "\"£\"#,##0"
    sql:
    (COALESCE(${total_savings_plan_usage}, 0) * 0.15) +
    (COALESCE(${total_ri_usage}, 0) * 0.30) ;;
    description: "Estimated total savings from commitments vs on-demand (SP=15%, RI=30%)"
  }

  measure: total_discount_savings {
    group_label: "Discounts > Savings"
    type: number
    value_format: "\"£\"#,##0"
    sql: ${total_all_discounts} ;;
    description: "Total savings from all discount programs"
  }

  measure: total_savings_realized {
    group_label: "Overall > Savings"
    type: number
    value_format: "\"£\"#,##0"
    sql: ${total_commitment_savings} + ${total_discount_savings} ;;
    description: "Total savings from commitments and discounts combined"
  }

# By Account Analysis
  measure: account_savings_plan_cost {
    group_label: "By Account > Savings Plans"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${savings_plan_savings_plan_a_r_n} IS NOT NULL
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    drill_fields: [line_item_usage_account_name, line_item_usage_account_id]
  }

  measure: account_ri_cost {
    group_label: "By Account > Reserved Instances"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${line_item_line_item_type} = 'DiscountedUsage'
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    drill_fields: [line_item_usage_account_name, line_item_usage_account_id]
  }

  measure: account_discount_amount {
    group_label: "By Account > Discounts"
    type: sum
    value_format: "\"£\"#,##0"
    sql: ABS(COALESCE(${discount_total_discount}, 0)) * 0.79 ;;
    drill_fields: [line_item_usage_account_name, line_item_usage_account_id]
  }

# Summary Metrics for Dashboard
  measure: total_compute_spend {
    group_label: "Overall > Spend Summary"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${service_category} IN ('Compute', 'Containers & Serverless')
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    description: "Total compute spend across organization"
  }

  measure: effective_savings_rate {
    group_label: "Overall > Savings"
    type: number
    value_format: "0.00\%"
    sql:
    CASE
      WHEN ${total_compute_spend} > 0
      THEN (${total_savings_realized} / NULLIF(${total_compute_spend}, 0)) * 100
      ELSE 0
    END ;;
    description: "Effective savings rate as percentage of compute spend"
  }

# Waste Metrics
  measure: total_commitment_waste {
    group_label: "Waste > Commitments"
    type: number
    value_format: "\"£\"#,##0"
    sql: ${savings_plan_unused_commitment} + ${total_ri_unused_cost} ;;
    description: "Total waste from unused commitments"
  }

  measure: waste_percentage {
    group_label: "Waste > Overall"
    type: number
    value_format: "0.00\%"
    sql:
    CASE
      WHEN (${total_savings_plan_commitment} + ${total_ri_effective_cost} + ${total_ri_unused_cost}) > 0
      THEN (${total_commitment_waste} /
            NULLIF(${total_savings_plan_commitment} + ${total_ri_effective_cost} + ${total_ri_unused_cost}, 0)) * 100
      ELSE 0
    END ;;
    description: "Waste as percentage of total commitments"
  }

# Commitment Health Score
  measure: commitment_health_score {
    group_label: "Overall > Health"
    type: number
    value_format: "0"
    sql:
    (
      CASE
        WHEN ${commitment_coverage_percentage} >= 70 THEN 30
        WHEN ${commitment_coverage_percentage} >= 50 THEN 20
        WHEN ${commitment_coverage_percentage} >= 30 THEN 10
        ELSE 0
      END +
      CASE
        WHEN ${savings_plan_utilization_rate} >= 95 THEN 25
        WHEN ${savings_plan_utilization_rate} >= 85 THEN 20
        WHEN ${savings_plan_utilization_rate} >= 75 THEN 15
        ELSE 10
      END +
      CASE
        WHEN ${ri_utilization_rate} >= 95 THEN 25
        WHEN ${ri_utilization_rate} >= 85 THEN 20
        WHEN ${ri_utilization_rate} >= 75 THEN 15
        ELSE 10
      END +
      CASE
        WHEN ${waste_percentage} <= 5 THEN 20
        WHEN ${waste_percentage} <= 10 THEN 15
        WHEN ${waste_percentage} <= 15 THEN 10
        ELSE 5
      END
    ) ;;
    description: "Overall commitment health score (0-100)"
  }

# Add to cur2.view.lkml

  measure: total_sp_eligible_usage {
    group_label: "Commitment Discounts > Savings Plans > Usage"
    type: sum
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${service_category} IN ('Compute', 'Containers & Serverless')
           AND ${line_item_line_item_type} = 'Usage'
      THEN ${line_item_unblended_cost} * 0.79
      ELSE 0
    END ;;
    description: "Total eligible compute usage that could be covered by Savings Plans"
    drill_fields: [line_item_usage_account_name, line_item_product_code]
  }

  measure: sp_over_usage {
    group_label: "Commitment Discounts > Savings Plans > Usage"
    type: number
    value_format: "\"£\"#,##0"
    sql:
    CASE
      WHEN ${total_sp_eligible_usage} > ${total_savings_plan_commitment}
      THEN ${total_sp_eligible_usage} - ${total_savings_plan_commitment}
      ELSE 0
    END ;;
    description: "Usage beyond Savings Plan commitment (potential additional SP opportunity)"
  }

  measure: sp_coverage_gap {
    group_label: "Commitment Discounts > Savings Plans > Coverage"
    type: number
    value_format: "0.00\%"
    sql:
    CASE
      WHEN ${total_sp_eligible_usage} > 0
      THEN ((${total_sp_eligible_usage} - ${total_savings_plan_utilized}) /
            NULLIF(${total_sp_eligible_usage}, 0)) * 100
      ELSE 0
    END ;;
    description: "Percentage of eligible usage not covered by Savings Plans"
  }

  measure: actual_vs_commitment_ratio {
    group_label: "Commitment Discounts > Savings Plans > Utilization"
    type: number
    value_format: "0.00"
    sql:
    CASE
      WHEN ${total_savings_plan_commitment} > 0
      THEN ${total_sp_eligible_usage} / NULLIF(${total_savings_plan_commitment}, 0)
      ELSE 0
    END ;;
    description: "Ratio of actual usage to commitment (>1 means over-usage, <1 means under-usage)"
  }
}