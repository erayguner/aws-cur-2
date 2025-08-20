---
# =====================================================
# FINOPS MASTER DASHBOARD
# =====================================================
# Comprehensive FinOps dashboard following Looker best practices
# Includes advanced analytics, gamification, forecasting, and data operations
# 
# Author: Claude FinOps Dashboard Generator
# Last Updated: 2025-08-19
# =====================================================

- dashboard: finops_master_dashboard
  title: 🏆 FinOps Master Command Center
  description: 'Comprehensive FinOps dashboard with advanced analytics, gamification, forecasting, and data operations monitoring'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations following Looker best practices
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  # Advanced dashboard configuration
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'
  
  filters:
  - name: Time Period
    title: 📅 Time Period
    type: field_filter
    default_value: '30 days ago for 30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
        - '7 days ago for 7 days'
        - '30 days ago for 30 days'
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
    listens_to_filters: [AWS Service, Environment, Team]
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
    listens_to_filters: [AWS Account, Team]
    field: cur2.environment

  - name: Team
    title: 👥 Team
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
    field: cur2.team

  - name: Cost Threshold
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

  elements:
  # =====================================================
  # EXECUTIVE KPI SECTION
  # =====================================================
  
  - title: 🎯 FinOps Maturity Score
    name: finops_maturity_kpi
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.finops_maturity_score]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: FINOPS MATURITY
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [60, 80]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: less than
      value: 60
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 4
    height: 6

  - title: 💰 Total Cloud Spend
    name: total_spend_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.month_over_month_change]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: TOTAL SPEND
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: '@{COST_THRESHOLD_HIGH}'
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 4
    width: 4
    height: 6

  - title: 🔄 Optimization Score
    name: optimization_score_kpi
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.optimization_score]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: OPTIMIZATION SCORE
    value_format: "#,##0.0"
    conditional_formatting:
    - type: greater than
      value: 85
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [70, 85]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: less than
      value: 70
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 8
    width: 4
    height: 6

  - title: 💡 Right-sizing Opportunity
    name: rightsizing_opportunity_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: RIGHT-SIZING OPPORTUNITY
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [1000, 10000]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: less than
      value: 1000
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 12
    width: 4
    height: 6

  # =====================================================
  # GAMIFICATION SECTION
  # =====================================================

  - title: 🏆 Cost Hero Leaderboard
    name: cost_hero_leaderboard
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.cost_hero_points, cur2.sustainability_champion_score, 
             cur2.waste_warrior_achievements, cur2.level_progress]
    sorts: [cur2.cost_hero_points desc]
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
    - type: greater than
      value: 1000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.cost_hero_points]
    - type: greater than
      value: 80
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.sustainability_champion_score]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 6
    col: 0
    width: 8
    height: 8

  - title: 🎮 Achievement Progress
    name: achievement_progress
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields: [cur2.cost_hero_points, cur2.sustainability_champion_score, 
             cur2.waste_warrior_achievements, cur2.team_collaboration_score]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: achievement-progress
        label: Achievement Progress
        type: continuous
        stops:
        - color: '#16a34a'
          offset: 0
        - color: '#eab308'
          offset: 50
        - color: '#dc2626'
          offset: 100
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 6
    col: 8
    width: 8
    height: 8

  # =====================================================
  # FORECASTING SECTION
  # =====================================================

  - title: 📈 Cost Forecasting Analysis
    name: cost_forecasting_chart
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, 
             cur2.trend_forecast_7d, cur2.seasonal_forecast_30d, cur2.budget_burn_rate]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: forecasting-colors
        label: Forecasting Colors
        type: categorical
        stops:
        - color: '#1f77b4'
          offset: 0
        - color: '#ff7f0e'
          offset: 1
        - color: '#2ca02c'
          offset: 2
        - color: '#d62728'
          offset: 3
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 14
    col: 0
    width: 16
    height: 8

  - title: 📊 Usage Pattern Forecast
    name: usage_pattern_forecast_chart
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_usage_amount, 
             cur2.usage_pattern_forecast, cur2.growth_forecast_90d]
    sorts: [cur2.line_item_usage_start_date]
    limit: 60
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 22
    col: 0
    width: 16
    height: 8

  # =====================================================
  # COST ANOMALY DETECTION
  # =====================================================

  - title: 🚨 Cost Anomaly Detection
    name: cost_anomaly_detection
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, 
             cur2.cost_anomaly_score, cur2.line_item_product_code]
    sorts: [cur2.line_item_usage_start_date]
    limit: 500
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
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    size_by_field: cur2.cost_anomaly_score
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: anomaly-colors
        label: Anomaly Colors
        type: continuous
        stops:
        - color: '#16a34a'
          offset: 0
        - color: '#eab308'
          offset: 50
        - color: '#dc2626'
          offset: 100
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 30
    col: 0
    width: 16
    height: 8

  # =====================================================
  # DATA OPERATIONS MONITORING
  # =====================================================

  - title: 🔍 Data Operations Health
    name: data_ops_health
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields: [cur2.data_freshness_hours, cur2.data_completeness_score, 
             cur2.ingestion_health_score, cur2.data_quality_alerts]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: less than
      value: 12
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.data_freshness_hours]
    - type: greater than
      value: 80
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.data_completeness_score, cur2.ingestion_health_score]
    - type: greater than
      value: 0
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.data_quality_alerts]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 38
    col: 0
    width: 8
    height: 6

  - title: 📈 Data Quality Trends
    name: data_quality_trends
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_date, cur2.data_completeness_score, 
             cur2.processing_lag_hours, cur2.cost_variance_coefficient]
    sorts: [cur2.line_item_usage_start_date]
    limit: 30
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 38
    col: 8
    width: 8
    height: 6

  # =====================================================
  # RESOURCE EFFICIENCY ANALYSIS
  # =====================================================

  - title: ⚡ Resource Efficiency Analysis
    name: resource_efficiency_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.service_category, cur2.cost_type, cur2.resource_efficiency_score, 
             cur2.total_unblended_cost, cur2.savings_vs_on_demand, cur2.savings_percentage]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
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
    - type: greater than
      value: 80
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.resource_efficiency_score]
    - type: greater than
      value: 20
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.savings_percentage]
    - type: greater than
      value: 1000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.savings_vs_on_demand]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 44
    col: 0
    width: 16
    height: 10

  # =====================================================
  # SUSTAINABILITY & CARBON IMPACT
  # =====================================================

  - title: 🌱 Sustainability Dashboard
    name: sustainability_dashboard
    model: aws_billing
    explore: cur2
    type: treemap_vis
    fields: [cur2.service_category, cur2.estimated_carbon_impact, 
             cur2.carbon_efficiency_score, cur2.total_unblended_cost]
    sorts: [cur2.estimated_carbon_impact desc]
    limit: 15
    column_limit: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: sustainability-colors
        label: Sustainability Colors
        type: continuous
        stops:
        - color: '#16a34a'
          offset: 0
        - color: '#22c55e'
          offset: 25
        - color: '#eab308'
          offset: 50
        - color: '#f59e0b'
          offset: 75
        - color: '#dc2626'
          offset: 100
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 54
    col: 0
    width: 16
    height: 8