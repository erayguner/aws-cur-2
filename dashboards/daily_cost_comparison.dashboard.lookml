---
- dashboard: daily_cost_comparison
  title: 📅 Daily Cost Comparison Analysis
  description: 'Day-over-day AWS cost analysis with anomaly detection and variance tracking'
  layout: newspaper
  preferred_viewer: dashboards-next

  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
  load_configuration: wait

  # Cross-filtering configuration
  crossfilter_enabled: true

  elements:
  # ====================
  # KEY METRICS SUMMARY
  # ====================
  - title: Daily Cost Summary
    name: daily_summary_metrics
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [
      cur2.total_unblended_cost,
      cur2.count_unique_services,
      cur2.count_unique_accounts,
      cur2.average_daily_cost
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
  # DAILY COST COMPARISON TABLE
  # ====================
  - title: Daily Cost Breakdown by Service
    name: daily_cost_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_date,
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    pivots: [cur2.line_item_usage_start_date]
    fill_fields: [cur2.line_item_usage_start_date]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_date desc, cur2.total_unblended_cost desc 0]
    limit: 500
    column_limit: 90
    total: true
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
    header_font_size: 11
    rows_font_size: 11
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
      cur2.line_item_product_code: Service
      cur2.line_item_usage_account_name: Account
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
    height: 12
    row: 3
    col: 0

  # ====================
  # TOP 20 COST CHANGES BY SERVICE
  # ====================
  - title: Top 20 Daily Cost Changes by Service
    name: top_daily_changes
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost
    ]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)) / offset(${cur2.total_unblended_cost}, 1)"
      label: "% Change"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: pct_change
      _type_hint: number
    - category: table_calculation
      expression: "${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)"
      label: "Cost Variance"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: cost_variance
      _type_hint: number
    - category: table_calculation
      expression: "if(abs(${pct_change}) > 0.20, \"⚠️ High\", if(abs(${pct_change}) > 0.10, \"⚡ Medium\", \"✓ Normal\"))"
      label: "Change Flag"
      _kind_hint: measure
      table_calculation: change_flag
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
      cur2.line_item_product_code: Service
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Current Cost
    conditional_formatting:
    - type: greater than
      value: 0.20
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [pct_change]
    - type: between
      value: [0.10, 0.20]
      background_color: '#fb923c'
      font_color: '#000000'
      bold: false
      fields: [pct_change]
    - type: less than
      value: -0.20
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [pct_change]
    - type: between
      value: [-0.20, -0.10]
      background_color: '#86efac'
      font_color: '#000000'
      bold: false
      fields: [pct_change]
    width: 12
    height: 10
    row: 15
    col: 0

  # ====================
  # ANOMALY DETECTION (>20% SPIKES)
  # ====================
  - title: Cost Anomalies (Spikes > 20%)
    name: cost_anomalies
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_date,
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost,
      cur2.cost_z_score
    ]
    fill_fields: [cur2.line_item_usage_start_date]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    filters:
      cur2.is_cost_anomaly: 'Yes'
    sorts: [cur2.line_item_usage_start_date desc, cur2.total_unblended_cost desc]
    limit: 100
    dynamic_fields:
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)) / offset(${cur2.total_unblended_cost}, 1)"
      label: "Daily % Change"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: daily_pct_change
      _type_hint: number
    - category: table_calculation
      expression: "${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)"
      label: "Spike Amount"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: spike_amount
      _type_hint: number
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
      cur2.line_item_usage_start_date: Date
      cur2.line_item_product_code: Service
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Cost
      cur2.cost_z_score: Z-Score
    conditional_formatting:
    - type: greater than
      value: 0.50
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [daily_pct_change]
    - type: between
      value: [0.20, 0.50]
      background_color: '#fb923c'
      font_color: '#000000'
      bold: false
      fields: [daily_pct_change]
    - type: greater than
      value: 2
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.cost_z_score]
    width: 12
    height: 10
    row: 15
    col: 12

  # ====================
  # DAILY USAGE PATTERNS
  # ====================
  - title: Daily Usage Patterns
    name: daily_usage_patterns
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [
      cur2.line_item_usage_start_date,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    fill_fields: [cur2.line_item_usage_start_date]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
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
    y_axes:
    - label: Cost
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label: Usage
      orientation: right
      series:
      - axisId: cur2.total_usage_amount
        id: cur2.total_usage_amount
        name: Total Usage
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_label: Date
    series_colors:
      cur2.total_unblended_cost: '#1f77b4'
      cur2.total_usage_amount: '#ff7f0e'
    width: 12
    height: 8
    row: 25
    col: 0

  # ====================
  # WEEKEND VS WEEKDAY ANALYSIS
  # ====================
  - title: Weekend vs. Weekday Cost Analysis
    name: weekend_weekday_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_product_code,
      cur2.total_unblended_cost
    ]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - dimension: is_weekend
      label: Is Weekend
      expression: "if(day_of_week(${cur2.line_item_usage_start_date}) = 0 OR day_of_week(${cur2.line_item_usage_start_date}) = 6, \"Weekend\", \"Weekday\")"
      _kind_hint: dimension
      _type_hint: string
    - category: measure
      expression:
      label: Weekday Cost
      value_format: '"£"#,##0.00'
      based_on: cur2.total_unblended_cost
      _kind_hint: measure
      measure: weekday_cost
      type: sum
      _type_hint: number
      filters:
        is_weekend: 'Weekday'
    - category: measure
      expression:
      label: Weekend Cost
      value_format: '"£"#,##0.00'
      based_on: cur2.total_unblended_cost
      _kind_hint: measure
      measure: weekend_cost
      type: sum
      _type_hint: number
      filters:
        is_weekend: 'Weekend'
    - category: table_calculation
      expression: "${weekend_cost} / ${weekday_cost}"
      label: "Weekend/Weekday Ratio"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: weekend_weekday_ratio
      _type_hint: number
    - category: table_calculation
      expression: "if(${weekend_weekday_ratio} > 0.80, \"⚠️ High Weekend Usage\", if(${weekend_weekday_ratio} < 0.30, \"✓ Good Optimization\", \"⚡ Moderate\"))"
      label: "Optimization Flag"
      _kind_hint: measure
      table_calculation: optimization_flag
      _type_hint: string
    hidden_fields: [is_weekend]
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
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Total Cost
    conditional_formatting:
    - type: greater than
      value: 0.80
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [weekend_weekday_ratio]
    - type: less than
      value: 0.30
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [weekend_weekday_ratio]
    width: 12
    height: 8
    row: 25
    col: 12

  # ====================
  # FILTERS
  # ====================
  filters:
  - name: Date Range
    title: 📅 Date Range
    type: field_filter
    default_value: '90 days'
    allow_multiple_values: false
    required: true
    ui_config:
      type: relative_timeframes
      display: inline
      options:
      - 7 days
      - 14 days
      - 30 days
      - 60 days
      - 90 days
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
