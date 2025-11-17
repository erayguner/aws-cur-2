---
# =====================================================
# REAL-TIME COST VISIBILITY DASHBOARD
# =====================================================
# Live spending tracking with hourly granularity and instant alerts
# Based on 2025 FinOps best practices
#
# Features:
# - Real-time cost tracking with hourly updates
# - Live spend rate monitoring
# - Instant anomaly alerts
# - Multi-account visibility with CUR 2.0 account names
# - Service-level spending trends
# =====================================================
- dashboard: realtime_cost_visibility
  title: 📊 Real-Time Cost Visibility Dashboard
  description: Live AWS spending tracking with hourly granularity, instant anomaly detection, and multi-account visibility (CUR 2.0 Enhanced)
  layout: newspaper
  preferred_viewer: dashboards-next
  auto_run: true
  refresh: 5 minutes
  load_configuration: wait
  crossfilter_enabled: true
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'
  elements:
  - title: 💰 Current Hour Spend
    name: current_hour_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.total_unblended_cost

  filters:
      cur2.line_item_usage_start_hour: 1 hour
    limit: 1
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 0
    col: 0
    width: 4
    height: 4
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true
      show_comparison_label: true
      single_value_title: CURRENT HOUR SPEND
      value_format: $#,##0.00
      comparison_label: vs Previous Hour
      conditional_formatting:
      - type: greater than
        value: 1000
        background_color: '#fef3c7'
        font_color: '#92400e'
        bold: true
    note_text: 💰 Current Hour Spend visualization
  - title: 📈 Hourly Burn Rate
    name: hourly_burn_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_hour: 1 hour
    limit: 1
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 0
    col: 4
    width: 4
    height: 4
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: true
      comparison_type: value
      single_value_title: HOURLY BURN RATE
      value_format: $#,##0.00/hr
      comparison_label: Projected Daily
      conditional_formatting:
      - type: greater than
        value: 500
        background_color: '#fecaca'
        font_color: '#dc2626'
        bold: true
    note_text: 📈 Hourly Burn Rate visualization
  - title: 🎯 Today vs Budget
    name: today_vs_budget
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields:
    - cur2.total_unblended_cost
    - cur2.budget_utilization_percentage
    filters:
      cur2.line_item_usage_start_date: today
    limit: 1
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 0
    col: 8
    width: 4
    height: 4
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      single_value_title: DAILY BUDGET UTILIZATION
      value_format: '#,##0%'
      conditional_formatting:
      - type: greater than
        value: 90
        background_color: '#dc2626'
        font_color: '#ffffff'
        bold: true
      - type: between
        value:
        - 70
        - 90
        background_color: '#eab308'
        font_color: '#ffffff'
        bold: true
      - type: less than
        value: 70
        background_color: '#16a34a'
        font_color: '#ffffff'
        bold: true
    note_text: 🎯 Today vs Budget visualization
  - title: 🚨 Active Anomalies
    name: active_anomalies
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.cost_anomaly_count
    filters:
      cur2.cost_anomaly_score: '>75'
      cur2.line_item_usage_start_date: 24 hours
    limit: 1
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 0
    col: 12
    width: 4
    height: 4
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      single_value_title: ACTIVE ANOMALIES
      value_format: '#,##0'
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
    note_text: 🚨 Active Anomalies visualization
  - title: 💸 Month-to-Date Spend
    name: mtd_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.total_unblended_cost
    - cur2.month_over_month_change
    filters:
      cur2.line_item_usage_start_date: this month
    limit: 1
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 0
    col: 16
    width: 4
    height: 4
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: true
      comparison_type: change
      comparison_reverse_colors: true
      single_value_title: MONTH-TO-DATE SPEND
      value_format: $#,##0
      comparison_label: vs Last Month
    note_text: 💸 Month-to-Date Spend visualization
  - title: 📊 Projected Month-End
    name: projected_month_end
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.projected_month_end_cost
    filters:
      cur2.line_item_usage_start_date: this month
    limit: 1
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 0
    col: 20
    width: 4
    height: 4
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: true
      comparison_type: value
      single_value_title: PROJECTED MONTH-END
      value_format: $#,##0
      comparison_label: Confidence ±10%
    note_text: 📊 Projected Month-End visualization
  - title: ⏰ Hourly Spend Trend (Last 24 Hours)
    name: hourly_spend_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields:
    - cur2.line_item_usage_start_hour
    - cur2.total_unblended_cost
    - cur2.total_usage_cost
    - cur2.total_amortized_cost
    filters:
      cur2.line_item_usage_start_date: 24 hours
    sorts:
    - cur2.line_item_usage_start_hour
    limit: 500
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 4
    col: 0
    width: 16
    height: 8
    visualization_config:
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
      show_totals_labels: true
      show_silhouette: false
      totals_color: '#808080'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: Hourly Cost
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Unblended Cost
        - axisId: cur2.total_usage_cost
          id: cur2.total_usage_cost
          name: Usage Cost
        - axisId: cur2.total_amortized_cost
          id: cur2.total_amortized_cost
          name: Amortized Cost
        showLabels: true
        showValues: true
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_unblended_cost: '#1f77b4'
        cur2.total_usage_cost: '#ff7f0e'
        cur2.total_amortized_cost: '#2ca02c'
    note_text: ⏰ Hourly Spend Trend (Last 24 Hours) visualization
  - title: 🔥 Top 10 Cost Drivers (Current Hour)
    name: top_cost_drivers_current_hour
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_hour: 1 hour
    sorts:
    - cur2.total_unblended_cost desc
    limit: 10
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Region_Filter: cur2.product_region
    row: 4
    col: 16
    width: 8
    height: 8
    visualization_config:
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
      show_value_labels: true
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      show_totals_labels: false
      show_silhouette: false
      totals_color: '#808080'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      ordering: none
      show_null_labels: false
    note_text: 🔥 Top 10 Cost Drivers (Current Hour) visualization
  - title: 🏢 Multi-Account Spend Distribution
    name: multi_account_spend
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_usage_account_name
    - cur2.line_item_usage_account_id
    - cur2.total_unblended_cost
    - cur2.hour_over_hour_change
    - cur2.day_over_day_change
    - cur2.cost_anomaly_score
    filters:
      cur2.line_item_usage_start_date: 24 hours
    sorts:
    - cur2.total_unblended_cost desc
    limit: 50
    listen:
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 12
    col: 0
    width: 12
    height: 10
    visualization_config:
      show_view_names: false
      limit_displayed_rows: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
      enable_conditional_formatting: true
      header_text_alignment: left
      header_font_size: 12
      rows_font_size: 12
      conditional_formatting:
      - type: greater than
        value: 10
        background_color: '#fecaca'
        font_color: '#dc2626'
        bold: true
        fields:
        - cur2.hour_over_hour_change
      - type: greater than
        value: 75
        background_color: '#fef3c7'
        font_color: '#92400e'
        bold: true
        fields:
        - cur2.cost_anomaly_score
      - type: greater than
        value: 1000
        background_color: '#dbeafe'
        font_color: '#1e40af'
        bold: true
        fields:
        - cur2.total_unblended_cost
    note_text: 🏢 Multi-Account Spend Distribution visualization
  - title: 📊 Account Spend Heatmap
    name: account_spend_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_usage_account_name
    - cur2.line_item_usage_start_hour
    - cur2.total_unblended_cost
    pivots:
    - cur2.line_item_usage_start_hour
    filters:
      cur2.line_item_usage_start_date: 24 hours
    sorts:
    - cur2.total_unblended_cost desc 0
    limit: 20
    listen:
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 12
    col: 12
    width: 12
    height: 10
    visualization_config:
      show_view_names: false
      limit_displayed_rows: false
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      show_row_numbers: false
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
      enable_conditional_formatting: true
      header_text_alignment: left
      header_font_size: 10
      rows_font_size: 10
      conditional_formatting_include_totals: false
      conditional_formatting_include_nulls: false
      conditional_formatting:
      - type: high to low
        value: null
        background_color: null
        font_color: null
        color_application:
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom:
            id: heatmap-colors
            label: Heatmap Colors
            type: continuous
            stops:
            - color: '#ffffff'
              offset: 0
            - color: '#fef3c7'
              offset: 33
            - color: '#fbbf24'
              offset: 66
            - color: '#dc2626'
              offset: 100
        bold: false
        italic: false
        strikethrough: false
        fields:
        - cur2.total_unblended_cost
    note_text: 📊 Account Spend Heatmap visualization
  - title: 🔧 Service Spend Rate (Last 6 Hours)
    name: service_spend_rate
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_hour
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    pivots:
    - cur2.line_item_product_code
    filters:
      cur2.line_item_usage_start_date: 6 hours
    sorts:
    - cur2.line_item_usage_start_hour
    - cur2.line_item_product_code
    limit: 500
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Region_Filter: cur2.product_region
    row: 22
    col: 0
    width: 16
    height: 8
    visualization_config:
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
      show_null_points: true
      interpolation: linear
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      column_limit: 10
    note_text: 🔧 Service Spend Rate (Last 6 Hours) visualization
  - title: 🌍 Regional Spend Distribution
    name: regional_spend_distribution
    model: aws_billing
    explore: cur2
    type: looker_geo_choropleth
    fields:
    - cur2.product_region
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: 24 hours
    sorts:
    - cur2.total_unblended_cost desc
    limit: 500
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 22
    col: 16
    width: 8
    height: 8
    visualization_config:
      show_view_names: false
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: regional-spend
          label: Regional Spend
          type: continuous
          stops:
          - color: '#dcfce7'
            offset: 0
          - color: '#4ade80'
            offset: 25
          - color: '#fbbf24'
            offset: 50
          - color: '#f97316'
            offset: 75
          - color: '#dc2626'
            offset: 100
      map: world
      map_projection: ''
      quantize_colors: false
      color_range:
      - '#dd3333'
      - '#80ce5d'
      - '#f78131'
      - '#369dc1'
      - '#c572d3'
      - '#36c1b3'
      - '#b57052'
      - '#ed69af'
    note_text: 🌍 Regional Spend Distribution visualization
  - title: 🚨 Real-Time Anomaly Alerts
    name: realtime_anomaly_alerts
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.line_item_usage_start_time
    - cur2.line_item_product_code
    - cur2.line_item_usage_account_name
    - cur2.total_unblended_cost
    - cur2.cost_anomaly_score
    - cur2.anomaly_severity
    - cur2.expected_cost_range
    filters:
      cur2.cost_anomaly_score: '>60'
      cur2.line_item_usage_start_date: 24 hours
    sorts:
    - cur2.cost_anomaly_score desc
    limit: 50
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
      Region_Filter: cur2.product_region
    row: 30
    col: 0
    width: 24
    height: 10
    visualization_config:
      show_view_names: false
      limit_displayed_rows: false
      show_row_numbers: true
      transpose: false
      truncate_text: true
      hide_totals: false
      hide_row_totals: false
      size_to_fit: true
      table_theme: white
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
        fields:
        - cur2.cost_anomaly_score
      - type: between
        value:
        - 75
        - 90
        background_color: '#f97316'
        font_color: '#ffffff'
        bold: true
        fields:
        - cur2.cost_anomaly_score
      - type: between
        value:
        - 60
        - 75
        background_color: '#fbbf24'
        font_color: '#78350f'
        bold: true
        fields:
        - cur2.cost_anomaly_score
    note_text: 🚨 Real-Time Anomaly Alerts visualization
  filters:
  - name: Time_Period
    title: ⏰ Time Period
    type: field_filter
    default_value: 24 hours
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
      - 1 hour
      - 6 hours
      - 12 hours
      - 24 hours
      - 48 hours
      - 7 days
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date
  - name: Account_Filter
    title: 🏢 AWS Account
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
    field: cur2.line_item_usage_account_name
  - name: Service_Filter
    title: 🔧 AWS Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters:
    - Account_Filter
    field: cur2.line_item_product_code
  - name: Region_Filter
    title: 🌍 AWS Region
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters:
    - Service_Filter
    field: cur2.product_region