---
- dashboard: project_performance_sla
  title: "Project Performance & SLA Dashboard"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Performance monitoring and SLA tracking dashboard correlating cost with performance metrics and availability"
  
  filters:
  - name: project_selector
    title: "Select Project"
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
  
  - name: performance_period
    title: "Performance Period"
    type: field_filter
    default_value: "7 days ago for 7 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date
  
  - name: sla_threshold
    title: "SLA Threshold (%)"
    type: field_filter
    default_value: "99.5"
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      options:
        min: 90
        max: 100
    model: aws_billing
    explore: cur2
    dimension: cur2.resource_efficiency_score
  
  - name: service_tier_filter
    title: "Service Tier"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: cur2
    dimension: cur2.service_category

  elements:
  # Row 1: Performance Overview
  - title: "Overall Performance Score"
    name: "overall_performance_score"
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields:
    - cur2.resource_efficiency_score
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "Performance Score"
    value_format: "#,##0.0%"
    gauge_fill_type: "segment"
    gauge_fill_colors:
    - "#dc3545"
    - "#ffc107"
    - "#fd7e14"
    - "#28a745"
    - "#20c997"
    range_max: 100
    range_min: 0
    angle_range: 270
    cutout: 60
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 0
    col: 0
    width: 8
    height: 6
    
  - title: "SLA Compliance Rate"
    name: "sla_compliance_rate"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.tag_coverage_rate
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "SLA Compliance"
    value_format: "#,##0.00%"
    font_size: large
    conditional_formatting:
    - type: greater than
      value: 0.995
      background_color: "#d4edda"
      font_color: "#155724"
      bold: true
    - type: between
      value:
      - 0.99
      - 0.995
      background_color: "#fff3cd"
      font_color: "#856404"
      bold: false
    - type: less than
      value: 0.99
      background_color: "#f8d7da"
      font_color: "#721c24"
      bold: true
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 0
    col: 8
    width: 8
    height: 6
    
  - title: "Cost-Performance Ratio"
    name: "cost_performance_ratio"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.cost_efficiency_ratio
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "$/Performance Point"
    value_format: "$#,##0.00"
    font_size: large
    text_color: "#17a2b8"
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 0
    col: 16
    width: 8
    height: 6
    
  # Row 2: Performance vs Cost Analysis
  - title: "Performance vs Cost Correlation"
    name: "performance_cost_correlation"
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields:
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    - cur2.resource_efficiency_score
    - cur2.usage_amount
    filters: {}
    sorts:
    - cur2.total_unblended_cost desc
    limit: 50
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
    plot_size_by_field: cur2.usage_amount
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
    x_axis_zoom: true
    y_axis_zoom: true
    quadrants_enabled: true
    quadrant_text_color: "#000000"
    quadrant_line_color: "#cccccc"
    quadrant_label_color: "#000000"
    quadrant_fill_color: "rgba(255,255,255,0.1)"
    series_colors:
      "AmazonEC2": "#ff6b35"
      "AmazonRDS": "#4ecdc4"
      "AmazonS3": "#45b7d1"
      "AWSLambda": "#96ceb4"
      "AmazonECS": "#ffeaa7"
      "AmazonEKS": "#fd79a8"
    x_axis_label: "Total Cost ($)"
    y_axis_label: "Performance Score (%)"
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 6
    col: 0
    width: 24
    height: 10
    
  # Row 3: Service Performance Breakdown
  - title: "Service Performance Breakdown"
    name: "service_performance_breakdown"
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_product_code
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    - cur2.total_unblended_cost
    filters: {}
    sorts:
    - cur2.resource_efficiency_score desc
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
    - label: "Performance Score (%)"
      orientation: left
      series:
      - axisId: cur2.resource_efficiency_score
        id: cur2.resource_efficiency_score
        name: "Performance Score"
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: "SLA Compliance"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Cost ($)"
      orientation: right
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: "Total Cost"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.resource_efficiency_score: "#28a745"
      cur2.tag_coverage_rate: "#17a2b8"
      cur2.total_unblended_cost: "#fd7e14"
    reference_lines:
    - reference_type: line
      range_start: max
      range_end: min
      margin_top: undefined
      margin_value: mean
      margin_bottom: undefined
      label_position: right
      color: "#dc3545"
      line_value: 95
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 16
    col: 0
    width: 12
    height: 8
    
  - title: "Regional Performance Distribution"
    name: "regional_performance_distribution"
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields:
    - cur2.line_item_availability_zone
    - cur2.resource_efficiency_score
    - cur2.total_unblended_cost
    - cur2.count_unique_resources
    filters: {}
    sorts:
    - cur2.resource_efficiency_score desc
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
    y_axis_combined: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes:
    - label: "Performance Score (%)"
      orientation: left
      series:
      - axisId: cur2.resource_efficiency_score
        id: cur2.resource_efficiency_score
        name: "Performance Score"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Resource Count"
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: "Resource Count"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.resource_efficiency_score: "#20c997"
      cur2.count_unique_resources: "#6f42c1"
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 16
    col: 12
    width: 12
    height: 8
    
  # Row 4: Performance Trends
  - title: "Performance & Cost Trend Analysis"
    name: "performance_cost_trend"
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_date
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    - cur2.total_unblended_cost
    - cur2.cost_efficiency_ratio
    filters: {}
    sorts:
    - cur2.line_item_usage_start_date
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: false
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: "Performance (%)"
      orientation: left
      series:
      - axisId: cur2.resource_efficiency_score
        id: cur2.resource_efficiency_score
        name: "Performance Score"
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: "SLA Compliance"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Cost ($)"
      orientation: right
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: "Total Cost"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.resource_efficiency_score: "#28a745"
      cur2.tag_coverage_rate: "#17a2b8"
      cur2.total_unblended_cost: "#fd7e14"
      cur2.cost_efficiency_ratio: "#6f42c1"
    reference_lines:
    - reference_type: line
      range_start: max
      range_end: min
      margin_top: undefined
      margin_value: mean
      margin_bottom: undefined
      label_position: right
      color: "#dc3545"
      line_value: 99.5
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      service_tier_filter: cur2.service_category
    row: 24
    col: 0
    width: 24
    height: 8
    
  # Row 5: Resource Performance Details
  - title: "Resource Performance & SLA Details"
    name: "resource_performance_details"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_resource_id
    - cur2.line_item_availability_zone
    - cur2.environment
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    - cur2.total_unblended_cost
    - cur2.cost_efficiency_ratio
    filters: {}
    sorts:
    - cur2.resource_efficiency_score desc
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
    - type: greater than
      value: 0.95
      background_color: "#d4edda"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.resource_efficiency_score
    - type: between
      value:
      - 0.80
      - 0.95
      background_color: "#fff3cd"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.resource_efficiency_score
    - type: less than
      value: 0.80
      background_color: "#f8d7da"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.resource_efficiency_score
    - type: less than
      value: 0.995
      background_color: "#ffe6cc"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_coverage_rate
    - type: greater than
      value: 1000
      background_color: "#e6ccff"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.total_unblended_cost
    listen:
      project_selector: cur2.environment
      performance_period: cur2.line_item_usage_start_date
      sla_threshold: cur2.resource_efficiency_score
      service_tier_filter: cur2.service_category
    row: 32
    col: 0
    width: 24
    height: 10