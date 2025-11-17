---
# =====================================================
# PREDICTIVE COST FORECASTING DASHBOARD (P10/P50/P90)
# =====================================================
# Advanced timeseries forecasting with probabilistic predictions
# Based on AWS Forecast, DeepAR+, and ETS models
#
# Features:
# - P10, P50, P90 quantile forecasts (lower, median, upper bounds)
# - Multiple forecasting models (DeepAR+, ETS, Prophet, ARIMA)
# - Confidence intervals and prediction accuracy
# - Scenario planning and what-if analysis
# - Budget variance predictions
# - Seasonality and trend decomposition
# =====================================================

- dashboard: predictive_cost_forecasting_p10_p50_p90
  title: 🔮 Predictive Cost Forecasting Dashboard (P10/P50/P90)
  description: 'Advanced timeseries cost forecasting with probabilistic predictions using P10/P50/P90 quantiles, multiple ML models, and scenario planning'
  layout: newspaper
  preferred_viewer: dashboards-next

  auto_run: true
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true

  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'

  elements:
  # =====================================================
  # FORECAST OVERVIEW KPIs
  # =====================================================

  - title: 📈 30-Day Forecast (P50)
    name: forecast_30d_p50
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.forecast_30d_p50_median]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    single_value_title: 30-DAY FORECAST (MEDIAN)
    value_format: "$#,##0"
    comparison_label: vs Current Month
    conditional_formatting:
    - type: greater than
      value: 100000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    listen:
      Forecast_Model: cur2.forecast_model_type
      Confidence_Level: cur2.confidence_level_percentage
    row: 0
    col: 0
    width: 6
    height: 4

  - title: 📉 Best Case (P10)
    name: forecast_30d_p10
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.forecast_30d_p10_lower]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: BEST CASE SCENARIO (P10)
    value_format: "$#,##0"
    conditional_formatting:
    - type: always
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Forecast_Model: cur2.forecast_model_type
      Confidence_Level: cur2.confidence_level_percentage
    row: 0
    col: 6
    width: 6
    height: 4

  - title: 📈 Worst Case (P90)
    name: forecast_30d_p90
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.forecast_30d_p90_upper]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: WORST CASE SCENARIO (P90)
    value_format: "$#,##0"
    conditional_formatting:
    - type: always
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
    listen:
      Forecast_Model: cur2.forecast_model_type
      Confidence_Level: cur2.confidence_level_percentage
    row: 0
    col: 12
    width: 6
    height: 4

  - title: 🎯 Forecast Accuracy (MAPE)
    name: forecast_accuracy_mape
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.forecast_mape_accuracy]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: FORECAST ACCURACY (MAPE)
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [80, 90]
      background_color: '#eab308'
      font_color: '#78350f'
      bold: true
    - type: less than
      value: 80
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
      Forecast_Model: cur2.forecast_model_type
    row: 0
    col: 18
    width: 6
    height: 4

  # =====================================================
  # MAIN FORECAST VISUALIZATION (P10/P50/P90)
  # =====================================================

  - title: 📊 Cost Forecast with Confidence Intervals (P10/P50/P90)
    name: main_forecast_visualization
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.forecast_date, cur2.actual_cost_historical,
             cur2.forecast_p10_lower_bound, cur2.forecast_p50_median,
             cur2.forecast_p90_upper_bound]
    sorts: [cur2.forecast_date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    x_axis_label: Date
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    y_axis_label: Cost ($)
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_dimension: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    y_axes:
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.actual_cost_historical
        id: cur2.actual_cost_historical
        name: Actual Cost
      - axisId: cur2.forecast_p10_lower_bound
        id: cur2.forecast_p10_lower_bound
        name: P10 (Best Case)
      - axisId: cur2.forecast_p50_median
        id: cur2.forecast_p50_median
        name: P50 (Median)
      - axisId: cur2.forecast_p90_upper_bound
        id: cur2.forecast_p90_upper_bound
        name: P90 (Worst Case)
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.forecast_p10_lower_bound: area
      cur2.forecast_p90_upper_bound: area
    series_colors:
      cur2.actual_cost_historical: '#1f77b4'
      cur2.forecast_p50_median: '#2ca02c'
      cur2.forecast_p10_lower_bound: '#d1fae5'
      cur2.forecast_p90_upper_bound: '#fee2e2'
    series_point_styles:
      cur2.actual_cost_historical: circle
      cur2.forecast_p50_median: diamond
    reference_lines:
    - reference_type: line
      line_value: median
      range_start: max
      range_end: min
      margin_top: deviation
      margin_value: mean
      margin_bottom: deviation
      label_position: right
      color: '#9334e9'
      label: Budget Threshold
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
      Forecast_Model: cur2.forecast_model_type
      Confidence_Level: cur2.confidence_level_percentage
    row: 4
    col: 0
    width: 24
    height: 10

  # =====================================================
  # MODEL COMPARISON
  # =====================================================

  - title: 🤖 Multi-Model Forecast Comparison
    name: multi_model_comparison
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.forecast_date, cur2.actual_cost_historical,
             cur2.deepar_forecast, cur2.ets_forecast,
             cur2.prophet_forecast, cur2.arima_forecast,
             cur2.ensemble_forecast]
    sorts: [cur2.forecast_date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    series_colors:
      cur2.actual_cost_historical: '#1f77b4'
      cur2.deepar_forecast: '#ff7f0e'
      cur2.ets_forecast: '#2ca02c'
      cur2.prophet_forecast: '#d62728'
      cur2.arima_forecast: '#9467bd'
      cur2.ensemble_forecast: '#8c564b'
    series_point_styles:
      cur2.actual_cost_historical: circle
      cur2.deepar_forecast: triangle
      cur2.ets_forecast: square
      cur2.prophet_forecast: diamond
      cur2.arima_forecast: hexagon
      cur2.ensemble_forecast: star
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
      Confidence_Level: cur2.confidence_level_percentage
    row: 14
    col: 0
    width: 16
    height: 10

  - title: 📊 Model Accuracy Comparison
    name: model_accuracy_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.forecast_model_type, cur2.forecast_mape_accuracy,
             cur2.forecast_rmse, cur2.forecast_mae]
    sorts: [cur2.forecast_mape_accuracy desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    point_style: circle
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
    - label: MAPE Accuracy %
      orientation: left
      series:
      - axisId: cur2.forecast_mape_accuracy
        id: cur2.forecast_mape_accuracy
        name: MAPE Accuracy
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Error Metrics
      orientation: right
      series:
      - axisId: cur2.forecast_rmse
        id: cur2.forecast_rmse
        name: RMSE
      - axisId: cur2.forecast_mae
        id: cur2.forecast_mae
        name: MAE
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.forecast_rmse: line
      cur2.forecast_mae: line
    series_colors:
      cur2.forecast_mape_accuracy: '#16a34a'
      cur2.forecast_rmse: '#dc2626'
      cur2.forecast_mae: '#fbbf24'
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
    row: 14
    col: 16
    width: 8
    height: 10

  # =====================================================
  # SERVICE-LEVEL FORECASTS
  # =====================================================

  - title: 🔧 Top Services - 30-Day Forecast
    name: top_services_forecast
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.current_monthly_cost,
             cur2.forecast_p10_lower_bound, cur2.forecast_p50_median,
             cur2.forecast_p90_upper_bound, cur2.forecast_growth_rate,
             cur2.forecast_confidence_score]
    filters:
      cur2.forecast_horizon_days: '30'
    sorts: [cur2.current_monthly_cost desc]
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting:
    - type: greater than
      value: 20
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
      fields: [cur2.forecast_growth_rate]
    - type: less than
      value: -10
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.forecast_growth_rate]
    - type: greater than
      value: 90
      background_color: '#dbeafe'
      font_color: '#1e40af'
      bold: true
      fields: [cur2.forecast_confidence_score]
    listen:
      Forecast_Model: cur2.forecast_model_type
    row: 24
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SEASONALITY & TREND ANALYSIS
  # =====================================================

  - title: 📈 Trend & Seasonality Decomposition
    name: trend_seasonality_decomposition
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.forecast_date, cur2.actual_cost_historical,
             cur2.trend_component, cur2.seasonal_component,
             cur2.residual_component]
    sorts: [cur2.forecast_date]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    show_null_points: false
    interpolation: linear
    y_axes:
    - label: Actual Cost
      orientation: left
      series:
      - axisId: cur2.actual_cost_historical
        id: cur2.actual_cost_historical
        name: Actual Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Components
      orientation: right
      series:
      - axisId: cur2.trend_component
        id: cur2.trend_component
        name: Trend
      - axisId: cur2.seasonal_component
        id: cur2.seasonal_component
        name: Seasonal
      - axisId: cur2.residual_component
        id: cur2.residual_component
        name: Residual
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.actual_cost_historical: '#1f77b4'
      cur2.trend_component: '#2ca02c'
      cur2.seasonal_component: '#ff7f0e'
      cur2.residual_component: '#d62728'
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
      Forecast_Model: cur2.forecast_model_type
    row: 34
    col: 0
    width: 16
    height: 10

  - title: 📊 Seasonal Pattern Strength
    name: seasonal_pattern_strength
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.month_name, cur2.seasonal_index,
             cur2.seasonal_strength_score]
    sorts: [cur2.month_name]
    limit: 12
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    point_style: circle
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
    - label: Seasonal Index
      orientation: left
      series:
      - axisId: cur2.seasonal_index
        id: cur2.seasonal_index
        name: Seasonal Index
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Strength Score
      orientation: right
      series:
      - axisId: cur2.seasonal_strength_score
        id: cur2.seasonal_strength_score
        name: Strength Score
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.seasonal_strength_score: line
    series_colors:
      cur2.seasonal_index: '#3b82f6'
      cur2.seasonal_strength_score: '#f59e0b'
    listen:
      Forecast_Model: cur2.forecast_model_type
    row: 34
    col: 16
    width: 8
    height: 10

  # =====================================================
  # SCENARIO PLANNING
  # =====================================================

  - title: 🎯 What-If Scenario Planning
    name: scenario_planning
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.scenario_name, cur2.scenario_baseline_cost,
             cur2.scenario_optimistic_10pct, cur2.scenario_pessimistic_10pct,
             cur2.scenario_growth_20pct, cur2.scenario_reduction_15pct]
    sorts: [cur2.scenario_baseline_cost desc]
    limit: 10
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    series_colors:
      cur2.scenario_baseline_cost: '#64748b'
      cur2.scenario_optimistic_10pct: '#16a34a'
      cur2.scenario_pessimistic_10pct: '#dc2626'
      cur2.scenario_growth_20pct: '#f97316'
      cur2.scenario_reduction_15pct: '#10b981'
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
    row: 44
    col: 0
    width: 16
    height: 10

  - title: 💰 Budget Impact Analysis
    name: budget_impact_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.budget_category, cur2.current_budget,
             cur2.forecast_p50_median, cur2.budget_variance,
             cur2.budget_variance_percentage, cur2.forecast_p90_upper_bound,
             cur2.worst_case_variance, cur2.risk_level]
    sorts: [cur2.budget_variance desc]
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting:
    - type: greater than
      value: 10
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
      fields: [cur2.budget_variance_percentage]
    - type: greater than
      value: 20
      background_color: '#7f1d1d'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.worst_case_variance]
    - type: contains
      value: HIGH
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.risk_level]
    - type: contains
      value: MEDIUM
      background_color: '#fbbf24'
      font_color: '#78350f'
      bold: true
      fields: [cur2.risk_level]
    listen:
      Forecast_Horizon: cur2.forecast_horizon_days
      Forecast_Model: cur2.forecast_model_type
    row: 44
    col: 16
    width: 8
    height: 10

  filters:
  - name: Forecast_Horizon
    title: 🔭 Forecast Horizon
    type: field_filter
    default_value: '30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options:
        - '7 days'
        - '14 days'
        - '30 days'
        - '60 days'
        - '90 days'
        - '180 days'
        - '365 days'
    model: aws_billing
    explore: cur2
    field: cur2.forecast_horizon_days

  - name: Forecast_Model
    title: 🤖 Forecast Model
    type: field_filter
    default_value: 'Auto-Select'
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options:
        - 'Auto-Select'
        - 'DeepAR+'
        - 'ETS'
        - 'Prophet'
        - 'ARIMA'
        - 'Ensemble'
    model: aws_billing
    explore: cur2
    field: cur2.forecast_model_type

  - name: Confidence_Level
    title: 📊 Confidence Level
    type: field_filter
    default_value: '80'
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options:
        - '50'
        - '68'
        - '80'
        - '90'
        - '95'
        - '99'
    model: aws_billing
    explore: cur2
    field: cur2.confidence_level_percentage

