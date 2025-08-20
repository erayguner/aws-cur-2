---
- dashboard: forecasting_analytics
  title: "Forecasting Analytics Dashboard"
  description: "Model accuracy tracking, prediction confidence analysis, and scenario planning tools"
  layout: newspaper
  preferred_viewer: dashboards-next

  filters:
  - name: forecast_period_filter
    title: "Forecast Period"
    type: field_filter
    default_value: "12 weeks ago for 12 weeks"
    allow_multiple_values: no
    required: no
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: forecasting_analytics
    dimension: forecasting_analytics.forecast_week_date

  - name: service_filter
    title: "AWS Service"
    type: field_filter
    default_value: ""
    allow_multiple_values: yes
    required: no
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: forecasting_analytics
    dimension: forecasting_analytics.product_name

  - name: account_filter
    title: "Account"
    type: field_filter
    default_value: ""
    allow_multiple_values: yes
    required: no
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: forecasting_analytics
    dimension: forecasting_analytics.account_name

  - name: confidence_filter
    title: "Prediction Confidence"
    type: field_filter
    default_value: ""
    allow_multiple_values: yes
    required: no
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: forecasting_analytics
    dimension: forecasting_analytics.prediction_confidence

  elements:
  # Model Performance Comparison
  - name: "model_performance_comparison"
    title: "Model Performance Comparison"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_grid
    fields:
    - forecasting_analytics.product_name
    - forecasting_analytics.account_name
    - forecasting_analytics.best_model
    - forecasting_analytics.prediction_confidence
    - forecasting_analytics.best_model_accuracy
    - forecasting_analytics.predictability_score
    - forecasting_analytics.cost_stability
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.best_model_accuracy desc
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
      value: 85
      background_color: "#d4edda"
      font_color: "#155724"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields:
      - forecasting_analytics.best_model_accuracy
    - type: between
      value:
      - 70
      - 85
      background_color: "#fff3cd"
      font_color: "#856404"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields:
      - forecasting_analytics.best_model_accuracy
    - type: less than
      value: 70
      background_color: "#f8d7da"
      font_color: "#721c24"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      bold: false
      italic: false
      strikethrough: false
      fields:
      - forecasting_analytics.best_model_accuracy
    width: 12
    height: 8
    row: 0
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Forecast vs Actual Comparison
  - name: "forecast_vs_actual_comparison"
    title: "Forecast vs Actual Performance"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_line
    fields:
    - forecasting_analytics.forecast_week_week
    - forecasting_analytics.actual_weekly_cost
    - forecasting_analytics.linear_forecast
    - forecasting_analytics.moving_avg_forecast
    - forecasting_analytics.exp_smoothing_forecast
    - forecasting_analytics.recommended_forecast
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.forecast_week_week
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
    trellis: ""
    stacking: ""
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
    - label: "Weekly Cost"
      orientation: left
      series:
      - axisId: forecasting_analytics.actual_weekly_cost
        id: forecasting_analytics.actual_weekly_cost
        name: "Actual Cost"
      - axisId: forecasting_analytics.linear_forecast
        id: forecasting_analytics.linear_forecast
        name: "Linear Forecast"
      - axisId: forecasting_analytics.moving_avg_forecast
        id: forecasting_analytics.moving_avg_forecast
        name: "Moving Average"
      - axisId: forecasting_analytics.exp_smoothing_forecast
        id: forecasting_analytics.exp_smoothing_forecast
        name: "Exponential Smoothing"
      - axisId: forecasting_analytics.recommended_forecast
        id: forecasting_analytics.recommended_forecast
        name: "Best Model"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      forecasting_analytics.actual_weekly_cost: "#1f77b4"
      forecasting_analytics.linear_forecast: "#ff7f0e"
      forecasting_analytics.moving_avg_forecast: "#2ca02c"
      forecasting_analytics.exp_smoothing_forecast: "#d62728"
      forecasting_analytics.recommended_forecast: "#9467bd"
    series_types: {}
    series_point_styles:
      forecasting_analytics.actual_weekly_cost: circle
      forecasting_analytics.linear_forecast: triangle
      forecasting_analytics.moving_avg_forecast: square
      forecasting_analytics.exp_smoothing_forecast: diamond
      forecasting_analytics.recommended_forecast: hexagon
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    width: 12
    height: 8
    row: 8
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Model Error Analysis
  - name: "model_error_analysis"
    title: "Model Error Analysis"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_column
    fields:
    - forecasting_analytics.product_name
    - forecasting_analytics.linear_percentage_error
    - forecasting_analytics.moving_avg_percentage_error
    - forecasting_analytics.exp_smoothing_percentage_error
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.linear_percentage_error
    limit: 15
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
    - label: "Prediction Error %"
      orientation: left
      series:
      - axisId: forecasting_analytics.linear_percentage_error
        id: forecasting_analytics.linear_percentage_error
        name: "Linear Model"
      - axisId: forecasting_analytics.moving_avg_percentage_error
        id: forecasting_analytics.moving_avg_percentage_error
        name: "Moving Average"
      - axisId: forecasting_analytics.exp_smoothing_percentage_error
        id: forecasting_analytics.exp_smoothing_percentage_error
        name: "Exp Smoothing"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      forecasting_analytics.linear_percentage_error: "#ff7f0e"
      forecasting_analytics.moving_avg_percentage_error: "#2ca02c"
      forecasting_analytics.exp_smoothing_percentage_error: "#d62728"
    width: 8
    height: 6
    row: 16
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Prediction Confidence Distribution
  - name: "prediction_confidence_distribution"
    title: "Prediction Confidence Distribution"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_pie
    fields:
    - forecasting_analytics.prediction_confidence
    - forecasting_analytics.predictability_score
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.predictability_score desc
    limit: 500
    column_limit: 50
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    colors:
    - "#28a745"
    - "#ffc107"
    - "#fd7e14"
    - "#dc3545"
    series_colors:
      forecasting_analytics.HIGH: "#28a745"
      forecasting_analytics.MEDIUM: "#ffc107"
      forecasting_analytics.LOW: "#fd7e14"
      forecasting_analytics.VERY_LOW: "#dc3545"
    width: 4
    height: 6
    row: 16
    col: 8
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Scenario Planning Analysis
  - name: "scenario_planning_analysis"
    title: "Scenario Planning Analysis"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_column
    fields:
    - forecasting_analytics.product_name
    - forecasting_analytics.actual_weekly_cost
    - forecasting_analytics.optimistic_scenario
    - forecasting_analytics.pessimistic_scenario
    - forecasting_analytics.stress_test_scenario
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.actual_weekly_cost desc
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
    trellis: ""
    stacking: ""
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
    totals_color: "#808080"
    y_axes:
    - label: "Weekly Cost"
      orientation: left
      series:
      - axisId: forecasting_analytics.actual_weekly_cost
        id: forecasting_analytics.actual_weekly_cost
        name: "Current"
      - axisId: forecasting_analytics.optimistic_scenario
        id: forecasting_analytics.optimistic_scenario
        name: "Optimistic (+10%)"
      - axisId: forecasting_analytics.pessimistic_scenario
        id: forecasting_analytics.pessimistic_scenario
        name: "Pessimistic (-10%)"
      - axisId: forecasting_analytics.stress_test_scenario
        id: forecasting_analytics.stress_test_scenario
        name: "Stress Test (+20%)"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      forecasting_analytics.actual_weekly_cost: "#1f77b4"
      forecasting_analytics.optimistic_scenario: "#28a745"
      forecasting_analytics.pessimistic_scenario: "#ffc107"
      forecasting_analytics.stress_test_scenario: "#dc3545"
    width: 12
    height: 6
    row: 22
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Model Bias Analysis
  - name: "model_bias_analysis"
    title: "Model Bias Analysis"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_bar
    fields:
    - forecasting_analytics.product_name
    - forecasting_analytics.linear_bias
    - forecasting_analytics.moving_avg_bias
    - forecasting_analytics.exp_smoothing_bias
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.linear_bias desc
    limit: 15
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
    - label: "Bias (%)"
      orientation: left
      series:
      - axisId: forecasting_analytics.linear_bias
        id: forecasting_analytics.linear_bias
        name: "Linear Bias"
      - axisId: forecasting_analytics.moving_avg_bias
        id: forecasting_analytics.moving_avg_bias
        name: "Moving Avg Bias"
      - axisId: forecasting_analytics.exp_smoothing_bias
        id: forecasting_analytics.exp_smoothing_bias
        name: "Exp Smoothing Bias"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      forecasting_analytics.linear_bias: "#ff7f0e"
      forecasting_analytics.moving_avg_bias: "#2ca02c"
      forecasting_analytics.exp_smoothing_bias: "#d62728"
    width: 8
    height: 8
    row: 28
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Volatility vs Accuracy Scatter
  - name: "volatility_vs_accuracy_scatter"
    title: "Volatility vs Accuracy Analysis"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_scatter
    fields:
    - forecasting_analytics.product_name
    - forecasting_analytics.cost_volatility_4week
    - forecasting_analytics.best_model_accuracy
    - forecasting_analytics.trend_strength_4week
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.best_model_accuracy desc
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
    plot_size_by_dimension: forecasting_analytics.trend_strength_4week
    trellis: ""
    stacking: ""
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
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    width: 4
    height: 8
    row: 28
    col: 8
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Best Model Distribution
  - name: "best_model_distribution"
    title: "Best Model Distribution"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_donut_multiples
    fields:
    - forecasting_analytics.best_model
    - forecasting_analytics.predictability_score
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.predictability_score desc
    limit: 500
    column_limit: 50
    show_value_labels: true
    font_size: 12
    colors:
    - "#17a2b8"
    - "#28a745"
    - "#6f42c1"
    series_colors:
      forecasting_analytics.LINEAR: "#17a2b8"
      forecasting_analytics.MOVING_AVERAGE: "#28a745"
      forecasting_analytics.EXPONENTIAL_SMOOTHING: "#6f42c1"
    width: 12
    height: 6
    row: 36
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence

  # Confidence Intervals Visualization
  - name: "confidence_intervals_visualization"
    title: "Forecast Confidence Intervals"
    model: aws_billing
    explore: forecasting_analytics
    type: looker_line
    fields:
    - forecasting_analytics.forecast_week_week
    - forecasting_analytics.recommended_forecast
    - forecasting_analytics.forecast_upper_bound
    - forecasting_analytics.forecast_lower_bound
    - forecasting_analytics.actual_weekly_cost
    pivots: []
    filters: {}
    sorts:
    - forecasting_analytics.forecast_week_week
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
    trellis: ""
    stacking: ""
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
    - label: "Weekly Cost"
      orientation: left
      series:
      - axisId: forecasting_analytics.recommended_forecast
        id: forecasting_analytics.recommended_forecast
        name: "Forecast"
      - axisId: forecasting_analytics.forecast_upper_bound
        id: forecasting_analytics.forecast_upper_bound
        name: "Upper Bound"
      - axisId: forecasting_analytics.forecast_lower_bound
        id: forecasting_analytics.forecast_lower_bound
        name: "Lower Bound"
      - axisId: forecasting_analytics.actual_weekly_cost
        id: forecasting_analytics.actual_weekly_cost
        name: "Actual"
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    x_axis_zoom: true
    y_axis_zoom: true
    series_colors:
      forecasting_analytics.recommended_forecast: "#1f77b4"
      forecasting_analytics.forecast_upper_bound: "#ffcccc"
      forecasting_analytics.forecast_lower_bound: "#ffcccc"
      forecasting_analytics.actual_weekly_cost: "#ff7f0e"
    series_types:
      forecasting_analytics.forecast_upper_bound: area
      forecasting_analytics.forecast_lower_bound: area
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    width: 12
    height: 8
    row: 42
    col: 0
    listen:
      forecast_period_filter: forecasting_analytics.forecast_week_date
      service_filter: forecasting_analytics.product_name
      account_filter: forecasting_analytics.account_name
      confidence_filter: forecasting_analytics.prediction_confidence