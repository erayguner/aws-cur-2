---
- dashboard: capacity_planning
  title: Capacity Planning Dashboard
  description: 'Resource demand forecasting, scaling recommendations, and capacity constraint monitoring'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  elements:
  - title: Scaling Recommendations
    name: scaling_recommendations
    model: aws_billing
    explore: capacity_planning
    type: looker_grid
    fields: [
      capacity_planning.product_name,
      capacity_planning.account_name,
      capacity_planning.availability_zone,
      capacity_planning.scaling_recommendation,
      capacity_planning.days_to_capacity_limit,
      capacity_planning.estimated_cost_impact,
      capacity_planning.volatility_risk
    ]
    pivots: []
    filters:
      capacity_planning.scaling_recommendation: '-OPTIMAL'
    sorts: [capacity_planning.scaling_recommendation, capacity_planning.days_to_capacity_limit]
    limit: 500
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
    - type: equal to
      value: IMMEDIATE_SCALE_UP
      background_color: '#dc3545'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: true
      italic: false
      strikethrough: false
      fields: [capacity_planning.scaling_recommendation]
    - type: equal to
      value: SCALE_UP_SOON
      background_color: '#fd7e14'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: true
      italic: false
      strikethrough: false
      fields: [capacity_planning.scaling_recommendation]
    - type: less than
      value: 7
      background_color: '#dc3545'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: true
      italic: false
      strikethrough: false
      fields: [capacity_planning.days_to_capacity_limit]
    width: 12
    height: 8
    row: 0
    col: 0
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  - title: Capacity Utilization Trends
    name: capacity_utilization_trends
    model: aws_billing
    explore: capacity_planning
    type: looker_line
    fields: [
      capacity_planning.usage_date,
      capacity_planning.avg_resource_utilization,
      capacity_planning.peak_resource_utilization,
      capacity_planning.p95_utilization,
      capacity_planning.p80_utilization
    ]
    pivots: []
    filters: {}
    sorts: [capacity_planning.usage_date]
    limit: 500
    column_limit: 50
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: Resource Utilization
      orientation: left
      series:
      - axisId: capacity_planning.avg_resource_utilization
        id: capacity_planning.avg_resource_utilization
        name: Average Utilization
      - axisId: capacity_planning.peak_resource_utilization
        id: capacity_planning.peak_resource_utilization
        name: Peak Utilization
      - axisId: capacity_planning.p95_utilization
        id: capacity_planning.p95_utilization
        name: 95th Percentile
      - axisId: capacity_planning.p80_utilization
        id: capacity_planning.p80_utilization
        name: 80th Percentile
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      capacity_planning.avg_resource_utilization: '#1f77b4'
      capacity_planning.peak_resource_utilization: '#ff7f0e'
      capacity_planning.p95_utilization: '#2ca02c'
      capacity_planning.p80_utilization: '#d62728'
    series_types: {}
    series_point_styles:
      capacity_planning.avg_resource_utilization: circle
      capacity_planning.peak_resource_utilization: triangle
      capacity_planning.p95_utilization: square
      capacity_planning.p80_utilization: diamond
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    width: 8
    height: 6
    row: 8
    col: 0
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  - title: Capacity Growth Rate
    name: capacity_growth_gauge
    model: aws_billing
    explore: capacity_planning
    type: single_value
    fields: [capacity_planning.capacity_growth_rate]
    pivots: []
    filters: {}
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: '#1f77b4'
    single_value_title: Weekly Capacity Growth Rate
    conditional_formatting:
    - type: greater than
      value: 20
      background_color: '#dc3545'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: []
    - type: between
      value: [10, 20]
      background_color: '#fd7e14'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: []
    - type: between
      value: [0, 10]
      background_color: '#28a745'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: []
    width: 4
    height: 6
    row: 8
    col: 8
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  - title: Current vs Predicted Capacity (30d)
    name: predicted_vs_current_capacity
    model: aws_billing
    explore: capacity_planning
    type: looker_column
    fields: [
      capacity_planning.product_name,
      capacity_planning.total_capacity_used,
      capacity_planning.predicted_capacity_30d,
      capacity_planning.recommended_capacity
    ]
    pivots: []
    filters: {}
    sorts: [capacity_planning.total_capacity_used desc]
    limit: 10
    column_limit: 50
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
    y_axes:
    - label: Capacity Units
      orientation: left
      series:
      - axisId: capacity_planning.total_capacity_used
        id: capacity_planning.total_capacity_used
        name: Current Capacity
      - axisId: capacity_planning.predicted_capacity_30d
        id: capacity_planning.predicted_capacity_30d
        name: Predicted Capacity (30d)
      - axisId: capacity_planning.recommended_capacity
        id: capacity_planning.recommended_capacity
        name: Recommended Capacity
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      capacity_planning.total_capacity_used: '#1f77b4'
      capacity_planning.predicted_capacity_30d: '#ff7f0e'
      capacity_planning.recommended_capacity: '#2ca02c'
    width: 12
    height: 6
    row: 14
    col: 0
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  - title: Scaling Cost Impact Analysis
    name: cost_impact_analysis
    model: aws_billing
    explore: capacity_planning
    type: looker_grid
    fields: [
      capacity_planning.product_name,
      capacity_planning.account_name,
      capacity_planning.scaling_recommendation,
      capacity_planning.total_cost,
      capacity_planning.estimated_cost_impact,
      capacity_planning.total_capacity_used,
      capacity_planning.recommended_capacity
    ]
    pivots: []
    filters: {}
    sorts: [capacity_planning.estimated_cost_impact desc]
    limit: 500
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
    - type: greater than
      value: 0
      background_color: '#f8d7da'
      font_color: '#721c24'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: [capacity_planning.estimated_cost_impact]
    - type: less than
      value: 0
      background_color: '#d4edda'
      font_color: '#155724'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: [capacity_planning.estimated_cost_impact]
    width: 12
    height: 8
    row: 20
    col: 0
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  - title: Utilization Heatmap by Availability Zone
    name: utilization_heatmap_by_az
    model: aws_billing
    explore: capacity_planning
    type: looker_grid
    fields: [
      capacity_planning.product_name,
      capacity_planning.usage_week,
      capacity_planning.avg_resource_utilization
    ]
    pivots: [capacity_planning.usage_week]
    filters: {}
    sorts: [capacity_planning.usage_week, capacity_planning.avg_resource_utilization desc 0]
    limit: 500
    column_limit: 8
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
    - type: along a scale...
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
        palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825
      bold: false
      italic: false
      strikethrough: false
      fields: []
    width: 8
    height: 8
    row: 28
    col: 0
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  - title: Critical Capacity Alerts
    name: critical_capacity_alerts
    model: aws_billing
    explore: capacity_planning
    type: single_value
    fields: [capacity_planning.active_resources]
    pivots: []
    filters:
      capacity_planning.scaling_recommendation: IMMEDIATE_SCALE_UP
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: '#dc3545'
    single_value_title: Resources Requiring Immediate Scaling
    conditional_formatting:
    - type: greater than
      value: 0
      background_color: '#dc3545'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: true
      italic: false
      strikethrough: false
      fields: []
    width: 4
    height: 8
    row: 28
    col: 8
    listen:
      Analysis Period: capacity_planning.usage_date
      AWS Service: capacity_planning.product_name
      Account: capacity_planning.account_name
      Availability Zone: capacity_planning.availability_zone

  filters:
  - name: Analysis Period
    title: Analysis Period
    type: field_filter
    default_value: '30 days ago for 30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: capacity_planning
    listens_to_filters: []
    field: capacity_planning.usage_date

  - name: AWS Service
    title: AWS Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: capacity_planning
    listens_to_filters: []
    field: capacity_planning.product_name

  - name: Account
    title: Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: capacity_planning
    listens_to_filters: []
    field: capacity_planning.account_name

  - name: Availability Zone
    title: Availability Zone
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: capacity_planning
    listens_to_filters: []
    field: capacity_planning.availability_zone