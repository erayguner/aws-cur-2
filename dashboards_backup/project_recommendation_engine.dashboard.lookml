---
- dashboard: project_recommendation_engine
  title: "Project Optimization Recommendations"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "AI-powered recommendation engine providing prioritized, actionable cost optimization suggestions with ROI analysis"
  
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
  
  - name: recommendation_period
    title: "Analysis Period"
    type: field_filter
    default_value: "90 days ago for 90 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date
  
  - name: min_roi_threshold
    title: "Minimum ROI Threshold (%)"
    type: field_filter
    default_value: "15"
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
    dimension: cur2.savings_percentage
  
  - name: implementation_effort
    title: "Implementation Effort"
    type: field_filter
    default_value: "Low,Medium"
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: cur2
    dimension: cur2.optimization_action_type

  elements:
  # Row 1: Recommendation Summary
  - title: "Total Optimization Potential"
    name: "total_optimization_potential"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.savings_vs_on_demand
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: "Total Savings Potential"
    value_format: "$#,##0"
    font_size: large
    text_color: "#28a745"
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
    row: 0
    col: 0
    width: 6
    height: 4
    
  - title: "High-Impact Recommendations"
    name: "high_impact_recommendations"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.count_unique_resources
    filters:
      cur2.optimization_action_type: "Rightsize,Migrate,Reserved Instance"
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "High-Impact Actions"
    value_format: "#,##0"
    font_size: large
    text_color: "#fd7e14"
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
    row: 0
    col: 6
    width: 6
    height: 4
    
  - title: "Quick Wins Available"
    name: "quick_wins_available"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.count_unique_resources
    filters:
      cur2.optimization_action_type: "Terminate,Schedule,Cleanup"
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "Quick Wins"
    value_format: "#,##0"
    font_size: large
    text_color: "#17a2b8"
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
    row: 0
    col: 12
    width: 6
    height: 4
    
  - title: "ROI Score"
    name: "roi_score"
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields:
    - cur2.savings_percentage
    filters: {}
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: "Overall ROI Score"
    value_format: "#,##0.0%"
    gauge_fill_type: "segment"
    gauge_fill_colors:
    - "#e74c3c"
    - "#f39c12"
    - "#f1c40f"
    - "#2ecc71"
    - "#27ae60"
    range_max: 100
    range_min: 0
    angle_range: 270
    cutout: 60
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
    row: 0
    col: 18
    width: 6
    height: 4
    
  # Row 2: Prioritized Recommendations Matrix
  - title: "Recommendation Priority Matrix"
    name: "recommendation_priority_matrix"
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields:
    - cur2.optimization_action_type
    - cur2.savings_vs_on_demand
    - cur2.total_unblended_cost
    - cur2.tag_coverage_rate
    filters: {}
    sorts:
    - cur2.savings_vs_on_demand desc
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
    plot_size_by_field: cur2.total_unblended_cost
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
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
      "Rightsize": "#ff6b35"
      "Reserved Instance": "#4ecdc4"
      "Migrate": "#45b7d1"
      "Terminate": "#dc3545"
      "Schedule": "#ffc107"
      "Cleanup": "#6f42c1"
    x_axis_label: "Implementation Effort (Cost)"
    y_axis_label: "Potential Savings ($)"
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
      implementation_effort: cur2.optimization_action_type
    row: 4
    col: 0
    width: 24
    height: 10
    
  # Row 3: Action Categories
  - title: "Immediate Actions (0-30 days)"
    name: "immediate_actions"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_resource_id
    - cur2.optimization_action_type
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    - cur2.line_item_availability_zone
    filters:
      cur2.optimization_action_type: "Terminate,Schedule,Cleanup"
    sorts:
    - cur2.savings_vs_on_demand desc
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
    header_font_size: 11
    rows_font_size: 10
    conditional_formatting:
    - type: equal to
      value: "Terminate"
      background_color: "#ffcccc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: equal to
      value: "Schedule"
      background_color: "#fff3cd"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: greater than
      value: 100
      background_color: "#ccffcc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_vs_on_demand
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
    row: 14
    col: 0
    width: 12
    height: 8
    
  - title: "Short-term Actions (30-90 days)"
    name: "short_term_actions"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_resource_id
    - cur2.optimization_action_type
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    - cur2.line_item_availability_zone
    filters:
      cur2.optimization_action_type: "Rightsize,Reserved Instance,Spot"
    sorts:
    - cur2.savings_vs_on_demand desc
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
    header_font_size: 11
    rows_font_size: 10
    conditional_formatting:
    - type: equal to
      value: "Rightsize"
      background_color: "#cce5ff"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: equal to
      value: "Reserved Instance"
      background_color: "#d4edda"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: greater than
      value: 200
      background_color: "#ccffcc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_vs_on_demand
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
    row: 14
    col: 12
    width: 12
    height: 8
    
  # Row 4: ROI Analysis
  - title: "ROI by Recommendation Type"
    name: "roi_by_recommendation"
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.optimization_action_type
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    - cur2.savings_percentage
    filters: {}
    sorts:
    - cur2.savings_percentage desc
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
    - label: "Savings ($)"
      orientation: left
      series:
      - axisId: cur2.savings_vs_on_demand
        id: cur2.savings_vs_on_demand
        name: "Total Savings"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "ROI (%)"
      orientation: right
      series:
      - axisId: cur2.savings_percentage
        id: cur2.savings_percentage
        name: "ROI Percentage"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.savings_vs_on_demand: "#28a745"
      cur2.savings_percentage: "#fd7e14"
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
      implementation_effort: cur2.optimization_action_type
    row: 22
    col: 0
    width: 12
    height: 8
    
  - title: "Implementation Timeline"
    name: "implementation_timeline"
    model: aws_billing
    explore: cur2
    type: looker_timeline
    fields:
    - cur2.optimization_action_type
    - cur2.line_item_usage_start_date
    - cur2.savings_vs_on_demand
    - cur2.line_item_product_code
    filters: {}
    sorts:
    - cur2.line_item_usage_start_date
    limit: 50
    show_view_names: false
    color_application:
      collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
      custom:
        id: "implementation-timeline"
        label: "Implementation Timeline"
        type: "categorical"
        stops:
        - color: "#dc3545"
          offset: 0
        - color: "#ffc107"
          offset: 20
        - color: "#28a745"
          offset: 40
        - color: "#17a2b8"
          offset: 60
        - color: "#6f42c1"
          offset: 80
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
      implementation_effort: cur2.optimization_action_type
    row: 22
    col: 12
    width: 12
    height: 8
    
  # Row 5: Detailed Action Plan
  - title: "Comprehensive Action Plan"
    name: "comprehensive_action_plan"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.optimization_action_type
    - cur2.line_item_product_code
    - cur2.line_item_resource_id
    - cur2.line_item_availability_zone
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    filters: {}
    sorts:
    - cur2.savings_vs_on_demand desc
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
      num_rows: 30
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 11
    rows_font_size: 10
    conditional_formatting:
    - type: contains
      value: "Terminate"
      background_color: "#ffebee"
      font_color: "#d32f2f"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: contains
      value: "Rightsize"
      background_color: "#e3f2fd"
      font_color: "#1976d2"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: contains
      value: "Reserved"
      background_color: "#e8f5e8"
      font_color: "#388e3c"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.optimization_action_type
    - type: greater than
      value: 0.30
      background_color: "#ccffcc"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_percentage
    - type: greater than
      value: 500
      background_color: "#fff9c4"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_vs_on_demand
    listen:
      project_selector: cur2.environment
      recommendation_period: cur2.line_item_usage_start_date
      min_roi_threshold: cur2.savings_percentage
      implementation_effort: cur2.optimization_action_type
    row: 30
    col: 0
    width: 24
    height: 12