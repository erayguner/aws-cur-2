---
# =====================================================
# ADVANCED ML-BASED ANOMALY DETECTION DASHBOARD
# =====================================================
# Machine learning-powered cost anomaly detection
# Based on AWS Cost Anomaly Detection and 2025 FinOps best practices
#
# Features:
# - ML-powered anomaly scoring with confidence intervals
# - Root cause analysis and impact assessment
# - Automated alert prioritization
# - Pattern recognition across services and accounts
# - Historical anomaly tracking
# =====================================================

- dashboard: ml_anomaly_detection_advanced
  title: 🤖 Advanced ML Anomaly Detection Dashboard
  description: 'Machine learning-powered cost anomaly detection with root cause analysis, impact assessment, and automated alerting'
  layout: newspaper
  preferred_viewer: dashboards-next

  auto_run: true
  refresh: 15 minutes
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
  # ANOMALY OVERVIEW KPIs
  # =====================================================

  - title: 🚨 Critical Anomalies Detected
    name: critical_anomalies
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_anomaly_count]
    filters:
      cur2.anomaly_severity: 'CRITICAL'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    single_value_title: CRITICAL ANOMALIES
    value_format: "#,##0"
    comparison_label: vs Previous Period
    conditional_formatting:
    - type: greater than
      value: 0
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    - type: equal to
      value: 0
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    listen:
      Detection_Period: cur2.line_item_usage_start_date
    row: 0
    col: 0
    width: 4
    height: 4

  - title: 💰 Total Anomalous Spend
    name: total_anomalous_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_anomalous_cost]
    filters:
      cur2.cost_anomaly_score: '>60'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    single_value_title: ANOMALOUS SPEND
    value_format: "$#,##0"
    comparison_label: Financial Impact
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
      Min_Anomaly_Score: cur2.cost_anomaly_score
    row: 0
    col: 4
    width: 4
    height: 4

  - title: 📈 Average Anomaly Score
    name: avg_anomaly_score
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.avg_anomaly_score]
    filters:
      cur2.cost_anomaly_score: '>0'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: AVG ANOMALY SCORE
    value_format: "#,##0.0"
    conditional_formatting:
    - type: greater than
      value: 85
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [70, 85]
      background_color: '#f97316'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [50, 70]
      background_color: '#fbbf24'
      font_color: '#78350f'
      bold: true
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
    row: 0
    col: 8
    width: 4
    height: 4

  - title: 🎯 Detection Accuracy
    name: detection_accuracy
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.anomaly_detection_accuracy]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: DETECTION ACCURACY
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
    listen:
      Detection_Period: cur2.line_item_usage_start_date
    row: 0
    col: 12
    width: 4
    height: 4

  - title: ⏱️ Mean Time to Detect
    name: mean_time_to_detect
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.mean_time_to_detect_hours]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: MEAN TIME TO DETECT
    value_format: "#,##0.0\" hrs\""
    conditional_formatting:
    - type: less than
      value: 6
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [6, 12]
      background_color: '#eab308'
      font_color: '#78350f'
      bold: true
    - type: greater than
      value: 12
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Detection_Period: cur2.line_item_usage_start_date
    row: 0
    col: 16
    width: 4
    height: 4

  - title: 💡 False Positive Rate
    name: false_positive_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.false_positive_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: FALSE POSITIVE RATE
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: less than
      value: 10
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 20
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Detection_Period: cur2.line_item_usage_start_date
    row: 0
    col: 20
    width: 4
    height: 4

  # =====================================================
  # ANOMALY TIMELINE & TRENDS
  # =====================================================

  - title: 📊 Anomaly Detection Timeline
    name: anomaly_timeline
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_date, cur2.cost_anomaly_count,
             cur2.total_anomalous_cost, cur2.avg_anomaly_score]
    filters:
      cur2.cost_anomaly_score: '>60'
    sorts: [cur2.line_item_usage_start_date]
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
    - label: Anomaly Count
      orientation: left
      series:
      - axisId: cur2.cost_anomaly_count
        id: cur2.cost_anomaly_count
        name: Anomaly Count
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Anomalous Cost
      orientation: right
      series:
      - axisId: cur2.total_anomalous_cost
        id: cur2.total_anomalous_cost
        name: Anomalous Cost
      - axisId: cur2.avg_anomaly_score
        id: cur2.avg_anomaly_score
        name: Avg Score
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.total_anomalous_cost: area
      cur2.avg_anomaly_score: line
    series_colors:
      cur2.cost_anomaly_count: '#dc2626'
      cur2.total_anomalous_cost: '#fbbf24'
      cur2.avg_anomaly_score: '#1f77b4'
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
      Min_Anomaly_Score: cur2.cost_anomaly_score
    row: 4
    col: 0
    width: 16
    height: 8

  - title: 🎯 Anomaly Severity Distribution
    name: anomaly_severity_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.anomaly_severity, cur2.cost_anomaly_count]
    filters:
      cur2.cost_anomaly_score: '>60'
    sorts: [cur2.cost_anomaly_count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    series_colors:
      CRITICAL: '#dc2626'
      HIGH: '#f97316'
      MEDIUM: '#fbbf24'
      LOW: '#10b981'
    listen:
      Detection_Period: cur2.line_item_usage_start_date
    row: 4
    col: 16
    width: 8
    height: 8

  # =====================================================
  # ROOT CAUSE ANALYSIS
  # =====================================================

  - title: 🔍 Root Cause Analysis - Top Anomalous Services
    name: root_cause_services
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.cost_anomaly_count,
             cur2.total_anomalous_cost, cur2.avg_anomaly_score,
             cur2.anomaly_impact_percentage, cur2.root_cause_category]
    filters:
      cur2.cost_anomaly_score: '>60'
    sorts: [cur2.total_anomalous_cost desc]
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
      value: 90
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.avg_anomaly_score]
    - type: greater than
      value: 5000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.total_anomalous_cost]
    - type: greater than
      value: 20
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
      fields: [cur2.anomaly_impact_percentage]
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
      Min_Anomaly_Score: cur2.cost_anomaly_score
    row: 12
    col: 0
    width: 12
    height: 10

  - title: 🏢 Root Cause Analysis - Accounts
    name: root_cause_accounts
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.cost_anomaly_count,
             cur2.total_anomalous_cost, cur2.avg_anomaly_score,
             cur2.anomaly_trend, cur2.estimated_waste_amount]
    filters:
      cur2.cost_anomaly_score: '>60'
    sorts: [cur2.total_anomalous_cost desc]
    limit: 15
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
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
      fields: [cur2.avg_anomaly_score]
    - type: contains
      value: INCREASING
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.anomaly_trend]
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
      Min_Anomaly_Score: cur2.cost_anomaly_score
    row: 12
    col: 12
    width: 12
    height: 10

  # =====================================================
  # ML MODEL PERFORMANCE
  # =====================================================

  - title: 🤖 ML Model Performance Metrics
    name: ml_model_performance
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.anomaly_detection_accuracy,
             cur2.true_positive_rate, cur2.false_positive_rate,
             cur2.precision_score, cur2.recall_score]
    sorts: [cur2.line_item_usage_start_date]
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
    y_axes:
    - label: Performance %
      orientation: left
      series:
      - axisId: cur2.anomaly_detection_accuracy
        id: cur2.anomaly_detection_accuracy
        name: Accuracy
      - axisId: cur2.true_positive_rate
        id: cur2.true_positive_rate
        name: True Positive Rate
      - axisId: cur2.false_positive_rate
        id: cur2.false_positive_rate
        name: False Positive Rate
      - axisId: cur2.precision_score
        id: cur2.precision_score
        name: Precision
      - axisId: cur2.recall_score
        id: cur2.recall_score
        name: Recall
      showLabels: true
      showValues: true
      minValue: 0
      maxValue: 100
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.anomaly_detection_accuracy: '#16a34a'
      cur2.true_positive_rate: '#1f77b4'
      cur2.false_positive_rate: '#dc2626'
      cur2.precision_score: '#fbbf24'
      cur2.recall_score: '#8b5cf6'
    listen:
      Detection_Period: cur2.line_item_usage_start_date
    row: 22
    col: 0
    width: 16
    height: 8

  - title: 📊 Confidence Interval Analysis
    name: confidence_intervals
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.actual_cost,
             cur2.predicted_cost_baseline, cur2.confidence_upper_bound,
             cur2.confidence_lower_bound]
    sorts: [cur2.line_item_usage_start_date]
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    series_types:
      cur2.actual_cost: line
      cur2.predicted_cost_baseline: line
      cur2.confidence_upper_bound: area
      cur2.confidence_lower_bound: area
    series_colors:
      cur2.actual_cost: '#1f77b4'
      cur2.predicted_cost_baseline: '#2ca02c'
      cur2.confidence_upper_bound: '#fee2e2'
      cur2.confidence_lower_bound: '#fee2e2'
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Min_Anomaly_Score: cur2.cost_anomaly_score
    row: 22
    col: 16
    width: 8
    height: 8

  # =====================================================
  # DETAILED ANOMALY INVESTIGATION
  # =====================================================

  - title: 🔬 Detailed Anomaly Investigation
    name: detailed_anomaly_investigation
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_start_time, cur2.line_item_product_code,
             cur2.line_item_usage_account_name, cur2.line_item_resource_id,
             cur2.total_unblended_cost, cur2.expected_cost_range,
             cur2.cost_deviation_percentage, cur2.cost_anomaly_score,
             cur2.anomaly_severity, cur2.root_cause_category,
             cur2.recommended_action]
    filters:
      cur2.cost_anomaly_score: '>75'
    sorts: [cur2.cost_anomaly_score desc]
    limit: 100
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
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
      value: 95
      background_color: '#7f1d1d'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.cost_anomaly_score]
    - type: between
      value: [85, 95]
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.cost_anomaly_score]
    - type: between
      value: [75, 85]
      background_color: '#f97316'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.cost_anomaly_score]
    - type: greater than
      value: 50
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.cost_deviation_percentage]
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
    row: 30
    col: 0
    width: 24
    height: 12

  # =====================================================
  # ANOMALY PATTERNS & INSIGHTS
  # =====================================================

  - title: 🎯 Anomaly Pattern Analysis
    name: anomaly_patterns
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_product_code, cur2.total_anomalous_cost,
             cur2.cost_anomaly_count, cur2.avg_anomaly_score,
             cur2.cost_volatility_score]
    filters:
      cur2.cost_anomaly_score: '>60'
    sorts: [cur2.total_anomalous_cost desc]
    limit: 100
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    x_axis_label: Anomaly Count
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    y_axis_label: Anomalous Cost
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_dimension: cur2.avg_anomaly_score
    trellis: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: anomaly-pattern-colors
        label: Anomaly Pattern Colors
        type: continuous
        stops:
        - color: '#16a34a'
          offset: 0
        - color: '#fbbf24'
          offset: 50
        - color: '#dc2626'
          offset: 100
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
    row: 42
    col: 0
    width: 16
    height: 10

  - title: 📊 Hourly Anomaly Heatmap
    name: hourly_anomaly_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_start_day_of_week, cur2.line_item_usage_start_hour,
             cur2.cost_anomaly_count]
    pivots: [cur2.line_item_usage_start_hour]
    filters:
      cur2.cost_anomaly_score: '>60'
    sorts: [cur2.line_item_usage_start_day_of_week, cur2.line_item_usage_start_hour]
    limit: 500
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: center
    header_font_size: 10
    rows_font_size: 10
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: hourly-heatmap
        label: Hourly Heatmap
        type: continuous
        stops:
        - color: '#ffffff'
          offset: 0
        - color: '#fed7aa'
          offset: 33
        - color: '#fb923c'
          offset: 66
        - color: '#dc2626'
          offset: 100
    conditional_formatting:
    - type: high to low
      value:
      background_color:
      font_color:
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: hourly-heatmap-gradient
          label: Heatmap Gradient
          type: continuous
          stops:
          - color: '#ffffff'
            offset: 0
          - color: '#fed7aa'
            offset: 33
          - color: '#fb923c'
            offset: 66
          - color: '#dc2626'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.cost_anomaly_count]
    listen:
      Detection_Period: cur2.line_item_usage_start_date
      Severity_Filter: cur2.anomaly_severity
    row: 42
    col: 16
    width: 8
    height: 10

  filters:
  - name: Detection_Period
    title: 🔍 Detection Period
    type: field_filter
    default_value: '7 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
        - '24 hours'
        - '7 days'
        - '14 days'
        - '30 days'
        - '90 days'
    model: aws_billing
    explore: cur2
    field: cur2.line_item_usage_start_date

  - name: Severity_Filter
    title: ⚠️ Anomaly Severity
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: inline
      options:
        - CRITICAL
        - HIGH
        - MEDIUM
        - LOW
    model: aws_billing
    explore: cur2
    field: cur2.anomaly_severity

  - name: Min_Anomaly_Score
    title: 📊 Minimum Anomaly Score
    type: field_filter
    default_value: '60'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 100
    model: aws_billing
    explore: cur2
    field: cur2.cost_anomaly_score

