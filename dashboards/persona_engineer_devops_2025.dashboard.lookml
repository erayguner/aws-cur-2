---
# =====================================================
# ENGINEERING & DEVOPS PERSONA DASHBOARD 2025
# =====================================================
# Resource-level cost analysis and optimization
# For: Engineering Managers, DevOps Teams, SRE, Platform Engineers
# Focus: Infrastructure efficiency, service optimization, cost per environment
#
# Author: Claude Dashboard Generator
# Last Updated: 2025-11-17
# =====================================================

- dashboard: persona_engineer_devops_2025
  title: 🔧 Engineering & DevOps Dashboard 2025
  description: 'Resource-level cost analysis, service optimization, and infrastructure efficiency dashboard for engineering and DevOps teams'
  layout: newspaper
  preferred_viewer: dashboards-next

  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
  load_configuration: wait
  crossfilter_enabled: true

  # Professional technical styling
  embed_style:
    background_color: '#0f172a'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#f1f5f9'
    tile_background_color: '#1e293b'

  filters:
  - name: Time Period
    title: 📅 Analysis Period
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
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

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
    listens_to_filters: []
    field: cur2.team

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
    listens_to_filters: []
    field: cur2.project

  - name: Environment
    title: 🌍 Environment
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.environment

  - name: Service
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
    listens_to_filters: []
    field: cur2.line_item_product_code

  - name: Region
    title: 🌎 Region
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_availability_zone

  elements:
  # =====================================================
  # SECTION 1: MY TEAM'S COSTS
  # =====================================================

  - title: 💰 Total Team Cost
    name: total_team_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: TOTAL COST
    value_format: "$#,##0"
    font_size: large
    text_color: '#10b981'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 0
    col: 0
    width: 4
    height: 3

  - title: 📊 Cost Trend
    name: cost_trend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.week_over_week_change]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    single_value_title: WEEK OVER WEEK
    value_format: "$#,##0"
    comparison_label: WoW Change
    font_size: large
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 0
    col: 4
    width: 4
    height: 3

  - title: 🖥️ Resource Count
    name: resource_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: ACTIVE RESOURCES
    value_format: "#,##0"
    font_size: large
    text_color: '#3b82f6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 0
    col: 8
    width: 4
    height: 3

  - title: 💡 Avg Cost/Resource
    name: avg_cost_per_resource
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_per_resource]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: AVG COST PER RESOURCE
    value_format: "$#,##0.00"
    font_size: large
    text_color: '#f59e0b'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 0
    col: 12
    width: 4
    height: 3

  - title: 🎯 Cost by Project
    name: cost_by_project
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.project, cur2.total_unblended_cost]
    filters:
      cur2.project: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    colors: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899', '#14b8a6', '#f97316']
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 3
    col: 0
    width: 8
    height: 6

  - title: 🌍 Cost by Environment
    name: cost_by_environment
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.environment, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.environment: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#ef4444'
      cur2.count_unique_resources: '#3b82f6'
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
    - label: Resources
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: Resource Count
      showLabels: true
      showValues: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 3
    col: 8
    width: 8
    height: 6

  - title: 💸 Top 10 Resources by Cost
    name: top_10_resources_cost
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.product_instance_type,
             cur2.line_item_availability_zone, cur2.total_unblended_cost, cur2.total_usage_amount,
             cur2.environment, cur2.team]
    filters:
      cur2.line_item_resource_id: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 1000
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [500, 1000]
      background_color: '#fef3c7'
      font_color: '#92400e'
      fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 9
    col: 0
    width: 16
    height: 6

  # =====================================================
  # SECTION 2: SERVICE-LEVEL BREAKDOWN
  # =====================================================

  - title: 🖥️ EC2 Costs by Instance Type
    name: ec2_costs_by_instance_type
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.product_instance_type, cur2.total_unblended_cost, cur2.count_unique_resources, cur2.total_usage_amount]
    filters:
      cur2.line_item_product_code: AmazonEC2
      cur2.product_instance_type: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 15
    col: 0
    width: 8
    height: 7

  - title: 💾 RDS Costs
    name: rds_costs
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_instance_type, cur2.total_unblended_cost, cur2.line_item_availability_zone]
    pivots: [cur2.line_item_availability_zone]
    filters:
      cur2.line_item_product_code: AmazonRDS
      cur2.product_instance_type: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 15
    col: 8
    width: 8
    height: 7

  - title: 📦 S3 Storage Costs
    name: s3_storage_costs
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_type, cur2.total_unblended_cost, cur2.total_usage_amount, cur2.line_item_unblended_rate]
    filters:
      cur2.line_item_product_code: AmazonS3
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 500
      background_color: '#fee2e2'
      font_color: '#991b1b'
      fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 22
    col: 0
    width: 8
    height: 6

  - title: ⚡ Lambda/Serverless Costs
    name: lambda_serverless_costs
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.lambda_cost, cur2.total_usage_amount]
    filters:
      cur2.line_item_product_code: AWSLambda
    fill_fields: [cur2.line_item_usage_start_date]
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 30
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    point_style: circle
    show_value_labels: false
    series_colors:
      cur2.lambda_cost: '#8b5cf6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 22
    col: 8
    width: 8
    height: 6

  - title: 🌐 Service Cost Summary
    name: service_cost_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.count_unique_resources,
             cur2.total_usage_amount, cur2.cost_per_resource]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 5000
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [1000, 5000]
      background_color: '#fef3c7'
      font_color: '#92400e'
      fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 28
    col: 0
    width: 16
    height: 7

  # =====================================================
  # SECTION 3: RESOURCE EFFICIENCY
  # =====================================================

  - title: 💡 Resource Efficiency Score
    name: resource_efficiency_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.resource_efficiency_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: EFFICIENCY SCORE
    value_format: "0.0"
    font_size: large
    text_color: '#10b981'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 35
    col: 0
    width: 4
    height: 3

  - title: ⚙️ Usage vs Cost Efficiency
    name: usage_vs_cost_efficiency
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_resource_id, cur2.total_usage_amount, cur2.total_unblended_cost,
             cur2.line_item_product_code]
    filters:
      cur2.line_item_resource_id: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_dimension: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: circle
    series_colors:
      AmazonEC2: '#3b82f6'
      AmazonRDS: '#10b981'
      AmazonS3: '#f59e0b'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 35
    col: 4
    width: 12
    height: 8

  - title: 🏗️ Instance Type Distribution
    name: instance_type_distribution
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.product_instance_family, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.product_instance_family: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
      cur2.count_unique_resources: '#10b981'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 43
    col: 0
    width: 8
    height: 7

  - title: 🌍 Availability Zone Distribution
    name: availability_zone_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_availability_zone, cur2.total_unblended_cost]
    filters:
      cur2.line_item_availability_zone: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 60
    colors: ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899']
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 43
    col: 8
    width: 8
    height: 7

  # =====================================================
  # SECTION 4: INFRASTRUCTURE OPTIMIZATION
  # =====================================================

  - title: 💰 Commitment Coverage
    name: commitment_coverage
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.commitment_coverage_percentage]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: RI/SP COVERAGE
    value_format: "0.0\%"
    font_size: large
    text_color: '#10b981'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 50
    col: 0
    width: 4
    height: 3

  - title: 📊 RI Utilization
    name: ri_utilization
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.ri_utilization_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: RI UTILIZATION
    value_format: "0.0\%"
    font_size: large
    text_color: '#3b82f6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 50
    col: 4
    width: 4
    height: 3

  - title: 💡 Potential Savings
    name: potential_savings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: RIGHT-SIZING OPPORTUNITY
    value_format: "$#,##0"
    font_size: large
    text_color: '#f59e0b'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 50
    col: 8
    width: 4
    height: 3

  - title: 🎯 Spot vs On-Demand vs Reserved
    name: spot_ondemand_reserved_split
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.pricing_purchase_option, cur2.total_unblended_cost, cur2.total_usage_amount]
    filters:
      cur2.pricing_purchase_option: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    stacking: ''
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      On Demand: '#ef4444'
      Reserved: '#10b981'
      Spot: '#3b82f6'
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
    - label: Usage
      orientation: right
      series:
      - axisId: cur2.total_usage_amount
        id: cur2.total_usage_amount
        name: Usage Amount
      showLabels: true
      showValues: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 50
    col: 12
    width: 4
    height: 8

  - title: 💰 Cost by Purchase Option Over Time
    name: cost_by_purchase_option_time
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.pricing_purchase_option, cur2.total_unblended_cost]
    pivots: [cur2.pricing_purchase_option]
    filters:
      cur2.pricing_purchase_option: -EMPTY
    fill_fields: [cur2.line_item_usage_start_date]
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 90
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    point_style: none
    show_value_labels: false
    stacking: normal
    legend_position: center
    series_colors:
      On Demand - cur2.total_unblended_cost: '#ef4444'
      Reserved - cur2.total_unblended_cost: '#10b981'
      Spot - cur2.total_unblended_cost: '#3b82f6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 53
    col: 0
    width: 12
    height: 7

  - title: 📊 Commitment Savings Analysis
    name: commitment_savings_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_ri_cost, cur2.total_savings_plan_cost,
             cur2.total_on_demand_cost, cur2.total_commitment_savings, cur2.commitment_coverage_percentage]
    sorts: [cur2.total_commitment_savings desc]
    limit: 15
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 1000
      background_color: '#d1fae5'
      font_color: '#065f46'
      bold: true
      fields: [cur2.total_commitment_savings]
    - type: less than
      value: 50
      background_color: '#fee2e2'
      font_color: '#991b1b'
      fields: [cur2.commitment_coverage_percentage]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 60
    col: 0
    width: 16
    height: 6

  # =====================================================
  # SECTION 5: COST BY WORKLOAD
  # =====================================================

  - title: ☸️ Kubernetes Cluster Costs
    name: kubernetes_cluster_costs
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.aws_eks_cluster, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.aws_eks_cluster: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
      cur2.count_unique_resources: '#10b981'
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
    - label: Resources
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: Resource Count
      showLabels: true
      showValues: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 66
    col: 0
    width: 8
    height: 7

  - title: 🐳 ECS Service Costs
    name: ecs_service_costs
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.aws_ecs_service, cur2.total_unblended_cost, cur2.total_usage_amount]
    filters:
      cur2.aws_ecs_service: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#8b5cf6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 66
    col: 8
    width: 8
    height: 7

  - title: 📱 Application Costs
    name: application_costs
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.aws_application, cur2.total_unblended_cost, cur2.count_unique_resources,
             cur2.environment, cur2.cost_per_resource]
    filters:
      cur2.aws_application: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 5000
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [1000, 5000]
      background_color: '#fef3c7'
      font_color: '#92400e'
      fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 73
    col: 0
    width: 16
    height: 6

  # =====================================================
  # SECTION 6: NETWORK COSTS
  # =====================================================

  - title: 🌐 Total Data Transfer Cost
    name: total_data_transfer_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_data_transfer_cost]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: DATA TRANSFER COST
    value_format: "$#,##0"
    font_size: large
    text_color: '#ef4444'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 79
    col: 0
    width: 4
    height: 3

  - title: 📊 Data Transfer GB
    name: total_data_transfer_gb
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_data_transfer_gb]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: TOTAL DATA TRANSFER
    value_format: "#,##0.00\" GB\""
    font_size: large
    text_color: '#3b82f6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 79
    col: 4
    width: 4
    height: 3

  - title: 💰 Cost per GB
    name: data_transfer_cost_per_gb
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.data_transfer_cost_per_gb]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: COST PER GB
    value_format: "$0.000"
    font_size: large
    text_color: '#f59e0b'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 79
    col: 8
    width: 4
    height: 3

  - title: 🔀 Network Cost Breakdown
    name: network_cost_breakdown
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.internet_egress_cost, cur2.inter_region_cost, cur2.nat_gateway_cost,
             cur2.load_balancer_cost, cur2.vpc_endpoint_cost]
    limit: 1
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    series_labels:
      cur2.internet_egress_cost: Internet Egress
      cur2.inter_region_cost: Inter-Region
      cur2.nat_gateway_cost: NAT Gateway
      cur2.load_balancer_cost: Load Balancer
      cur2.vpc_endpoint_cost: VPC Endpoint
    colors: ['#ef4444', '#f59e0b', '#10b981', '#3b82f6', '#8b5cf6']
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 79
    col: 12
    width: 4
    height: 8

  - title: 🌍 Data Transfer by Type Over Time
    name: data_transfer_by_type_time
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.internet_egress_cost, cur2.inter_region_cost,
             cur2.nat_gateway_cost]
    fill_fields: [cur2.line_item_usage_start_date]
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 30
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    point_style: none
    show_value_labels: false
    stacking: normal
    legend_position: center
    series_colors:
      cur2.internet_egress_cost: '#ef4444'
      cur2.inter_region_cost: '#f59e0b'
      cur2.nat_gateway_cost: '#10b981'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 82
    col: 0
    width: 12
    height: 7

  - title: 🔧 Network Infrastructure Costs
    name: network_infrastructure_costs
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.line_item_usage_type, cur2.total_unblended_cost,
             cur2.total_usage_amount, cur2.line_item_unblended_rate]
    filters:
      cur2.line_item_product_code: AmazonVPC,AWSELB,AWSDirectConnect
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    table_theme: white
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 1000
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Region: cur2.line_item_availability_zone
    row: 89
    col: 0
    width: 16
    height: 6

  # =====================================================
  # SECTION 7: TIME-BASED ANALYSIS
  # =====================================================

  - title: ⏰ Hourly Cost Pattern
    name: hourly_cost_pattern
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_time, cur2.total_unblended_cost, cur2.total_usage_amount]
    sorts: [cur2.line_item_usage_start_time]
    limit: 24
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_value_labels: false
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 95
    col: 0
    width: 8
    height: 7

  - title: 📅 Daily Cost Trend
    name: daily_cost_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, cur2.count_unique_resources]
    fill_fields: [cur2.line_item_usage_start_date]
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 90
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    point_style: circle
    show_value_labels: false
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
      cur2.count_unique_resources: '#10b981'
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
    - label: Resources
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: Resource Count
      showLabels: true
      showValues: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 95
    col: 8
    width: 8
    height: 7

  - title: 📊 Weekly Cost Comparison
    name: weekly_cost_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_week, cur2.total_unblended_cost, cur2.week_over_week_change]
    fill_fields: [cur2.line_item_usage_start_week]
    sorts: [cur2.line_item_usage_start_week desc]
    limit: 12
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_combined: true
    show_value_labels: true
    label_density: 25
    legend_position: center
    series_colors:
      cur2.total_unblended_cost: '#3b82f6'
      cur2.week_over_week_change: '#f59e0b'
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
    - label: WoW Change
      orientation: right
      series:
      - axisId: cur2.week_over_week_change
        id: cur2.week_over_week_change
        name: Week over Week Change
      showLabels: true
      showValues: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 102
    col: 0
    width: 16
    height: 7

  # =====================================================
  # SECTION 8: DETAILED RESOURCE TABLE
  # =====================================================

  - title: 🔍 Detailed Resource Analysis
    name: detailed_resource_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.product_instance_type,
             cur2.line_item_availability_zone, cur2.environment, cur2.team, cur2.project,
             cur2.total_unblended_cost, cur2.total_usage_amount, cur2.pricing_purchase_option,
             cur2.week_over_week_change]
    filters:
      cur2.line_item_resource_id: -EMPTY
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
    show_view_names: false
    show_row_numbers: true
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 11
    rows_font_size: 11
    conditional_formatting:
    # Cost highlighting
    - type: greater than
      value: 1000
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [500, 1000]
      background_color: '#fef3c7'
      font_color: '#92400e'
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [100, 500]
      background_color: '#dbeafe'
      font_color: '#1e40af'
      fields: [cur2.total_unblended_cost]
    # Environment highlighting
    - type: equal to
      value: prod
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.environment]
    - type: equal to
      value: staging
      background_color: '#fef3c7'
      font_color: '#92400e'
      fields: [cur2.environment]
    - type: equal to
      value: dev
      background_color: '#dbeafe'
      font_color: '#1e40af'
      fields: [cur2.environment]
    # Cost trend highlighting
    - type: greater than
      value: 20
      background_color: '#fee2e2'
      font_color: '#991b1b'
      bold: true
      fields: [cur2.week_over_week_change]
    - type: less than
      value: -20
      background_color: '#d1fae5'
      font_color: '#065f46'
      bold: true
      fields: [cur2.week_over_week_change]
    listen:
      Time Period: cur2.line_item_usage_start_date
      Team: cur2.team
      Project: cur2.project
      Environment: cur2.environment
      Service: cur2.line_item_product_code
      Region: cur2.line_item_availability_zone
    row: 109
    col: 0
    width: 16
    height: 12
