---
# =====================================================
# DATA OPERATIONS MONITORING DASHBOARD
# =====================================================
# Comprehensive data operations monitoring and data quality tracking
# Following Looker best practices for operational dashboards
# 
# Author: Claude Data Ops Generator
# Last Updated: 2025-08-19
# =====================================================

- dashboard: data_ops_monitoring
  title: 🔧 Data Operations Control Center
  description: 'Real-time data quality monitoring, ingestion health, and operational metrics for AWS CUR data pipeline'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Real-time monitoring optimization
  auto_run: true
  refresh: 15 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  # Operational dashboard styling
  embed_style:
    background_color: '#f1f5f9'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#0f172a'
    tile_background_color: '#ffffff'
  
  filters:
  - name: Monitoring Window
    title: ⏰ Monitoring Window
    type: field_filter
    default_value: '24 hours ago for 24 hours'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
        - '1 hours ago for 1 hours'
        - '6 hours ago for 6 hours'
        - '24 hours ago for 24 hours'
        - '7 days ago for 7 days'
        - '30 days ago for 30 days'
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: Data Source
    title: 📊 Data Source
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_product_code

  - name: Quality Threshold
    title: 🎯 Quality Threshold
    type: field_filter
    default_value: '80'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 100
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.data_completeness_score

  elements:
  # =====================================================
  # REAL-TIME HEALTH INDICATORS
  # =====================================================
  
  - title: 🟢 System Health Status
    name: system_health_status
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.ingestion_health_score]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: SYSTEM HEALTH
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [70, 90]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: less than
      value: 70
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
      Quality Threshold: cur2.data_completeness_score
    row: 0
    col: 0
    width: 4
    height: 4

  - title: ⏱️ Data Freshness
    name: data_freshness_indicator
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.data_freshness_hours]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: DATA FRESHNESS (Hours)
    value_format: "#,##0.0"
    conditional_formatting:
    - type: less than
      value: 6
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [6, 12]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 12
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 0
    col: 4
    width: 4
    height: 4

  - title: 📊 Data Completeness
    name: data_completeness_gauge
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.data_completeness_score]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: COMPLETENESS SCORE
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [70, 90]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: less than
      value: 70
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 0
    col: 8
    width: 4
    height: 4

  - title: 🚨 Quality Alerts
    name: quality_alerts_counter
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.data_quality_alerts]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: QUALITY ALERTS
    value_format: "#,##0"
    conditional_formatting:
    - type: equal to
      value: 0
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [1, 5]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 5
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 0
    col: 12
    width: 4
    height: 4

  # =====================================================
  # PROCESSING METRICS
  # =====================================================

  - title: ⚡ Processing Lag Analysis
    name: processing_lag_chart
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.processing_lag_hours, 
             cur2.data_freshness_hours]
    sorts: [cur2.line_item_usage_start_date]
    limit: 168
    column_limit: 50
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
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: Hours
      orientation: left
      series:
      - axisId: cur2.processing_lag_hours
        id: cur2.processing_lag_hours
        name: Processing Lag
      - axisId: cur2.data_freshness_hours
        id: cur2.data_freshness_hours
        name: Data Freshness
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: processing-metrics
        label: Processing Metrics
        type: categorical
        stops:
        - color: '#1f77b4'
          offset: 0
        - color: '#ff7f0e'
          offset: 1
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 4
    col: 0
    width: 16
    height: 6

  # =====================================================
  # DATA QUALITY TRENDS
  # =====================================================

  - title: 📈 Data Quality Trend Analysis
    name: data_quality_trends
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.data_completeness_score, 
             cur2.ingestion_health_score, cur2.cost_variance_coefficient]
    sorts: [cur2.line_item_usage_start_date]
    limit: 168
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    y_axes:
    - label: Score
      orientation: left
      series:
      - axisId: cur2.data_completeness_score
        id: cur2.data_completeness_score
        name: Completeness Score
      - axisId: cur2.ingestion_health_score
        id: cur2.ingestion_health_score
        name: Health Score
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Variance
      orientation: right
      series:
      - axisId: cur2.cost_variance_coefficient
        id: cur2.cost_variance_coefficient
        name: Cost Variance
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 10
    col: 0
    width: 16
    height: 6

  # =====================================================
  # DETAILED MONITORING TABLE
  # =====================================================

  - title: 🔍 Detailed Quality Metrics
    name: detailed_quality_metrics
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_start_date, cur2.line_item_product_code,
             cur2.data_freshness_hours, cur2.data_completeness_score,
             cur2.processing_lag_hours, cur2.data_quality_alerts,
             cur2.duplicate_detection_count, cur2.ingestion_health_score]
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 50
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
    rows_font_size: 11
    conditional_formatting:
    - type: less than
      value: 6
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: false
      fields: [cur2.data_freshness_hours]
    - type: greater than
      value: 12
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.data_freshness_hours]
    - type: greater than
      value: 90
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: false
      fields: [cur2.data_completeness_score, cur2.ingestion_health_score]
    - type: less than
      value: 70
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.data_completeness_score, cur2.ingestion_health_score]
    - type: greater than
      value: 0
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.data_quality_alerts, cur2.duplicate_detection_count]
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 16
    col: 0
    width: 16
    height: 10

  # =====================================================
  # OPERATIONAL ALERTS & NOTIFICATIONS
  # =====================================================

  - title: 🚨 Critical Alerts Summary
    name: critical_alerts_summary
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields: [cur2.data_quality_alerts, cur2.duplicate_detection_count]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: equal to
      value: 0
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.data_quality_alerts, cur2.duplicate_detection_count]
    - type: greater than
      value: 0
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.data_quality_alerts, cur2.duplicate_detection_count]
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 26
    col: 0
    width: 8
    height: 4

  - title: 📊 Performance Summary
    name: performance_summary
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields: [cur2.processing_lag_hours, cur2.cost_variance_coefficient]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: "#,##0.00"
    conditional_formatting:
    - type: less than
      value: 6
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.processing_lag_hours]
    - type: greater than
      value: 12
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.processing_lag_hours]
    - type: less than
      value: 0.5
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.cost_variance_coefficient]
    - type: greater than
      value: 1.0
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.cost_variance_coefficient]
    listen:
      Monitoring Window: cur2.line_item_usage_start_date
      Data Source: cur2.line_item_product_code
    row: 26
    col: 8
    width: 8
    height: 4