---
- dashboard: detailed_cost_analysis
  title: 🔍 Detailed Cost Analysis
  description: 'In-depth AWS cost analysis for FinOps teams and cost optimization'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  
  # Cross-filtering configuration  
  crossfilter_enabled: true
  
  elements:
  - title: Cost Summary
    name: total_cost_summary
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields: [
      cur2.total_unblended_cost,
      cur2.total_blended_cost,
      cur2.total_usage_amount,
      cur2.count
    ]
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Minimum Cost Threshold: cur2.total_unblended_cost
    limit: 500
    column_limit: 50
    width: 16
    height: 4
    row: 0
    col: 0
    
  - title: Daily Cost Trend
    name: daily_cost_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Minimum Cost Threshold: cur2.total_unblended_cost
    sorts: [cur2.line_item_usage_start_date]
    limit: 31
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_dimension: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    width: 16
    height: 6
    row: 4
    col: 0
    
  - title: Service → Account → Region Cost Flow
    name: service_cost_flow
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.line_item_availability_zone,
      cur2.total_unblended_cost
    ]
    filters:
      cur2.line_item_availability_zone: '-EMPTY'
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Minimum Cost Threshold: cur2.total_unblended_cost
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    column_limit: 50
    width: 16
    height: 8
    row: 10
    col: 0
    
  - title: Usage Type Distribution
    name: usage_type_histogram
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_usage_type, cur2.total_unblended_cost]
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Minimum Cost Threshold: cur2.total_unblended_cost
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    column_limit: 50
    width: 8
    height: 8
    row: 18
    col: 0
    
  - title: Instance Type Cost Analysis
    name: instance_type_cost
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [
      cur2.product_instance_type,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    filters:
      cur2.product_instance_type: '-EMPTY'
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Minimum Cost Threshold: cur2.total_unblended_cost
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_dimension: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    width: 8
    height: 8
    row: 18
    col: 8
    
  - title: Detailed Cost Breakdown
    name: detailed_cost_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.line_item_usage_type,
      cur2.product_instance_type,
      cur2.line_item_availability_zone,
      cur2.total_unblended_cost,
      cur2.total_usage_amount,
      cur2.pricing_unit
    ]
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Minimum Cost Threshold: cur2.total_unblended_cost
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
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
    conditional_formatting:
    - type: greater than
      value: '@{COST_THRESHOLD_HIGH}'
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: cost-alert
          label: Cost Alert
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
      fields: [cur2.total_unblended_cost]
    width: 16
    height: 10
    row: 26
    col: 0

  filters:
  - name: Billing Period
    title: 📅 Billing Period
    type: field_filter
    default_value: '1 months ago for 1 months'
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

  - name: AWS Service
    title: 🔧 AWS Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account, Environment, Cost Category]
    field: cur2.line_item_product_code

  - name: AWS Account
    title: 🏢 AWS Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service]
    field: cur2.line_item_usage_account_name

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
    listens_to_filters: [AWS Service, AWS Account]
    field: cur2.environment

  - name: Cost Category
    title: 📊 Cost Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service]
    field: cur2.service_category

  - name: AWS Region
    title: 🌎 AWS Region
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service, AWS Account]
    field: cur2.product_region_code

  - name: Minimum Cost Threshold
    title: 💰 Minimum Cost ($)
    type: field_filter
    default_value: '0'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 100000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost