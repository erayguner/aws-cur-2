---
# =====================================================
# SHOWBACK/CHARGEBACK INTERNAL BILLING DASHBOARD
# =====================================================
# Comprehensive dashboard for internal cost allocation and billing
# Following 2025 FinOps best practices for chargeback and showback
# =====================================================

- dashboard: showback_chargeback_billing
  title: "Showback/Chargeback Internal Billing"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive internal billing dashboard for department/team cost allocation, chargeback reports, shared services allocation, and invoice-ready views aligned with 2025 FinOps Framework"

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
  - name: section_header_billing_summary
    type: text
    title_text: "<h2>Billing Summary Overview</h2>"
    subtitle_text: "Executive summary of internal billing and cost allocation"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total Billable Amount"
    name: total_billable_amount_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL BILLABLE AMOUNT"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 100000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 2
    col: 0
    width: 4
    height: 4
  - title: "Allocated Costs"
    name: allocated_costs_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.team_cost_allocation]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ALLOCATED COSTS"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 50000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 2
    col: 4
    width: 4
    height: 4
  - title: "Unallocated Costs"
    name: unallocated_costs_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.unallocated_team_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "UNALLOCATED COSTS"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: less than
        value: 1000
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: greater than
        value: 10000
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 2
    col: 8
    width: 4
    height: 4
  - title: "Active Cost Centers"
    name: active_cost_centers_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ACTIVE COST CENTERS"
      value_format: "#,##0"
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 2
    col: 12
    width: 4
    height: 4
  - title: "Active Departments"
    name: active_departments_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_projects]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ACTIVE DEPARTMENTS"
      value_format: "#,##0"
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 2
    col: 16
    width: 4
    height: 4
  - title: "Allocation Rate"
    name: allocation_rate_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.team_cost_allocation, cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: allocation_rate
      label: Allocation Rate
      expression: "(${cur2.team_cost_allocation} / nullif(${cur2.total_unblended_cost}, 0)) * 100"
      _type_hint: number
  # =====================================================
  # SECTION: DEPARTMENT/TEAM COST ALLOCATION
  # =====================================================
    visualization_config:
        value_format: "#,##0.0\"%\""
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ALLOCATION RATE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 95
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 80
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 2
    col: 20
    width: 4
    height: 4
  - name: section_header_cost_allocation
    type: text
    title_text: "<h2>Department & Team Cost Allocation</h2>"
    subtitle_text: "Detailed cost breakdown by organizational unit"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Cost by Team/Cost Center"
    name: cost_by_team
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.total_unblended_cost, cur2.environment_production_cost,
             cur2.environment_development_cost, cur2.environment_staging_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
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
      y_axes:
      - label: "Cost"
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
      series_colors:
        cur2.environment_production_cost: "#dc2626"
        cur2.environment_development_cost: "#16a34a"
        cur2.environment_staging_cost: "#fbbf24"
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost]
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 8
    col: 0
    width: 12
    height: 8
  - title: "Cost by Department/Project"
    name: cost_by_department
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.project, cur2.total_unblended_cost, cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
  # =====================================================
  # SECTION: INTERNAL BILLING REPORTS
  # =====================================================
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
      - label: "Cost"
        orientation: bottom
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
      hidden_fields: [cur2.count_unique_resources]
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 8
    col: 12
    width: 12
    height: 8
  - name: section_header_billing_reports
    type: text
    title_text: "<h2>Internal Billing Reports</h2>"
    subtitle_text: "Invoice-ready reports for internal chargeback"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Team/Cost Center Billing Statement"
    name: team_billing_statement
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.total_unblended_cost, cur2.ec2_cost, cur2.s3_cost,
             cur2.rds_cost, cur2.lambda_cost, cur2.count_unique_resources,
             cur2.line_item_usage_account_name]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: other_services_cost
      label: Other Services Cost
      expression: "${cur2.total_unblended_cost} - ${cur2.ec2_cost} - ${cur2.s3_cost} - ${cur2.rds_cost} - ${cur2.lambda_cost}"
      _type_hint: number
    - table_calculation: avg_cost_per_resource
      label: Avg Cost Per Resource
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      _type_hint: number
  # =====================================================
  # SECTION: COST CENTER ATTRIBUTION
  # =====================================================
    visualization_config:
        value_format: "$#,##0.00"
        value_format: "$#,##0.00"
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
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      - type: greater than
        value: 5000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [cur2.ec2_cost]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.ec2_cost: "$#,##0.00"
        cur2.s3_cost: "$#,##0.00"
        cur2.rds_cost: "$#,##0.00"
        cur2.lambda_cost: "$#,##0.00"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 18
    col: 0
    width: 24
    height: 10
  - name: section_header_cost_center
    type: text
    title_text: "<h2>Cost Center Attribution</h2>"
    subtitle_text: "Detailed attribution of costs to organizational cost centers"
    body_text: ""
    row: 28
    col: 0
    width: 24
    height: 2

  - title: "Cost Center Distribution"
    name: cost_center_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.team, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 30
    col: 0
    width: 8
    height: 8
  - title: "Cost Center Trend"
    name: cost_center_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, cur2.team]
    pivots: [cur2.team]
    sorts: [cur2.line_item_usage_start_date, cur2.team]
    limit: 500
  # =====================================================
  # SECTION: SHARED SERVICES ALLOCATION
  # =====================================================
    visualization_config:
      column_limit: 10
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
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 30
    col: 8
    width: 16
    height: 8
  - name: section_header_shared_services
    type: text
    title_text: "<h2>Shared Services Allocation</h2>"
    subtitle_text: "Cost allocation for shared infrastructure and services"
    body_text: ""
    row: 38
    col: 0
    width: 24
    height: 2

  - title: "Shared Services Cost Breakdown"
    name: shared_services_breakdown
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.count_unique_accounts]
    filters:
      cur2.service_category: "Networking,Security,Management"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: allocated_per_account
      label: Allocated Per Account
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_accounts}, 0)"
      _type_hint: number
    visualization_config:
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
      - label: "Per Account"
        orientation: right
        series:
        - axisId: allocated_per_account
          id: allocated_per_account
          name: Per Account
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        allocated_per_account: line
      defaults_version: 1
      hidden_fields: [cur2.count_unique_accounts]
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
    row: 40
    col: 0
    width: 16
    height: 8
  - title: "Shared Services Allocation Model"
    name: shared_services_allocation_model
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.count_unique_accounts,
             cur2.count_teams, cur2.count_projects]
    filters:
      cur2.service_category: "Networking,Security,Management"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: allocation_per_team
      label: Allocation Per Team
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_teams}, 0)"
      _type_hint: number
    - table_calculation: allocation_method
      label: Allocation Method
      expression: "\"Equal Split\""
      _type_hint: string
  # =====================================================
  # SECTION: TRANSFER PRICING MODELS
  # =====================================================
    visualization_config:
        value_format: "$#,##0.00"
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
        value: 1000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [allocation_per_team]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.count_unique_accounts, cur2.count_projects]
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
    row: 40
    col: 16
    width: 8
    height: 8
  - name: section_header_transfer_pricing
    type: text
    title_text: "<h2>Transfer Pricing Models</h2>"
    subtitle_text: "Internal transfer pricing for shared resources and services"
    body_text: ""
    row: 48
    col: 0
    width: 24
    height: 2

  - title: "Transfer Pricing by Service Category"
    name: transfer_pricing_by_category
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.service_category, cur2.total_unblended_cost, cur2.total_usage_amount,
             cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: unit_rate
      label: Unit Rate
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      _type_hint: number
    - table_calculation: markup_percentage
      label: Markup %
      expression: "15"
      _type_hint: number
    - table_calculation: transfer_price
      label: Transfer Price
      expression: "${unit_rate} * (1 + (${markup_percentage} / 100))"
      _type_hint: number
    - table_calculation: total_transfer_revenue
      label: Total Transfer Revenue
      expression: "${transfer_price} * ${cur2.total_usage_amount}"
      _type_hint: number
  # =====================================================
  # SECTION: INVOICE GENERATION VIEWS
  # =====================================================
    visualization_config:
        value_format: "$#,##0.0000"
        value_format: "#,##0.0\"%\""
        value_format: "$#,##0.0000"
        value_format: "$#,##0.00"
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
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [total_transfer_revenue]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_usage_amount: "#,##0.000"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 50
    col: 0
    width: 24
    height: 10
  - name: section_header_invoice
    type: text
    title_text: "<h2>Invoice-Ready Reports</h2>"
    subtitle_text: "Detailed invoice reports ready for internal billing systems"
    body_text: ""
    row: 60
    col: 0
    width: 24
    height: 2

  - title: "Monthly Invoice Summary by Cost Center"
    name: monthly_invoice_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.line_item_usage_account_name, cur2.billing_period,
             cur2.total_unblended_cost, cur2.total_discount_amount, cur2.total_net_unblended_cost,
             cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
    dynamic_fields:
    - table_calculation: invoice_number
      label: Invoice Number
      expression: "concat(\"INV-\", ${cur2.billing_period}, \"-\", row())"
      _type_hint: string
    - table_calculation: payment_terms
      label: Payment Terms
      expression: "\"Net 30\""
      _type_hint: string
    - table_calculation: invoice_date
      label: Invoice Date
      expression: "now()"
      _type_hint: date
    - table_calculation: due_date
      label: Due Date
      expression: "add_days(30, ${invoice_date})"
      _type_hint: date
  # =====================================================
  # SECTION: COST ALLOCATION SUMMARY
  # =====================================================
    visualization_config:
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
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_net_unblended_cost]
      - type: greater than
        value: 1000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [cur2.total_discount_amount]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_discount_amount: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
      series_cell_visualizations:
        cur2.total_net_unblended_cost:
          is_active: true
          palette:
            palette_id: custom_sequential
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#ffffff"
            - "#fbbf24"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Environment: cur2.environment
      Service Category: cur2.service_category
    row: 62
    col: 0
    width: 24
    height: 12
  - name: section_header_allocation_summary
    type: text
    title_text: "<h2>Cost Allocation Summary</h2>"
    subtitle_text: "Comprehensive summary of cost allocation across all dimensions"
    body_text: ""
    row: 74
    col: 0
    width: 24
    height: 2

  - title: "Multi-Dimensional Cost Allocation Heatmap"
    name: cost_allocation_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.environment, cur2.total_unblended_cost]
    pivots: [cur2.environment]
    sorts: [cur2.total_unblended_cost desc 0, cur2.environment]
    limit: 20
  filters:
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
      header_font_size: 11
      rows_font_size: 11
      conditional_formatting:
      - type: greater than
        value: 5000
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [1000, 5000]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
      - type: less than
        value: 1000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      series_cell_visualizations:
        cur2.total_unblended_cost:
          is_active: true
          palette:
            palette_id: custom_diverging
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#dcfce7"
            - "#fef3c7"
            - "#fecaca"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Cost Center: cur2.team
      Department: cur2.project
      Service Category: cur2.service_category
    row: 76
    col: 0
    width: 24
    height: 10
  - name: Billing Period
    title: "Billing Period"
    type: field_filter
    default_value: "this month"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date
    note_text: "Billing Period visualization"
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
  - name: Cost Center
    title: "Cost Center (Team)"
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
    field: cur2.team
    note_text: "Cost Center (Team) visualization"
  - name: Department
    title: "Department (Project)"
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
    field: cur2.project
    note_text: "Department (Project) visualization"
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
  - name: Service Category
    title: "Service Category"
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
    field: cur2.service_category
    note_text: "Service Category visualization"
