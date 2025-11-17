---
- dashboard: consumption_forecasting
  title: Consumption Forecasting Dashboard
  description: 'Advanced forecasting for AWS usage and cost consumption patterns with prediction intervals'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  elements:
  - title: Cost Trend Forecast with Confidence Intervals
    name: cost_trend_forecast
    model: aws_billing
    explore: consumption_forecasting
    type: looker_line
    fields: [
      consumption_cur2.usage_date,
      consumption_cur2.total_daily_cost,
      consumption_cur2.predicted_cost,
      consumption_cur2.cost_upper_bound,
      consumption_cur2.cost_lower_bound
    ]
    pivots: []
    filters: {}
    sorts: [consumption_cur2.usage_date]
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
    - label: Daily Cost
      orientation: left
      series:
      - axisId: consumption_cur2.total_daily_cost
        id: consumption_cur2.total_daily_cost
        name: Actual Cost
      - axisId: consumption_cur2.predicted_cost
        id: consumption_cur2.predicted_cost
        name: Predicted Cost
      - axisId: consumption_cur2.cost_upper_bound
        id: consumption_cur2.cost_upper_bound
        name: Upper Bound (95% CI)
      - axisId: consumption_cur2.cost_lower_bound
        id: consumption_cur2.cost_lower_bound
        name: Lower Bound (95% CI)
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      consumption_cur2.total_daily_cost: '#1f77b4'
      consumption_cur2.predicted_cost: '#ff7f0e'
      consumption_cur2.cost_upper_bound: '#ffb3b3'
      consumption_cur2.cost_lower_bound: '#ffb3b3'
    series_types:
      consumption_cur2.cost_upper_bound: area
      consumption_cur2.cost_lower_bound: area
    series_point_styles:
      consumption_cur2.total_daily_cost: circle
      consumption_cur2.predicted_cost: triangle
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    width: 12
    height: 8
    row: 0
    col: 0
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  - title: Usage Growth Indicators
    name: usage_growth_kpis
    model: aws_billing
    explore: consumption_forecasting
    type: looker_grid
    fields: [
      consumption_cur2.product_name,
      consumption_cur2.usage_growth_rate,
      consumption_cur2.cost_growth_rate,
      consumption_cur2.predicted_usage,
      consumption_cur2.predicted_cost
    ]
    pivots: []
    filters: {}
    sorts: [consumption_cur2.usage_growth_rate desc]
    limit: 20
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
    - type: along a scale...
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: [consumption_cur2.usage_growth_rate]
    - type: along a scale...
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields: [consumption_cur2.cost_growth_rate]
    width: 12
    height: 6
    row: 8
    col: 0
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  - title: Service-Level Consumption Patterns
    name: service_consumption_heatmap
    model: aws_billing
    explore: consumption_forecasting
    type: looker_grid
    fields: [
      consumption_cur2.product_name,
      consumption_cur2.usage_week,
      consumption_cur2.total_daily_usage
    ]
    pivots: [consumption_cur2.usage_week]
    filters: {}
    sorts: [consumption_cur2.usage_week, consumption_cur2.total_daily_usage desc 0]
    limit: 500
    column_limit: 12
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
    width: 12
    height: 8
    row: 14
    col: 0
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  - title: Seasonal Usage Patterns
    name: seasonal_patterns
    model: aws_billing
    explore: consumption_forecasting
    type: looker_column
    fields: [
      consumption_cur2.usage_date,
      consumption_cur2.total_daily_usage,
      consumption_cur2.seasonal_adjustment
    ]
    pivots: []
    filters: {}
    sorts: [consumption_cur2.usage_date]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    y_axes:
    - label: Usage
      orientation: left
      series:
      - axisId: consumption_cur2.total_daily_usage
        id: consumption_cur2.total_daily_usage
        name: Daily Usage
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label: Seasonal Factor
      orientation: right
      series:
      - axisId: consumption_cur2.seasonal_adjustment
        id: consumption_cur2.seasonal_adjustment
        name: Seasonal Factor
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      consumption_cur2.seasonal_adjustment: line
    series_colors:
      consumption_cur2.total_daily_usage: '#1f77b4'
      consumption_cur2.seasonal_adjustment: '#ff7f0e'
    width: 6
    height: 6
    row: 22
    col: 0
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  - title: Cost Volatility Analysis
    name: volatility_analysis
    model: aws_billing
    explore: consumption_forecasting
    type: looker_scatter
    fields: [
      consumption_cur2.product_name,
      consumption_cur2.cost_30day_moving_avg,
      consumption_cur2.cost_volatility,
      consumption_cur2.cost_growth_rate
    ]
    pivots: []
    filters: {}
    sorts: [consumption_cur2.cost_volatility desc]
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
    plot_size_by_dimension: consumption_cur2.cost_growth_rate
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
    width: 6
    height: 6
    row: 22
    col: 6
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  - title: Fastest Growing Services
    name: top_growing_services
    model: aws_billing
    explore: consumption_forecasting
    type: looker_bar
    fields: [
      consumption_cur2.product_name,
      consumption_cur2.usage_growth_rate,
      consumption_cur2.predicted_usage
    ]
    pivots: []
    filters:
      consumption_cur2.usage_growth_rate: '>0'
    sorts: [consumption_cur2.usage_growth_rate desc]
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
    - label: Growth Rate %
      orientation: left
      series:
      - axisId: consumption_cur2.usage_growth_rate
        id: consumption_cur2.usage_growth_rate
        name: Usage Growth Rate
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      consumption_cur2.usage_growth_rate: '#e31a1c'
    width: 6
    height: 6
    row: 28
    col: 0
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  - title: Usage Efficiency Trends
    name: usage_efficiency_trends
    model: aws_billing
    explore: consumption_forecasting
    type: looker_line
    fields: [
      consumption_cur2.usage_month,
      consumption_cur2.total_daily_cost,
      consumption_cur2.total_daily_usage
    ]
    pivots: []
    filters: {}
    sorts: [consumption_cur2.usage_month]
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
    - label: Cost
      orientation: left
      series:
      - axisId: consumption_cur2.total_daily_cost
        id: consumption_cur2.total_daily_cost
        name: Daily Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label: Usage
      orientation: right
      series:
      - axisId: consumption_cur2.total_daily_usage
        id: consumption_cur2.total_daily_usage
        name: Daily Usage
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      consumption_cur2.total_daily_cost: '#1f77b4'
      consumption_cur2.total_daily_usage: '#ff7f0e'
    width: 6
    height: 6
    row: 28
    col: 6
    listen:
      Historical Period: consumption_cur2.usage_date
      AWS Service: consumption_cur2.product_name
      Account: consumption_cur2.account_name

  filters:
  - name: Historical Period
    title: Historical Period
    type: field_filter
    default_value: '90 days ago for 90 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: consumption_forecasting
    listens_to_filters: []
    field: consumption_cur2.usage_date

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
    explore: consumption_forecasting
    listens_to_filters: []
    field: consumption_cur2.product_name

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
    explore: consumption_forecasting
    listens_to_filters: []
    field: consumption_cur2.account_name