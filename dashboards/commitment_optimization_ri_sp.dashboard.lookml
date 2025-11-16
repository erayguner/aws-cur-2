---
# =====================================================
# COMMITMENT OPTIMIZATION DASHBOARD (RI/SP)
# =====================================================
# Comprehensive Reserved Instance and Savings Plan optimization
# Based on 2025 FinOps commitment management best practices
#
# Features:
# - RI/SP coverage and utilization tracking
# - Commitment recommendations and ROI analysis
# - Expiration tracking and renewal planning
# - On-Demand vs Commitment cost comparison
# - Multi-year commitment strategy analysis
# =====================================================

- dashboard: commitment_optimization_ri_sp
  title: 💎 Commitment Optimization Dashboard (RI/SP)
  description: 'Comprehensive Reserved Instance and Savings Plan optimization with coverage tracking, utilization analysis, and ROI recommendations'
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

  filters:
  - name: Time_Period
    title: 📅 Time Period
    type: field_filter
    default_value: '30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
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
    field: cur2.line_item_usage_account_name

  - name: Service_Filter
    title: 🔧 Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    field: cur2.line_item_product_code

  elements:
  # =====================================================
  # COMMITMENT OVERVIEW KPIs
  # =====================================================

  - title: 💰 Total Commitment Savings
    name: total_commitment_savings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_commitment_savings]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    single_value_title: TOTAL COMMITMENT SAVINGS
    value_format: "$#,##0"
    comparison_label: vs On-Demand
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 0
    col: 0
    width: 4
    height: 4

  - title: 📊 Overall Coverage Rate
    name: overall_coverage_rate
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.commitment_coverage_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: COVERAGE RATE
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [60, 80]
      background_color: '#eab308'
      font_color: '#78350f'
      bold: true
    - type: less than
      value: 60
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 0
    col: 4
    width: 4
    height: 4

  - title: 🎯 Average Utilization
    name: average_utilization
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.commitment_utilization_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: UTILIZATION RATE
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [75, 90]
      background_color: '#eab308'
      font_color: '#78350f'
      bold: true
    - type: less than
      value: 75
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 0
    col: 8
    width: 4
    height: 4

  - title: 💡 Potential Additional Savings
    name: potential_additional_savings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.potential_commitment_savings]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: POTENTIAL ADDITIONAL SAVINGS
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 5000
      background_color: '#fbbf24'
      font_color: '#78350f'
      bold: true
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 0
    col: 12
    width: 4
    height: 4

  - title: ⏰ Commitments Expiring (90 Days)
    name: expiring_commitments
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.expiring_commitment_count]
    filters:
      cur2.commitment_expiration_days: '<=90'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: EXPIRING SOON
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 5
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
    - type: greater than
      value: 0
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 0
    col: 16
    width: 4
    height: 4

  - title: 📈 Savings Rate
    name: savings_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.commitment_savings_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: SAVINGS RATE
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: greater than
      value: 40
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
    - type: between
      value: [25, 40]
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 0
    col: 20
    width: 4
    height: 4

  # =====================================================
  # COVERAGE & UTILIZATION TRENDS
  # =====================================================

  - title: 📊 Coverage & Utilization Trends
    name: coverage_utilization_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.commitment_coverage_rate,
             cur2.commitment_utilization_rate, cur2.ri_coverage_rate,
             cur2.sp_coverage_rate]
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
    - label: Percentage
      orientation: left
      series:
      - axisId: cur2.commitment_coverage_rate
        id: cur2.commitment_coverage_rate
        name: Overall Coverage
      - axisId: cur2.commitment_utilization_rate
        id: cur2.commitment_utilization_rate
        name: Overall Utilization
      - axisId: cur2.ri_coverage_rate
        id: cur2.ri_coverage_rate
        name: RI Coverage
      - axisId: cur2.sp_coverage_rate
        id: cur2.sp_coverage_rate
        name: SP Coverage
      showLabels: true
      showValues: true
      minValue: 0
      maxValue: 100
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.commitment_coverage_rate: '#1f77b4'
      cur2.commitment_utilization_rate: '#2ca02c'
      cur2.ri_coverage_rate: '#ff7f0e'
      cur2.sp_coverage_rate: '#9467bd'
    reference_lines:
    - reference_type: line
      line_value: '80'
      range_start: max
      range_end: min
      margin_top: deviation
      margin_value: mean
      margin_bottom: deviation
      label_position: right
      color: '#16a34a'
      label: Target Coverage (80%)
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 4
    col: 0
    width: 16
    height: 8

  - title: 💰 Commitment Savings Over Time
    name: commitment_savings_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.ri_savings,
             cur2.sp_savings, cur2.total_commitment_savings]
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    show_totals_labels: true
    show_silhouette: false
    totals_color: '#808080'
    series_colors:
      cur2.ri_savings: '#10b981'
      cur2.sp_savings: '#3b82f6'
      cur2.total_commitment_savings: '#8b5cf6'
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 4
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SERVICE-LEVEL ANALYSIS
  # =====================================================

  - title: 🔧 Service-Level Coverage Analysis
    name: service_coverage_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_cost,
             cur2.on_demand_cost, cur2.commitment_cost,
             cur2.commitment_coverage_rate, cur2.commitment_utilization_rate,
             cur2.commitment_savings, cur2.potential_commitment_savings]
    sorts: [cur2.total_cost desc]
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
      value: 80
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.commitment_coverage_rate, cur2.commitment_utilization_rate]
    - type: less than
      value: 60
      background_color: '#fecaca'
      font_color: '#7f1d1d'
      bold: true
      fields: [cur2.commitment_coverage_rate]
    - type: greater than
      value: 5000
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.potential_commitment_savings]
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 12
    col: 0
    width: 24
    height: 10

  # =====================================================
  # RI/SP RECOMMENDATIONS
  # =====================================================

  - title: 💡 Top Commitment Recommendations
    name: commitment_recommendations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.recommendation_type,
             cur2.recommended_commitment_amount, cur2.estimated_monthly_savings,
             cur2.estimated_roi_percentage, cur2.payback_period_months,
             cur2.recommendation_confidence_score, cur2.recommended_term]
    filters:
      cur2.recommendation_confidence_score: '>75'
    sorts: [cur2.estimated_monthly_savings desc]
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
      value: 30
      background_color: '#dcfce7'
      font_color: '#166534'
      bold: true
      fields: [cur2.estimated_roi_percentage]
    - type: less than
      value: 12
      background_color: '#dbeafe'
      font_color: '#1e40af'
      bold: true
      fields: [cur2.payback_period_months]
    - type: greater than
      value: 90
      background_color: '#fef3c7'
      font_color: '#92400e'
      bold: true
      fields: [cur2.recommendation_confidence_score]
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 22
    col: 0
    width: 24
    height: 10

  # =====================================================
  # EXPIRATION & RENEWAL TRACKING
  # =====================================================

  - title: ⏰ Commitment Expiration Timeline
    name: expiration_timeline
    model: aws_billing
    explore: cur2
    type: looker_timeline
    fields: [cur2.reservation_arn, cur2.line_item_product_code,
             cur2.commitment_start_date, cur2.commitment_end_date,
             cur2.commitment_monthly_cost, cur2.commitment_expiration_days]
    filters:
      cur2.commitment_expiration_days: '<=180'
    sorts: [cur2.commitment_end_date]
    limit: 50
    show_view_names: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    groupBars: true
    labelSize: 10pt
    showLegend: true
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 32
    col: 0
    width: 16
    height: 10

  - title: 📊 Expiring Commitments Summary
    name: expiring_commitments_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.commitment_expiration_bucket, cur2.expiring_commitment_count,
             cur2.expiring_commitment_value, cur2.average_utilization_rate,
             cur2.renewal_recommendation]
    filters:
      cur2.commitment_expiration_days: '<=365'
    sorts: [cur2.commitment_expiration_bucket]
    limit: 10
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
    - type: contains
      value: '0-30 days'
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.commitment_expiration_bucket]
    - type: contains
      value: '31-60 days'
      background_color: '#f97316'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.commitment_expiration_bucket]
    - type: contains
      value: '61-90 days'
      background_color: '#fbbf24'
      font_color: '#78350f'
      bold: true
      fields: [cur2.commitment_expiration_bucket]
    listen:
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 32
    col: 16
    width: 8
    height: 10

  # =====================================================
  # ROI & FINANCIAL ANALYSIS
  # =====================================================

  - title: 💰 Commitment ROI Analysis
    name: commitment_roi_analysis
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.commitment_term_length, cur2.total_commitment_cost,
             cur2.total_on_demand_equivalent_cost, cur2.total_savings,
             cur2.roi_percentage]
    sorts: [cur2.total_savings desc]
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
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_commitment_cost
        id: cur2.total_commitment_cost
        name: Commitment Cost
      - axisId: cur2.total_on_demand_equivalent_cost
        id: cur2.total_on_demand_equivalent_cost
        name: On-Demand Equivalent
      - axisId: cur2.total_savings
        id: cur2.total_savings
        name: Total Savings
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: ROI %
      orientation: right
      series:
      - axisId: cur2.roi_percentage
        id: cur2.roi_percentage
        name: ROI %
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.roi_percentage: line
    series_colors:
      cur2.total_commitment_cost: '#3b82f6'
      cur2.total_on_demand_equivalent_cost: '#ef4444'
      cur2.total_savings: '#10b981'
      cur2.roi_percentage: '#8b5cf6'
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 42
    col: 0
    width: 16
    height: 10

  - title: 📊 Coverage Gap Analysis
    name: coverage_gap_analysis
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.cost_allocation_type, cur2.total_cost]
    sorts: [cur2.total_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    series_colors:
      Reserved Instance: '#10b981'
      Savings Plan: '#3b82f6'
      On-Demand: '#ef4444'
      Spot: '#f59e0b'
    listen:
      Time_Period: cur2.line_item_usage_start_date
      Account_Filter: cur2.line_item_usage_account_name
      Service_Filter: cur2.line_item_product_code
    row: 42
    col: 16
    width: 8
    height: 10
