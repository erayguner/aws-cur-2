---
# Waste Detection Dashboard
# Identify and track unused, underutilized, and wasteful AWS resources

- dashboard: waste_detection
  title: 🗑️ Waste Detection & Optimization
  description: Identify unused, underutilized, and wasteful AWS resources for immediate cost optimization
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
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
    listens_to_filters: [AWS Service, Environment]
    field: cur2.line_item_usage_account_name

  - name: AWS Service
    title: 🔧 AWS Service
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
    field: cur2.line_item_product_code

  - name: Environment
    title: 🌍 Environment
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account]
    field: cur2.environment

  - name: Waste Threshold
    title: 💰 Waste Threshold ($)
    type: field_filter
    default_value: "0"
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 10000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost

  elements:
  # Waste Summary KPIs
  - name: waste_summary_kpis
    title: Waste Detection Summary
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields: [cur2.total_unblended_cost]
    dynamic_fields:
    - measure: zero_usage_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: Zero Usage Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.total_usage_amount: "0"
    - measure: low_utilization_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: Low Utilization Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.total_usage_amount: ">0,<10"
    - table_calculation: total_waste_cost
      label: Total Potential Waste
      expression: "${zero_usage_cost} + ${low_utilization_cost}"
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: waste_percentage
      label: Waste % of Total Spend
      expression: "(${total_waste_cost} / ${cur2.total_unblended_cost}) * 100"
      value_format: null
      value_format_name: percent_2
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
    
  # Zero Usage Resources
  - name: zero_usage_resources
    title: Zero Usage Resources (Immediate Waste)
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_usage_account_name
    - cur2.line_item_resource_id
    - cur2.line_item_usage_type
    - cur2.product_instance_type
    - cur2.line_item_availability_zone
    - cur2.total_unblended_cost
    - cur2.total_usage_amount
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
      cur2.total_usage_amount: "0"
      cur2.total_unblended_cost: ">{% parameter waste_threshold_filter %}"
      cur2.line_item_resource_id: "-EMPTY"
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
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
    - type: greater than
      value: "@{COST_THRESHOLD_MEDIUM}"
      background_color: "#dc2626"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: waste-alert
          label: Waste Alert
          type: continuous
          stops:
          - color: "#fef3c7"
            offset: 0
          - color: "#f59e0b"
            offset: 50
          - color: "#dc2626"
            offset: 100
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    width: 16
    height: 8
    row: 4
    col: 0
    
  # Waste by Service Treemap
  - name: waste_by_service_treemap
    title: Waste Distribution by Service
    model: aws_billing
    explore: cur2
    type: treemap_vis
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
      cur2.total_usage_amount: "0,<10"
      cur2.total_unblended_cost: ">{% parameter waste_threshold_filter %}"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    column_limit: 50
    width: 8
    height: 8
    row: 12
    col: 0
    
  # Low Utilization Histogram
  - name: low_utilization_histogram
    title: Low Utilization Distribution
    model: aws_billing
    explore: cur2
    type: histogram_vis
    fields: [cur2.total_usage_amount, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
      cur2.total_usage_amount: ">0,<100"
      cur2.total_unblended_cost: ">{% parameter waste_threshold_filter %}"
    sorts: [cur2.total_usage_amount]
    limit: 50
    column_limit: 50
    width: 8
    height: 8
    row: 12
    col: 8
    
  # Waste Trend Over Time
  - name: waste_trend
    title: Daily Waste Trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    dynamic_fields:
    - measure: daily_zero_usage_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: Zero Usage Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.total_usage_amount: "0"
    - measure: daily_low_usage_cost
      based_on: cur2.total_unblended_cost
      type: sum
      label: Low Usage Cost
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      table_calculation: false
      _type_hint: type_unspecified
      filters:
        cur2.total_usage_amount: ">0,<10"
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
    height: 6
    row: 20
    col: 0
    
  # Resource-level Waste Analysis
  - name: resource_waste_analysis
    title: Resource-Level Waste Analysis
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.line_item_product_code
    - cur2.line_item_usage_account_name
    - cur2.line_item_resource_id
    - cur2.product_instance_type
    - cur2.line_item_availability_zone
    - cur2.total_unblended_cost
    - cur2.total_usage_amount
    - cur2.pricing_unit
    dynamic_fields:
    - table_calculation: waste_category
      label: Waste Category
      expression: |-
        case(
          when ${cur2.total_usage_amount} = 0 then "Zero Usage"
          when ${cur2.total_usage_amount} < 1 then "Very Low Usage"
          when ${cur2.total_usage_amount} < 10 then "Low Usage"
          else "Normal Usage"
        end
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    - table_calculation: optimization_action
      label: Recommended Action
      expression: |-
        case(
          when ${cur2.total_usage_amount} = 0 then "Terminate Immediately"
          when ${cur2.total_usage_amount} < 1 then "Downsize or Terminate"
          when ${cur2.total_usage_amount} < 10 then "Right-size Instance"
          else "Monitor"
        end
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    - table_calculation: monthly_savings_potential
      label: Monthly Savings Potential
      expression: |-
        case(
          when ${cur2.total_usage_amount} = 0 then ${cur2.total_unblended_cost}
          when ${cur2.total_usage_amount} < 1 then ${cur2.total_unblended_cost} * 0.8
          when ${cur2.total_usage_amount} < 10 then ${cur2.total_unblended_cost} * 0.5
          else 0
        end
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: "{% parameter billing_period_filter %}"
      cur2.line_item_usage_account_name: "{% parameter account_filter %}"
      cur2.total_usage_amount: "<50"
      cur2.total_unblended_cost: ">{% parameter waste_threshold_filter %}"
      cur2.line_item_resource_id: "-EMPTY"
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
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
      value: Zero Usage
      background_color: "#dc2626"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: waste-categories
          label: Waste Categories
          type: categorical
          colors: ["#dc2626", "#f59e0b", "#eab308", "#16a34a"]
      bold: true
      italic: false
      strikethrough: false
      fields: [waste_category]
    - type: equal to
      value: Very Low Usage
      background_color: "#f59e0b"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: false
      italic: false
      strikethrough: false
      fields: [waste_category]
    - type: equal to
      value: Terminate Immediately
      background_color: "#dc2626"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: true
      italic: false
      strikethrough: false
      fields: [optimization_action]
    width: 16
    height: 12
    row: 26
    col: 0