---
# =====================================================
# INFRASTRUCTURE OVERVIEW DASHBOARD
# =====================================================
# High-level overview of AWS infrastructure metrics
# Projects, teams, accounts, services, and resource counts
# 
# Author: Claude Dashboard Generator
# Last Updated: 2025-08-19
# =====================================================

- dashboard: infrastructure_overview
  title: 🏗️ AWS Infrastructure Overview
  description: 'High-level overview dashboard showing project counts, team statistics, account summaries, and infrastructure metrics'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  # Professional dashboard styling with color-blind friendly design
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
    listens_to_filters: []
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
    listens_to_filters: []
    field: cur2.environment

  - name: Cost Threshold
    title: 💰 Minimum Cost ($)
    type: field_filter
    default_value: '10'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 10000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost

  elements:
  # =====================================================
  # EXECUTIVE SUMMARY METRICS
  # =====================================================
  
  - title: 🎯 Active Projects
    name: active_projects_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_projects]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: ACTIVE PROJECTS
    value_format: "#,##0"
    font_size: large
    text_color: '#1f77b4'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 3
    height: 4

  - title: 👥 Active Teams
    name: active_teams_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: ACTIVE TEAMS
    value_format: "#,##0"
    font_size: large
    text_color: '#ff7f0e'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 3
    width: 3
    height: 4

  - title: 🏢 AWS Accounts
    name: aws_accounts_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_accounts]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: AWS ACCOUNTS
    value_format: "#,##0"
    font_size: large
    text_color: '#9467bd'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 6
    width: 3
    height: 4

  - title: 🔧 AWS Services
    name: aws_services_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_services]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: AWS SERVICES
    value_format: "#,##0"
    font_size: large
    text_color: '#8c564b'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 9
    width: 3
    height: 4

  - title: 🖥️ Total Resources
    name: total_resources_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: TOTAL RESOURCES
    value_format: "#,##0"
    font_size: large
    text_color: '#e377c2'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 12
    width: 4
    height: 4

  # =====================================================
  # PROJECT AND TEAM BREAKDOWN
  # =====================================================

  - title: 🎯 Projects by Environment
    name: projects_by_environment
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.environment, cur2.count_projects]
    sorts: [cur2.count_projects desc]
    limit: 10
    column_limit: 50
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: environment-colors-colorblind
        label: Environment Colors (Colorblind Safe)
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
        - color: '#e377c2'  # Safe pink
          offset: 4
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 0
    width: 8
    height: 6

  - title: 👥 Teams by Cost
    name: teams_by_cost
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.total_unblended_cost, cur2.count_projects]
    sorts: [cur2.total_unblended_cost desc]
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
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Project Count
      orientation: right
      series:
      - axisId: cur2.count_projects
        id: cur2.count_projects
        name: Project Count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: team-cost-colors-colorblind
        label: Team Cost Colors (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue
          offset: 0
        - color: '#ff7f0e'  # Safe orange
          offset: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 8
    width: 8
    height: 6

  # =====================================================
  # SERVICE AND ACCOUNT ANALYSIS
  # =====================================================

  - title: 🔧 Top AWS Services by Usage
    name: top_services_usage
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.count_unique_resources,
             cur2.count_projects, cur2.count_teams, cur2.total_usage_amount]
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
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
    # Color-blind friendly: High cost services
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
    # Resource count highlighting
    - type: greater than
      value: 100
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.count_unique_resources]
    # Project and team count highlighting
    - type: greater than
      value: 10
      background_color: '#e6f2ff'  # Very light blue
      font_color: '#0052cc'  # Medium blue
      bold: true
      fields: [cur2.count_projects, cur2.count_teams]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 10
    col: 0
    width: 16
    height: 8

  # =====================================================
  # REGIONAL AND ACCOUNT DISTRIBUTION
  # =====================================================

  - title: 🌍 Regional Distribution
    name: regional_distribution
    model: aws_billing
    explore: cur2
    type: looker_geo_choropleth
    fields: [cur2.region, cur2.total_unblended_cost, cur2.count_projects, cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    column_limit: 50
    map: world
    load_configuration: wait
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: regional-colors-colorblind
        label: Regional Colors (Colorblind Safe)
        type: continuous
        stops:
        - color: '#e6f2ff'  # Very light blue
          offset: 0
        - color: '#cce5ff'  # Light blue
          offset: 25
        - color: '#1f77b4'  # Safe blue
          offset: 75
        - color: '#003d82'  # Dark blue
          offset: 100
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 18
    col: 0
    width: 8
    height: 8

  - title: 🏢 Account Summary
    name: account_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost, cur2.count_projects,
             cur2.count_teams, cur2.count_unique_services, cur2.count_unique_resources]
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
    # Color-blind friendly: Account cost levels
    - type: greater than
      value: 100000
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [25000, 100000]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.total_unblended_cost]
    # Resource and service count highlighting
    - type: greater than
      value: 20
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.count_unique_services]
    - type: greater than
      value: 500
      background_color: '#e6f2ff'  # Very light blue
      font_color: '#0052cc'  # Medium blue
      bold: true
      fields: [cur2.count_unique_resources]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 18
    col: 8
    width: 8
    height: 8

  # =====================================================
  # INFRASTRUCTURE TRENDS
  # =====================================================

  - title: 📈 Infrastructure Growth Trends
    name: infrastructure_growth_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.count_projects, cur2.count_teams,
             cur2.count_unique_services, cur2.count_unique_resources, cur2.total_unblended_cost]
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
    - label: Count
      orientation: left
      series:
      - axisId: cur2.count_projects
        id: cur2.count_projects
        name: Projects
      - axisId: cur2.count_teams
        id: cur2.count_teams
        name: Teams
      - axisId: cur2.count_unique_services
        id: cur2.count_unique_services
        name: Services
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Resources
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: Resources
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: growth-trends-colorblind
        label: Growth Trends (Colorblind Safe)
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
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 26
    col: 0
    width: 16
    height: 8

  # =====================================================
  # SUMMARY STATISTICS
  # =====================================================

  - title: 📊 Infrastructure Summary Statistics
    name: infrastructure_summary_stats
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.environment, cur2.count_projects, cur2.count_teams, cur2.count_unique_accounts,
             cur2.count_unique_services, cur2.count_unique_resources, cur2.total_unblended_cost,
             cur2.average_daily_cost]
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
    # Color-blind friendly: Environment highlighting
    - type: contains
      value: prod
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.environment]
    - type: contains
      value: staging
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.environment]
    - type: contains
      value: dev
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.environment]
    # Cost highlighting
    - type: greater than
      value: 50000
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.total_unblended_cost]
    # High resource counts
    - type: greater than
      value: 1000
      background_color: '#e6f2ff'  # Very light blue
      font_color: '#0052cc'  # Medium blue
      bold: true
      fields: [cur2.count_unique_resources]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Cost Threshold: cur2.total_unblended_cost
    row: 34
    col: 0
    width: 16
    height: 10