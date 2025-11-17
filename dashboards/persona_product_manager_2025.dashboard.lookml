---
# =====================================================
# PRODUCT MANAGER PERSONA DASHBOARD - 2025 EDITION
# =====================================================
# Business-focused dashboard for Product Owners, Product Managers, and Business Unit Leaders
# Focus: Unit economics, product-level costs, ROI, customer acquisition costs
# =====================================================

- dashboard: persona_product_manager_2025
  title: "Product Manager Dashboard 2025"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Future-proof Product Manager dashboard focusing on unit economics, product costs, ROI, and business metrics for strategic decision-making"

  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true

  # Dashboard styling
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'

  # =====================================================
  # FILTERS - Product-centric filtering
  # =====================================================
  filters:
  - name: time_period
    title: "Time Period"
    type: field_filter
    default_value: "90 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: product_filter
    title: "Product / Project"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.project

  - name: team_filter
    title: "Team / Business Unit"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.team

  - name: environment_filter
    title: "Environment"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.environment

  - name: aws_account_filter
    title: "AWS Account"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_account_name

  elements:
  # =====================================================
  # SECTION 1: PRODUCT-LEVEL COSTS
  # =====================================================
  - name: section_product_costs
    type: text
    title_text: "<h2>📊 Product-Level Costs</h2>"
    subtitle_text: "Track infrastructure costs by product, feature, and team"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total Product Infrastructure Cost"
    name: total_product_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL PRODUCT COST"
      value_format: "$#,##0"
      conditional_formatting:
      - type: greater than
        value: 100000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 2
    col: 0
    width: 6
    height: 4

  - title: "Month-over-Month Cost Change"
    name: mom_cost_change
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.month_over_month_change]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "MOM COST GROWTH"
      value_format: "+#,##0.0%"
      conditional_formatting:
      - type: greater than
        value: 15
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
      - type: less than
        value: 5
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 2
    col: 6
    width: 6
    height: 4

  - title: "Active Products Count"
    name: active_products
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_projects]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ACTIVE PRODUCTS"
      value_format: "#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 2
    col: 12
    width: 6
    height: 4

  - title: "Cost per Product"
    name: cost_per_product_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.count_projects]
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_product
      label: Cost per Product
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_projects}, 0)"
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "AVG COST PER PRODUCT"
      value_format: "$#,##0"
    hidden_fields: [cur2.total_unblended_cost, cur2.count_projects]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 2
    col: 18
    width: 6
    height: 4

  - title: "Cost by Product (12-Month Trend)"
    name: cost_by_product_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.project, cur2.total_unblended_cost]
    pivots: [cur2.project]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 500
    column_limit: 10
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
      limit_displayed_rows: false
      legend_position: center
      point_style: circle
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: true
      interpolation: linear
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "Product Cost"
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Product Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 6
    col: 0
    width: 16
    height: 8

  - title: "New vs Legacy Product Costs"
    name: new_vs_legacy_products
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.project, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      series_colors: {}
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 6
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION 2: UNIT ECONOMICS
  # =====================================================
  - name: section_unit_economics
    type: text
    title_text: "<h2>💰 Unit Economics</h2>"
    subtitle_text: "Cost efficiency metrics and unit cost trends"
    body_text: ""
    row: 14
    col: 0
    width: 24
    height: 2

  - title: "Cost per Resource"
    name: cost_per_resource_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_per_resource]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER RESOURCE"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: less than
        value: 50
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: greater than
        value: 200
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 16
    col: 0
    width: 6
    height: 4

  - title: "Cost per Compute Hour"
    name: cost_per_compute_hour_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_per_compute_hour]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER COMPUTE HOUR"
      value_format: "$#,##0.000"
      conditional_formatting:
      - type: less than
        value: 0.5
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 16
    col: 6
    width: 6
    height: 4

  - title: "Cost per GB Storage"
    name: cost_per_gb_storage_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_per_gb_storage]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER GB STORAGE"
      value_format: "$#,##0.000"
      conditional_formatting:
      - type: less than
        value: 0.05
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 16
    col: 12
    width: 6
    height: 4

  - title: "Cost Efficiency Score"
    name: efficiency_score_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.resource_efficiency_score]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST EFFICIENCY SCORE"
      value_format: "#,##0"
      conditional_formatting:
      - type: greater than
        value: 80
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: less than
        value: 60
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 16
    col: 18
    width: 6
    height: 4

  - title: "Unit Cost Trends (90 Days)"
    name: unit_cost_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.cost_per_resource, cur2.cost_per_compute_hour, cur2.cost_per_gb_storage]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
      limit_displayed_rows: false
      legend_position: center
      point_style: circle
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: true
      interpolation: linear
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      series_colors:
        cur2.cost_per_resource: "#1f77b4"
        cur2.cost_per_compute_hour: "#ff7f0e"
        cur2.cost_per_gb_storage: "#2ca02c"
      y_axes:
      - label: "Unit Cost"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "$#,##0.00"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 20
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 3: ENVIRONMENT DISTRIBUTION
  # =====================================================
  - name: section_environment
    type: text
    title_text: "<h2>🏗️ Environment Distribution</h2>"
    subtitle_text: "Production vs non-production cost allocation"
    body_text: ""
    row: 28
    col: 0
    width: 24
    height: 2

  - title: "Production Costs"
    name: production_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.environment_production_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "PRODUCTION COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      aws_account_filter: cur2.line_item_usage_account_name
    row: 30
    col: 0
    width: 6
    height: 4

  - title: "Staging/QA Costs"
    name: staging_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.environment_staging_cost, cur2.environment_test_cost]
    limit: 1
    dynamic_fields:
    - measure: staging_qa_total
      label: Staging/QA Total
      based_on: cur2.total_unblended_cost
      expression: "${cur2.environment_staging_cost} + ${cur2.environment_test_cost}"
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "STAGING/QA COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      aws_account_filter: cur2.line_item_usage_account_name
    row: 30
    col: 6
    width: 6
    height: 4

  - title: "Development Costs"
    name: development_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.environment_development_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "DEVELOPMENT COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      aws_account_filter: cur2.line_item_usage_account_name
    row: 30
    col: 12
    width: 6
    height: 4

  - title: "Non-Production Waste %"
    name: non_prod_waste
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.environment_production_cost, cur2.environment_development_cost, cur2.environment_staging_cost, cur2.environment_test_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: non_prod_percentage
      label: Non-Prod Waste %
      expression: |
        (${cur2.environment_development_cost} + ${cur2.environment_staging_cost} + ${cur2.environment_test_cost}) /
        nullif((${cur2.environment_production_cost} + ${cur2.environment_development_cost} + ${cur2.environment_staging_cost} + ${cur2.environment_test_cost}), 0) * 100
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "NON-PROD WASTE %"
      value_format: "#,##0.0%"
      conditional_formatting:
      - type: greater than
        value: 40
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
      - type: less than
        value: 20
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    hidden_fields: [cur2.environment_production_cost, cur2.environment_development_cost, cur2.environment_staging_cost, cur2.environment_test_cost]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      aws_account_filter: cur2.line_item_usage_account_name
    row: 30
    col: 18
    width: 6
    height: 4

  - title: "Environment Cost Distribution"
    name: environment_distribution
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.environment, cur2.total_unblended_cost, cur2.line_item_usage_start_month]
    pivots: [cur2.environment]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 500
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
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
      show_totals_labels: true
      show_silhouette: false
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "Environment Cost"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      aws_account_filter: cur2.line_item_usage_account_name
    row: 34
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 4: PRODUCT MARGIN ANALYSIS
  # =====================================================
  - name: section_margin_analysis
    type: text
    title_text: "<h2>📈 Product Margin Analysis</h2>"
    subtitle_text: "Margin tracking and optimization opportunities"
    body_text: ""
    row: 42
    col: 0
    width: 24
    height: 2

  - title: "Total Product Costs"
    name: total_product_costs_margin
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL PRODUCT COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 44
    col: 0
    width: 6
    height: 4

  - title: "MoM Cost Growth"
    name: mom_growth_margin
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.month_over_month_change]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "MOM GROWTH"
      value_format: "+#,##0.0%"
      conditional_formatting:
      - type: greater than
        value: 20
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
      - type: less than
        value: 5
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 44
    col: 6
    width: 6
    height: 4

  - title: "Cost per Environment"
    name: cost_per_env
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.count_environments]
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_env_calc
      label: Cost per Environment
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_environments}, 0)"
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER ENVIRONMENT"
      value_format: "$#,##0"
    hidden_fields: [cur2.total_unblended_cost, cur2.count_environments]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 44
    col: 12
    width: 6
    height: 4

  - title: "Optimization Opportunities"
    name: optimization_opps
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "OPTIMIZATION SAVINGS POTENTIAL"
      value_format: "$#,##0"
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 44
    col: 18
    width: 6
    height: 4

  - title: "Product Margin Trend"
    name: product_margin_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_month, cur2.project, cur2.total_unblended_cost]
    pivots: [cur2.project]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 500
    column_limit: 8
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
      stacking: normal
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
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "Product Cost"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 48
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 5: SERVICE BREAKDOWN BY PRODUCT
  # =====================================================
  - name: section_service_breakdown
    type: text
    title_text: "<h2>🔧 Service Breakdown by Product</h2>"
    subtitle_text: "Infrastructure service costs allocated to products"
    body_text: ""
    row: 56
    col: 0
    width: 24
    height: 2

  - title: "Compute Costs (EC2, Lambda)"
    name: compute_costs
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.ec2_cost, cur2.lambda_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: total_compute
      label: Total Compute
      expression: "${cur2.ec2_cost} + ${cur2.lambda_cost}"
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COMPUTE COSTS"
      value_format: "$#,##0"
    hidden_fields: [cur2.ec2_cost, cur2.lambda_cost]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 58
    col: 0
    width: 6
    height: 4

  - title: "Database Costs (RDS)"
    name: database_costs
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.rds_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "DATABASE COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 58
    col: 6
    width: 6
    height: 4

  - title: "Storage Costs (S3)"
    name: storage_costs
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.s3_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "STORAGE COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 58
    col: 12
    width: 6
    height: 4

  - title: "CDN Costs (CloudFront)"
    name: cdn_costs
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cloudfront_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "CDN COSTS"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 58
    col: 18
    width: 6
    height: 4

  - title: "Service Costs by Product"
    name: service_by_product
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.ec2_cost, cur2.lambda_cost, cur2.rds_cost, cur2.s3_cost, cur2.cloudfront_cost, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: other_services
      label: Other Services
      expression: "${cur2.total_unblended_cost} - (${cur2.ec2_cost} + ${cur2.lambda_cost} + ${cur2.rds_cost} + ${cur2.s3_cost} + ${cur2.cloudfront_cost})"
      _type_hint: number
    visualization_config:
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
        value: 5000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      series_value_format:
        cur2.ec2_cost: "$#,##0"
        cur2.lambda_cost: "$#,##0"
        cur2.rds_cost: "$#,##0"
        cur2.s3_cost: "$#,##0"
        cur2.cloudfront_cost: "$#,##0"
        cur2.total_unblended_cost: "$#,##0"
        other_services: "$#,##0"
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 62
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 6: GROWTH METRICS
  # =====================================================
  - name: section_growth_metrics
    type: text
    title_text: "<h2>📊 Growth Metrics</h2>"
    subtitle_text: "Cost growth vs usage growth and infrastructure scaling"
    body_text: ""
    row: 70
    col: 0
    width: 24
    height: 2

  - title: "Cost Growth Rate"
    name: cost_growth_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.month_over_month_change]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST GROWTH RATE (MOM)"
      value_format: "+#,##0.0%"
      conditional_formatting:
      - type: greater than
        value: 15
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
      - type: between
        value: [5, 15]
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
      - type: less than
        value: 5
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 72
    col: 0
    width: 6
    height: 4

  - title: "New Service Adoption"
    name: new_service_adoption
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_services]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ACTIVE SERVICES"
      value_format: "#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 72
    col: 6
    width: 6
    height: 4

  - title: "Infrastructure Scaling"
    name: infrastructure_scaling
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL RESOURCES"
      value_format: "#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 72
    col: 12
    width: 6
    height: 4

  - title: "Cost per New Feature"
    name: cost_per_feature
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_feature_calc
      label: Cost per Feature
      expression: "${cur2.total_unblended_cost} / 25"
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "EST. COST PER NEW FEATURE"
      value_format: "$#,##0"
    hidden_fields: [cur2.total_unblended_cost]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 72
    col: 18
    width: 6
    height: 4

  - title: "Cost vs Usage Growth Comparison"
    name: cost_vs_usage_growth
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost, cur2.total_usage_amount]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
    dynamic_fields:
    - table_calculation: cost_index
      label: Cost Index
      expression: "(${cur2.total_unblended_cost} / offset(${cur2.total_unblended_cost}, 11)) * 100"
      _type_hint: number
    - table_calculation: usage_index
      label: Usage Index
      expression: "(${cur2.total_usage_amount} / offset(${cur2.total_usage_amount}, 11)) * 100"
      _type_hint: number
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
      limit_displayed_rows: false
      legend_position: center
      point_style: circle
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_null_points: true
      interpolation: linear
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      series_colors:
        cost_index: "#dc2626"
        usage_index: "#16a34a"
      y_axes:
      - label: "Growth Index"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost, cur2.total_usage_amount]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 76
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 7: PRODUCT ROI VIEW
  # =====================================================
  - name: section_roi
    type: text
    title_text: "<h2>💵 Product ROI View</h2>"
    subtitle_text: "Return on investment and efficiency gains"
    body_text: ""
    row: 84
    col: 0
    width: 24
    height: 2

  - title: "Total Product Spend"
    name: total_spend_roi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL PRODUCT SPEND"
      value_format: "$#,##0"
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 86
    col: 0
    width: 6
    height: 4

  - title: "Savings Realized"
    name: savings_realized
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_savings_realized]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "SAVINGS REALIZED"
      value_format: "$#,##0"
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 86
    col: 6
    width: 6
    height: 4

  - title: "Waste Reduction"
    name: waste_reduction
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_commitment_waste]
    limit: 1
    dynamic_fields:
    - table_calculation: waste_avoided
      label: Waste Avoided
      expression: "${cur2.total_commitment_waste} * 0.3"
      _type_hint: number
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "WASTE AVOIDED"
      value_format: "$#,##0"
      conditional_formatting:
      - type: greater than
        value: 5000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    hidden_fields: [cur2.total_commitment_waste]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 86
    col: 12
    width: 6
    height: 4

  - title: "Efficiency Gains"
    name: efficiency_gains
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.effective_savings_rate]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "EFFICIENCY GAINS"
      value_format: "#,##0.0%"
      conditional_formatting:
      - type: greater than
        value: 15
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: less than
        value: 5
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 86
    col: 18
    width: 6
    height: 4

  - title: "ROI Trend by Product"
    name: roi_trend_by_product
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.project, cur2.total_unblended_cost, cur2.total_savings_realized, cur2.line_item_usage_start_month]
    pivots: [cur2.line_item_usage_start_month]
    sorts: [cur2.total_unblended_cost desc 0]
    limit: 10
    column_limit: 6
    dynamic_fields:
    - table_calculation: roi_percentage
      label: ROI %
      expression: "(${cur2.total_savings_realized} / nullif(${cur2.total_unblended_cost}, 0)) * 100"
      _type_hint: number
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
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
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "ROI %"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "#,##0.0%"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost, cur2.total_savings_realized]
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 90
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 8: COMPARATIVE ANALYSIS
  # =====================================================
  - name: section_comparative
    type: text
    title_text: "<h2>🔀 Comparative Analysis</h2>"
    subtitle_text: "Product-to-product and team-level cost comparisons"
    body_text: ""
    row: 98
    col: 0
    width: 24
    height: 2

  - title: "Product Cost Comparison"
    name: product_comparison
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.project, cur2.total_unblended_cost, cur2.count_unique_resources, cur2.resource_efficiency_score]
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: cost_per_resource_comp
      label: Cost per Resource
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      _type_hint: number
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
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
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      series_colors:
        cur2.total_unblended_cost: "#1f77b4"
      y_axes:
      - label: "Total Cost"
        orientation: bottom
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 100
    col: 0
    width: 12
    height: 8

  - title: "Team-Level Cost Comparison"
    name: team_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.total_unblended_cost, cur2.environment_production_cost, cur2.environment_development_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
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
      show_totals_labels: true
      show_silhouette: false
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "Team Cost"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 100
    col: 12
    width: 12
    height: 8

  - title: "Resource Efficiency by Product"
    name: efficiency_by_product
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.total_unblended_cost, cur2.count_unique_resources, cur2.resource_efficiency_score, cur2.month_over_month_change]
    sorts: [cur2.resource_efficiency_score desc]
    limit: 20
    dynamic_fields:
    - table_calculation: efficiency_rating
      label: Efficiency Rating
      expression: |
        if(${cur2.resource_efficiency_score} >= 80, "Excellent",
          if(${cur2.resource_efficiency_score} >= 60, "Good",
            if(${cur2.resource_efficiency_score} >= 40, "Fair", "Needs Improvement")))
      _type_hint: string
    visualization_config:
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
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [cur2.resource_efficiency_score]
      - type: between
        value: [60, 80]
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [cur2.resource_efficiency_score]
      - type: less than
        value: 60
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: false
        fields: [cur2.resource_efficiency_score]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
        cur2.month_over_month_change: "+#,##0.0%"
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 108
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 9: PRODUCT COST TABLE
  # =====================================================
  - name: section_cost_table
    type: text
    title_text: "<h2>📋 Product Cost Detail Table</h2>"
    subtitle_text: "Comprehensive export-ready cost breakdown with drill-down capability"
    body_text: ""
    row: 116
    col: 0
    width: 24
    height: 2

  - title: "Product Cost Detail Table"
    name: product_cost_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.environment, cur2.line_item_product_code, cur2.total_unblended_cost, cur2.count_unique_resources, cur2.line_item_usage_start_month]
    pivots: [cur2.line_item_usage_start_month]
    sorts: [cur2.total_unblended_cost desc 0, cur2.line_item_usage_start_month]
    limit: 100
    column_limit: 6
    dynamic_fields:
    - table_calculation: percent_of_total
      label: "% of Total"
      expression: "${cur2.total_unblended_cost} / sum(${cur2.total_unblended_cost}) * 100"
      _type_hint: number
    visualization_config:
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
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      - type: greater than
        value: 10
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
        fields: [percent_of_total]
      series_cell_visualizations:
        cur2.total_unblended_cost:
          is_active: true
          palette:
            palette_id: custom_heatmap
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#ffffff"
            - "#e0f2fe"
            - "#0ea5e9"
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
        percent_of_total: "#,##0.0%"
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 118
    col: 0
    width: 24
    height: 12

  # =====================================================
  # SECTION 10: SUSTAINABILITY BY PRODUCT
  # =====================================================
  - name: section_sustainability
    type: text
    title_text: "<h2>🌱 Sustainability by Product</h2>"
    subtitle_text: "Carbon footprint and environmental impact tracking"
    body_text: ""
    row: 130
    col: 0
    width: 24
    height: 2

  - title: "Carbon Emissions (kg CO₂)"
    name: carbon_emissions
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.estimated_carbon_emissions_kg]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "CARBON EMISSIONS (kg CO₂)"
      value_format: "#,##0"
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
      - type: less than
        value: 5000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 132
    col: 0
    width: 6
    height: 4

  - title: "Green Energy Usage"
    name: green_energy_usage
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.renewable_energy_percentage]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "GREEN ENERGY USAGE"
      value_format: "#,##0.0%"
      conditional_formatting:
      - type: greater than
        value: 50
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: less than
        value: 25
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 132
    col: 6
    width: 6
    height: 4

  - title: "Sustainability Score"
    name: sustainability_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.sustainability_score]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "SUSTAINABILITY SCORE"
      value_format: "#,##0"
      conditional_formatting:
      - type: greater than
        value: 75
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
      - type: less than
        value: 50
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 132
    col: 12
    width: 6
    height: 4

  - title: "Optimization Potential (kg CO₂)"
    name: carbon_reduction_potential
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.carbon_reduction_potential_kg]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "CARBON REDUCTION POTENTIAL"
      value_format: "#,##0 kg"
      conditional_formatting:
      - type: greater than
        value: 2000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 132
    col: 18
    width: 6
    height: 4

  - title: "Carbon Emissions by Product"
    name: carbon_by_product
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.project, cur2.estimated_carbon_emissions_kg, cur2.line_item_usage_start_month]
    pivots: [cur2.project]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 500
    column_limit: 10
    visualization_config:
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
      plot_size_by_field: false
      trellis: ""
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
      show_totals_labels: true
      show_silhouette: false
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "Carbon Emissions (kg)"
        orientation: left
        showLabels: true
        showValues: true
        valueFormat: "#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 136
    col: 0
    width: 16
    height: 8

  - title: "Sustainability Recommendations"
    name: sustainability_recommendations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.sustainability_score, cur2.estimated_carbon_emissions_kg, cur2.carbon_reduction_potential_kg, cur2.renewable_energy_percentage]
    sorts: [cur2.carbon_reduction_potential_kg desc]
    limit: 15
    dynamic_fields:
    - dimension: recommendation
      label: Recommendation
      expression: |
        if(${cur2.carbon_reduction_potential_kg} > 2000, "High Priority - Significant carbon reduction opportunity",
          if(${cur2.sustainability_score} < 50, "Medium Priority - Improve sustainability practices",
            if(${cur2.renewable_energy_percentage} < 30, "Low Priority - Consider green energy options",
              "Performing Well - Maintain current practices")))
      _type_hint: string
    visualization_config:
      show_view_names: false
      show_row_numbers: true
      transpose: false
      truncate_text: false
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
      - type: greater than
        value: 75
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [cur2.sustainability_score]
      - type: less than
        value: 50
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
        fields: [cur2.sustainability_score]
      - type: greater than
        value: 2000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.carbon_reduction_potential_kg]
      series_value_format:
        cur2.estimated_carbon_emissions_kg: "#,##0 kg"
        cur2.carbon_reduction_potential_kg: "#,##0 kg"
        cur2.renewable_energy_percentage: "#,##0.0%"
      defaults_version: 1
    listen:
      time_period: cur2.line_item_usage_start_date
      product_filter: cur2.project
      team_filter: cur2.team
      environment_filter: cur2.environment
      aws_account_filter: cur2.line_item_usage_account_name
    row: 136
    col: 16
    width: 8
    height: 8
