---
# =====================================================
# COST COMPARISON ANALYTICS DASHBOARD
# =====================================================
# Month-to-month and week-to-week comparison dashboard
# Top spenders and savers analysis for projects and resources
# 
# Author: Claude Dashboard Generator
# Last Updated: 2025-08-19
# =====================================================

- dashboard: cost_comparison_analytics
  title: 📊 Cost Comparison Analytics
  description: 'Month-to-month and week-to-week cost comparison dashboard with top spenders and savers analysis for projects and resources'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  # Professional dashboard styling
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'
  
  filters:
  - name: Time Period
    title: 📅 Analysis Period
    type: field_filter
    default_value: '60 days ago for 60 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
        - '30 days ago for 30 days'
        - '60 days ago for 60 days'
        - '90 days ago for 90 days'
        - '6 months ago for 6 months'
        - '1 year ago for 1 year'
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
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service, Project, Environment]
    field: cur2.line_item_usage_account_name

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
    listens_to_filters: [AWS Account, Service Category]
    field: cur2.line_item_product_code

  - name: Service Category
    title: 📊 Service Category
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
    field: cur2.service_category

  - name: Project
    title: 🎯 Project
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account, Environment]
    field: cur2.project

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
    listens_to_filters: [AWS Account, Project]
    field: cur2.environment

  - name: Cost Threshold
    title: 💰 Minimum Cost ($)
    type: field_filter
    default_value: '100'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 50000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost

  elements:
  # =====================================================
  # EXECUTIVE SUMMARY KPIs
  # =====================================================
  
  - title: 📈 Month-over-Month Change
    name: month_over_month_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.month_over_month_change, cur2.total_unblended_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    single_value_title: MONTH-OVER-MONTH CHANGE
    value_format: "#,##0.0%"
    conditional_formatting:
    # Color-blind friendly: Blue for good, Orange for caution, Dark red for alert
    - type: less than
      value: -10
      background_color: '#1f77b4'  # Safe blue
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [-10, 10]
      background_color: '#ff7f0e'  # Safe orange
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 10
      background_color: '#d62728'  # Safe red
      font_color: '#ffffff'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 4
    height: 4

  - title: 📅 Week-over-Week Change
    name: week_over_week_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.week_over_week_change, cur2.total_unblended_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    single_value_title: WEEK-OVER-WEEK CHANGE
    value_format: "#,##0.0%"
    conditional_formatting:
    # Color-blind friendly: Blue for good, Orange for caution, Dark red for alert
    - type: less than
      value: -15
      background_color: '#1f77b4'  # Safe blue
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [-15, 15]
      background_color: '#ff7f0e'  # Safe orange
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 15
      background_color: '#d62728'  # Safe red
      font_color: '#ffffff'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 4
    width: 4
    height: 4

  - title: 💰 Total Spend This Period
    name: total_spend_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: TOTAL SPEND
    value_format: "$#,##0"
    conditional_formatting:
    # Color-blind friendly: Light orange background with dark text
    - type: greater than
      value: 100000
      background_color: '#ffe5b4'  # Light safe orange
      font_color: '#8b4513'  # Dark brown text
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 8
    width: 4
    height: 4

  - title: 🎯 Cost Variance Score
    name: cost_variance_kpi
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.cost_variance_coefficient]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: COST VARIANCE
    value_format: "#,##0.0"
    conditional_formatting:
    # Color-blind friendly: Blue for good, Orange for caution, Dark red for alert
    - type: less than
      value: 0.5
      background_color: '#1f77b4'  # Safe blue
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [0.5, 1.0]
      background_color: '#ff7f0e'  # Safe orange
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 1.0
      background_color: '#d62728'  # Safe red
      font_color: '#ffffff'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 12
    width: 4
    height: 4

  # =====================================================
  # TOP 10 SPENDERS AND SAVERS
  # =====================================================

  - title: 🔥 Top 10 Spenders - Month over Month
    name: top_spenders_month
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.line_item_product_code, cur2.total_unblended_cost, 
             cur2.month_over_month_change, cur2.previous_month_cost, cur2.cost_difference]
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
    conditional_formatting:
    # Color-blind friendly: High cost indicators
    - type: greater than
      value: 50000
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [10000, 50000]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.total_unblended_cost]
    # Month-over-month increase indicators
    - type: greater than
      value: 20
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.month_over_month_change]
    - type: between
      value: [10, 20]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.month_over_month_change]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 0
    width: 8
    height: 10

  - title: 💚 Top 10 Savers - Month over Month
    name: top_savers_month
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.line_item_product_code, cur2.total_unblended_cost, 
             cur2.month_over_month_change, cur2.previous_month_cost, cur2.cost_difference]
    sorts: [cur2.month_over_month_change]
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
    conditional_formatting:
    # Color-blind friendly: Best savers (using blue tones)
    - type: less than
      value: -20
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.month_over_month_change]
    - type: between
      value: [-20, -10]
      background_color: '#e6f2ff'  # Very light blue
      font_color: '#0052cc'  # Medium blue
      bold: true
      fields: [cur2.month_over_month_change]
    # Savings amount highlighting
    - type: less than
      value: -5000
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.cost_difference]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 8
    width: 8
    height: 10

  # =====================================================
  # RESOURCE LEVEL ANALYSIS
  # =====================================================

  - title: 🖥️ Top 10 Resource Spenders
    name: top_resource_spenders
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.line_item_usage_account_name,
             cur2.total_unblended_cost, cur2.month_over_month_change, cur2.total_usage_amount]
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
    conditional_formatting:
    # Color-blind friendly: High cost resources
    - type: greater than
      value: 10000
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [1000, 10000]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.total_unblended_cost]
    # Usage increase indicators
    - type: greater than
      value: 30
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.month_over_month_change]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 14
    col: 0
    width: 16
    height: 8

  # =====================================================
  # TREND ANALYSIS CHARTS
  # =====================================================

  - title: 📈 Monthly Cost Trend Comparison
    name: monthly_cost_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost, 
             cur2.previous_month_cost, cur2.trend_forecast_7d]
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Current Month
      - axisId: cur2.previous_month_cost
        id: cur2.previous_month_cost
        name: Previous Month
      - axisId: cur2.trend_forecast_7d
        id: cur2.trend_forecast_7d
        name: Forecast
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: monthly-trends-colorblind
        label: Monthly Trends (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue
          offset: 0
        - color: '#ff7f0e'  # Safe orange
          offset: 1
        - color: '#9467bd'  # Safe purple
          offset: 2
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 22
    col: 0
    width: 16
    height: 8

  - title: 📅 Weekly Cost Trend Comparison
    name: weekly_cost_trends
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_week, cur2.total_unblended_cost, 
             cur2.week_over_week_change, cur2.usage_pattern_forecast]
    sorts: [cur2.line_item_usage_start_week]
    limit: 12
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Weekly Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Change (%)
      orientation: right
      series:
      - axisId: cur2.week_over_week_change
        id: cur2.week_over_week_change
        name: Week-over-Week Change
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 30
    col: 0
    width: 16
    height: 8

  # =====================================================
  # PROJECT COMPARISON ANALYSIS
  # =====================================================

  - title: 🎯 Project Cost Comparison
    name: project_cost_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.project, cur2.total_unblended_cost, cur2.month_over_month_change,
             cur2.previous_month_cost, cur2.environment]
    pivots: [cur2.environment]
    sorts: [cur2.total_unblended_cost desc 0]
    limit: 15
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: project-comparison-colorblind
        label: Project Comparison (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue
          offset: 0
        - color: '#ff7f0e'  # Safe orange
          offset: 1
        - color: '#9467bd'  # Safe purple
          offset: 2
        - color: '#8c564b'  # Safe brown
          offset: 3
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 38
    col: 0
    width: 16
    height: 10

  # =====================================================
  # DETAILED ANALYSIS TABLE
  # =====================================================

  - title: 📋 Detailed Cost Comparison Analysis
    name: detailed_comparison_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.line_item_product_code, cur2.line_item_usage_account_name,
             cur2.environment, cur2.total_unblended_cost, cur2.month_over_month_change,
             cur2.week_over_week_change, cur2.previous_month_cost, cur2.cost_difference]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
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
    rows_font_size: 11
    conditional_formatting:
    # Color-blind friendly: Cost levels and changes
    - type: greater than
      value: 25000
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [5000, 25000]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.total_unblended_cost]
    # Month-over-month changes
    - type: greater than
      value: 25
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.month_over_month_change]
    - type: less than
      value: -15
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.month_over_month_change]
    # Week-over-week changes
    - type: greater than
      value: 30
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.week_over_week_change]
    - type: less than
      value: -20
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.week_over_week_change]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Project: cur2.project
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 48
    col: 0
    width: 16
    height: 12