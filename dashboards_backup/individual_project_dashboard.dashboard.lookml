---
# Individual Project Dashboard
# Personal gamified tracking for cost optimization achievements and progress

- dashboard: individual_project_dashboard
  title: 🎯 My Project Cost Optimization Journey
  description: Personal gamified dashboard for tracking individual project cost optimization progress and achievements
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  filters:
  - name: My Project
    title: 🎯 My Project
    type: field_filter
    default_value: ""
    allow_multiple_values: false
    required: true
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.environment
  
  - name: Tracking Period
    title: 📅 Tracking Period
    type: field_filter
    default_value: 3 months ago for 3 months
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date
  
  - name: AWS Account
    title: 🏢 AWS Account
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [My Project]
    field: cur2.line_item_usage_account_name

  elements:
  # Personal Score Display
  - name: personal_score_display
    title: My Optimization Score
    model: aws_billing
    explore: cur2
    type: kpi_vis
    fields: [cur2.savings_percentage]
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: OPTIMIZATION SCORE
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.30
      background_color: "#ffd700"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: null
    - type: between
      value: [0.15, 0.30]
      background_color: "#c0c0c0"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: null
    - type: between
      value: [0.05, 0.15]
      background_color: "#cd7f32"
      font_color: "#ffffff"
      bold: false
      italic: false
      strikethrough: false
      fields: null
    width: 8
    height: 6
    row: 0
    col: 0
    
  # Level Progress Indicator
  - name: level_progress_indicator
    title: Level Progress
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.resource_efficiency_score]
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: EFFICIENCY LEVEL
    value_format: "#,##0.0%"
    gauge_fill_type: segment
    gauge_fill_colors: ["#e74c3c", "#f39c12", "#f1c40f", "#2ecc71", "#27ae60"]
    angle: 90
    cutout: 60
    range_max: 100
    range_min: 0
    angle_range: 270
    gauge_value_formatting: decimal_1
    width: 8
    height: 6
    row: 0
    col: 8
    
  # Achievement Gallery
  - name: achievement_gallery
    title: My Achievements
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields:
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    - cur2.total_unblended_cost
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    limit: 1
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color_enabled: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: achievement-colors
        label: Achievement Colors
        type: categorical
        stops:
        - color: "#ffd700"
          offset: 0
        - color: "#ff6b35"
          offset: 25
        - color: "#4ecdc4"
          offset: 50
        - color: "#45b7d1"
          offset: 75
    width: 8
    height: 6
    row: 0
    col: 16
    
  # Personal Cost Tracking with Goals
  - name: cost_tracking_with_goals
    title: Cost Optimization Goals Tracker
    model: aws_billing
    explore: cur2
    type: waterfall_vis
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost, cur2.savings_vs_on_demand]
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
    column_limit: 50
    show_view_names: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: cost-goal-tracker
        label: Cost Goal Tracker
        type: continuous
        stops:
        - color: "#e74c3c"
          offset: 0
        - color: "#f39c12"
          offset: 50
        - color: "#27ae60"
          offset: 100
    width: 12
    height: 8
    row: 6
    col: 0
    
  # Milestone Progress Chart
  - name: milestone_progress_chart
    title: Milestone Progress
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields:
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 0.80
      background_color: "#27ae60"
      font_color: "#ffffff"
      bold: true
      italic: false
      strikethrough: false
      fields: null
    - type: between
      value: [0.60, 0.80]
      background_color: "#f39c12"
      font_color: "#ffffff"
      bold: false
      italic: false
      strikethrough: false
      fields: null
    width: 12
    height: 8
    row: 6
    col: 12
    
  # Daily Activity Heatmap
  - name: daily_activity_heatmap
    title: Daily Optimization Activity
    model: aws_billing
    explore: cur2
    type: looker_calendar
    fields:
    - cur2.line_item_usage_start_date
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    sorts: [cur2.line_item_usage_start_date]
    limit: 365
    column_limit: 50
    show_view_names: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: activity-heatmap
        label: Activity Heatmap
        type: continuous
        stops:
        - color: "#ffffff"
          offset: 0
        - color: "#4ecdc4"
          offset: 25
        - color: "#45b7d1"
          offset: 50
        - color: "#96ceb4"
          offset: 75
        - color: "#ffeaa7"
          offset: 100
    width: 12
    height: 6
    row: 14
    col: 0
    
  # Resource Optimization Breakdown
  - name: resource_optimization_breakdown
    title: Resource Optimization Breakdown
    model: aws_billing
    explore: cur2
    type: treemap_vis
    fields:
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    sorts: [cur2.savings_vs_on_demand desc]
    limit: 20
    column_limit: 50
    show_view_names: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: resource-optimization
        label: Resource Optimization
        type: continuous
        stops:
        - color: "#ff7675"
          offset: 0
        - color: "#fdcb6e"
          offset: 50
        - color: "#6c5ce7"
          offset: 100
    width: 12
    height: 6
    row: 14
    col: 12
    
  # Personal Leaderboard Position
  - name: personal_leaderboard_position
    title: My Position in Company Leaderboard
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.environment
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    filters:
      cur2.line_item_usage_start_date: "{% parameter tracking_period_filter %}"
      cur2.environment: "-EMPTY"
    sorts: [cur2.savings_percentage desc]
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
    header_text_alignment: center
    header_font_size: 12
    rows_font_size: 11
    conditional_formatting:
    - type: equal to
      value: "{% parameter my_project_filter %}"
      background_color: "#74b9ff"
      font_color: "#ffffff"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.environment]
    width: 12
    height: 8
    row: 20
    col: 0
    
  # Achievement Progress Breakdown
  - name: achievement_progress_breakdown
    title: Achievement Progress Breakdown
    model: aws_billing
    explore: cur2
    type: gauge_vis
    fields:
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    listen:
      Tracking Period: cur2.line_item_usage_start_date
      My Project: cur2.environment
      AWS Account: cur2.line_item_usage_account_name
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    gauge_type: semi
    gauge_max: 100
    gauge_min: 0
    gauge_colors: ["#e74c3c", "#f39c12", "#f1c40f", "#2ecc71", "#27ae60"]
    gauge_label_type: labPer
    gauge_value_formatting: decimal_1
    gauge_fill_colors: ["#e74c3c", "#f39c12", "#2ecc71"]
    width: 12
    height: 8
    row: 20
    col: 12