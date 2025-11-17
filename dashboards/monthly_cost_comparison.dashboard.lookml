---
- dashboard: monthly_cost_comparison
  title: 📆 Monthly Cost Comparison Analysis
  description: 'Month-over-month and year-over-year AWS cost analysis with seasonality patterns'
  layout: newspaper
  preferred_viewer: dashboards-next

  # Performance optimizations
  auto_run: false
  refresh: 120 minutes
  load_configuration: wait

  # Cross-filtering configuration
  crossfilter_enabled: true

  elements:
  # ====================
  # KEY METRICS SUMMARY
  # ====================
  - title: Monthly Cost Summary
    name: monthly_summary_metrics
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [
      cur2.total_unblended_cost,
      cur2.count_unique_services,
      cur2.count_unique_accounts,
      cur2.month_over_month_change,
      cur2.year_over_year_change
    ]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    limit: 500
    width: 24
    height: 3
    row: 0
    col: 0

  # ====================
  # MONTHLY COST COMPARISON TABLE
  # ====================
  - title: Month-over-Month Cost by Account & Service
    name: monthly_cost_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_month,
      cur2.line_item_usage_account_name,
      cur2.line_item_product_code,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    pivots: [cur2.line_item_usage_start_month]
    fill_fields: [cur2.line_item_usage_start_month]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_month desc, cur2.total_unblended_cost desc 0]
    limit: 500
    column_limit: 24
    total: true
    row_total: right
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
    header_font_size: 10
    rows_font_size: 10
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_labels:
      cur2.line_item_usage_start_month: Month
      cur2.line_item_usage_account_name: Account
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Cost
      cur2.total_usage_amount: Usage
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
    conditional_formatting:
    - type: along a scale...
      value:
      background_color:
      font_color:
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4
        options:
          steps: 5
          reverse: false
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    width: 24
    height: 14
    row: 3
    col: 0

  # ====================
  # MOM & YOY COMPARISON TABLE
  # ====================
  - title: Monthly Trends with MoM % and YoY %
    name: monthly_trends
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_month,
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost
    ]
    fill_fields: [cur2.line_item_usage_start_month]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_month desc, cur2.total_unblended_cost desc]
    limit: 100
    dynamic_fields:
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)) / offset(${cur2.total_unblended_cost}, 1)"
      label: "MoM %"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: mom_pct
      _type_hint: number
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 12)) / offset(${cur2.total_unblended_cost}, 12)"
      label: "YoY %"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: yoy_pct
      _type_hint: number
    - category: table_calculation
      expression: "${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)"
      label: "MoM Variance"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: mom_variance
      _type_hint: number
    - category: table_calculation
      expression: "if(${mom_pct} > 0, \"📈\", if(${mom_pct} < 0, \"📉\", \"➡️\"))"
      label: "Trend"
      _kind_hint: measure
      table_calculation: trend
      _type_hint: string
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
    series_labels:
      cur2.line_item_usage_start_month: Month
      cur2.line_item_product_code: Service
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Cost
    conditional_formatting:
    - type: greater than
      value: 0.15
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [mom_pct]
    - type: between
      value: [0.05, 0.15]
      background_color: '#fb923c'
      font_color: '#000000'
      bold: false
      fields: [mom_pct]
    - type: less than
      value: -0.15
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [mom_pct]
    - type: greater than
      value: 0.25
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [yoy_pct]
    - type: less than
      value: -0.25
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [yoy_pct]
    width: 12
    height: 12
    row: 17
    col: 0

  # ====================
  # SEASONALITY PATTERNS
  # ====================
  - title: Seasonality Patterns (Monthly Average by Calendar Month)
    name: seasonality_analysis
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [
      cur2.total_unblended_cost
    ]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [calendar_month]
    limit: 12
    dynamic_fields:
    - dimension: calendar_month
      label: Calendar Month
      expression: "month(${cur2.line_item_usage_start_month})"
      _kind_hint: dimension
      _type_hint: number
    - dimension: month_name
      label: Month Name
      expression: "if(${calendar_month} = 1, \"Jan\", if(${calendar_month} = 2, \"Feb\", if(${calendar_month} = 3, \"Mar\", if(${calendar_month} = 4, \"Apr\", if(${calendar_month} = 5, \"May\", if(${calendar_month} = 6, \"Jun\", if(${calendar_month} = 7, \"Jul\", if(${calendar_month} = 8, \"Aug\", if(${calendar_month} = 9, \"Sep\", if(${calendar_month} = 10, \"Oct\", if(${calendar_month} = 11, \"Nov\", \"Dec\")))))))))))"
      _kind_hint: dimension
      _type_hint: string
    - category: measure
      expression:
      label: Avg Monthly Cost
      value_format: '"£"#,##0.00'
      based_on: cur2.total_unblended_cost
      _kind_hint: measure
      measure: avg_monthly_cost
      type: average
      _type_hint: number
    hidden_fields: [cur2.total_unblended_cost, calendar_month]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    x_axis_label: Month
    y_axes:
    - label: Average Cost
      orientation: left
      series:
      - axisId: avg_monthly_cost
        id: avg_monthly_cost
        name: Avg Monthly Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    series_colors:
      avg_monthly_cost: '#1f77b4'
    width: 12
    height: 12
    row: 17
    col: 12

  # ====================
  # QUARTERLY ROLLUPS
  # ====================
  - title: Quarterly Cost Rollups
    name: quarterly_rollups
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_quarter,
      cur2.line_item_product_code,
      cur2.total_unblended_cost
    ]
    pivots: [cur2.line_item_usage_start_quarter]
    fill_fields: [cur2.line_item_usage_start_quarter]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_quarter desc, cur2.total_unblended_cost desc 0]
    limit: 100
    column_limit: 8
    total: true
    row_total: right
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
    series_labels:
      cur2.line_item_usage_start_quarter: Quarter
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Cost
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    conditional_formatting:
    - type: along a scale...
      value:
      background_color:
      font_color:
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4
        options:
          steps: 5
          reverse: false
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    width: 12
    height: 10
    row: 29
    col: 0

  # ====================
  # YEAR-OVER-YEAR COMPARISON
  # ====================
  - title: Year-over-Year Cost Comparison
    name: yoy_comparison
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_year,
      cur2.line_item_product_code,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    pivots: [cur2.line_item_usage_start_year]
    fill_fields: [cur2.line_item_usage_start_year]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_year desc, cur2.total_unblended_cost desc 0]
    limit: 100
    column_limit: 3
    total: true
    row_total: right
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
    series_labels:
      cur2.line_item_usage_start_year: Year
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Cost
      cur2.total_usage_amount: Usage
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    conditional_formatting:
    - type: along a scale...
      value:
      background_color:
      font_color:
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4
        options:
          steps: 5
          reverse: false
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    width: 12
    height: 10
    row: 29
    col: 12

  # ====================
  # BUDGET VARIANCE TRACKING
  # ====================
  - title: Monthly Budget Variance Tracking
    name: budget_variance
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_month,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost,
      cur2.projected_monthly_cost
    ]
    fill_fields: [cur2.line_item_usage_start_month]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 24
    dynamic_fields:
    - category: table_calculation
      expression: "mean(offset_list(${cur2.total_unblended_cost}, 1, 3))"
      label: "Budget (3-Month Avg)"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: budget_3_month_avg
      _type_hint: number
    - category: table_calculation
      expression: "${cur2.total_unblended_cost} - ${budget_3_month_avg}"
      label: "Variance"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: variance
      _type_hint: number
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - ${budget_3_month_avg}) / ${budget_3_month_avg}"
      label: "Variance %"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: variance_pct
      _type_hint: number
    - category: table_calculation
      expression: "if(${variance_pct} > 0.10, \"🔴 Over Budget\", if(${variance_pct} < -0.10, \"🟢 Under Budget\", \"🟡 On Track\"))"
      label: "Status"
      _kind_hint: measure
      table_calculation: status
      _type_hint: string
    hidden_fields: [cur2.projected_monthly_cost]
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
    series_labels:
      cur2.line_item_usage_start_month: Month
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Actual Cost
    conditional_formatting:
    - type: greater than
      value: 0.10
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [variance_pct]
    - type: less than
      value: -0.10
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [variance_pct]
    - type: between
      value: [-0.10, 0.10]
      background_color: '#fbbf24'
      font_color: '#000000'
      bold: false
      fields: [variance_pct]
    width: 12
    height: 10
    row: 39
    col: 0

  # ====================
  # MONTHLY COST TREND LINE
  # ====================
  - title: 24-Month Cost Trend
    name: monthly_trend_line
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [
      cur2.line_item_usage_start_month,
      cur2.total_unblended_cost
    ]
    fill_fields: [cur2.line_item_usage_start_month]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_month]
    limit: 24
    dynamic_fields:
    - category: table_calculation
      expression: "mean(offset_list(${cur2.total_unblended_cost}, -2, 5))"
      label: "5-Month Moving Avg"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: 5_month_moving_avg
      _type_hint: number
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
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    x_axis_label: Month
    y_axes:
    - label: Cost
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Monthly Cost
      - axisId: 5_month_moving_avg
        id: 5_month_moving_avg
        name: 5-Month Moving Avg
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    series_colors:
      cur2.total_unblended_cost: '#1f77b4'
      5_month_moving_avg: '#ff7f0e'
    series_types:
      5_month_moving_avg: area
    width: 12
    height: 10
    row: 39
    col: 12

  # ====================
  # FILTERS
  # ====================
  filters:
  - name: Date Range
    title: 📅 Date Range
    type: field_filter
    default_value: '24 months'
    allow_multiple_values: false
    required: true
    ui_config:
      type: relative_timeframes
      display: inline
      options:
      - 6 months
      - 12 months
      - 18 months
      - 24 months
      - 36 months
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
    listens_to_filters: [AWS Account, Environment]
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
