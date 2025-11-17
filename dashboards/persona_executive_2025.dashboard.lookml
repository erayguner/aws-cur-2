---
- dashboard: persona_executive_2025
  title: 💼 Executive FinOps Dashboard 2025
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Strategic cloud cost oversight for CFO, CTO, CEO, and VP of Engineering - Board presentation ready'

  # Performance optimizations
  auto_run: true
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true

  elements:
  # =============================================================================
  # SECTION 1: STRATEGIC KPIs (Top Row)
  # =============================================================================

  - title: Total Cloud Spend (Current Month)
    name: total_cloud_spend_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: 'this month'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: '$#,##0'
    conditional_formatting:
    - type: greater than
      value: 1000000
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [500000, 1000000]
      background_color: '#eab308'
      font_color: '#000000'
      bold: false
    - type: less than
      value: 500000
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: false
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 0
    col: 0
    width: 4
    height: 3

  - title: MoM Change %
    name: mom_change_pct
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.month_over_month_change]
    filters:
      cur2.line_item_usage_start_date: 'this month'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    value_format: '0.0"%"'
    conditional_formatting:
    - type: greater than
      value: 0.1
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [-0.05, 0.1]
      background_color: '#eab308'
      font_color: '#000000'
    - type: less than
      value: -0.05
      background_color: '#16a34a'
      font_color: '#ffffff'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 0
    col: 4
    width: 4
    height: 3

  - title: YoY Change %
    name: yoy_change_pct
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.year_over_year_change]
    filters:
      cur2.line_item_usage_start_date: 'this month'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0.0"%"'
    conditional_formatting:
    - type: greater than
      value: 0.2
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [-0.1, 0.2]
      background_color: '#eab308'
      font_color: '#000000'
    - type: less than
      value: -0.1
      background_color: '#16a34a'
      font_color: '#ffffff'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 0
    col: 8
    width: 4
    height: 3

  - title: Annual Run Rate
    name: annual_run_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.projected_monthly_cost]
    filters:
      cur2.line_item_usage_start_date: 'this month'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: '$#,##0'
    dynamic_fields:
    - category: table_calculation
      expression: "${cur2.projected_monthly_cost} * 12"
      label: Annual Run Rate
      value_format: '$#,##0'
      _type_hint: number
      table_calculation: annual_run_rate
      _kind_hint: measure
    hidden_fields: [cur2.projected_monthly_cost]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 0
    col: 12
    width: 4
    height: 3

  - title: Commitment Utilization
    name: commitment_utilization
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.commitment_coverage_percentage]
    filters:
      cur2.line_item_usage_start_date: 'this month'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0"%"'
    conditional_formatting:
    - type: greater than
      value: 0.8
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [0.6, 0.8]
      background_color: '#eab308'
      font_color: '#000000'
    - type: less than
      value: 0.6
      background_color: '#dc2626'
      font_color: '#ffffff'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 0
    col: 16
    width: 4
    height: 3

  # =============================================================================
  # SECTION 2: BUSINESS IMPACT METRICS
  # =============================================================================

  - title: Cost by Environment
    name: cost_by_environment
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.environment, cur2.total_unblended_cost]
    filters:
      cur2.environment: '-EMPTY,-NULL'
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
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
    plot_size_by_field: false
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      options:
        steps: 5
    series_colors:
      Production: '#dc2626'
      Staging: '#eab308'
      Development: '#16a34a'
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 3
    col: 0
    width: 7
    height: 6

  - title: Cost by Team/Project
    name: cost_by_team
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.team, cur2.total_unblended_cost]
    filters:
      cur2.team: '-EMPTY,-NULL'
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      options:
        steps: 5
    series_colors: {}
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 3
    col: 7
    width: 6
    height: 6

  - title: Top 10 Cost Centers
    name: top_10_cost_centers
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.cost_center, cur2.total_unblended_cost]
    filters:
      cur2.cost_center: '-EMPTY,-NULL'
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
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
    plot_size_by_field: false
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 3
    col: 13
    width: 7
    height: 6

  # =============================================================================
  # SECTION 3: EFFICIENCY & OPTIMIZATION
  # =============================================================================

  - title: Savings Realized
    name: savings_realized
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_savings_realized]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: '$#,##0'
    font_size: medium
    text_color: '#16a34a'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 9
    col: 0
    width: 4
    height: 3

  - title: Waste Detection Score
    name: waste_detection_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.waste_detection_score]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0'
    conditional_formatting:
    - type: less than
      value: 30
      background_color: '#16a34a'
      font_color: '#ffffff'
    - type: between
      value: [30, 70]
      background_color: '#eab308'
      font_color: '#000000'
    - type: greater than
      value: 70
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 9
    col: 4
    width: 4
    height: 3

  - title: Tag Compliance %
    name: tag_compliance
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.tag_coverage_rate]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0"%"'
    conditional_formatting:
    - type: greater than
      value: 0.8
      background_color: '#16a34a'
      font_color: '#ffffff'
    - type: between
      value: [0.5, 0.8]
      background_color: '#eab308'
      font_color: '#000000'
    - type: less than
      value: 0.5
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 9
    col: 8
    width: 4
    height: 3

  - title: Right-Sizing Opportunities
    name: rightsizing_opportunities
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: '$#,##0'
    font_size: medium
    text_color: '#2563eb'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 9
    col: 12
    width: 4
    height: 3

  - title: Commitment Savings Breakdown
    name: commitment_savings_breakdown
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_month, cur2.total_commitment_savings, cur2.total_discount_amount]
    filters: {}
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
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
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: '#808080'
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      cur2.total_commitment_savings: '#16a34a'
      cur2.total_discount_amount: '#2563eb'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 9
    col: 16
    width: 4
    height: 3

  # =============================================================================
  # SECTION 4: FORECAST & TRENDS
  # =============================================================================

  - title: 12-Month Cost Trend
    name: twelve_month_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost, cur2.projected_monthly_cost]
    filters: {}
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
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
    plot_size_by_field: false
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
    interpolation: monotone
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_types:
      cur2.projected_monthly_cost: area
    series_colors:
      cur2.total_unblended_cost: '#1f77b4'
      cur2.projected_monthly_cost: '#ff7f0e'
    series_labels:
      cur2.total_unblended_cost: Actual Cost
      cur2.projected_monthly_cost: Projected Cost
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 12
    col: 0
    width: 10
    height: 6

  - title: Quarterly Forecast
    name: quarterly_forecast
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_quarter, cur2.total_unblended_cost]
    filters: {}
    sorts: [cur2.line_item_usage_start_quarter desc]
    limit: 8
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
    plot_size_by_field: false
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 12
    col: 10
    width: 10
    height: 6

  - title: Anomaly Alerts
    name: anomaly_alerts
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.is_cost_anomaly]
    filters:
      cur2.is_cost_anomaly: 'Yes'
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0'
    conditional_formatting:
    - type: equal to
      value: 0
      background_color: '#16a34a'
      font_color: '#ffffff'
    - type: greater than
      value: 0
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 18
    col: 0
    width: 4
    height: 3

  # =============================================================================
  # SECTION 5: SUSTAINABILITY (Future-proof)
  # =============================================================================

  - title: Estimated Carbon Emissions (kg)
    name: carbon_emissions
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.estimated_carbon_emissions_kg]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: '#,##0'
    font_size: medium
    text_color: '#059669'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 18
    col: 4
    width: 4
    height: 3

  - title: Green Energy Usage %
    name: green_energy_pct
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.renewable_energy_percentage]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0"%"'
    conditional_formatting:
    - type: greater than
      value: 0.7
      background_color: '#16a34a'
      font_color: '#ffffff'
    - type: between
      value: [0.4, 0.7]
      background_color: '#eab308'
      font_color: '#000000'
    - type: less than
      value: 0.4
      background_color: '#dc2626'
      font_color: '#ffffff'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 18
    col: 8
    width: 4
    height: 3

  - title: Sustainability Score
    name: sustainability_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.sustainability_score]
    filters: {}
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    enable_conditional_formatting: true
    value_format: '0'
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#16a34a'
      font_color: '#ffffff'
    - type: between
      value: [50, 80]
      background_color: '#eab308'
      font_color: '#000000'
    - type: less than
      value: 50
      background_color: '#dc2626'
      font_color: '#ffffff'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 18
    col: 12
    width: 4
    height: 3

  - title: Carbon Emissions Trend
    name: carbon_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_month, cur2.estimated_carbon_emissions_kg]
    filters: {}
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
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
    plot_size_by_field: false
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
    interpolation: monotone
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      cur2.estimated_carbon_emissions_kg: '#059669'
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 18
    col: 16
    width: 4
    height: 3

  # =============================================================================
  # SECTION 6: EXECUTIVE SUMMARY TABLE
  # =============================================================================

  - title: Executive Summary - Last 12 Months
    name: executive_summary_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost, cur2.total_commitment_savings,
             cur2.environment_production_cost, cur2.environment_staging_cost, cur2.environment_development_cost,
             cur2.month_over_month_change, cur2.commitment_coverage_percentage]
    filters: {}
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_labels:
      cur2.line_item_usage_start_month: Month
      cur2.total_unblended_cost: Total Spend
      cur2.total_commitment_savings: Savings
      cur2.environment_production_cost: Production
      cur2.environment_staging_cost: Staging
      cur2.environment_development_cost: Development
      cur2.month_over_month_change: MoM %
      cur2.commitment_coverage_percentage: Commitment %
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      cur2.total_commitment_savings:
        is_active: true
        palette:
          palette_id: 471a8295-662d-46fc-bd2d-2d0acd370c1e
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    conditional_formatting:
    - type: greater than
      value: 0.1
      background_color: ''
      font_color: '#dc2626'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.month_over_month_change]
    - type: less than
      value: 0
      background_color: ''
      font_color: '#16a34a'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.month_over_month_change]
    - type: greater than
      value: 0.8
      background_color: ''
      font_color: '#16a34a'
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.commitment_coverage_percentage]
    - type: less than
      value: 0.6
      background_color: ''
      font_color: '#dc2626'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.commitment_coverage_percentage]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 21
    col: 0
    width: 20
    height: 8

  - title: Top Services by Spend
    name: top_services_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.month_over_month_change,
             cur2.total_usage_amount, cur2.cost_per_resource]
    filters:
      cur2.line_item_product_code: '-EMPTY'
    sorts: [cur2.total_unblended_cost desc]
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_labels:
      cur2.line_item_product_code: Service
      cur2.total_unblended_cost: Total Cost
      cur2.month_over_month_change: MoM Change %
      cur2.total_usage_amount: Usage
      cur2.cost_per_resource: Cost/Resource
    series_cell_visualizations:
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    conditional_formatting:
    - type: greater than
      value: 0.15
      background_color: ''
      font_color: '#dc2626'
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.month_over_month_change]
    - type: less than
      value: 0
      background_color: ''
      font_color: '#16a34a'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.month_over_month_change]
    listen:
      Date Range: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 21
    col: 20
    width: 20
    height: 8

  # =============================================================================
  # FILTERS
  # =============================================================================

  filters:
  - name: Date Range
    title: 📅 Date Range
    type: field_filter
    default_value: '12 months'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
      - '7 days'
      - '30 days'
      - '3 months'
      - '6 months'
      - '12 months'
      - 'this month'
      - 'this quarter'
      - 'this year'
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: AWS Account
    title: 🏢 AWS Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Environment]
    field: cur2.line_item_usage_account_name

  - name: Environment
    title: 🌍 Environment
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account]
    field: cur2.environment
