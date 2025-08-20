---
# project_cost_deep_dive.dashboard.lkml
# Comprehensive project-specific cost analysis dashboard
# Detailed financial deep dive for individual project cost optimization

- dashboard: project_cost_deep_dive
  title: Project Cost Deep Dive Analysis
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Comprehensive cost analysis dashboard for individual project financial deep dive and optimization planning
  
  filters:
  - name: project_selector
    title: Select Project
    type: field_filter
    default_value: ""
    allow_multiple_values: false
    required: true
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.environment
  
  - name: analysis_period
    title: Analysis Period
    type: field_filter
    default_value: "6 months ago for 6 months"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date
  
  - name: comparison_period
    title: Compare To
    type: field_filter
    default_value: "12 months ago for 6 months"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date
  
  - name: cost_threshold
    title: Cost Threshold
    type: field_filter
    default_value: "10"
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.total_unblended_cost

  elements:
  # Row 1: Executive Summary Cards
  - name: total_project_cost
    title: Total Project Cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    single_value_title: Total Project Cost
    value_format: "$#,##0"
    font_size: large
    text_color: "#1f3a5f"
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 6
    height: 4
    
  - name: monthly_average_cost
    title: Monthly Average
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.average_monthly_cost]
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Monthly Average
    value_format: "$#,##0"
    font_size: large
    text_color: "#0f7b0f"
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 0
    col: 6
    width: 6
    height: 4
    
  - name: cost_growth_rate
    title: Cost Growth Rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_growth_rate]
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Growth Rate
    value_format: "#,##0.0%"
    font_size: large
    conditional_formatting:
    - type: greater than
      value: 0.20
      background_color: "#ff6b6b"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [0.05, 0.20]
      background_color: "#ffd93d"
      font_color: "#000000"
      bold: false
    - type: less than
      value: 0.05
      background_color: "#6bcf7f"
      font_color: "#ffffff"
      bold: false
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 0
    col: 12
    width: 6
    height: 4
    
  - name: optimization_score
    title: Optimization Score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.savings_percentage]
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Optimization Score
    value_format: "#,##0.0%"
    gauge_fill_type: segment
    gauge_fill_colors: ["#e74c3c", "#f39c12", "#f1c40f", "#2ecc71", "#27ae60"]
    range_max: 100
    range_min: 0
    angle_range: 270
    cutout: 60
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 0
    col: 18
    width: 6
    height: 4
    
  # Row 2: Cost Trend Analysis
  - name: cost_trend_analysis
    title: Project Cost Trend Analysis
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_month
    - cur2.total_unblended_cost
    - cur2.total_public_on_demand_cost
    - cur2.savings_vs_on_demand
    filters: {}
    sorts: [cur2.line_item_usage_start_month]
    limit: 500
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
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle_outline
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: "Cost ($)"
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      - axisId: cur2.total_public_on_demand_cost
        id: cur2.total_public_on_demand_cost
        name: On-Demand Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Savings ($)"
      orientation: right
      series:
      - axisId: cur2.savings_vs_on_demand
        id: cur2.savings_vs_on_demand
        name: Savings vs On-Demand
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.total_unblended_cost: "#1f3a93"
      cur2.total_public_on_demand_cost: "#ff6b35"
      cur2.savings_vs_on_demand: "#28a745"
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 4
    col: 0
    width: 24
    height: 8
    
  # Row 3: Service Breakdown
  - name: cost_by_service
    title: Cost by AWS Service
    model: aws_billing
    explore: cur2
    type: looker_donut_multiples
    fields:
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    - cur2.line_item_usage_start_month
    pivots: [cur2.line_item_usage_start_month]
    filters: {}
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    show_value_labels: true
    font_size: 12
    charts_across: 3
    hide_legend: false
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 12
    col: 0
    width: 12
    height: 8
    
  - name: top_cost_drivers
    title: Top Cost Drivers
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    - cur2.zero_usage_cost
    filters: {}
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
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
    y_axes:
    - label: "Total Cost ($)"
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
    - label: "Savings & Waste ($)"
      orientation: right
      series:
      - axisId: cur2.savings_vs_on_demand
        id: cur2.savings_vs_on_demand
        name: Savings
      - axisId: cur2.zero_usage_cost
        id: cur2.zero_usage_cost
        name: Waste
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.total_unblended_cost: "#1f3a93"
      cur2.savings_vs_on_demand: "#28a745"
      cur2.zero_usage_cost: "#dc3545"
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 12
    col: 12
    width: 12
    height: 8
    
  # Row 4: Regional & Environmental Analysis
  - name: cost_by_region_environment
    title: Cost by Region & Environment
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_availability_zone
    - cur2.environment
    - cur2.total_unblended_cost
    - cur2.count_unique_resources
    - cur2.savings_percentage
    filters: {}
    sorts: [cur2.total_unblended_cost desc]
    limit: 500
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
      background_color: "#ff9999"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 0.20
      background_color: "#99ff99"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.savings_percentage]
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 20
    col: 0
    width: 12
    height: 6
    
  - name: purchase_option_distribution
    title: Purchase Option Distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields:
    - cur2.purchase_option
    - cur2.total_unblended_cost
    filters: {}
    sorts: [cur2.total_unblended_cost desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 40
    series_colors:
      "On-Demand": "#ff6b35"
      "Reserved": "#4ecdc4"
      "Savings Plan": "#45b7d1"
      "Spot": "#96ceb4"
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 20
    col: 12
    width: 12
    height: 6
    
  # Row 5: Detailed Cost Analysis Table
  - name: detailed_resource_analysis
    title: Detailed Resource Cost Analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_usage_type
    - cur2.line_item_availability_zone
    - cur2.purchase_option
    - cur2.total_unblended_cost
    - cur2.usage_amount
    - cur2.savings_vs_on_demand
    - cur2.zero_usage_cost
    filters: {}
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
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: 50
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 11
    rows_font_size: 10
    conditional_formatting:
    - type: greater than
      value: 100
      background_color: "#ffe6e6"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 10
      background_color: "#ffcccc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.zero_usage_cost]
    - type: greater than
      value: 50
      background_color: "#e6ffe6"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.savings_vs_on_demand]
    listen:
      project_selector: cur2.environment
      analysis_period: cur2.line_item_usage_start_date
      cost_threshold: cur2.total_unblended_cost
    row: 26
    col: 0
    width: 24
    height: 8