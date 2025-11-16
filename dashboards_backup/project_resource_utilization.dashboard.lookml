---
# project_resource_utilization.dashboard.lkml
# Comprehensive resource utilization analysis for individual projects
# Identifies underutilized, oversized, and idle resources for optimization

- dashboard: project_resource_utilization
  title: Project Resource Utilization Analysis
  layout: newspaper
  preferred_viewer: dashboards-next
  description: Comprehensive resource utilization dashboard for identifying optimization opportunities in compute, storage, and database resources
  
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
    explore: compute_optimization
    dimension: cur2.environment
  
  - name: utilization_period
    title: Utilization Period
    type: field_filter
    default_value: 30 days ago for 30 days
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: compute_optimization
    dimension: compute_cur2.usage_date
  
  - name: resource_type_filter
    title: Resource Type
    type: field_filter
    default_value: EC2,RDS,S3
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: compute_optimization
    dimension: compute_cur2.compute_service
  
  - name: utilization_threshold
    title: Low Utilization Threshold (%)
    type: field_filter
    default_value: "20"
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      options:
        min: 0
        max: 100
    model: aws_billing
    explore: compute_optimization
    dimension: compute_cur2.optimization_priority

  elements:
  # Row 1: Utilization Summary Cards
  - title: Resource Efficiency Score
    name: resource_efficiency_score
    model: aws_billing
    explore: compute_optimization
    type: radial_gauge_vis
    fields: [compute_cur2.savings_percentage]
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Efficiency Score
    value_format: "#,##0.0%"
    gauge_fill_type: segment
    gauge_fill_colors: ["#e74c3c", "#f39c12", "#f1c40f", "#2ecc71", "#27ae60"]
    range_max: 100
    range_min: 0
    angle_range: 270
    cutout: 60
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 0
    col: 0
    width: 8
    height: 6
    
  - title: Underutilized Resources
    name: underutilized_resources
    model: aws_billing
    explore: compute_optimization
    type: single_value
    fields: [compute_cur2.instance_count]
    filters:
      compute_cur2.optimization_opportunity: High - Previous Generation,Medium - Consider Spot/RI
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Underutilized Resources
    value_format: "#,##0"
    font_size: large
    text_color: "#dc3545"
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 0
    col: 8
    width: 8
    height: 6
    
  - title: Potential Monthly Savings
    name: potential_monthly_savings
    model: aws_billing
    explore: compute_optimization
    type: single_value
    fields: [compute_cur2.total_potential_savings]
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Monthly Savings Potential
    value_format: "$#,##0"
    font_size: large
    text_color: "#28a745"
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 0
    col: 16
    width: 8
    height: 6
    
  # Row 2: Utilization Distribution
  - title: Resource Utilization Distribution
    name: utilization_distribution
    model: aws_billing
    explore: compute_optimization
    type: looker_donut_multiples
    fields:
    - compute_cur2.optimization_priority
    - compute_cur2.total_unblended_cost
    - compute_cur2.compute_service
    pivots: [compute_cur2.compute_service]
    filters: {}
    sorts: [compute_cur2.total_unblended_cost desc]
    limit: 500
    show_value_labels: true
    font_size: 12
    charts_across: 3
    hide_legend: false
    series_colors:
      High Priority: "#dc3545"
      Medium Priority: "#ffc107"
      Low Priority: "#17a2b8"
      Optimized: "#28a745"
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 6
    col: 0
    width: 24
    height: 8
    
  # Row 3: Detailed Utilization Analysis
  - title: Instance Type Utilization Analysis
    name: instance_utilization_analysis
    model: aws_billing
    explore: compute_optimization
    type: looker_column
    fields:
    - compute_cur2.instance_type
    - compute_cur2.total_unblended_cost
    - compute_cur2.total_potential_savings
    - compute_cur2.instance_count
    filters: {}
    sorts: [compute_cur2.total_unblended_cost desc]
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
    plot_size_by_field: false
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: compute_cur2.total_unblended_cost
        id: compute_cur2.total_unblended_cost
        name: Current Cost
      - axisId: compute_cur2.total_potential_savings
        id: compute_cur2.total_potential_savings
        name: Potential Savings
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Instance Count
      orientation: right
      series:
      - axisId: compute_cur2.instance_count
        id: compute_cur2.instance_count
        name: Instance Count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      compute_cur2.total_unblended_cost: "#1f3a93"
      compute_cur2.total_potential_savings: "#28a745"
      compute_cur2.instance_count: "#fd7e14"
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 14
    col: 0
    width: 12
    height: 8
    
  - title: Optimization Opportunities Heatmap
    name: optimization_heatmap
    model: aws_billing
    explore: compute_optimization
    type: looker_grid
    fields:
    - compute_cur2.line_item_availability_zone
    - compute_cur2.instance_generation
    - compute_cur2.optimization_priority
    - compute_cur2.instance_count
    - compute_cur2.total_potential_savings
    filters: {}
    sorts: [compute_cur2.total_potential_savings desc]
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
    - type: equal to
      value: High Priority
      background_color: "#ffcccc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [compute_cur2.optimization_priority]
    - type: equal to
      value: Previous Generation
      background_color: "#ffe6cc"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: [compute_cur2.instance_generation]
    - type: greater than
      value: 100
      background_color: "#ccffcc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [compute_cur2.total_potential_savings]
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 14
    col: 12
    width: 12
    height: 8
    
  # Row 4: Storage Utilization (if storage_optimization explore exists)
  - title: Storage Utilization Overview
    name: storage_utilization_overview
    model: aws_billing
    explore: storage_optimization
    type: looker_pie
    fields:
    - storage_cur2.storage_service
    - storage_cur2.total_unblended_cost
    filters: {}
    sorts: [storage_cur2.total_unblended_cost desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 40
    series_colors:
      S3: "#ff9500"
      EBS: "#4ecdc4"
      EFS: "#45b7d1"
      FSx: "#96ceb4"
    listen:
      project_selector: cur2.environment
      utilization_period: storage_cur2.usage_date
    row: 22
    col: 0
    width: 8
    height: 6
    
  - title: Storage Rightsizing Opportunities
    name: storage_rightsizing
    model: aws_billing
    explore: storage_optimization
    type: single_value
    fields: [storage_cur2.total_potential_savings]
    filters:
      storage_cur2.optimization_opportunity: "-Optimized"
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Storage Savings Potential
    value_format: "$#,##0"
    font_size: large
    text_color: "#28a745"
    listen:
      project_selector: cur2.environment
      utilization_period: storage_cur2.usage_date
    row: 22
    col: 8
    width: 8
    height: 6
    
  - title: Unused Storage Volumes
    name: unused_storage_volumes
    model: aws_billing
    explore: storage_optimization
    type: single_value
    fields: [storage_cur2.volume_count]
    filters:
      storage_cur2.optimization_opportunity: High - Unused Volume
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Unused Volumes
    value_format: "#,##0"
    font_size: large
    text_color: "#dc3545"
    listen:
      project_selector: cur2.environment
      utilization_period: storage_cur2.usage_date
    row: 22
    col: 16
    width: 8
    height: 6
    
  # Row 5: Detailed Resource Table
  - title: Detailed Resource Utilization Report
    name: detailed_resource_report
    model: aws_billing
    explore: compute_optimization
    type: looker_grid
    fields:
    - compute_cur2.resource_id
    - compute_cur2.compute_service
    - compute_cur2.instance_type
    - compute_cur2.line_item_availability_zone
    - compute_cur2.optimization_opportunity
    - compute_cur2.total_unblended_cost
    - compute_cur2.total_potential_savings
    - compute_cur2.purchase_option
    filters: {}
    sorts: [compute_cur2.total_potential_savings desc]
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
      num_rows: 25
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 11
    rows_font_size: 10
    conditional_formatting:
    - type: contains
      value: High
      background_color: "#ffcccc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [compute_cur2.optimization_opportunity]
    - type: contains
      value: Medium
      background_color: "#fff3cd"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: [compute_cur2.optimization_opportunity]
    - type: equal to
      value: On-Demand
      background_color: "#ffe6cc"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: [compute_cur2.purchase_option]
    - type: greater than
      value: 50
      background_color: "#ccffcc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [compute_cur2.total_potential_savings]
    listen:
      project_selector: cur2.environment
      utilization_period: compute_cur2.usage_date
      resource_type_filter: compute_cur2.compute_service
    row: 28
    col: 0
    width: 24
    height: 10