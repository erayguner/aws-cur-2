---
# =====================================================
# FINANCE/PROCUREMENT PERSONA DASHBOARD 2025
# =====================================================
# Future-proof dashboard for Finance Analysts, Procurement Team,
# Accounts Payable, and Budget Managers
# Focus: Billing accuracy, invoice reconciliation, budget tracking,
# commitment contracts, vendor management
# =====================================================

- dashboard: persona_finance_procurement_2025
  title: "Finance & Procurement Dashboard 2025"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive finance and procurement dashboard for invoice reconciliation, budget tracking, commitment contract management, and vendor analysis aligned with 2025 accounting standards"

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

  # =====================================================
  # SECTION 1: INVOICE SUMMARY
  # =====================================================

  elements:
  - name: section_header_invoice_summary
    type: text
    title_text: "<h2>📋 Invoice Summary</h2>"
    subtitle_text: "Billing period overview, invoice tracking, and payment analysis"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total Billing Period Cost"
    name: total_billing_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL BILLING PERIOD COST"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 100000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Invoice ID: cur2.invoice_id
      Billing Entity: cur2.billing_entity
    row: 2
    col: 0
    width: 4
    height: 4

  - title: "Net Amount (After Discounts)"
    name: net_amount_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_net_unblended_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "NET AMOUNT (AFTER DISCOUNTS)"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 80000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Invoice ID: cur2.invoice_id
      Billing Entity: cur2.billing_entity
    row: 2
    col: 4
    width: 4
    height: 4

  - title: "Total Tax Amount"
    name: total_tax_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_tax_amount]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL TAX AMOUNT"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Invoice ID: cur2.invoice_id
      Billing Entity: cur2.billing_entity
    row: 2
    col: 8
    width: 4
    height: 4

  - title: "Total Discounts Applied"
    name: total_discounts_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_all_discounts]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL DISCOUNTS APPLIED"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 5000
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Invoice ID: cur2.invoice_id
      Billing Entity: cur2.billing_entity
    row: 2
    col: 12
    width: 4
    height: 4

  - title: "Active Invoices"
    name: active_invoices_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    filters:
      cur2.invoice_id: "-NULL"
    limit: 1
    dynamic_fields:
    - measure: invoice_count
      label: Invoice Count
      based_on: cur2.invoice_id
      type: count_distinct
      _kind_hint: measure
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ACTIVE INVOICES"
      value_format: "#,##0"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Billing Entity: cur2.billing_entity
    row: 2
    col: 16
    width: 4
    height: 4

  - title: "Billing Entities"
    name: billing_entities_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count]
    filters:
      cur2.billing_entity: "-NULL"
    limit: 1
    dynamic_fields:
    - measure: billing_entity_count
      label: Billing Entity Count
      based_on: cur2.billing_entity
      type: count_distinct
      _kind_hint: measure
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "BILLING ENTITIES"
      value_format: "#,##0"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 2
    col: 20
    width: 4
    height: 4

  - title: "Invoice Breakdown by Entity"
    name: invoice_by_entity
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.invoice_id, cur2.billing_entity, cur2.invoicing_entity,
             cur2.bill_type, cur2.total_unblended_cost, cur2.total_tax_amount,
             cur2.total_all_discounts, cur2.total_net_unblended_cost]
    filters:
      cur2.invoice_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: payment_terms
      label: Payment Terms
      expression: "\"Net 30\""
      _type_hint: string
    - table_calculation: amount_due
      label: Amount Due
      expression: "${cur2.total_net_unblended_cost} + ${cur2.total_tax_amount}"
      _type_hint: number
    visualization_config:
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
        value: 50000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [amount_due]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        cur2.total_all_discounts: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        amount_due: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Invoice ID: cur2.invoice_id
      Billing Entity: cur2.billing_entity
    row: 6
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 2: BUDGET VS. ACTUAL
  # =====================================================

  - name: section_header_budget_analysis
    type: text
    title_text: "<h2>💰 Budget vs. Actual Analysis</h2>"
    subtitle_text: "Monthly budget tracking, variance analysis, and forecast modeling"
    body_text: ""
    row: 14
    col: 0
    width: 24
    height: 2

  - title: "Budget Burn Rate"
    name: budget_burn_rate_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.budget_burn_rate]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "BUDGET BURN RATE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 100
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [80, 100]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
      - type: less than
        value: 80
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 16
    col: 0
    width: 6
    height: 4

  - title: "Projected Monthly Cost"
    name: projected_monthly_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.projected_monthly_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "PROJECTED MONTHLY COST"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 16
    col: 6
    width: 6
    height: 4

  - title: "Month-over-Month Change"
    name: mom_change_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.month_over_month_change]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "MONTH-OVER-MONTH CHANGE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 10
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: -5
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 16
    col: 12
    width: 6
    height: 4

  - title: "Average Daily Cost"
    name: avg_daily_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.average_daily_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "AVERAGE DAILY COST"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 16
    col: 18
    width: 6
    height: 4

  - title: "Monthly Budget Tracking"
    name: monthly_budget_tracking
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.billing_period_start_month, cur2.total_unblended_cost,
             cur2.projected_monthly_cost, cur2.month_over_month_change,
             cur2.budget_burn_rate, cur2.average_daily_cost]
    sorts: [cur2.billing_period_start_month desc]
    limit: 12
    dynamic_fields:
    - table_calculation: budget_target
      label: Budget Target
      expression: "120000"
      _type_hint: number
    - table_calculation: variance_amount
      label: Variance ($)
      expression: "${cur2.total_unblended_cost} - ${budget_target}"
      _type_hint: number
    - table_calculation: variance_percent
      label: Variance (%)
      expression: "(${variance_amount} / nullif(${budget_target}, 0)) * 100"
      _type_hint: number
    - table_calculation: forecast_to_month_end
      label: Forecast to Month-End
      expression: "${cur2.projected_monthly_cost}"
      _type_hint: number
    visualization_config:
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
        value: 0
        background_color: "#fecaca"
        font_color: "#991b1b"
        bold: true
        fields: [variance_amount]
      - type: less than
        value: 0
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [variance_amount]
      - type: greater than
        value: 5
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [variance_percent]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.projected_monthly_cost: "$#,##0.00"
        cur2.average_daily_cost: "$#,##0.00"
        budget_target: "$#,##0.00"
        variance_amount: "$#,##0.00"
        variance_percent: "#,##0.0\"%\""
        forecast_to_month_end: "$#,##0.00"
        cur2.month_over_month_change: "#,##0.0\"%\""
        cur2.budget_burn_rate: "#,##0.0\"%\""
      series_cell_visualizations:
        variance_percent:
          is_active: true
          palette:
            palette_id: custom_diverging
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 20
    col: 0
    width: 24
    height: 10

  - title: "Budget Variance by Account"
    name: budget_variance_by_account
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost,
             cur2.month_over_month_change]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: account_budget
      label: Account Budget
      expression: "10000"
      _type_hint: number
    - table_calculation: variance
      label: Variance
      expression: "${cur2.total_unblended_cost} - ${account_budget}"
      _type_hint: number
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
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Actual Cost
        - axisId: account_budget
          id: account_budget
          name: Budget
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        account_budget: line
      series_colors:
        cur2.total_unblended_cost: "#3b82f6"
        account_budget: "#dc2626"
      defaults_version: 1
      hidden_fields: [variance, cur2.month_over_month_change]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 30
    col: 0
    width: 12
    height: 8

  - title: "Budget Variance by Service"
    name: budget_variance_by_service
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: service_budget
      label: Service Budget
      expression: "5000"
      _type_hint: number
    - table_calculation: variance
      label: Variance
      expression: "${cur2.total_unblended_cost} - ${service_budget}"
      _type_hint: number
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
          name: Actual Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_unblended_cost: "#10b981"
      defaults_version: 1
      hidden_fields: [service_budget, variance]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 30
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION 3: COST ALLOCATION
  # =====================================================

  - name: section_header_cost_allocation
    type: text
    title_text: "<h2>📊 Cost Allocation</h2>"
    subtitle_text: "Department/team cost breakdown and chargeback analysis"
    body_text: ""
    row: 38
    col: 0
    width: 24
    height: 2

  - title: "Allocated Costs"
    name: allocated_costs_total
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
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
      Cost Center: cur2.cost_center
    row: 40
    col: 0
    width: 6
    height: 4

  - title: "Unallocated Costs"
    name: unallocated_costs_total
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
      - type: greater than
        value: 5000
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 1000
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 40
    col: 6
    width: 6
    height: 4

  - title: "Allocation Rate"
    name: allocation_rate_metric
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
    visualization_config:
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
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 40
    col: 12
    width: 6
    height: 4

  - title: "Active Cost Centers"
    name: active_cost_centers_count
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
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 40
    col: 18
    width: 6
    height: 4

  - title: "Cost by Payer Account"
    name: cost_by_payer
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.payer_account_name, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 44
    col: 0
    width: 8
    height: 8

  - title: "Cost by Linked Account"
    name: cost_by_linked_account
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost,
             cur2.total_net_unblended_cost, cur2.total_all_discounts]
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
          name: Gross Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_unblended_cost: "#3b82f6"
        cur2.total_net_unblended_cost: "#10b981"
      defaults_version: 1
      hidden_fields: [cur2.total_all_discounts]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 44
    col: 8
    width: 16
    height: 8

  - title: "Cost by Cost Category"
    name: cost_by_category
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.cost_category, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.cost_category: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
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
        cur2.total_unblended_cost: "#8b5cf6"
      defaults_version: 1
      hidden_fields: [cur2.count_unique_resources]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 52
    col: 0
    width: 12
    height: 8

  - title: "Chargeback by Department/Team"
    name: chargeback_by_team
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.project, cur2.total_unblended_cost,
             cur2.team_cost_allocation, cur2.count_unique_resources]
    filters:
      cur2.team: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: chargeback_amount
      label: Chargeback Amount
      expression: "${cur2.team_cost_allocation}"
      _type_hint: number
    - table_calculation: cost_per_resource
      label: Cost per Resource
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      _type_hint: number
    visualization_config:
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
        value: 10000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [chargeback_amount]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.team_cost_allocation: "$#,##0.00"
        chargeback_amount: "$#,##0.00"
        cost_per_resource: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
      Cost Center: cur2.cost_center
    row: 52
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION 4: COMMITMENT CONTRACTS
  # =====================================================

  - name: section_header_commitments
    type: text
    title_text: "<h2>📝 Commitment Contracts</h2>"
    subtitle_text: "Reserved Instance and Savings Plan tracking and amortization"
    body_text: ""
    row: 60
    col: 0
    width: 24
    height: 2

  - title: "Total RI Commitments"
    name: total_ri_commitments
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_ri_cost]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL RI COMMITMENTS"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 62
    col: 0
    width: 6
    height: 4

  - title: "Total SP Commitments"
    name: total_sp_commitments
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_savings_plan_commitment]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL SP COMMITMENTS"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 62
    col: 6
    width: 6
    height: 4

  - title: "RI Utilization Rate"
    name: ri_utilization
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.ri_utilization_rate]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "RI UTILIZATION RATE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 90
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 70
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 62
    col: 12
    width: 6
    height: 4

  - title: "SP Utilization Rate"
    name: sp_utilization
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.savings_plan_utilization_rate]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "SP UTILIZATION RATE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 90
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: less than
        value: 70
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 62
    col: 18
    width: 6
    height: 4

  - title: "RI Amortization Tracking"
    name: ri_amortization
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.reservation_reservation_a_r_n, cur2.reservation_start_time,
             cur2.reservation_end_time, cur2.reservation_amortized_upfront_fee_for_billing_period,
             cur2.reservation_recurring_fee_for_usage, cur2.total_ri_effective_cost,
             cur2.reservation_unused_amortized_upfront_fee_for_billing_period]
    filters:
      cur2.reservation_reservation_a_r_n: "-NULL"
    sorts: [cur2.total_ri_effective_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: total_ri_cost
      label: Total RI Cost
      expression: "${cur2.reservation_amortized_upfront_fee_for_billing_period} + ${cur2.reservation_recurring_fee_for_usage}"
      _type_hint: number
    - table_calculation: contract_status
      label: Contract Status
      expression: "if(${cur2.reservation_end_time} > now(), \"Active\", \"Expired\")"
      _type_hint: string
    visualization_config:
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
      - type: equal to
        value: "Expired"
        background_color: "#fecaca"
        font_color: "#991b1b"
        bold: true
        fields: [contract_status]
      - type: greater than
        value: 500
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [cur2.reservation_unused_amortized_upfront_fee_for_billing_period]
      series_value_format:
        cur2.reservation_amortized_upfront_fee_for_billing_period: "$#,##0.00"
        cur2.reservation_recurring_fee_for_usage: "$#,##0.00"
        cur2.total_ri_effective_cost: "$#,##0.00"
        cur2.reservation_unused_amortized_upfront_fee_for_billing_period: "$#,##0.00"
        total_ri_cost: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 66
    col: 0
    width: 24
    height: 10

  - title: "SP Commitment Tracking"
    name: sp_commitment
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.savings_plan_savings_plan_a_r_n, cur2.savings_plan_start_time,
             cur2.savings_plan_end_time, cur2.savings_plan_offering_type,
             cur2.savings_plan_purchase_term, cur2.savings_plan_payment_option,
             cur2.savings_plan_amortized_upfront_commitment_for_billing_period,
             cur2.savings_plan_recurring_commitment_for_billing_period,
             cur2.savings_plan_used_commitment, cur2.savings_plan_unused_commitment]
    filters:
      cur2.savings_plan_savings_plan_a_r_n: "-NULL"
    sorts: [cur2.savings_plan_used_commitment desc]
    limit: 50
    dynamic_fields:
    - table_calculation: total_commitment
      label: Total Commitment
      expression: "${cur2.savings_plan_amortized_upfront_commitment_for_billing_period} + ${cur2.savings_plan_recurring_commitment_for_billing_period}"
      _type_hint: number
    - table_calculation: utilization
      label: Utilization (%)
      expression: "(${cur2.savings_plan_used_commitment} / nullif(${total_commitment}, 0)) * 100"
      _type_hint: number
    - table_calculation: contract_status
      label: Contract Status
      expression: "if(${cur2.savings_plan_end_time} > now(), \"Active\", \"Expired\")"
      _type_hint: string
    visualization_config:
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
      - type: equal to
        value: "Expired"
        background_color: "#fecaca"
        font_color: "#991b1b"
        bold: true
        fields: [contract_status]
      - type: less than
        value: 70
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [utilization]
      - type: greater than
        value: 90
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [utilization]
      series_value_format:
        cur2.savings_plan_amortized_upfront_commitment_for_billing_period: "$#,##0.00"
        cur2.savings_plan_recurring_commitment_for_billing_period: "$#,##0.00"
        cur2.savings_plan_used_commitment: "$#,##0.00"
        cur2.savings_plan_unused_commitment: "$#,##0.00"
        total_commitment: "$#,##0.00"
        utilization: "#,##0.0\"%\""
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 76
    col: 0
    width: 24
    height: 10

  - title: "Commitment Savings Trend"
    name: commitment_savings_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.billing_period_start_month, cur2.total_commitment_savings,
             cur2.total_ri_cost, cur2.total_savings_plan_cost]
    sorts: [cur2.billing_period_start_month]
    limit: 12
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
      - label: "Cost/Savings"
        orientation: left
        series:
        - axisId: cur2.total_commitment_savings
          id: cur2.total_commitment_savings
          name: Total Savings
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_commitment_savings: "#16a34a"
        cur2.total_ri_cost: "#3b82f6"
        cur2.total_savings_plan_cost: "#8b5cf6"
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
    row: 86
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 5: DISCOUNT & CREDITS
  # =====================================================

  - name: section_header_discounts
    type: text
    title_text: "<h2>💸 Discounts & Credits</h2>"
    subtitle_text: "Discount tracking, credit application, and negotiated pricing analysis"
    body_text: ""
    row: 94
    col: 0
    width: 24
    height: 2

  - title: "Total Discounts"
    name: total_discounts_summary
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_all_discounts]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL DISCOUNTS"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 96
    col: 0
    width: 4
    height: 4

  - title: "EDP Discounts"
    name: edp_discounts_total
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_edp_discount]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "EDP DISCOUNTS"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 96
    col: 4
    width: 4
    height: 4

  - title: "PPA Credits"
    name: ppa_credits_total
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_ppa_discount]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "PPA CREDITS"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 96
    col: 8
    width: 4
    height: 4

  - title: "Standard Discounts"
    name: standard_discounts_total
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_discount_amount]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "STANDARD DISCOUNTS"
      value_format: "$#,##0.00"
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 96
    col: 12
    width: 4
    height: 4

  - title: "Total Savings Realized"
    name: total_savings_realized
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_savings_realized]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL SAVINGS REALIZED"
      value_format: "$#,##0.00"
      conditional_formatting:
      - type: greater than
        value: 10000
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 96
    col: 16
    width: 4
    height: 4

  - title: "Effective Savings Rate"
    name: effective_savings_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.effective_savings_rate]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "EFFECTIVE SAVINGS RATE"
      value_format: "#,##0.0\"%\""
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 96
    col: 20
    width: 4
    height: 4

  - title: "Discount Breakdown by Type"
    name: discount_breakdown
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.total_edp_discount, cur2.total_ppa_discount,
             cur2.total_discount_amount, cur2.total_commitment_savings]
    limit: 1
    dynamic_fields:
    - measure: edp_discounts
      label: EDP Discounts
      based_on: cur2.total_edp_discount
      type: sum
      _kind_hint: measure
    - measure: ppa_credits
      label: PPA Credits
      based_on: cur2.total_ppa_discount
      type: sum
      _kind_hint: measure
    - measure: standard_discounts
      label: Standard Discounts
      based_on: cur2.total_discount_amount
      type: sum
      _kind_hint: measure
    - measure: commitment_savings
      label: Commitment Savings
      based_on: cur2.total_commitment_savings
      type: sum
      _kind_hint: measure
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      series_colors:
        cur2.total_edp_discount: "#16a34a"
        cur2.total_ppa_discount: "#3b82f6"
        cur2.total_discount_amount: "#8b5cf6"
        cur2.total_commitment_savings: "#10b981"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 100
    col: 0
    width: 8
    height: 8

  - title: "Monthly Discount Trend"
    name: discount_trend
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.billing_period_start_month, cur2.total_all_discounts,
             cur2.total_edp_discount, cur2.total_ppa_discount]
    sorts: [cur2.billing_period_start_month]
    limit: 12
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
      - label: "Discount Amount"
        orientation: left
        series:
        - axisId: cur2.total_all_discounts
          id: cur2.total_all_discounts
          name: Total Discounts
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_edp_discount: "#16a34a"
        cur2.total_ppa_discount: "#3b82f6"
        cur2.total_all_discounts: "#8b5cf6"
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
    row: 100
    col: 8
    width: 16
    height: 8

  - title: "Discount Detail Report"
    name: discount_detail
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.line_item_product_code,
             cur2.total_unblended_cost, cur2.total_all_discounts,
             cur2.total_net_unblended_cost, cur2.discount]
    filters:
      cur2.total_all_discounts: ">0"
    sorts: [cur2.total_all_discounts desc]
    limit: 50
    dynamic_fields:
    - table_calculation: discount_rate
      label: Discount Rate (%)
      expression: "(${cur2.total_all_discounts} / nullif(${cur2.total_unblended_cost}, 0)) * 100"
      _type_hint: number
    - table_calculation: discount_type
      label: Discount Type
      expression: "${cur2.discount}"
      _type_hint: string
    visualization_config:
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
        value: 20
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [discount_rate]
      - type: greater than
        value: 1000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [cur2.total_all_discounts]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_all_discounts: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        discount_rate: "#,##0.0\"%\""
      defaults_version: 1
      hidden_fields: [cur2.discount]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 108
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 6: BILLING PERIOD ANALYSIS
  # =====================================================

  - name: section_header_billing_period
    type: text
    title_text: "<h2>📅 Billing Period Analysis</h2>"
    subtitle_text: "Period-over-period billing trends, bill types, and currency analysis"
    body_text: ""
    row: 118
    col: 0
    width: 24
    height: 2

  - title: "Month-by-Month Billing Summary"
    name: monthly_billing_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.billing_period, cur2.billing_period_start_date,
             cur2.billing_period_end_date, cur2.bill_type,
             cur2.total_unblended_cost, cur2.total_tax_amount,
             cur2.total_all_discounts, cur2.total_net_unblended_cost]
    sorts: [cur2.billing_period_start_date desc]
    limit: 24
    dynamic_fields:
    - table_calculation: days_in_period
      label: Days in Period
      expression: "diff_days(${cur2.billing_period_start_date}, ${cur2.billing_period_end_date})"
      _type_hint: number
    - table_calculation: avg_daily_cost
      label: Avg Daily Cost
      expression: "${cur2.total_unblended_cost} / nullif(${days_in_period}, 0)"
      _type_hint: number
    visualization_config:
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
        value: 100000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        cur2.total_all_discounts: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        avg_daily_cost: "$#,##0.00"
      series_cell_visualizations:
        cur2.total_unblended_cost:
          is_active: true
          palette:
            palette_id: custom_sequential
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
    row: 120
    col: 0
    width: 24
    height: 10

  - title: "Bill Type Breakdown"
    name: bill_type_breakdown
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.bill_type, cur2.total_unblended_cost]
    filters:
      cur2.bill_type: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 130
    col: 0
    width: 8
    height: 8

  - title: "Currency Analysis"
    name: currency_analysis
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_currency_code, cur2.total_unblended_cost, cur2.count]
    filters:
      cur2.line_item_currency_code: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
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
        cur2.total_unblended_cost: "#3b82f6"
      defaults_version: 1
      hidden_fields: [cur2.count]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 130
    col: 8
    width: 16
    height: 8

  - title: "Billing Entity Summary"
    name: billing_entity_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.billing_entity, cur2.invoicing_entity, cur2.total_unblended_cost,
             cur2.total_tax_amount, cur2.total_net_unblended_cost, cur2.count]
    filters:
      cur2.billing_entity: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: avg_transaction_size
      label: Avg Transaction Size
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count}, 0)"
      _type_hint: number
    visualization_config:
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
        value: 50000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        avg_transaction_size: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 138
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 7: RECONCILIATION TABLES
  # =====================================================

  - name: section_header_reconciliation
    type: text
    title_text: "<h2>✅ Reconciliation Tables</h2>"
    subtitle_text: "Invoice reconciliation, cost type verification, and GL-ready reports"
    body_text: ""
    row: 146
    col: 0
    width: 24
    height: 2

  - title: "Line Item Count by Invoice"
    name: line_items_by_invoice
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.invoice_id, cur2.billing_entity, cur2.count,
             cur2.total_unblended_cost, cur2.total_tax_amount,
             cur2.total_all_discounts, cur2.total_net_unblended_cost]
    filters:
      cur2.invoice_id: "-NULL"
    sorts: [cur2.count desc]
    limit: 50
    dynamic_fields:
    - table_calculation: avg_line_item_cost
      label: Avg Line Item Cost
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count}, 0)"
      _type_hint: number
    - table_calculation: total_amount_due
      label: Total Amount Due
      expression: "${cur2.total_net_unblended_cost} + ${cur2.total_tax_amount}"
      _type_hint: number
    visualization_config:
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
        value: 1000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [cur2.count]
      - type: greater than
        value: 50000
        background_color: "#fecaca"
        font_color: "#991b1b"
        bold: true
        fields: [total_amount_due]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        cur2.total_all_discounts: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        avg_line_item_cost: "$#,##0.00"
        total_amount_due: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 148
    col: 0
    width: 24
    height: 10

  - title: "Cost Type Breakdown"
    name: cost_type_breakdown
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_line_item_type, cur2.total_unblended_cost, cur2.count]
    filters:
      cur2.line_item_line_item_type: "-NULL"
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
        cur2.total_unblended_cost: "#8b5cf6"
      defaults_version: 1
      hidden_fields: [cur2.count]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 158
    col: 0
    width: 12
    height: 8

  - title: "Blended vs Unblended Cost Comparison"
    name: blended_unblended_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_account_name, cur2.total_blended_cost,
             cur2.total_unblended_cost, cur2.total_net_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: blended_variance
      label: Blended Variance
      expression: "${cur2.total_unblended_cost} - ${cur2.total_blended_cost}"
      _type_hint: number
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
      show_value_labels: false
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
        orientation: left
        series:
        - axisId: cur2.total_blended_cost
          id: cur2.total_blended_cost
          name: Blended Cost
        - axisId: cur2.total_unblended_cost
          id: cur2.total_unblended_cost
          name: Unblended Cost
        - axisId: cur2.total_net_unblended_cost
          id: cur2.total_net_unblended_cost
          name: Net Unblended Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_blended_cost: "#3b82f6"
        cur2.total_unblended_cost: "#10b981"
        cur2.total_net_unblended_cost: "#8b5cf6"
      defaults_version: 1
      hidden_fields: [blended_variance]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 158
    col: 12
    width: 12
    height: 8

  - title: "Net Cost Calculation Reconciliation"
    name: net_cost_reconciliation
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.billing_period, cur2.total_unblended_cost,
             cur2.total_all_discounts, cur2.total_tax_amount,
             cur2.total_net_unblended_cost]
    sorts: [cur2.billing_period desc]
    limit: 12
    dynamic_fields:
    - table_calculation: calculated_net_cost
      label: Calculated Net Cost
      expression: "${cur2.total_unblended_cost} - ${cur2.total_all_discounts}"
      _type_hint: number
    - table_calculation: reconciliation_difference
      label: Reconciliation Difference
      expression: "${cur2.total_net_unblended_cost} - ${calculated_net_cost}"
      _type_hint: number
    - table_calculation: total_payable
      label: Total Payable (Net + Tax)
      expression: "${cur2.total_net_unblended_cost} + ${cur2.total_tax_amount}"
      _type_hint: number
    visualization_config:
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
      - type: not equal to
        value: 0
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
        fields: [reconciliation_difference]
      - type: equal to
        value: 0
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: false
        fields: [reconciliation_difference]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_all_discounts: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        calculated_net_cost: "$#,##0.00"
        reconciliation_difference: "$#,##0.00"
        total_payable: "$#,##0.00"
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
    row: 166
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION 8: ACCOUNTS PAYABLE VIEW
  # =====================================================

  - name: section_header_accounts_payable
    type: text
    title_text: "<h2>💳 Accounts Payable View</h2>"
    subtitle_text: "Payment processing, GL mapping, and department-level AP analysis"
    body_text: ""
    row: 176
    col: 0
    width: 24
    height: 2

  - title: "Cost by Billing Entity (AP View)"
    name: ap_billing_entity
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.billing_entity, cur2.invoicing_entity, cur2.invoice_id,
             cur2.total_unblended_cost, cur2.total_tax_amount,
             cur2.total_net_unblended_cost]
    filters:
      cur2.billing_entity: "-NULL"
    sorts: [cur2.total_net_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: amount_due
      label: Amount Due
      expression: "${cur2.total_net_unblended_cost} + ${cur2.total_tax_amount}"
      _type_hint: number
    - table_calculation: payment_terms
      label: Payment Terms
      expression: "\"Net 30\""
      _type_hint: string
    - table_calculation: due_date
      label: Due Date
      expression: "add_days(30, now())"
      _type_hint: date
    - table_calculation: payment_status
      label: Payment Status
      expression: "\"Pending\""
      _type_hint: string
    visualization_config:
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
        value: 50000
        background_color: "#fecaca"
        font_color: "#991b1b"
        bold: true
        fields: [amount_due]
      - type: equal to
        value: "Pending"
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [payment_status]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        cur2.total_net_unblended_cost: "$#,##0.00"
        amount_due: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 178
    col: 0
    width: 24
    height: 10

  - title: "GL Code Mapping (via Tags)"
    name: gl_code_mapping
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.cost_center, cur2.project, cur2.team,
             cur2.total_unblended_cost, cur2.total_tax_amount]
    filters:
      cur2.cost_center: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: gl_account
      label: GL Account
      expression: "concat(\"5000-\", ${cur2.cost_center})"
      _type_hint: string
    - table_calculation: department_code
      label: Department Code
      expression: "${cur2.project}"
      _type_hint: string
    - table_calculation: cost_center_code
      label: Cost Center Code
      expression: "${cur2.cost_center}"
      _type_hint: string
    - table_calculation: total_gl_amount
      label: Total GL Amount
      expression: "${cur2.total_unblended_cost}"
      _type_hint: number
    visualization_config:
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
        value: 10000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [total_gl_amount]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
        total_gl_amount: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.project, cur2.cost_center]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Cost Center: cur2.cost_center
    row: 188
    col: 0
    width: 24
    height: 10

  - title: "Cost Center Allocation for AP"
    name: ap_cost_center
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.cost_center, cur2.team, cur2.total_unblended_cost,
             cur2.total_tax_amount, cur2.count_unique_resources]
    filters:
      cur2.cost_center: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: expense_category
      label: Expense Category
      expression: "\"Cloud Infrastructure\""
      _type_hint: string
    - table_calculation: approver
      label: Approver
      expression: "\"Finance Manager\""
      _type_hint: string
    - table_calculation: approval_status
      label: Approval Status
      expression: "\"Approved\""
      _type_hint: string
    visualization_config:
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
      - type: equal to
        value: "Approved"
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [approval_status]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.total_tax_amount: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Cost Center: cur2.cost_center
    row: 198
    col: 0
    width: 24
    height: 10

  - title: "Department-Level Costs"
    name: department_costs_ap
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.project, cur2.total_unblended_cost, cur2.total_tax_amount]
    filters:
      cur2.project: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: total_expense
      label: Total Expense
      expression: "${cur2.total_unblended_cost} + ${cur2.total_tax_amount}"
      _type_hint: number
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
      show_value_labels: true
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
          name: Base Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_unblended_cost: "#3b82f6"
        cur2.total_tax_amount: "#fbbf24"
      defaults_version: 1
      hidden_fields: [total_expense]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 208
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION 9: PROCUREMENT INSIGHTS
  # =====================================================

  - name: section_header_procurement
    type: text
    title_text: "<h2>🛒 Procurement Insights</h2>"
    subtitle_text: "Service catalog analysis, vendor management, and new service tracking"
    body_text: ""
    row: 216
    col: 0
    width: 24
    height: 2

  - title: "Service Catalog Costs"
    name: service_catalog_costs
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.product_product_family,
             cur2.total_unblended_cost, cur2.total_usage_amount,
             cur2.count_unique_accounts, cur2.count_unique_resources]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: unit_cost
      label: Unit Cost
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      _type_hint: number
    - table_calculation: cost_per_account
      label: Cost per Account
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_accounts}, 0)"
      _type_hint: number
    - table_calculation: vendor
      label: Vendor
      expression: "\"AWS\""
      _type_hint: string
    visualization_config:
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
        value: 10000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        unit_cost: "$#,##0.0000"
        cost_per_account: "$#,##0.00"
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 218
    col: 0
    width: 24
    height: 10

  - title: "New Service Adoption"
    name: new_service_adoption
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.line_item_usage_start_month,
             cur2.total_unblended_cost, cur2.count_unique_accounts]
    sorts: [cur2.line_item_usage_start_month desc, cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: service_age_months
      label: Service Age (Months)
      expression: "diff_months(${cur2.line_item_usage_start_month}, now())"
      _type_hint: number
    - table_calculation: adoption_status
      label: Adoption Status
      expression: "if(${service_age_months} <= 3, \"New\", if(${service_age_months} <= 12, \"Growing\", \"Mature\"))"
      _type_hint: string
    visualization_config:
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
      - type: equal to
        value: "New"
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [adoption_status]
      - type: equal to
        value: "Growing"
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [adoption_status]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 228
    col: 0
    width: 12
    height: 10

  - title: "Service Usage Trend"
    name: service_usage_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.billing_period_start_month, cur2.line_item_product_code,
             cur2.total_unblended_cost]
    pivots: [cur2.line_item_product_code]
    sorts: [cur2.billing_period_start_month, cur2.line_item_product_code]
    limit: 500
    column_limit: 10
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
          name: Service Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    listen:
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 228
    col: 12
    width: 12
    height: 10

  - title: "Vendor Relationship Analysis (AWS vs Marketplace)"
    name: vendor_analysis
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_legal_entity, cur2.total_unblended_cost]
    filters:
      cur2.line_item_legal_entity: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      defaults_version: 1
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
    row: 238
    col: 0
    width: 8
    height: 8

  - title: "Top 20 Services by Cost"
    name: top_services_procurement
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost,
             cur2.month_over_month_change]
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
      series_colors:
        cur2.total_unblended_cost: "#10b981"
      defaults_version: 1
      hidden_fields: [cur2.month_over_month_change]
    listen:
      Billing Period: cur2.billing_period_start_month
      Payer Account: cur2.payer_account_name
      Linked Account: cur2.line_item_usage_account_name
    row: 238
    col: 8
    width: 16
    height: 8

  # =====================================================
  # DASHBOARD FILTERS
  # =====================================================

  filters:
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
    field: cur2.billing_period_start_month

  - name: Payer Account
    title: "Payer Account"
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
    field: cur2.payer_account_name

  - name: Linked Account
    title: "Linked Account"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Payer Account]
    field: cur2.line_item_usage_account_name

  - name: Invoice ID
    title: "Invoice ID"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Billing Period, Payer Account]
    field: cur2.invoice_id

  - name: Billing Entity
    title: "Billing Entity"
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
    field: cur2.billing_entity

  - name: Cost Center
    title: "Cost Center"
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
    field: cur2.cost_center
