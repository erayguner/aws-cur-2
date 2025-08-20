---
- dashboard: project_security_compliance
  title: "Project Security & Compliance Dashboard"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive security posture and compliance monitoring dashboard for individual project governance and risk management"
  
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
  
  - name: compliance_period
    title: "Compliance Period"
    type: field_filter
    default_value: "30 days ago for 30 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date
  
  - name: environment_filter
    title: "Environment"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: cur2
    dimension: cur2.environment
  
  - name: compliance_threshold
    title: "Minimum Compliance Score"
    type: field_filter
    default_value: "70"
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      options:
        min: 0
        max: 100
    model: aws_billing
    explore: cur2
    dimension: cur2.tag_coverage_rate

  elements:
  # Row 1: Security Score Summary
  - title: "Overall Compliance Score"
    name: "overall_compliance_score"
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields:
    - cur2.tag_coverage_rate
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "Compliance Score"
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
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 0
    col: 0
    width: 8
    height: 6
    
  - title: "Tagged Resources Rate"
    name: "tagged_resources_rate"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.tag_compliance_percentage
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "Tag Compliance Rate"
    value_format: "#,##0.0%"
    font_size: large
    conditional_formatting:
    - type: greater than
      value: 0.90
      background_color: "#d4edda"
      font_color: "#155724"
      bold: true
    - type: between
      value:
      - 0.70
      - 0.90
      background_color: "#fff3cd"
      font_color: "#856404"
      bold: false
    - type: less than
      value: 0.70
      background_color: "#f8d7da"
      font_color: "#721c24"
      bold: true
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 0
    col: 8
    width: 8
    height: 6
    
  - title: "Security Violations"
    name: "security_violations"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.count_unique_resources
    filters:
      cur2.tag_coverage_rate: "<0.7"
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "Non-Compliant Resources"
    value_format: "#,##0"
    font_size: large
    text_color: "#dc3545"
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 0
    col: 16
    width: 8
    height: 6
    
  # Row 2: Compliance Breakdown
  - title: "Compliance by AWS Service"
    name: "compliance_by_service"
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_product_code
    - cur2.tag_coverage_rate
    - cur2.total_unblended_cost
    - cur2.count_unique_resources
    filters: {}
    sorts:
    - cur2.total_unblended_cost desc
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
    - label: "Compliance Score (%)"
      orientation: left
      series:
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: "Compliance Score"
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
      cur2.tag_coverage_rate: "#28a745"
      cur2.count_unique_resources: "#fd7e14"
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 6
    col: 0
    width: 12
    height: 8
    
  - title: "Environment Compliance Comparison"
    name: "environment_compliance_comparison"
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields:
    - cur2.environment
    - cur2.tag_coverage_rate
    - cur2.tag_compliance_percentage
    - cur2.total_unblended_cost
    filters: {}
    sorts:
    - cur2.tag_coverage_rate desc
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
    series_colors:
      cur2.tag_coverage_rate: "#17a2b8"
      cur2.tag_compliance_percentage: "#28a745"
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
    row: 6
    col: 12
    width: 12
    height: 8
    
  # Row 3: Regional Compliance & Cost Impact
  - title: "Regional Compliance Heatmap"
    name: "regional_compliance_heatmap"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_availability_zone
    - cur2.tag_coverage_rate
    - cur2.tag_compliance_percentage
    - cur2.total_unblended_cost
    - cur2.count_unique_resources
    filters: {}
    sorts:
    - cur2.tag_coverage_rate
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
    - type: less than
      value: 0.70
      background_color: "#ffcccc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_coverage_rate
    - type: between
      value:
      - 0.70
      - 0.85
      background_color: "#fff3cd"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_coverage_rate
    - type: greater than
      value: 0.85
      background_color: "#d4edda"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_coverage_rate
    - type: less than
      value: 0.60
      background_color: "#f8d7da"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_compliance_percentage
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 14
    col: 0
    width: 12
    height: 6
    
  - title: "Cost Impact of Non-Compliance"
    name: "cost_impact_noncompliance"
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields:
    - cur2.tag_coverage_rate_tier
    - cur2.total_unblended_cost
    filters: {}
    sorts:
    - cur2.total_unblended_cost desc
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 40
    series_colors:
      "High Compliance (>85%)": "#28a745"
      "Medium Compliance (70-85%)": "#ffc107"
      "Low Compliance (<70%)": "#dc3545"
      "Unknown": "#6c757d"
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 14
    col: 12
    width: 12
    height: 6
    
  # Row 4: Compliance Trends
  - title: "Compliance Trend Over Time"
    name: "compliance_trend"
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_month
    - cur2.tag_coverage_rate
    - cur2.tag_compliance_percentage
    - cur2.total_unblended_cost
    filters: {}
    sorts:
    - cur2.line_item_usage_start_month
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
    - label: "Compliance Score (%)"
      orientation: left
      series:
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: "Overall Compliance"
      - axisId: cur2.tag_compliance_percentage
        id: cur2.tag_compliance_percentage
        name: "Tag Compliance"
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
      cur2.tag_coverage_rate: "#28a745"
      cur2.tag_compliance_percentage: "#17a2b8"
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
      line_value: 70
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
    row: 20
    col: 0
    width: 24
    height: 8
    
  # Row 5: Detailed Compliance Issues
  - title: "Non-Compliant Resources Requiring Attention"
    name: "noncompliant_resources"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_resource_id
    - cur2.line_item_availability_zone
    - cur2.environment
    - cur2.tag_coverage_rate
    - cur2.tag_compliance_percentage
    - cur2.total_unblended_cost
    filters:
      cur2.tag_coverage_rate: "<0.8"
    sorts:
    - cur2.total_unblended_cost desc
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
    - type: less than
      value: 0.50
      background_color: "#ffcccc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_coverage_rate
    - type: between
      value:
      - 0.50
      - 0.70
      background_color: "#fff3cd"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_coverage_rate
    - type: less than
      value: 0.30
      background_color: "#f8d7da"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.tag_compliance_percentage
    - type: greater than
      value: 100
      background_color: "#ffe6cc"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.total_unblended_cost
    listen:
      project_selector: cur2.environment
      compliance_period: cur2.line_item_usage_start_date
      environment_filter: cur2.environment
      compliance_threshold: cur2.tag_coverage_rate
    row: 28
    col: 0
    width: 24
    height: 10