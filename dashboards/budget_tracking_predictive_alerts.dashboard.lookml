---
# =====================================================
# BUDGET TRACKING WITH PREDICTIVE ALERTS DASHBOARD
# =====================================================
# Comprehensive budget management dashboard with predictive analytics
# Following 2025 FinOps best practices for proactive budget monitoring
# =====================================================

- dashboard: budget_tracking_predictive_alerts
  title: "Budget Tracking with Predictive Alerts"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive budget tracking dashboard with predictive alerts, burn rate analysis, variance tracking, and AI-powered forecasting aligned with 2025 FinOps Framework"

  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true

  # Dashboard styling
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'

  elements:
  - name: section_header_budget_health
    type: text
    title_text: "<h2>Budget Health Overview</h2>"
    subtitle_text: "Real-time budget status and utilization metrics"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Budget Utilization Percentage"
    name: budget_utilization_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: budget_utilization
      label: Budget Utilization
      expression: "(${cur2.total_unblended_cost} / 100000) * 100"
      _type_hint: number
    visualization_config:
        value_format: "#,##0.0\"%\""
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "BUDGET UTILIZATION"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 100
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [90, 100]
        background_color: "#f59e0b"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [75, 90]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: true
      - type: less than
        value: 75
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 2
    col: 0
    width: 4
    height: 5
  - title: "Monthly Budget Burn Rate"
    name: budget_burn_rate_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: daily_burn_rate
      label: Daily Burn Rate
      expression: "${cur2.total_unblended_cost} / 30"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "DAILY BURN RATE"
      value_format: "$#,##0"
      conditional_formatting:
      - type: greater than
        value: 5000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 2
    col: 4
    width: 4
    height: 5
  - title: "Budget Variance (Actual vs Budget)"
    name: budget_variance_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: budget_variance
      label: Budget Variance
      expression: "${cur2.total_unblended_cost} - 95000"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "BUDGET VARIANCE"
      value_format: "$#,##0"
      conditional_formatting:
      - type: greater than
        value: 0
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 0
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 2
    col: 8
    width: 4
    height: 5
  - title: "Forecasted Budget Overrun Risk"
    name: budget_overrun_risk_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: overrun_risk
      label: Overrun Risk
      expression: "case(when (${cur2.total_unblended_cost} / 100000) > 0.95 then \"High\", when (${cur2.total_unblended_cost} / 100000) > 0.80 then \"Medium\", else \"Low\")"
      _type_hint: string
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "OVERRUN RISK"
      conditional_formatting:
      - type: equal to
        value: "High"
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: equal to
        value: "Medium"
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
      - type: equal to
        value: "Low"
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 2
    col: 12
    width: 4
    height: 5
  - title: "Remaining Budget"
    name: remaining_budget_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: remaining_budget
      label: Remaining Budget
      expression: "100000 - ${cur2.total_unblended_cost}"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "REMAINING BUDGET"
      value_format: "$#,##0"
      conditional_formatting:
      - type: less than
        value: 5000
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: greater than
        value: 20000
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 2
    col: 16
    width: 4
    height: 5
  - title: "Days Until Budget Exhaustion"
    name: days_until_exhaustion_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: days_until_exhaustion
      label: Days Until Exhaustion
      expression: "(100000 - ${cur2.total_unblended_cost}) / (${cur2.total_unblended_cost} / 30)"
      _type_hint: number
  # =====================================================
  # SECTION: BUDGET VS ACTUAL TRACKING
  # =====================================================
    visualization_config:
        value_format: "#,##0"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "DAYS UNTIL EXHAUSTION"
      value_format: "#,##0"
      conditional_formatting:
      - type: less than
        value: 7
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [7, 14]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 2
    col: 20
    width: 4
    height: 5
  - name: section_header_budget_actual
    type: text
    title_text: "<h2>Budget vs Actual Analysis</h2>"
    subtitle_text: "Detailed comparison of budgeted vs actual spend with forecasting"
    body_text: ""
    row: 7
    col: 0
    width: 24
    height: 2

  - title: "Budget vs Actual by Department"
    name: budget_vs_actual_department
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: allocated_budget
      label: Allocated Budget
      expression: "15000"
      _type_hint: number
    - table_calculation: variance_pct
      label: Variance %
      expression: "((${cur2.total_unblended_cost} - ${allocated_budget}) / ${allocated_budget}) * 100"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0"
        value_format: "#,##0.0\"%\""
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
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
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: "Cost"
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Actual Cost
        - axisId: allocated_budget
          id: allocated_budget
          name: Budget
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      - label: "Variance %"
        orientation: right
        series:
        - axisId: variance_pct
          id: variance_pct
          name: Variance %
        showLabels: true
        showValues: true
        valueFormat: "#,##0.0\"%\""
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        variance_pct: line
        allocated_budget: scatter
      series_colors:
        cur2.total_unblended_cost: "#1f77b4"
        allocated_budget: "#dc2626"
        variance_pct: "#ff7f0e"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 9
    col: 0
    width: 16
    height: 8
  - title: "Budget Alert Thresholds"
    name: budget_alert_thresholds
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    dynamic_fields:
    - table_calculation: budget_limit
      label: Budget Limit
      expression: "15000"
      _type_hint: number
    - table_calculation: threshold_50
      label: 50% Alert
      expression: "${budget_limit} * 0.50"
      _type_hint: number
    - table_calculation: threshold_75
      label: 75% Alert
      expression: "${budget_limit} * 0.75"
      _type_hint: number
    - table_calculation: threshold_90
      label: 90% Alert
      expression: "${budget_limit} * 0.90"
      _type_hint: number
    - table_calculation: threshold_100
      label: 100% Alert
      expression: "${budget_limit}"
      _type_hint: number
    - table_calculation: alert_status
      label: Alert Status
      expression: "case(when ${cur2.total_unblended_cost} >= ${threshold_100} then \"Critical - 100%\", when ${cur2.total_unblended_cost} >= ${threshold_90} then \"Warning - 90%\", when ${cur2.total_unblended_cost} >= ${threshold_75} then \"Caution - 75%\", when ${cur2.total_unblended_cost} >= ${threshold_50} then \"Monitor - 50%\", else \"Normal\")"
      _type_hint: string
  # =====================================================
  # SECTION: FORECASTING & PREDICTIVE ALERTS
  # =====================================================
    visualization_config:
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
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
      rows_font_size: 11
      conditional_formatting:
      - type: equal to
        value: "Critical - 100%"
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
        fields: [alert_status]
      - type: equal to
        value: "Warning - 90%"
        background_color: "#f59e0b"
        font_color: "#ffffff"
        bold: true
        fields: [alert_status]
      - type: equal to
        value: "Caution - 75%"
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
        fields: [alert_status]
      - type: equal to
        value: "Monitor - 50%"
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [alert_status]
      - type: equal to
        value: "Normal"
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [alert_status]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 9
    col: 16
    width: 8
    height: 8
  - name: section_header_forecasting
    type: text
    title_text: "<h2>Forecasting & Predictive Alerts</h2>"
    subtitle_text: "AI-powered budget forecasting with early warning alerts"
    body_text: ""
    row: 17
    col: 0
    width: 24
    height: 2

  - title: "Budget Forecast with Confidence Intervals"
    name: budget_forecast_confidence
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
    dynamic_fields:
    - table_calculation: budget_target
      label: Budget Target
      expression: "100000 / 12"
      _type_hint: number
    - table_calculation: forecast_p50
      label: Forecast (P50)
      expression: "${cur2.total_unblended_cost} * 1.05"
      _type_hint: number
    - table_calculation: forecast_p90
      label: Forecast (P90)
      expression: "${cur2.total_unblended_cost} * 1.15"
      _type_hint: number
    - table_calculation: forecast_p10
      label: Forecast (P10)
      expression: "${cur2.total_unblended_cost} * 0.95"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
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
      plot_size_by_field: false
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
      interpolation: linear
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: "Cost"
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Actual Cost
        - axisId: budget_target
          id: budget_target
          name: Budget Target
        - axisId: forecast_p50
          id: forecast_p50
          name: Forecast P50
        - axisId: forecast_p90
          id: forecast_p90
          name: Forecast P90
        - axisId: forecast_p10
          id: forecast_p10
          name: Forecast P10
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        forecast_p90: area
        forecast_p10: area
        budget_target: scatter
      series_colors:
        cur2.total_unblended_cost: "#1f77b4"
        budget_target: "#dc2626"
        forecast_p50: "#2ca02c"
        forecast_p90: "#ffcccc"
        forecast_p10: "#ccffcc"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 19
    col: 0
    width: 16
    height: 8
  - title: "Predictive Spend Alerts"
    name: predictive_spend_alerts
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: predicted_eom_cost
      label: Predicted EOM Cost
      expression: "${cur2.total_unblended_cost} * (30 / 15)"
      _type_hint: number
    - table_calculation: service_budget
      label: Service Budget
      expression: "10000"
      _type_hint: number
    - table_calculation: predicted_overrun
      label: Predicted Overrun
      expression: "${predicted_eom_cost} - ${service_budget}"
      _type_hint: number
    - table_calculation: alert_priority
      label: Alert Priority
      expression: "case(when ${predicted_overrun} > 5000 then \"Critical\", when ${predicted_overrun} > 2000 then \"High\", when ${predicted_overrun} > 0 then \"Medium\", else \"Low\")"
      _type_hint: string
  # =====================================================
  # SECTION: HISTORICAL BUDGET PERFORMANCE
  # =====================================================
    visualization_config:
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
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
      rows_font_size: 11
      conditional_formatting:
      - type: equal to
        value: "Critical"
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
        fields: [alert_priority]
      - type: equal to
        value: "High"
        background_color: "#f59e0b"
        font_color: "#ffffff"
        bold: true
        fields: [alert_priority]
      - type: equal to
        value: "Medium"
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
        fields: [alert_priority]
      - type: greater than
        value: 0
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
        fields: [predicted_overrun]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 19
    col: 16
    width: 8
    height: 8
  - name: section_header_historical
    type: text
    title_text: "<h2>Historical Budget Performance</h2>"
    subtitle_text: "Trend analysis and historical budget tracking"
    body_text: ""
    row: 27
    col: 0
    width: 24
    height: 2

  - title: "Monthly Budget Performance Trend"
    name: monthly_budget_performance
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost]
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
    dynamic_fields:
    - table_calculation: monthly_budget
      label: Monthly Budget
      expression: "100000 / 12"
      _type_hint: number
    - table_calculation: variance
      label: Variance
      expression: "${cur2.total_unblended_cost} - ${monthly_budget}"
      _type_hint: number
    - table_calculation: cumulative_variance
      label: Cumulative Variance
      expression: "running_total(${variance})"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
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
      plot_size_by_field: false
      trellis: ""
      stacking: ""
      limit_displayed_rows: false
      legend_position: center
      point_style: circle
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: false
      show_null_points: true
      interpolation: linear
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: "Cost"
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Actual Cost
        - axisId: monthly_budget
          id: monthly_budget
          name: Budget
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      - label: "Variance"
        orientation: right
        series:
        - axisId: variance
          id: variance
          name: Variance
        - axisId: cumulative_variance
          id: cumulative_variance
          name: Cumulative Variance
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        monthly_budget: scatter
      series_colors:
        cur2.total_unblended_cost: "#1f77b4"
        monthly_budget: "#dc2626"
        variance: "#ff7f0e"
        cumulative_variance: "#2ca02c"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 29
    col: 0
    width: 16
    height: 8
  - title: "Budget Allocation Recommendations"
    name: budget_allocation_recommendations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    dynamic_fields:
    - table_calculation: current_allocation
      label: Current Allocation
      expression: "15000"
      _type_hint: number
    - table_calculation: recommended_allocation
      label: Recommended Allocation
      expression: "${cur2.total_unblended_cost} * 1.10"
      _type_hint: number
    - table_calculation: allocation_adjustment
      label: Allocation Adjustment
      expression: "${recommended_allocation} - ${current_allocation}"
      _type_hint: number
    - table_calculation: adjustment_pct
      label: Adjustment %
      expression: "(${allocation_adjustment} / ${current_allocation}) * 100"
      _type_hint: number
    - table_calculation: recommendation
      label: Recommendation
      expression: "case(when ${adjustment_pct} > 20 then \"Increase Budget\", when ${adjustment_pct} > 10 then \"Minor Increase\", when ${adjustment_pct} > -10 then \"Maintain\", when ${adjustment_pct} > -20 then \"Minor Decrease\", else \"Decrease Budget\")"
      _type_hint: string
  # =====================================================
  # SECTION: BUDGET VARIANCE ANALYSIS
  # =====================================================
    visualization_config:
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "$#,##0"
        value_format: "#,##0.0\"%\""
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
      rows_font_size: 11
      conditional_formatting:
      - type: equal to
        value: "Increase Budget"
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
        fields: [recommendation]
      - type: equal to
        value: "Minor Increase"
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [recommendation]
      - type: equal to
        value: "Maintain"
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [recommendation]
      - type: equal to
        value: "Minor Decrease"
        background_color: "#e0f2fe"
        font_color: "#075985"
        bold: false
        fields: [recommendation]
      - type: equal to
        value: "Decrease Budget"
        background_color: "#dbeafe"
        font_color: "#1e40af"
        bold: false
        fields: [recommendation]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 29
    col: 16
    width: 8
    height: 8
  - name: section_header_variance
    type: text
    title_text: "<h2>Budget Variance Deep Dive</h2>"
    subtitle_text: "Detailed variance analysis by service and department"
    body_text: ""
    row: 37
    col: 0
    width: 24
    height: 2

  - title: "Service-Level Budget Variance Heatmap"
    name: service_budget_variance_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.line_item_product_code, cur2.total_unblended_cost]
    pivots: [cur2.line_item_product_code]
    sorts: [cur2.total_unblended_cost desc 0]
    limit: 8
    visualization_config:
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
      header_font_size: 11
      rows_font_size: 11
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [5000, 10000]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
      - type: less than
        value: 5000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
      series_cell_visualizations:
        cur2.total_unblended_cost:
          is_active: true
          palette:
            palette_id: custom_heatmap
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#dcfce7"
            - "#fef3c7"
            - "#fecaca"
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 39
    col: 0
    width: 16
    height: 10
  - title: "Top Budget Overruns"
    name: top_budget_overruns
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [variance desc]
    limit: 10
    dynamic_fields:
    - table_calculation: service_budget
      label: Service Budget
      expression: "10000"
      _type_hint: number
    - table_calculation: variance
      label: Variance
      expression: "${cur2.total_unblended_cost} - ${service_budget}"
      _type_hint: number
  filters:
    visualization_config:
        value_format: "$#,##0"
        value_format: "$#,##0"
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
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: "Variance"
        orientation: bottom
        series:
        - axisId: variance
          id: variance
          name: Variance
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        variance: "#dc2626"
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost, service_budget]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Department: cur2.team
      Environment: cur2.environment
    row: 39
    col: 16
    width: 8
    height: 10
  - name: Time Period
    title: "Time Period"
    type: field_filter
    default_value: "30 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date
    note_text: "Time Period visualization"
  - name: AWS Account
    title: "AWS Account"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_account_name
    note_text: "AWS Account visualization"
  - name: Service
    title: "AWS Service"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_product_code
    note_text: "AWS Service visualization"
  - name: Department
    title: "Department (Team)"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.team
    note_text: "Department (Team) visualization"
  - name: Environment
    title: "Environment"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.environment
    note_text: "Environment visualization"
