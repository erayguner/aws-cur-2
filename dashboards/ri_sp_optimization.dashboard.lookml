---
# Reserved Instance & Savings Plan Optimization Dashboard
# Comprehensive RI/SP utilization and optimization recommendations

- dashboard: ri_sp_optimization
  title: RI/SP Optimization
  description: Reserved Instance and Savings Plan utilization analysis and optimization opportunities
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true

  filters:
  - name: Billing Period
    title: 📅 Billing Period
    type: field_filter
    default_value: 1 months ago for 1 months
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: AWS Account
    title: 🏢 AWS Account
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

  - name: RI Utilization Threshold
    title: 📊 RI Utilization Threshold (%)
    type: field_filter
    default_value: "80"
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
    field: cur2.reservation_effective_cost

  - name: Service Category
    title: 🔧 Service Category
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account]
    field: cur2.service_category

  elements:
  # RI/SP Summary KPIs
  - name: ri_sp_summary
    title: RI/SP Summary
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields:
    - cur2.total_unblended_cost
    - cur2.total_blended_cost
    dynamic_fields:
    - measure: reservation_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: Reservation Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: RIFee
    - measure: savings_plan_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: Savings Plan Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: SavingsPlansRecurringFee
    - table_calculation: total_savings
      label: Total Potential Savings
      expression: "${cur2.total_unblended_cost} - ${cur2.total_blended_cost}"
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
    limit: 500
    column_limit: 50
    width: 16
    height: 4
    row: 0
    col: 0
    
  # RI Utilization Gauge
  - name: ri_utilization_gauge
    title: Reserved Instance Utilization
    model: aws_billing
    explore: cur2
    type: gauge_vis
    fields: [cur2.total_usage_amount]
    dynamic_fields:
    - measure: ri_usage
      based_on: cur2.total_usage_amount
      type: sum
      label: RI Usage
      value_format: null
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: DiscountedUsage
    - measure: total_ri_capacity
      based_on: cur2.total_usage_amount
      type: sum
      label: Total RI Capacity
      value_format: null
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: RIFee
    - table_calculation: utilization_rate
      label: Utilization Rate (%)
      expression: "(${ri_usage} / ${total_ri_capacity}) * 100"
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: less than
      value: "{% parameter ri_utilization_threshold %}"
      background_color: "#dc2626"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: utilization-gauge
          label: Utilization Gauge
          type: continuous
          stops:
          - color: "#dc2626"
            offset: 0
          - color: "#eab308"
            offset: 60
          - color: "#16a34a"
            offset: 80
      bold: false
      italic: false
      strikethrough: false
      fields: [utilization_rate]
    width: 8
    height: 6
    row: 4
    col: 0
    
  # Savings Plan Utilization Gauge
  - name: sp_utilization_gauge
    title: Savings Plan Utilization
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.total_usage_amount]
    dynamic_fields:
    - measure: sp_usage
      based_on: cur2.total_usage_amount
      type: sum
      label: SP Usage
      value_format: null
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: SavingsPlansNegation,SavingsPlansCoveredUsage
    - measure: total_sp_commitment
      based_on: cur2.total_usage_amount
      type: sum
      label: Total SP Commitment
      value_format: null
      value_format_name: decimal_2
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: SavingsPlansRecurringFee
    - table_calculation: sp_utilization_rate
      label: SP Utilization Rate (%)
      expression: "(${sp_usage} / ${total_sp_commitment}) * 100"
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
    limit: 500
    column_limit: 50
    width: 8
    height: 6
    row: 4
    col: 8
    
  # RI Coverage by Service
  - name: ri_coverage_by_service
    title: RI Coverage by Service
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_product_code
    - cur2.total_unblended_cost
    dynamic_fields:
    - measure: ri_covered_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: RI Covered Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: DiscountedUsage
    - measure: on_demand_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: On-Demand Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: Usage
    - table_calculation: ri_coverage_percent
      label: RI Coverage %
      expression: "(${ri_covered_cost} / (${ri_covered_cost} + ${on_demand_cost})) * 100"
      value_format: null
      value_format_name: percent_1
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    column_limit: 50
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
    plot_size_by_dimension: false
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    width: 16
    height: 8
    row: 10
    col: 0
    
  # RI/SP Optimization Opportunities Table
  - name: optimization_opportunities
    title: Optimization Opportunities
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.line_item_product_code
    - cur2.product_instance_type
    - cur2.line_item_availability_zone
    - cur2.total_unblended_cost
    - cur2.total_usage_amount
    dynamic_fields:
    - measure: on_demand_spend
      based_on: cur2.total_unblended_cost
      type: sum
      label: On-Demand Spend
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: Usage
    - table_calculation: potential_savings
      label: Potential Monthly Savings (30%)
      expression: "${on_demand_spend} * 0.30"
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: optimization_priority
      label: Priority
      expression: |-
        case(
          when ${on_demand_spend} > @{COST_THRESHOLD_HIGH} then "High"
          when ${on_demand_spend} > @{COST_THRESHOLD_MEDIUM} then "Medium"
          else "Low"
        end
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
      cur2.line_item_type: Usage
      cur2.total_unblended_cost: ">@{COST_THRESHOLD_MEDIUM}"
    sorts: [on_demand_spend desc]
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
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: equal to
      value: High
      background_color: "#dc2626"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: priority-colors
          label: Priority Colors
          type: categorical
          colors: ["#dc2626", "#eab308", "#16a34a"]
      bold: true
      italic: false
      strikethrough: false
      fields: [optimization_priority]
    - type: equal to
      value: Medium
      background_color: "#eab308"
      font_color: "#000000"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: false
      italic: false
      strikethrough: false
      fields: [optimization_priority]
    width: 16
    height: 10
    row: 18
    col: 0
    
  # RI/SP Trend Analysis
  - name: ri_sp_trend
    title: RI/SP Cost Trend Over Time
    model: aws_billing
    explore: cur2
    type: looker_area
    fields:
    - cur2.line_item_usage_start_date
    - cur2.total_unblended_cost
    dynamic_fields:
    - measure: ri_cost_daily
      based_on: cur2.total_unblended_cost
      type: sum
      label: RI Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: RIFee,DiscountedUsage
    - measure: sp_cost_daily
      based_on: cur2.total_unblended_cost
      type: sum
      label: Savings Plan Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: SavingsPlansRecurringFee,SavingsPlansCoveredUsage
    - measure: on_demand_cost_daily
      based_on: cur2.total_unblended_cost
      type: sum
      label: On-Demand Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.line_item_type: Usage
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
    sorts: [cur2.line_item_usage_start_date]
    limit: 31
    column_limit: 50
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
    plot_size_by_dimension: false
    trellis: ""
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
    totals_color: "#808080"
    width: 16
    height: 8
    row: 28
    col: 0