---
- dashboard: weekly_cost_comparison
  title: 📊 Weekly Cost Comparison Analysis
  description: 'Week-over-week AWS cost analysis with trend detection and rolling averages'
  layout: newspaper
  preferred_viewer: dashboards-next

  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait

  # Cross-filtering configuration
  crossfilter_enabled: true

  elements:
  # ====================
  # KEY METRICS SUMMARY
  # ====================
  - title: Weekly Cost Summary
    name: weekly_summary_metrics
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [
      cur2.total_unblended_cost,
      cur2.count_unique_services,
      cur2.count_unique_accounts,
      cur2.week_over_week_change
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
  # WEEKLY COST COMPARISON TABLE
  # ====================
  - title: Week-over-Week Cost by Service
    name: weekly_cost_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_week,
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    pivots: [cur2.line_item_usage_start_week]
    fill_fields: [cur2.line_item_usage_start_week]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_week desc, cur2.total_unblended_cost desc 0]
    limit: 500
    column_limit: 26
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
      cur2.line_item_usage_start_week: Week
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
  # WEEKLY TREND ANALYSIS WITH WOW %
  # ====================
  - title: Weekly Cost Trends with WoW %
    name: weekly_trends
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_week,
      cur2.line_item_product_code,
      cur2.total_unblended_cost
    ]
    fill_fields: [cur2.line_item_usage_start_week]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_week desc, cur2.total_unblended_cost desc]
    limit: 100
    dynamic_fields:
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)) / offset(${cur2.total_unblended_cost}, 1)"
      label: "WoW %"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: wow_pct
      _type_hint: number
    - category: table_calculation
      expression: "if(${wow_pct} > 0, \"📈 Increase\", if(${wow_pct} < 0, \"📉 Decrease\", \"➡️ Flat\"))"
      label: "Trend"
      _kind_hint: measure
      table_calculation: trend
      _type_hint: string
    - category: table_calculation
      expression: "${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)"
      label: "WoW Variance"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: wow_variance
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
      cur2.line_item_usage_start_week: Week
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Cost
    conditional_formatting:
    - type: greater than
      value: 0.15
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [wow_pct]
    - type: between
      value: [0.05, 0.15]
      background_color: '#fb923c'
      font_color: '#000000'
      bold: false
      fields: [wow_pct]
    - type: less than
      value: -0.15
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [wow_pct]
    - type: between
      value: [-0.15, -0.05]
      background_color: '#86efac'
      font_color: '#000000'
      bold: false
      fields: [wow_pct]
    width: 12
    height: 10
    row: 15
    col: 0

  # ====================
  # ROLLING 4-WEEK AVERAGES
  # ====================
  - title: Rolling 4-Week Average Costs
    name: rolling_4week_avg
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_week,
      cur2.line_item_product_code,
      cur2.total_unblended_cost
    ]
    fill_fields: [cur2.line_item_usage_start_week]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_week desc]
    limit: 26
    dynamic_fields:
    - category: table_calculation
      expression: "mean(offset_list(${cur2.total_unblended_cost}, 0, 4))"
      label: "4-Week Avg"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: 4_week_avg
      _type_hint: number
    - category: table_calculation
      expression: "${cur2.total_unblended_cost} - ${4_week_avg}"
      label: "Variance from Avg"
      value_format: '"£"#,##0.00'
      value_format_name: gbp_0
      _kind_hint: measure
      table_calculation: variance_from_avg
      _type_hint: number
    - category: table_calculation
      expression: "(${cur2.total_unblended_cost} - ${4_week_avg}) / ${4_week_avg}"
      label: "% from Avg"
      value_format: '#,##0.0%'
      value_format_name: percent_1
      _kind_hint: measure
      table_calculation: pct_from_avg
      _type_hint: number
    - category: table_calculation
      expression: "if(${pct_from_avg} > 0.20, \"⚠️ Above Normal\", if(${pct_from_avg} < -0.20, \"✓ Below Normal\", \"➡️ Normal\"))"
      label: "Status"
      _kind_hint: measure
      table_calculation: status
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
      cur2.line_item_usage_start_week: Week
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Current Week Cost
    conditional_formatting:
    - type: greater than
      value: 0.20
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [pct_from_avg]
    - type: less than
      value: -0.20
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [pct_from_avg]
    width: 12
    height: 10
    row: 15
    col: 12

  # ====================
  # WEEKLY PEAK ANALYSIS
  # ====================
  - title: Weekly Peak Cost Analysis
    name: weekly_peak_analysis
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
    sorts: [peak_cost desc]
    limit: 20
    dynamic_fields:
    - category: measure
      expression:
      label: Peak Cost
      value_format: '"£"#,##0.00'
      based_on: cur2.total_unblended_cost
      _kind_hint: measure
      measure: peak_cost
      type: max
      _type_hint: number
    - category: measure
      expression:
      label: Avg Cost
      value_format: '"£"#,##0.00'
      based_on: cur2.total_unblended_cost
      _kind_hint: measure
      measure: avg_cost
      type: average
      _type_hint: number
    - category: measure
      expression:
      label: Min Cost
      value_format: '"£"#,##0.00'
      based_on: cur2.total_unblended_cost
      _kind_hint: measure
      measure: min_cost
      type: min
      _type_hint: number
    - category: table_calculation
      expression: "${peak_cost} / ${avg_cost}"
      label: "Peak/Avg Ratio"
      value_format: '#,##0.00'
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: peak_avg_ratio
      _type_hint: number
    - category: table_calculation
      expression: "if(${peak_avg_ratio} > 2.0, \"⚠️ High Variability\", if(${peak_avg_ratio} > 1.5, \"⚡ Moderate\", \"✓ Stable\"))"
      label: "Variability"
      _kind_hint: measure
      table_calculation: variability
      _type_hint: string
    hidden_fields: [cur2.total_unblended_cost]
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
    conditional_formatting:
    - type: greater than
      value: 2.0
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [peak_avg_ratio]
    - type: between
      value: [1.5, 2.0]
      background_color: '#fb923c'
      font_color: '#000000'
      bold: false
      fields: [peak_avg_ratio]
    width: 12
    height: 10
    row: 25
    col: 0

  # ====================
  # SERVICE-LEVEL WEEKLY TRENDS
  # ====================
  - title: Service-Level Weekly Trends
    name: service_weekly_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [
      cur2.line_item_usage_start_week,
      cur2.line_item_product_code,
      cur2.total_unblended_cost
    ]
    pivots: [cur2.line_item_product_code]
    fill_fields: [cur2.line_item_usage_start_week]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    filters:
      cur2.line_item_product_code: '-EMPTY'
    sorts: [cur2.line_item_usage_start_week desc, cur2.line_item_product_code]
    limit: 500
    column_limit: 10
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
    x_axis_label: Week
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
    width: 12
    height: 10
    row: 25
    col: 12

  # ====================
  # ACCOUNT-LEVEL WEEKLY COMPARISON
  # ====================
  - title: Account-Level Weekly Comparison
    name: account_weekly_comparison
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_week,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost
    ]
    pivots: [cur2.line_item_usage_start_week]
    fill_fields: [cur2.line_item_usage_start_week]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      AWS Region: cur2.product_region_code
    sorts: [cur2.line_item_usage_start_week desc, cur2.total_unblended_cost desc 0]
    limit: 100
    column_limit: 13
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
    header_font_size: 11
    rows_font_size: 11
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_labels:
      cur2.line_item_usage_start_week: Week
      cur2.line_item_usage_account_name: Account
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
    width: 24
    height: 10
    row: 35
    col: 0

  # ====================
  # FILTERS
  # ====================
  filters:
  - name: Date Range
    title: 📅 Date Range
    type: field_filter
    default_value: '26 weeks'
    allow_multiple_values: false
    required: true
    ui_config:
      type: relative_timeframes
      display: inline
      options:
      - 8 weeks
      - 13 weeks
      - 26 weeks
      - 52 weeks
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
