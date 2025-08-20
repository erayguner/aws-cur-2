---
- dashboard: budget_forecasting
  title: Budget Forecasting Dashboard
  description: 'Financial planning with budget variance predictions, cost projections, and ROI analysis'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  elements:
  - title: Budget Health Overview
    name: budget_health_overview
    model: aws_billing
    explore: budget_forecasting
    type: looker_grid
    fields: [
      budget_cur2.product_name,
      budget_cur2.account_name,
      budget_cur2.budget_status,
      budget_cur2.budget_variance,
      budget_cur2.budget_variance_percent,
      budget_cur2.budget_health_score,
      budget_cur2.forecasted_monthly_budget
    ]
    pivots: []
    filters: {}
    sorts: [budget_cur2.budget_health_score]
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
    - type: less than
      value: 60
      background_color: '#f8d7da'
      font_color: '#721c24'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: true
      italic: false
      strikethrough: false
      fields: [budget_cur2.budget_health_score]
    - type: between
      value: [60, 80]
      background_color: '#fff3cd'
      font_color: '#856404'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: [budget_cur2.budget_health_score]
    - type: greater than
      value: 80
      background_color: '#d4edda'
      font_color: '#155724'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: [budget_cur2.budget_health_score]
    width: 12
    height: 8
    row: 0
    col: 0
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: Budget vs Actual Cost Trends
    name: budget_vs_actual_trend
    model: aws_billing
    explore: budget_forecasting
    type: looker_line
    fields: [
      budget_cur2.budget_month_month,
      budget_cur2.actual_cost,
      budget_cur2.baseline_budget,
      budget_cur2.forecasted_monthly_budget,
      budget_cur2.budget_upper_bound,
      budget_cur2.budget_lower_bound
    ]
    pivots: []
    filters: {}
    sorts: [budget_cur2.budget_month_month]
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
    - label: Monthly Cost
      orientation: left
      series:
      - axisId: budget_cur2.actual_cost
        id: budget_cur2.actual_cost
        name: Actual Cost
      - axisId: budget_cur2.baseline_budget
        id: budget_cur2.baseline_budget
        name: Baseline Budget
      - axisId: budget_cur2.forecasted_monthly_budget
        id: budget_cur2.forecasted_monthly_budget
        name: Forecasted Budget
      - axisId: budget_cur2.budget_upper_bound
        id: budget_cur2.budget_upper_bound
        name: Upper Bound
      - axisId: budget_cur2.budget_lower_bound
        id: budget_cur2.budget_lower_bound
        name: Lower Bound
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      budget_cur2.actual_cost: '#1f77b4'
      budget_cur2.baseline_budget: '#ff7f0e'
      budget_cur2.forecasted_monthly_budget: '#2ca02c'
      budget_cur2.budget_upper_bound: '#ffcccc'
      budget_cur2.budget_lower_bound: '#ffcccc'
    series_types:
      budget_cur2.budget_upper_bound: area
      budget_cur2.budget_lower_bound: area
    series_point_styles:
      budget_cur2.actual_cost: circle
      budget_cur2.baseline_budget: triangle
      budget_cur2.forecasted_monthly_budget: diamond
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    width: 12
    height: 8
    row: 8
    col: 0
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: Monthly Budget Variance Analysis
    name: budget_variance_analysis
    model: aws_billing
    explore: budget_forecasting
    type: looker_column
    fields: [
      budget_cur2.budget_month_month,
      budget_cur2.budget_variance,
      budget_cur2.budget_variance_percent
    ]
    pivots: []
    filters: {}
    sorts: [budget_cur2.budget_month_month]
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    y_axes:
    - label: Variance ($)
      orientation: left
      series:
      - axisId: budget_cur2.budget_variance
        id: budget_cur2.budget_variance
        name: Budget Variance
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label: Variance (%)
      orientation: right
      series:
      - axisId: budget_cur2.budget_variance_percent
        id: budget_cur2.budget_variance_percent
        name: Variance %
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      budget_cur2.budget_variance: '#1f77b4'
      budget_cur2.budget_variance_percent: '#ff7f0e'
    series_types:
      budget_cur2.budget_variance_percent: line
    width: 8
    height: 6
    row: 16
    col: 0
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: ROI & Savings Tracker
    name: roi_savings_tracker
    model: aws_billing
    explore: budget_forecasting
    type: single_value
    fields: [budget_cur2.month_over_month_savings_percent]
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
    custom_color: '#28a745'
    single_value_title: Month-over-Month Savings
    conditional_formatting:
    - type: greater than
      value: 10
      background_color: '#28a745'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: true
      italic: false
      strikethrough: false
      fields: []
    - type: between
      value: [5, 10]
      background_color: '#ffc107'
      font_color: '#000000'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: []
    - type: less than
      value: 5
      background_color: '#dc3545'
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
    row: 16
    col: 8
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: Seasonal Budget Patterns
    name: seasonal_budget_patterns
    model: aws_billing
    explore: budget_forecasting
    type: looker_line
    fields: [
      budget_cur2.budget_month_month,
      budget_cur2.seasonal_factor,
      budget_cur2.monthly_growth_rate
    ]
    pivots: []
    filters: {}
    sorts: [budget_cur2.budget_month_month]
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
    y_axis_combined: false
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: Seasonal Factor
      orientation: left
      series:
      - axisId: budget_cur2.seasonal_factor
        id: budget_cur2.seasonal_factor
        name: Seasonal Factor
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label: Growth Rate (%)
      orientation: right
      series:
      - axisId: budget_cur2.monthly_growth_rate
        id: budget_cur2.monthly_growth_rate
        name: Monthly Growth Rate
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      budget_cur2.seasonal_factor: '#1f77b4'
      budget_cur2.monthly_growth_rate: '#ff7f0e'
    width: 12
    height: 6
    row: 22
    col: 0
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: Cost Efficiency Trends
    name: cost_efficiency_analysis
    model: aws_billing
    explore: budget_forecasting
    type: looker_scatter
    fields: [
      budget_cur2.product_name,
      budget_cur2.cost_per_unit,
      budget_cur2.cost_volatility_6month,
      budget_cur2.monthly_growth_rate
    ]
    pivots: []
    filters: {}
    sorts: [budget_cur2.cost_per_unit desc]
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
    plot_size_by_dimension: budget_cur2.monthly_growth_rate
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    x_axis_zoom: true
    y_axis_zoom: true
    width: 8
    height: 8
    row: 28
    col: 0
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: Annual Budget Projection
    name: annual_budget_projection
    model: aws_billing
    explore: budget_forecasting
    type: single_value
    fields: [budget_cur2.forecasted_annual_budget]
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
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: '#1f77b4'
    single_value_title: Forecasted Annual Budget
    width: 4
    height: 4
    row: 28
    col: 8
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  - title: YTD Budget Performance
    name: ytd_budget_performance
    model: aws_billing
    explore: budget_forecasting
    type: single_value
    fields: [budget_cur2.ytd_budget_variance]
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
    single_value_title: YTD Budget Variance
    conditional_formatting:
    - type: greater than
      value: 0
      background_color: '#dc3545'
      font_color: '#FFFFFF'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: []
    - type: less than
      value: 0
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
    height: 4
    row: 32
    col: 8
    listen:
      Budget Period: budget_cur2.budget_month_date
      AWS Service: budget_cur2.product_name
      Account: budget_cur2.account_name
      Budget Status: budget_cur2.budget_status

  filters:
  - name: Budget Period
    title: Budget Period
    type: field_filter
    default_value: '12 months ago for 12 months'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: budget_forecasting
    listens_to_filters: []
    field: budget_cur2.budget_month_date

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
    explore: budget_forecasting
    listens_to_filters: []
    field: budget_cur2.product_name

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
    explore: budget_forecasting
    listens_to_filters: []
    field: budget_cur2.account_name

  - name: Budget Status
    title: Budget Status
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: budget_forecasting
    listens_to_filters: []
    field: budget_cur2.budget_status