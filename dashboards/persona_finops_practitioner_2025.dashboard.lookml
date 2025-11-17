---
# =====================================================
# FINOPS PRACTITIONER PERSONA DASHBOARD 2025
# =====================================================
# Future-proof FinOps Practitioner dashboard for Cloud Economists
# and Cloud Financial Analysts
#
# Persona: FinOps Lead, Cloud Economist, Cloud Financial Analyst
# Focus: Detailed optimization, commitment management, showback/chargeback,
#        anomaly detection, and actionable insights
#
# Author: Claude FinOps Dashboard Generator
# Created: 2025-11-17
# Version: 1.0.0
# =====================================================

- dashboard: persona_finops_practitioner_2025
  title: 💼 FinOps Practitioner Command Center 2025
  description: 'Advanced FinOps dashboard for practitioners focused on commitment optimization, cost allocation, waste reduction, and anomaly detection'
  layout: newspaper
  preferred_viewer: dashboards-next

  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
  load_configuration: wait
  crossfilter_enabled: true

  # Styling
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'

  # =====================================================
  # COMPREHENSIVE FILTERS
  # =====================================================

  filters:
  - name: Date Range
    title: 📅 Date Range
    type: field_filter
    default_value: '30 days ago for 30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
        - '7 days ago for 7 days'
        - '14 days ago for 14 days'
        - '30 days ago for 30 days'
        - '60 days ago for 60 days'
        - '90 days ago for 90 days'
        - 'this month'
        - 'last month'
        - 'this quarter'
        - 'last quarter'
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
    listens_to_filters: [AWS Service, Environment, Team, Cost Center]
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
    listens_to_filters: [AWS Service]
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
    listens_to_filters: [AWS Account, Environment, Cost Center]
    field: cur2.team

  - name: Project
    title: 📁 Project
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Team, Environment]
    field: cur2.project

  - name: Cost Center
    title: 💰 Cost Center
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Team, AWS Account]
    field: cur2.cost_center

  - name: Region
    title: 🌐 Region
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
    field: cur2.region

  - name: Pricing Term
    title: 💳 Pricing Term
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options:
        - OnDemand
        - Reserved
        - Spot
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.pricing_term

  elements:
  # =====================================================
  # SECTION 1: COMMITMENT OPTIMIZATION
  # =====================================================

  - title: 📊 COMMITMENT OPTIMIZATION
    name: commitment_optimization_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    query_timezone: America/Los_Angeles
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: COMMITMENT OPTIMIZATION OVERVIEW
    value_format: ''
    note_display: hover
    note_text: 'Track Reserved Instance and Savings Plan utilization, coverage, and optimization opportunities'
    row: 0
    col: 0
    width: 24
    height: 2

  - title: 🎯 RI Utilization Rate
    name: ri_utilization_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.ri_utilization_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: RI UTILIZATION
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.85
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.70, 0.85]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.70
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 2
    col: 0
    width: 4
    height: 4

  - title: 💚 SP Utilization Rate
    name: sp_utilization_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.savings_plan_utilization_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: SAVINGS PLAN UTILIZATION
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.90
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.75, 0.90]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.75
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 2
    col: 4
    width: 4
    height: 4

  - title: 📈 Commitment Coverage
    name: commitment_coverage
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.commitment_coverage_percentage]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: COMMITMENT COVERAGE
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.70
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.50, 0.70]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.50
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 2
    col: 8
    width: 4
    height: 4

  - title: 💰 Total Commitment Savings
    name: total_commitment_savings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_commitment_savings, cur2.effective_savings_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Effective Rate
    single_value_title: COMMITMENT SAVINGS
    value_format: "$#,##0"
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 2
    col: 12
    width: 6
    height: 4

  - title: 🏥 Commitment Health Score
    name: commitment_health_score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.commitment_health_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: HEALTH SCORE
    value_format: "0"
    conditional_formatting:
    - type: greater than
      value: 85
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [70, 85]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 70
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 2
    col: 18
    width: 6
    height: 4

  - title: 📊 RI vs SP Cost Comparison
    name: ri_vs_sp_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_month, cur2.total_ri_cost, cur2.total_savings_plan_cost,
             cur2.total_on_demand_cost]
    fill_fields: [cur2.line_item_usage_start_month]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: '#808080'
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: looker-color-palette-1
      options:
        steps: 3
    series_colors:
      cur2.total_ri_cost: '#3b82f6'
      cur2.total_savings_plan_cost: '#10b981'
      cur2.total_on_demand_cost: '#f59e0b'
    series_labels:
      cur2.total_ri_cost: Reserved Instances
      cur2.total_savings_plan_cost: Savings Plans
      cur2.total_on_demand_cost: On-Demand
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 6
    col: 0
    width: 12
    height: 8

  - title: 🔍 Commitment Utilization Trends
    name: commitment_utilization_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.ri_utilization_rate,
             cur2.savings_plan_utilization_rate, cur2.commitment_coverage_percentage]
    fill_fields: [cur2.line_item_usage_start_date]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: cur2.ri_utilization_rate,
            id: cur2.ri_utilization_rate, name: RI Utilization}, {axisId: cur2.savings_plan_utilization_rate,
            id: cur2.savings_plan_utilization_rate, name: SP Utilization}, {axisId: cur2.commitment_coverage_percentage,
            id: cur2.commitment_coverage_percentage, name: Coverage %}], showLabels: true,
        showValues: true, valueFormat: '0%', unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_colors:
      cur2.ri_utilization_rate: '#3b82f6'
      cur2.savings_plan_utilization_rate: '#10b981'
      cur2.commitment_coverage_percentage: '#8b5cf6'
    series_labels:
      cur2.ri_utilization_rate: RI Utilization
      cur2.savings_plan_utilization_rate: SP Utilization
      cur2.commitment_coverage_percentage: Coverage %
    reference_lines: [{reference_type: line, line_value: '0.80', range_start: max, range_end: min,
        margin_top: deviation, margin_value: mean, margin_bottom: deviation, label_position: right,
        color: '#10b981', label: 'Target 80%'}]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 6
    col: 12
    width: 12
    height: 8

  - title: 💸 Commitment Waste Analysis
    name: commitment_waste_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_ri_unused_cost,
             cur2.savings_plan_unused_commitment, cur2.total_commitment_waste, cur2.waste_percentage]
    filters:
      cur2.total_commitment_waste: '>0'
    sorts: [cur2.total_commitment_waste desc]
    limit: 20
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
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_ri_unused_cost, cur2.savings_plan_unused_commitment, cur2.total_commitment_waste]
    - type: greater than
      value: 0.10
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.waste_percentage]
    series_cell_visualizations:
      cur2.total_commitment_waste:
        is_active: true
        palette:
          palette_id: looker-color-palette-diverging-0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_labels:
      cur2.line_item_product_code: Service
      cur2.total_ri_unused_cost: RI Unused Cost
      cur2.savings_plan_unused_commitment: SP Unused Cost
      cur2.total_commitment_waste: Total Waste
      cur2.waste_percentage: Waste %
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 14
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 2: COST ALLOCATION & CHARGEBACK
  # =====================================================

  - title: 💼 COST ALLOCATION & CHARGEBACK
    name: cost_allocation_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: COST ALLOCATION & CHARGEBACK ANALYSIS
    value_format: ''
    note_display: hover
    note_text: 'Track costs by account, team, project, and analyze tag compliance for accurate chargeback'
    row: 22
    col: 0
    width: 24
    height: 2

  - title: 💰 Total Tagged Cost
    name: total_tagged_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_tagged_cost, cur2.tag_coverage_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Tag Coverage
    single_value_title: TAGGED COST
    value_format: "$#,##0"
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 24
    col: 0
    width: 6
    height: 4

  - title: 🏷️ Untagged Resource Cost
    name: untagged_resource_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_untagged_cost]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: UNTAGGED COST
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    - type: between
      value: [1000, 10000]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 1000
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 24
    col: 6
    width: 6
    height: 4

  - title: 📊 Tag Coverage Rate
    name: tag_coverage_rate
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.tag_coverage_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: TAG COVERAGE
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.90
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.70, 0.90]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.70
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 24
    col: 12
    width: 6
    height: 4

  - title: 🎯 Allocation Metrics
    name: allocation_metrics
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.count_teams, cur2.count_projects, cur2.count_environments,
             cur2.count_unique_accounts]
    limit: 1
    show_view_names: false
    show_row_numbers: false
    transpose: true
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    series_labels:
      cur2.count_teams: Teams
      cur2.count_projects: Projects
      cur2.count_environments: Environments
      cur2.count_unique_accounts: Accounts
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 24
    col: 18
    width: 6
    height: 4

  - title: 🏢 Cost by Account with Drill-down
    name: cost_by_account
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost,
             cur2.month_over_month_change, cur2.total_discount_amount]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
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
      palette_id: looker-color-palette-1
      options:
        steps: 5
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
    series_labels:
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Total Cost
      cur2.month_over_month_change: MoM Change
      cur2.total_discount_amount: Discounts
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 28
    col: 0
    width: 12
    height: 8

  - title: 👥 Cost by Team/Project
    name: cost_by_team_project
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.team, cur2.total_unblended_cost]
    filters:
      cur2.team: '-NULL'
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: looker-color-palette-1
      options:
        steps: 5
    series_colors: {}
    series_labels:
      cur2.team: Team
      cur2.total_unblended_cost: Cost
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 28
    col: 12
    width: 12
    height: 8

  - title: 📋 Tag Compliance by Service
    name: tag_compliance_by_service
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.total_tagged_cost,
             cur2.total_untagged_cost, cur2.tag_coverage_rate, cur2.has_team_tag, cur2.has_environment_tag]
    sorts: [cur2.total_unblended_cost desc]
    limit: 25
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
    - type: less than
      value: 0.80
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.tag_coverage_rate]
    - type: greater than
      value: 1000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_untagged_cost]
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
      cur2.tag_coverage_rate:
        is_active: true
    series_labels:
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Total Cost
      cur2.total_tagged_cost: Tagged Cost
      cur2.total_untagged_cost: Untagged Cost
      cur2.tag_coverage_rate: Coverage %
      cur2.has_team_tag: Has Team Tag
      cur2.has_environment_tag: Has Env Tag
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 36
    col: 0
    width: 24
    height: 10

  - title: 💳 Showback/Chargeback Table
    name: showback_chargeback_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.cost_center, cur2.environment, cur2.total_unblended_cost,
             cur2.team_cost_allocation, cur2.total_commitment_savings, cur2.total_discount_amount]
    filters:
      cur2.team: '-NULL'
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
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
      value: 10000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_unblended_cost]
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
      cur2.team_cost_allocation:
        is_active: true
    series_labels:
      cur2.team: Team
      cur2.cost_center: Cost Center
      cur2.environment: Environment
      cur2.total_unblended_cost: Total Cost
      cur2.team_cost_allocation: Allocated Cost
      cur2.total_commitment_savings: Commitment Savings
      cur2.total_discount_amount: Discounts
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 46
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 3: WASTE & OPTIMIZATION
  # =====================================================

  - title: 🗑️ WASTE & OPTIMIZATION
    name: waste_optimization_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: WASTE DETECTION & OPTIMIZATION OPPORTUNITIES
    value_format: ''
    note_display: hover
    note_text: 'Identify and track waste from unused commitments, idle resources, and non-production environments'
    row: 56
    col: 0
    width: 24
    height: 2

  - title: 💸 Total Waste Detected
    name: total_waste_detected
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_commitment_waste, cur2.waste_percentage]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: true
    show_comparison_label: true
    comparison_label: Waste %
    single_value_title: TOTAL WASTE
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    - type: between
      value: [1000, 10000]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 1000
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 58
    col: 0
    width: 6
    height: 4

  - title: 💡 Right-sizing Opportunity
    name: rightsizing_opportunity
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: RIGHT-SIZING SAVINGS
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 5000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 58
    col: 6
    width: 6
    height: 4

  - title: 🌐 Data Transfer Waste
    name: data_transfer_waste
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_data_transfer_cost, cur2.transfer_optimization_savings]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Potential Savings
    single_value_title: DATA TRANSFER COST
    value_format: "$#,##0"
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 58
    col: 12
    width: 6
    height: 4

  - title: 🎮 Waste Detection Score
    name: waste_detection_score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.waste_detection_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: WASTE DETECTION
    value_format: "0"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [60, 80]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 60
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 58
    col: 18
    width: 6
    height: 4

  - title: 🔧 Unused RI/SP Analysis
    name: unused_ri_sp_analysis
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_month, cur2.total_ri_unused_cost,
             cur2.savings_plan_unused_commitment, cur2.total_commitment_waste]
    fill_fields: [cur2.line_item_usage_start_month]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: '#808080'
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: looker-color-palette-2
      options:
        steps: 3
    series_colors:
      cur2.total_ri_unused_cost: '#ef4444'
      cur2.savings_plan_unused_commitment: '#f97316'
      cur2.total_commitment_waste: '#dc2626'
    series_labels:
      cur2.total_ri_unused_cost: Unused RI
      cur2.savings_plan_unused_commitment: Unused SP
      cur2.total_commitment_waste: Total Waste
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 62
    col: 0
    width: 12
    height: 8

  - title: 🌍 Non-Production Environment Costs
    name: non_production_costs
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.environment_production_cost, cur2.environment_development_cost,
             cur2.environment_staging_cost, cur2.environment_test_cost]
    limit: 1
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: looker-color-palette-1
      options:
        steps: 5
    series_colors:
      cur2.environment_production_cost: '#10b981'
      cur2.environment_development_cost: '#3b82f6'
      cur2.environment_staging_cost: '#f59e0b'
      cur2.environment_test_cost: '#8b5cf6'
    series_labels:
      cur2.environment_production_cost: Production
      cur2.environment_development_cost: Development
      cur2.environment_staging_cost: Staging
      cur2.environment_test_cost: Test
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 62
    col: 12
    width: 12
    height: 8

  - title: 📊 Waste by Service Category
    name: waste_by_service
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.service_category, cur2.total_commitment_waste, cur2.right_sizing_opportunity,
             cur2.transfer_optimization_savings, cur2.waste_percentage, cur2.total_unblended_cost]
    filters:
      cur2.total_commitment_waste: '>0'
    sorts: [cur2.total_commitment_waste desc]
    limit: 20
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
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_commitment_waste, cur2.right_sizing_opportunity]
    - type: greater than
      value: 0.15
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.waste_percentage]
    series_cell_visualizations:
      cur2.total_commitment_waste:
        is_active: true
        palette:
          palette_id: looker-color-palette-diverging-0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      cur2.right_sizing_opportunity:
        is_active: true
    series_labels:
      cur2.service_category: Service Category
      cur2.total_commitment_waste: Commitment Waste
      cur2.right_sizing_opportunity: Right-sizing Opp
      cur2.transfer_optimization_savings: Data Transfer Savings
      cur2.waste_percentage: Waste %
      cur2.total_unblended_cost: Total Cost
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 70
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 4: ANOMALY DETECTION
  # =====================================================

  - title: 🚨 ANOMALY DETECTION
    name: anomaly_detection_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: COST ANOMALY DETECTION & VARIANCE ANALYSIS
    value_format: ''
    note_display: hover
    note_text: 'Detect unusual spending patterns and cost anomalies across services and accounts'
    row: 80
    col: 0
    width: 24
    height: 2

  - title: ⚠️ Cost Anomaly Score
    name: cost_anomaly_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_anomaly_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: ANOMALY SCORE
    value_format: "0.00"
    conditional_formatting:
    - type: greater than
      value: 2.0
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    - type: between
      value: [1.0, 2.0]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 1.0
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 82
    col: 0
    width: 6
    height: 4

  - title: 📊 Cost Z-Score
    name: cost_z_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_z_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: COST Z-SCORE
    value_format: "0.00"
    conditional_formatting:
    - type: greater than
      value: 3.0
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    - type: between
      value: [2.0, 3.0]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 2.0
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 82
    col: 6
    width: 6
    height: 4

  - title: 📈 Cost Variance %
    name: cost_variance_pct
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_variance_pct]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: COST VARIANCE
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.20
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    - type: between
      value: [0.10, 0.20]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.10
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 82
    col: 12
    width: 6
    height: 4

  - title: 🔔 Anomaly Flag Count
    name: anomaly_flag_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.is_cost_anomaly]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: ANOMALIES DETECTED
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 10
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    - type: between
      value: [1, 10]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: equal to
      value: 0
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 82
    col: 18
    width: 6
    height: 4

  - title: 📉 Anomaly Timeline
    name: anomaly_timeline
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost,
             cur2.cost_anomaly_score, cur2.cost_z_score]
    fill_fields: [cur2.line_item_usage_start_date]
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
    y_axes: [{label: Cost, orientation: left, series: [{axisId: cur2.total_unblended_cost,
            id: cur2.total_unblended_cost, name: Total Cost}], showLabels: true,
        showValues: true, valueFormat: "$#,##0", unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: Anomaly Metrics, orientation: right,
        series: [{axisId: cur2.cost_anomaly_score, id: cur2.cost_anomaly_score, name: Anomaly
              Score}, {axisId: cur2.cost_z_score, id: cur2.cost_z_score, name: Z-Score}],
        showLabels: true, showValues: true, valueFormat: '0.00', unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
      cur2.cost_anomaly_score: '#ef4444'
      cur2.cost_z_score: '#f59e0b'
    series_labels:
      cur2.total_unblended_cost: Cost
      cur2.cost_anomaly_score: Anomaly Score
      cur2.cost_z_score: Z-Score
    reference_lines: [{reference_type: line, line_value: '2', range_start: max, range_end: min,
        margin_top: deviation, margin_value: mean, margin_bottom: deviation, label_position: right,
        color: '#ef4444', label: 'Anomaly Threshold', y_axis_index: 1}]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 86
    col: 0
    width: 24
    height: 8

  - title: 🔍 Services with Unusual Spend
    name: services_unusual_spend
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.cost_anomaly_score,
             cur2.cost_z_score, cur2.cost_variance_pct, cur2.month_over_month_change]
    filters:
      cur2.cost_anomaly_score: '>1.5'
    sorts: [cur2.cost_anomaly_score desc]
    limit: 25
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
      value: 2.0
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.cost_anomaly_score, cur2.cost_z_score]
    - type: greater than
      value: 0.20
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.cost_variance_pct, cur2.month_over_month_change]
    series_cell_visualizations:
      cur2.cost_anomaly_score:
        is_active: true
        palette:
          palette_id: looker-color-palette-diverging-0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      cur2.total_unblended_cost:
        is_active: true
    series_labels:
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Total Cost
      cur2.cost_anomaly_score: Anomaly Score
      cur2.cost_z_score: Z-Score
      cur2.cost_variance_pct: Variance %
      cur2.month_over_month_change: MoM Change
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 94
    col: 0
    width: 24
    height: 10

  - title: 📊 Day-over-Day Variance Analysis
    name: day_over_day_variance
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_start_date, cur2.line_item_product_code, cur2.total_unblended_cost,
             cur2.cost_variance_pct, cur2.cost_difference]
    filters:
      cur2.cost_variance_pct: '>0.20'
    fill_fields: [cur2.line_item_usage_start_date]
    sorts: [cur2.cost_variance_pct desc]
    limit: 50
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
      value: 0.50
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.cost_variance_pct]
    - type: between
      value: [0.20, 0.50]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.cost_variance_pct]
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
      cur2.cost_difference:
        is_active: true
    series_labels:
      cur2.line_item_usage_start_date: Date
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Total Cost
      cur2.cost_variance_pct: Variance %
      cur2.cost_difference: Cost Difference
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 104
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 5: DISCOUNT ATTRIBUTION
  # =====================================================

  - title: 💸 DISCOUNT ATTRIBUTION
    name: discount_attribution_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: DISCOUNT ATTRIBUTION & SAVINGS ANALYSIS
    value_format: ''
    note_display: hover
    note_text: 'Track all discounts including EDP, PPA, volume discounts, and commitment savings'
    row: 114
    col: 0
    width: 24
    height: 2

  - title: 💰 Total Discounts
    name: total_discounts
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_all_discounts, cur2.savings_percentage]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: Savings %
    single_value_title: TOTAL DISCOUNTS
    value_format: "$#,##0"
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 116
    col: 0
    width: 6
    height: 4

  - title: 🎯 EDP Discount
    name: edp_discount
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_edp_discount]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: EDP DISCOUNT
    value_format: "$#,##0"
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 116
    col: 6
    width: 6
    height: 4

  - title: 📋 PPA Discount
    name: ppa_discount
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_ppa_discount]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: PPA DISCOUNT
    value_format: "$#,##0"
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 116
    col: 12
    width: 6
    height: 4

  - title: 🎁 Effective Savings Rate
    name: effective_savings_rate
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.effective_savings_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: EFFECTIVE RATE
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.30
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.15, 0.30]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.15
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 116
    col: 18
    width: 6
    height: 4

  - title: 📊 Discount Attribution by Service
    name: discount_by_service
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_product_code, cur2.total_edp_discount, cur2.total_ppa_discount,
             cur2.total_discount_amount, cur2.total_commitment_savings]
    filters:
      cur2.total_all_discounts: '>0'
    sorts: [cur2.total_all_discounts desc]
    limit: 15
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: '#808080'
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: looker-color-palette-1
      options:
        steps: 4
    series_colors:
      cur2.total_edp_discount: '#10b981'
      cur2.total_ppa_discount: '#3b82f6'
      cur2.total_discount_amount: '#8b5cf6'
      cur2.total_commitment_savings: '#f59e0b'
    series_labels:
      cur2.line_item_product_code: Service
      cur2.total_edp_discount: EDP
      cur2.total_ppa_discount: PPA
      cur2.total_discount_amount: Volume
      cur2.total_commitment_savings: Commitments
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 120
    col: 0
    width: 12
    height: 8

  - title: 💵 Savings vs On-Demand Pricing
    name: savings_vs_on_demand
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost,
             cur2.total_on_demand_cost, cur2.savings_vs_on_demand]
    fill_fields: [cur2.line_item_usage_start_month]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
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
    y_axes: [{label: Cost, orientation: left, series: [{axisId: cur2.total_unblended_cost,
            id: cur2.total_unblended_cost, name: Actual Cost}, {axisId: cur2.total_on_demand_cost,
            id: cur2.total_on_demand_cost, name: On-Demand Cost}], showLabels: true,
        showValues: true, valueFormat: "$#,##0", unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: Savings, orientation: right,
        series: [{axisId: cur2.savings_vs_on_demand, id: cur2.savings_vs_on_demand,
            name: Savings}], showLabels: true, showValues: true, valueFormat: "$#,##0",
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
      cur2.total_on_demand_cost: '#ef4444'
      cur2.savings_vs_on_demand: '#10b981'
    series_labels:
      cur2.total_unblended_cost: Actual Cost
      cur2.total_on_demand_cost: On-Demand Cost
      cur2.savings_vs_on_demand: Savings
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 120
    col: 12
    width: 12
    height: 8

  - title: 📋 Discount Percentage by Service
    name: discount_percentage_by_service
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.total_all_discounts,
             cur2.savings_percentage, cur2.effective_savings_rate, cur2.savings_vs_on_demand]
    filters:
      cur2.total_all_discounts: '>0'
    sorts: [cur2.savings_percentage desc]
    limit: 25
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
      value: 0.30
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.savings_percentage, cur2.effective_savings_rate]
    - type: greater than
      value: 5000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_all_discounts, cur2.savings_vs_on_demand]
    series_cell_visualizations:
      cur2.total_all_discounts:
        is_active: true
      cur2.savings_percentage:
        is_active: true
        palette:
          palette_id: looker-color-palette-sequential-0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_labels:
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Total Cost
      cur2.total_all_discounts: Total Discounts
      cur2.savings_percentage: Savings %
      cur2.effective_savings_rate: Effective Rate
      cur2.savings_vs_on_demand: vs On-Demand
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 128
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 6: FINOPS METRICS
  # =====================================================

  - title: 🎯 FINOPS METRICS
    name: finops_metrics_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: FINOPS PERFORMANCE METRICS & MATURITY
    value_format: ''
    note_display: hover
    note_text: 'Track FinOps maturity, optimization scores, automation coverage, and policy compliance'
    row: 138
    col: 0
    width: 24
    height: 2

  - title: 🏆 FinOps Maturity Score
    name: finops_maturity_score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.finops_maturity_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: MATURITY SCORE
    value_format: "0"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [60, 80]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 60
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 140
    col: 0
    width: 6
    height: 6

  - title: 🔄 Optimization Score
    name: optimization_score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.optimization_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: OPTIMIZATION
    value_format: "0.0"
    conditional_formatting:
    - type: greater than
      value: 85
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [70, 85]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 70
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 140
    col: 6
    width: 6
    height: 6

  - title: 🤖 Automation Coverage
    name: automation_coverage
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.automation_coverage_percentage]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: AUTOMATION
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.70
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.50, 0.70]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.50
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 140
    col: 12
    width: 6
    height: 6

  - title: ✅ Policy Compliance Rate
    name: policy_compliance_rate
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.policy_compliance_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: COMPLIANCE
    value_format: "0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.90
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [0.75, 0.90]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    - type: less than
      value: 0.75
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 140
    col: 18
    width: 6
    height: 6

  - title: 📈 FinOps Metrics Trend
    name: finops_metrics_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.finops_maturity_score,
             cur2.optimization_score, cur2.automation_coverage_percentage, cur2.policy_compliance_rate]
    fill_fields: [cur2.line_item_usage_start_month]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: looker-color-palette-1
      options:
        steps: 4
    series_colors:
      cur2.finops_maturity_score: '#3b82f6'
      cur2.optimization_score: '#10b981'
      cur2.automation_coverage_percentage: '#8b5cf6'
      cur2.policy_compliance_rate: '#f59e0b'
    series_labels:
      cur2.finops_maturity_score: Maturity
      cur2.optimization_score: Optimization
      cur2.automation_coverage_percentage: Automation
      cur2.policy_compliance_rate: Compliance
    reference_lines: [{reference_type: line, line_value: '80', range_start: max, range_end: min,
        margin_top: deviation, margin_value: mean, margin_bottom: deviation, label_position: right,
        color: '#10b981', label: 'Target'}]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 146
    col: 0
    width: 12
    height: 8

  - title: 🤖 Automation Performance
    name: automation_performance
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.automation_type, cur2.automation_coverage_percentage, cur2.automation_success_rate,
             cur2.automated_actions_count, cur2.successful_actions_count, cur2.failed_actions_count]
    filters:
      cur2.automation_type: '-NULL'
    sorts: [cur2.automation_coverage_percentage desc]
    limit: 25
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
      value: 0.90
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.automation_success_rate]
    - type: greater than
      value: 0
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.failed_actions_count]
    series_cell_visualizations:
      cur2.automation_coverage_percentage:
        is_active: true
      cur2.automated_actions_count:
        is_active: true
    series_labels:
      cur2.automation_type: Automation Type
      cur2.automation_coverage_percentage: Coverage %
      cur2.automation_success_rate: Success Rate
      cur2.automated_actions_count: Total Actions
      cur2.successful_actions_count: Successful
      cur2.failed_actions_count: Failed
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 146
    col: 12
    width: 12
    height: 8

  - title: 📋 Policy Compliance Analysis
    name: policy_compliance_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.policy_type, cur2.policy_compliance_status, cur2.compliant_resources_count,
             cur2.non_compliant_resources_count, cur2.policy_compliance_rate, cur2.violation_count]
    filters:
      cur2.policy_type: '-NULL'
    sorts: [cur2.violation_count desc]
    limit: 25
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
    - type: less than
      value: 0.80
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.policy_compliance_rate]
    - type: greater than
      value: 0
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.violation_count, cur2.non_compliant_resources_count]
    series_cell_visualizations:
      cur2.violation_count:
        is_active: true
        palette:
          palette_id: looker-color-palette-diverging-0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      cur2.policy_compliance_rate:
        is_active: true
    series_labels:
      cur2.policy_type: Policy Type
      cur2.policy_compliance_status: Status
      cur2.compliant_resources_count: Compliant
      cur2.non_compliant_resources_count: Non-Compliant
      cur2.policy_compliance_rate: Compliance Rate
      cur2.violation_count: Violations
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 154
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 7: DETAILED ANALYSIS TABLES
  # =====================================================

  - title: 📊 DETAILED ANALYSIS TABLES
    name: detailed_analysis_header
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: DETAILED ANALYSIS & EXPORT-READY TABLES
    value_format: ''
    note_display: hover
    note_text: 'Comprehensive breakdowns by service, account, resource, and commitment for detailed analysis and reporting'
    row: 164
    col: 0
    width: 24
    height: 2

  - title: 🔧 Service-Level Cost Breakdown
    name: service_level_breakdown
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.service_category, cur2.total_unblended_cost,
             cur2.total_usage_cost, cur2.total_commitment_savings, cur2.total_all_discounts,
             cur2.savings_percentage, cur2.month_over_month_change, cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
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
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 0.20
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.month_over_month_change]
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
      cur2.total_all_discounts:
        is_active: true
    series_labels:
      cur2.line_item_product_code: Service
      cur2.service_category: Category
      cur2.total_unblended_cost: Total Cost
      cur2.total_usage_cost: Usage Cost
      cur2.total_commitment_savings: Commitment Savings
      cur2.total_all_discounts: Discounts
      cur2.savings_percentage: Savings %
      cur2.month_over_month_change: MoM Change
      cur2.count_unique_resources: Resources
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 166
    col: 0
    width: 24
    height: 12

  - title: 🏢 Account-Level Variance Analysis
    name: account_variance_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost, cur2.previous_month_cost,
             cur2.month_over_month_change, cur2.cost_variance_pct, cur2.total_commitment_savings,
             cur2.account_ri_cost, cur2.account_savings_plan_cost, cur2.account_discount_amount]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
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
      value: 0.15
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.month_over_month_change, cur2.cost_variance_pct]
    - type: greater than
      value: 1000
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.total_commitment_savings, cur2.account_discount_amount]
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
      cur2.month_over_month_change:
        is_active: true
        palette:
          palette_id: looker-color-palette-diverging-0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_labels:
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Current Cost
      cur2.previous_month_cost: Previous Month
      cur2.month_over_month_change: MoM Change
      cur2.cost_variance_pct: Variance %
      cur2.total_commitment_savings: Commitment Savings
      cur2.account_ri_cost: RI Cost
      cur2.account_savings_plan_cost: SP Cost
      cur2.account_discount_amount: Discounts
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 178
    col: 0
    width: 24
    height: 12

  - title: 💎 Resource-Level Top Spenders
    name: resource_top_spenders
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.line_item_usage_account_name,
             cur2.total_unblended_cost, cur2.total_usage_amount, cur2.pricing_term,
             cur2.environment, cur2.team, cur2.cost_per_resource]
    filters:
      cur2.line_item_resource_id: '-NULL,-'
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
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
      value: 5000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_unblended_cost]
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
    series_labels:
      cur2.line_item_resource_id: Resource ID
      cur2.line_item_product_code: Service
      cur2.line_item_usage_account_name: Account
      cur2.total_unblended_cost: Total Cost
      cur2.total_usage_amount: Usage Amount
      cur2.pricing_term: Pricing Term
      cur2.environment: Environment
      cur2.team: Team
      cur2.cost_per_resource: Cost per Resource
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 190
    col: 0
    width: 24
    height: 12

  - title: 📋 Commitment Tracking Table
    name: commitment_tracking_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.reservation_reservation_a_r_n, cur2.savings_plan_savings_plan_a_r_n,
             cur2.line_item_product_code, cur2.pricing_term, cur2.reservation_start_time,
             cur2.reservation_end_time, cur2.savings_plan_start_time, cur2.savings_plan_end_time,
             cur2.total_ri_cost, cur2.total_savings_plan_cost, cur2.total_ri_unused_cost,
             cur2.savings_plan_unused_commitment, cur2.ri_utilization_rate, cur2.savings_plan_utilization_rate]
    filters:
      cur2.pricing_term: 'Reserved,Savings Plan'
    sorts: [cur2.total_ri_cost desc]
    limit: 100
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
    conditional_formatting:
    - type: less than
      value: 0.80
      background_color: '#fecaca'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.ri_utilization_rate, cur2.savings_plan_utilization_rate]
    - type: greater than
      value: 500
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_ri_unused_cost, cur2.savings_plan_unused_commitment]
    series_cell_visualizations:
      cur2.total_ri_cost:
        is_active: true
      cur2.total_savings_plan_cost:
        is_active: true
    series_labels:
      cur2.reservation_reservation_a_r_n: RI ARN
      cur2.savings_plan_savings_plan_a_r_n: SP ARN
      cur2.line_item_product_code: Service
      cur2.pricing_term: Type
      cur2.reservation_start_time: RI Start
      cur2.reservation_end_time: RI End
      cur2.savings_plan_start_time: SP Start
      cur2.savings_plan_end_time: SP End
      cur2.total_ri_cost: RI Cost
      cur2.total_savings_plan_cost: SP Cost
      cur2.total_ri_unused_cost: RI Unused
      cur2.savings_plan_unused_commitment: SP Unused
      cur2.ri_utilization_rate: RI Util %
      cur2.savings_plan_utilization_rate: SP Util %
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Service Category: cur2.service_category
      Environment: cur2.environment
      Team: cur2.team
      Project: cur2.project
      Cost Center: cur2.cost_center
      Region: cur2.region
    row: 202
    col: 0
    width: 24
    height: 12
