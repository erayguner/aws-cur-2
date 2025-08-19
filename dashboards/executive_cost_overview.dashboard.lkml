---
- dashboard: executive_cost_overview
  title: 📊 Executive Cost Overview
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'High-level AWS cost insights for executive leadership'
  
  # Performance optimizations
  auto_run: true
  refresh: 120 minutes
  load_configuration: wait
  crossfilter_enabled: true
  elements:
  - title: Total AWS Spend
    name: total_cost_kpi
    model: aws_billing
    explore: cur2
    type: kpi_vis
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: '3 months ago for 3 months'
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: d8ef4b14-88c3-4a54-9cf4-d8ad88a0b8b5
          label: Custom
          type: continuous
          stops:
          - color: '#16a34a'
            offset: 0
          - color: '#eab308'
            offset: 50
          - color: '#dc2626'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: null
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 8
    height: 4

  - title: Month-over-Month Change
    name: mom_change_gauge
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost]
    pivots: [cur2.line_item_usage_start_month]
    filters:
      cur2.line_item_usage_start_date: '3 months ago for 3 months'
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 2
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 8
    width: 8
    height: 4

  - title: Cost by Service (Treemap)
    name: cost_by_service_treemap
    model: aws_billing
    explore: cur2
    type: treemap_vis
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: '3 months ago for 3 months'
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    column_limit: 50
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 0
    width: 16
    height: 8

  - title: Monthly Cost Trend
    name: monthly_cost_trend
    model: aws_billing
    explore: cur2
    type: waterfall_vis
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: '3 months ago for 3 months'
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
    column_limit: 50
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 12
    col: 0
    width: 16
    height: 6

  - title: Top 10 Accounts by Cost
    name: top_accounts_table
    model: aws_billing
    explore: cur2
    type: report_table
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost, cur2.total_usage_amount]
    filters:
      cur2.line_item_usage_start_date: '3 months ago for 3 months'
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 18
    col: 0
    width: 8
    height: 8

  - title: Cost Distribution by Region
    name: cost_by_region
    model: aws_billing
    explore: cur2
    type: looker_geo_choropleth
    fields: [cur2.line_item_availability_zone, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: '3 months ago for 3 months'
      cur2.line_item_availability_zone: '-EMPTY'
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    column_limit: 50
    map: usa
    map_projection: ''
    show_view_names: false
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 18
    col: 8
    width: 8
    height: 8

  filters:
  - name: Billing Period
    title: 📅 Billing Period
    type: field_filter
    default_value: '3 months ago for 3 months'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: AWS Account
    title: 🏢 AWS Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Service Category, Environment]
    field: cur2.line_item_usage_account_name

  - name: Service Category
    title: 🔧 Service Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account]
    field: cur2.service_category

  - name: Environment
    title: 🌍 Environment
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account, Service Category]
    field: cur2.environment

  - name: Cost Threshold
    title: 💰 Minimum Cost ($)
    type: field_filter
    default_value: '1000'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 500000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost