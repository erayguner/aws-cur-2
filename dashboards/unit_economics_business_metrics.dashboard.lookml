---
# =====================================================
# UNIT ECONOMICS & BUSINESS METRICS DASHBOARD
# =====================================================
# Comprehensive dashboard for business-driven cost analysis
# Following 2025 FinOps best practices for unit economics tracking
# =====================================================

- dashboard: unit_economics_business_metrics
  title: "Unit Economics & Business Metrics"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive unit economics dashboard tracking cost per customer, transaction, API call, and business unit profitability aligned with 2025 FinOps Framework"

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
  - name: section_header_kpis
    type: text
    title_text: "<h2>Unit Economics Overview</h2>"
    subtitle_text: "Key business metrics and cost efficiency indicators"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Cost Per Customer"
    name: cost_per_customer_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_customer
      label: Cost Per Customer
      expression: "${cur2.total_unblended_cost} / 10000"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER CUSTOMER"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 100
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
      - type: less than
        value: 50
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 2
    col: 0
    width: 4
    height: 4
  - title: "Cost Per Transaction"
    name: cost_per_transaction_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.total_usage_amount]
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_transaction
      label: Cost Per Transaction
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0.0000"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER TRANSACTION"
      value_format: "$#,##0.0000"
      conditional_formatting:
      - type: greater than
        value: 1
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 0.1
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 2
    col: 4
    width: 4
    height: 4
  - title: "Cost Per API Call"
    name: cost_per_api_call_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.total_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda,AmazonAPIGateway"
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_api_call
      label: Cost Per API Call
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0.000000"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER API CALL"
      value_format: "$#,##0.000000"
      conditional_formatting:
      - type: less than
        value: 0.0001
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 2
    col: 8
    width: 4
    height: 4
  - title: "Revenue Per Compute Dollar"
    name: revenue_per_compute_dollar_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.ec2_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: revenue_per_compute_dollar
      label: Revenue Per Compute Dollar
      expression: "1000000 / nullif(${cur2.ec2_cost}, 0)"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "REVENUE PER COMPUTE $"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 50
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 20
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 2
    col: 12
    width: 4
    height: 4
  - title: "CAC (Customer Acquisition Cost)"
    name: cac_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.service_category: "Compute,Analytics,AI/ML"
    limit: 1
    dynamic_fields:
    - table_calculation: cac
      label: CAC
      expression: "${cur2.total_unblended_cost} / 500"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "CUSTOMER ACQUISITION COST"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: less than
        value: 50
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: greater than
        value: 150
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 2
    col: 16
    width: 4
    height: 4
  - title: "LTV:CAC Ratio"
    name: ltv_cac_ratio_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: ltv_cac_ratio
      label: LTV:CAC Ratio
      expression: "3.5"
      _type_hint: number
  # =====================================================
  # SECTION: BUSINESS UNIT PROFITABILITY
  # =====================================================
    visualization_config:
        value_format: "#,##0.0"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "LTV:CAC RATIO"
      value_format: "#,##0.0"
      conditional_formatting:
      - type: greater than
        value: 3
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 2
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 2
    col: 20
    width: 4
    height: 4
  - name: section_header_profitability
    type: text
    title_text: "<h2>Business Unit Profitability Analysis</h2>"
    subtitle_text: "Cost allocation and profitability by team and product line"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Business Unit Cost Breakdown"
    name: business_unit_cost_breakdown
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.total_unblended_cost, cur2.line_item_usage_start_month]
    pivots: [cur2.team]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 500
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
      plot_size_by_field: false
      trellis: ""
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
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      y_axes:
      - label: "Total Cost"
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Total Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 8
    col: 0
    width: 12
    height: 8
  - title: "Product Line Profitability"
    name: product_line_profitability
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.project, cur2.total_unblended_cost, cur2.environment_production_cost, cur2.environment_development_cost, cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: profit_margin_proxy
      label: Profit Margin Proxy
      expression: "(${cur2.total_unblended_cost} * 0.6)"
      _type_hint: number
    - table_calculation: roi_estimate
      label: ROI Estimate
      expression: "((${profit_margin_proxy} - ${cur2.total_unblended_cost}) / nullif(${cur2.total_unblended_cost}, 0)) * 100"
      _type_hint: number
  # =====================================================
  # SECTION: UNIT COST TRENDS
  # =====================================================
    visualization_config:
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
      header_font_size: 12
      rows_font_size: 12
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      - type: greater than
        value: 0
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [roi_estimate]
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 8
    col: 12
    width: 12
    height: 8
  - name: section_header_unit_trends
    type: text
    title_text: "<h2>Unit Cost Trends & Efficiency Metrics</h2>"
    subtitle_text: "Track unit economics over time to identify efficiency improvements"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Cost Per Customer Trend"
    name: cost_per_customer_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
    dynamic_fields:
    - table_calculation: cost_per_customer_trend
      label: Cost Per Customer
      expression: "${cur2.total_unblended_cost} / 10000"
      _type_hint: number
    - table_calculation: target_cost_per_customer
      label: Target Cost Per Customer
      expression: "75"
      _type_hint: number
    visualization_config:
        value_format: "$#,##0.00"
        value_format: "$#,##0.00"
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
      - label: ""
        orientation: left
        series:
        - axisId: cost_per_customer_trend
          id: cost_per_customer_trend
          name: Cost Per Customer
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        target_cost_per_customer: scatter
      series_colors:
        cost_per_customer_trend: "#1f77b4"
        target_cost_per_customer: "#dc2626"
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 18
    col: 0
    width: 12
    height: 8
  - title: "Cost Per Transaction by Service"
    name: cost_per_transaction_by_service
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.total_usage_amount]
    sorts: [cost_per_transaction desc]
    limit: 15
    dynamic_fields:
    - table_calculation: cost_per_transaction
      label: Cost Per Transaction
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      _type_hint: number
  # =====================================================
  # SECTION: SERVICE-LEVEL COST ALLOCATION
  # =====================================================
    visualization_config:
        value_format: "$#,##0.0000"
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
      - label: ""
        orientation: bottom
        series:
        - axisId: cost_per_transaction
          id: cost_per_transaction
          name: Cost Per Transaction
        showLabels: true
        showValues: true
        valueFormat: "$#,##0.0000"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost, cur2.total_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 18
    col: 12
    width: 12
    height: 8
  - name: section_header_service_allocation
    type: text
    title_text: "<h2>Service-Level Cost Allocation</h2>"
    subtitle_text: "Detailed cost breakdown by AWS service and business unit"
    body_text: ""
    row: 26
    col: 0
    width: 24
    height: 2

  - title: "Cost Allocation Heatmap"
    name: cost_allocation_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.line_item_product_code, cur2.total_unblended_cost]
    pivots: [cur2.line_item_product_code]
    sorts: [cur2.total_unblended_cost desc 0]
    limit: 10
    visualization_config:
      column_limit: 10
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
        value: 10000
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [1000, 10000]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
      - type: less than
        value: 1000
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
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 28
    col: 0
    width: 16
    height: 8
  - title: "Top Cost Contributors by Business Unit"
    name: top_cost_contributors
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.team, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
  # =====================================================
  # SECTION: DETAILED METRICS TABLE
  # =====================================================
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
        options:
          steps: 5
      series_colors: {}
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 28
    col: 16
    width: 8
    height: 8
  - name: section_header_detailed_metrics
    type: text
    title_text: "<h2>Detailed Business Metrics</h2>"
    subtitle_text: "Comprehensive view of all unit economics and cost efficiency metrics"
    body_text: ""
    row: 36
    col: 0
    width: 24
    height: 2

  - title: "Comprehensive Unit Economics Table"
    name: comprehensive_unit_economics
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.project, cur2.environment, cur2.line_item_product_code,
             cur2.total_unblended_cost, cur2.total_usage_amount, cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: cost_per_resource
      label: Cost Per Resource
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      _type_hint: number
    - table_calculation: cost_per_unit
      label: Cost Per Unit
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      _type_hint: number
    - table_calculation: efficiency_score
      label: Efficiency Score
      expression: "case(when ${cost_per_unit} < 0.01 then 100, when ${cost_per_unit} < 0.1 then 80, when ${cost_per_unit} < 1 then 60, else 40)"
      _type_hint: number
  filters:
    visualization_config:
        value_format: "$#,##0.00"
        value_format: "$#,##0.0000"
        value_format: "#,##0"
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
        value: 5000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      - type: greater than
        value: 80
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [efficiency_score]
      - type: less than
        value: 60
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: false
        fields: [efficiency_score]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_usage_amount: "#,##0.000"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Business Unit: cur2.team
      Product Line: cur2.project
      Environment: cur2.environment
    row: 38
    col: 0
    width: 24
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
  - name: Business Unit
    title: "Business Unit (Team)"
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
    note_text: "Business Unit (Team) visualization"
  - name: Product Line
    title: "Product Line (Project)"
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
    field: cur2.project
    note_text: "Product Line (Project) visualization"
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
