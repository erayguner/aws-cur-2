---
- dashboard: aws_summary_cur2
  title: "AWS Summary (CUR 2.0)"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "AWS cost summary dashboard using CUR 2.0 data schema"

  filters:
  - name: usage_start_date_filter
    title: "Usage Start Date"
    type: field_filter
    default_value: "365 day"
    allow_multiple_values: yes
    required: no
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date

  - name: product_name_filter
    title: "Product Name"
    type: field_filter
    default_value: ""
    allow_multiple_values: yes
    required: no
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_product_code

  - name: resource_id_filter
    title: "Resource ID"
    type: field_filter
    default_value: ""
    allow_multiple_values: yes
    required: no
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_resource_id

  elements:
  # Section Header - SPEND TO DATE
  - name: "spend_to_date_header"
    type: text
    title_text: "<b>SPEND TO DATE</b>"
    subtitle_text: ""
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  # Year Over Year Spend Line Chart
  - title: "YEAR OVER YEAR SPEND"
    name: "year_over_year_spend"
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_month_name
    - cur2.line_item_usage_start_year
    - cur2.total_blended_cost
    pivots:
    - cur2.line_item_usage_start_year
    filters:
      cur2.line_item_usage_start_month: "before 0 months from now"
      cur2.line_item_usage_start_year: "3 years ago for 3 years,1 years"
      cur2.total_blended_cost: "NOT NULL"
    sorts:
    - cur2.line_item_usage_start_year
    - cur2.line_item_usage_start_month_name
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    show_null_points: false
    interpolation: monotone
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      custom:
        id: "3ecc4891-ba14-1878-929a-6e2cc7d6a7de"
        label: "Custom"
        type: "discrete"
        colors:
        - "#ff9900"
        - "#146EB4"
        - "#e47911"
        - "#23223e"
        - "#111111"
        - "#48a3c6"
        - "#007eb9"
      options:
        steps: 5
    y_axes:
    - label: ""
      orientation: left
      series:
      - axisId: cur2.total_blended_cost
        id: "2018 - cur2.total_blended_cost"
        name: "2018 - Total Blended Cost"
      - axisId: cur2.total_blended_cost
        id: "2019 - cur2.total_blended_cost"
        name: "2019 - Total Blended Cost"
      - axisId: cur2.total_blended_cost
        id: "2020 - cur2.total_blended_cost"
        name: "2020 - Total Blended Cost"
      - axisId: cur2.total_blended_cost
        id: "2021 - cur2.total_blended_cost"
        name: "2021 - Total Blended Cost"
      showLabels: true
      showValues: true
      valueFormat: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
      unpinAxis: false
      tickDensity: custom
      tickDensityCustom: 13
      type: linear
    series_types: {}
    series_colors: {}
    label_color: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    listen:
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 2
    col: 4
    width: 20
    height: 8

  # YTD Costs KPI
  - title: "YTD Costs"
    name: "ytd_costs"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.line_item_usage_start_year
    - cur2.total_blended_cost
    filters:
      cur2.line_item_usage_start_date: "this year"
    sorts:
    - cur2.line_item_usage_start_year desc
    limit: 2
    dynamic_fields:
    - _kind_hint: measure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/offset(${cur2.total_blended_cost},1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FF9900"
    single_value_title: "YTD Costs"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    conditional_formatting:
    - type: "equal to"
      value: ""
      background_color: ""
      font_color: ""
      color_application:
        collection_id: "b43731d5-dc87-4a8e-b807-635bef3948e7"
        palette_id: "85de97da-2ded-4dec-9dbd-e6a7d36d5825"
      bold: false
      italic: false
      strikethrough: false
      fields: ""
    defaults_version: 1
    listen:
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 2
    col: 0
    width: 4
    height: 2

  # QTD Costs KPI
  - title: "QTD Costs"
    name: "qtd_costs"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.line_item_usage_start_quarter
    - cur2.total_blended_cost
    filters:
      cur2.line_item_usage_start_date: "this quarter"
    sorts:
    - cur2.line_item_usage_start_quarter desc
    limit: 2
    dynamic_fields:
    - _kind_hint: measure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/offset(${cur2.total_blended_cost},1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FF9900"
    single_value_title: "QTD Costs"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    defaults_version: 1
    listen:
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 4
    col: 0
    width: 4
    height: 2

  # MTD Costs KPI
  - title: "MTD Costs"
    name: "mtd_costs"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.line_item_usage_start_month
    - cur2.total_blended_cost
    filters:
      cur2.line_item_usage_start_date: "this month"
    sorts:
    - cur2.line_item_usage_start_month desc
    limit: 2
    dynamic_fields:
    - _kind_hint: measure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/offset(${cur2.total_blended_cost},1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FF9900"
    single_value_title: "MTD Costs"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    defaults_version: 1
    listen:
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 6
    col: 0
    width: 4
    height: 2

  # WTD Costs KPI
  - title: "WTD Costs"
    name: "wtd_costs"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.line_item_usage_start_week
    - cur2.total_blended_cost
    filters:
      cur2.line_item_usage_start_date: "this week"
    sorts:
    - cur2.line_item_usage_start_week desc
    limit: 2
    dynamic_fields:
    - _kind_hint: measure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/offset(${cur2.total_blended_cost},1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: false
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FF9900"
    single_value_title: "WTD Costs"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    defaults_version: 1
    listen:
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 8
    col: 0
    width: 4
    height: 2

  # Section Header - RESERVED INSTANCE ANALYSIS
  - name: "reserved_instance_header"
    type: text
    title_text: "<b>RESERVED INSTANCE ANALYSIS</b>"
    subtitle_text: ""
    body_text: ""
    row: 10
    col: 0
    width: 24
    height: 2

  # Reserved vs OnDemand Pie Chart
  - title: "RESERVED VS ONDEMAND INSTANCES"
    name: "reserved_vs_ondemand_pie"
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields:
    - cur2.cost_type
    - cur2.total_blended_cost
    filters:
      cur2.cost_type: "Reserved Instance,On-Demand"
    sorts:
    - cur2.total_blended_cost desc
    limit: 500
    column_limit: 50
    value_labels: labels
    label_type: labPer
    inner_radius: 55
    color_application:
      collection_id: billing
      palette_id: "billing-categorical-0"
      options:
        steps: 5
    series_colors:
      "On-Demand": "#FF9900"
      "Reserved Instance": "#E8EAED"
    series_labels:
      "On-Demand": "OnDemand Instances"
      "Reserved Instance": "Reserved Instances"
    defaults_version: 1
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 12
    col: 0
    width: 8
    height: 7

  # Reserved vs OnDemand by Month
  - title: "RESERVED VS ONDEMAND INSTANCES BY MONTH"
    name: "reserved_vs_ondemand_monthly"
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.line_item_usage_start_month
    - cur2.total_blended_cost
    pivots:
    - cur2.cost_type
    filters:
      cur2.cost_type: "Reserved Instance,On-Demand"
    sorts:
    - cur2.line_item_usage_start_month desc
    limit: 500
    dynamic_fields:
    - _kind_hint: measure
      table_calculation: percent_of_spend_reserved_instance
      _type_hint: number
      category: table_calculation
      expression: "pivot_where(${cur2.total_blended_cost}, ${cur2.cost_type} = \"Reserved Instance\") / ${cur2.total_blended_cost:total}"
      label: "Percent of Spend Reserved Instance"
      value_format: ""
      value_format_name: percent_1
    - _kind_hint: measure
      table_calculation: percent_of_spend_ondemand_instance
      _type_hint: number
      category: table_calculation
      expression: "pivot_where(${cur2.total_blended_cost}, ${cur2.cost_type} = \"On-Demand\") / ${cur2.total_blended_cost:total}"
      label: "Percent of Spend OnDemand Instance"
      value_format: ""
      value_format_name: percent_1
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: billing
      palette_id: "billing-categorical-0"
      options:
        steps: 5
    y_axes:
    - label: ""
      orientation: left
      series:
      - axisId: "On-Demand - cur2.total_blended_cost"
        id: "On-Demand - cur2.total_blended_cost"
        name: "Total Cost (OnDemand)"
      - axisId: "Reserved Instance - cur2.total_blended_cost"
        id: "Reserved Instance - cur2.total_blended_cost"
        name: "Total Cost (Reserved)"
      showLabels: true
      showValues: true
      valueFormat: "$0,\"K\""
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    - label: "Percent of Spend"
      orientation: right
      series:
      - axisId: percent_of_spend_reserved_instance
        id: percent_of_spend_reserved_instance
        name: "% of Spend Reserved"
      - axisId: percent_of_spend_ondemand_instance
        id: percent_of_spend_ondemand_instance
        name: "% of Spend OnDemand"
      showLabels: true
      showValues: true
      valueFormat: "0%"
      unpinAxis: false
      tickDensity: default
      tickDensityCustom: 5
      type: linear
    series_types:
      percent_of_spend_reserved_instance: line
      percent_of_spend_ondemand_instance: line
    series_colors:
      "On-Demand - cur2.total_blended_cost": "#FF9900"
      "Reserved Instance - cur2.total_blended_cost": "#E8EAED"
      percent_of_spend_reserved_instance: "#4285F4"
      percent_of_spend_ondemand_instance: "#23223e"
    series_labels:
      "On-Demand - cur2.total_blended_cost": "Total Cost (OnDemand)"
      "Reserved Instance - cur2.total_blended_cost": "Total Cost (Reserved)"
      percent_of_spend_reserved_instance: "% of Spend Reserved"
      percent_of_spend_ondemand_instance: "% of Spend OnDemand"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 12
    col: 8
    width: 16
    height: 7

  # Section Header - COST BREAKDOWN DETAILS
  - name: "cost_breakdown_header"
    type: text
    title_text: "<b>COST BREAKDOWN DETAILS</b>"
    subtitle_text: ""
    body_text: ""
    row: 19
    col: 0
    width: 24
    height: 2

  # Non Affiliated Costs
  - title: "NON AFFILIATED COSTS"
    name: "non_affiliated_costs"
    model: aws_billing
    explore: cur2
    type: single_value
    fields:
    - cur2.total_blended_cost
    filters:
      cur2.line_item_resource_id: "NULL"
    limit: 20
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FF9900"
    value_format: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
    defaults_version: 1
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 21
    col: 0
    width: 4
    height: 7

  # Top Billed Resources
  - title: "TOP BILLED RESOURCES"
    name: "top_billed_resources"
    model: aws_billing
    explore: cur2
    type: looker_waterfall
    fields:
    - cur2.total_blended_cost
    - cur2.line_item_resource_id
    filters:
      cur2.line_item_resource_id: "-NULL"
    sorts:
    - cur2.total_blended_cost desc
    limit: 10
    column_limit: 50
    dynamic_fields:
    - _kind_hint: measure
      table_calculation: total_cost
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}+0"
      label: "Total Cost"
      value_format: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
      value_format_name: ""
    up_color: "#FF9900"
    down_color: false
    total_color: "#9AA0A6"
    show_value_labels: true
    show_x_axis_ticks: true
    show_x_axis_label: true
    x_axis_scale: auto
    show_y_axis_labels: false
    show_y_axis_ticks: false
    y_axis_gridlines: false
    color_application:
      collection_id: google
      palette_id: "google-categorical-0"
      options:
        steps: 5
    label_color:
    - white
    defaults_version: 1
    hidden_fields:
    - cur2.total_blended_cost
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 21
    col: 4
    width: 20
    height: 7

  # Usage Type Grid
  - title: "USAGE TYPE"
    name: "usage_type_grid"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.total_blended_cost
    - cur2.total_unblended_cost
    - cur2.line_item_usage_type
    - cur2.line_item_usage_start_quarter
    pivots:
    - cur2.line_item_usage_start_quarter
    filters:
      cur2.line_item_usage_start_date: "this quarter, last quarter"
    sorts:
    - cur2.total_blended_cost desc 0
    - cur2.line_item_usage_start_quarter
    limit: 10
    dynamic_fields:
    - _kind_hint: supermeasure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "pivot_index(${cur2.total_blended_cost}, 2)/pivot_index(${cur2.total_blended_cost}, 1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    - _kind_hint: measure
      table_calculation: average_cost_per_month
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/3"
      label: "Monthly Avg."
      value_format: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      value_format_name: ""
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: "10"
    rows_font_size: "10"
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: google
      palette_id: "google-categorical-0"
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      cur2.total_blended_cost: "Total Cost"
      cur2.total_unblended_cost: "Total Unblended Cost"
      average_cost_per_month: "Monthly Avg."
    series_column_widths: {}
    series_cell_visualizations:
      cur2.total_blended_cost:
        is_active: true
        palette:
          palette_id: "fd01fd1a-7713-dbe1-266f-9d58b0e32fc3"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: "111a0970-bbea-4ba8-795e-c9a726d409c8"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
    series_value_format:
      cur2.total_blended_cost: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      average_cost_per_month: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
    defaults_version: 1
    hidden_fields:
    - cur2.total_unblended_cost
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 28
    col: 0
    width: 12
    height: 5

  # Linked Accounts Grid
  - title: "LINKED ACCOUNTS"
    name: "linked_accounts_grid"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.total_blended_cost
    - cur2.total_unblended_cost
    - cur2.line_item_usage_account_id
    - cur2.line_item_usage_start_quarter
    pivots:
    - cur2.line_item_usage_start_quarter
    filters:
      cur2.line_item_usage_start_date: "this quarter, last quarter"
    sorts:
    - cur2.total_blended_cost desc 0
    - cur2.line_item_usage_start_quarter
    limit: 10
    dynamic_fields:
    - _kind_hint: supermeasure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "pivot_index(${cur2.total_blended_cost}, 2)/pivot_index(${cur2.total_blended_cost}, 1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    - _kind_hint: measure
      table_calculation: average_cost_per_month
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/3"
      label: "Monthly Avg."
      value_format: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      value_format_name: ""
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: "10"
    rows_font_size: "10"
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: google
      palette_id: "google-categorical-0"
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      cur2.line_item_usage_account_id: "Linked Account ID"
      cur2.total_blended_cost: "Total Cost"
      cur2.total_unblended_cost: "Total Unblended Cost"
      average_cost_per_month: "Monthly Avg."
    series_column_widths: {}
    series_cell_visualizations:
      cur2.total_blended_cost:
        is_active: true
        palette:
          palette_id: "fd01fd1a-7713-dbe1-266f-9d58b0e32fc3"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: "111a0970-bbea-4ba8-795e-c9a726d409c8"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
    series_value_format:
      cur2.total_blended_cost: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      average_cost_per_month: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
    defaults_version: 1
    hidden_fields:
    - cur2.total_unblended_cost
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 28
    col: 12
    width: 12
    height: 5

  # Availability Region Grid
  - title: "AVAILABILITY REGION"
    name: "availability_region_grid"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.total_blended_cost
    - cur2.total_unblended_cost
    - cur2.line_item_availability_zone
    - cur2.line_item_usage_start_quarter
    pivots:
    - cur2.line_item_usage_start_quarter
    filters:
      cur2.line_item_usage_start_date: "this quarter, last quarter"
      cur2.line_item_availability_zone: "-NULL"
    sorts:
    - cur2.total_blended_cost desc 0
    - cur2.line_item_usage_start_quarter
    limit: 10
    dynamic_fields:
    - _kind_hint: supermeasure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "pivot_index(${cur2.total_blended_cost}, 2)/pivot_index(${cur2.total_blended_cost}, 1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    - _kind_hint: measure
      table_calculation: average_cost_per_month
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/3"
      label: "Monthly Avg."
      value_format: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      value_format_name: ""
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: "10"
    rows_font_size: "10"
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: google
      palette_id: "google-categorical-0"
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      cur2.total_blended_cost: "Total Cost"
      cur2.total_unblended_cost: "Total Unblended Cost"
      average_cost_per_month: "Monthly Avg."
    series_column_widths: {}
    series_cell_visualizations:
      cur2.total_blended_cost:
        is_active: true
        palette:
          palette_id: "fd01fd1a-7713-dbe1-266f-9d58b0e32fc3"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: "111a0970-bbea-4ba8-795e-c9a726d409c8"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
    series_value_format:
      cur2.total_blended_cost: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      average_cost_per_month: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
    defaults_version: 1
    hidden_fields:
    - cur2.total_unblended_cost
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 33
    col: 0
    width: 12
    height: 5

  # Service Area Grid
  - title: "SERVICE AREA"
    name: "service_area_grid"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.total_blended_cost
    - cur2.total_unblended_cost
    - cur2.line_item_product_code
    - cur2.line_item_usage_start_quarter
    pivots:
    - cur2.line_item_usage_start_quarter
    filters:
      cur2.line_item_usage_start_date: "this quarter, last quarter"
    sorts:
    - cur2.total_blended_cost desc 0
    - cur2.line_item_usage_start_quarter
    limit: 10
    dynamic_fields:
    - _kind_hint: supermeasure
      table_calculation: change
      _type_hint: number
      category: table_calculation
      expression: "pivot_index(${cur2.total_blended_cost}, 2)/pivot_index(${cur2.total_blended_cost}, 1)-1"
      label: Change
      value_format: ""
      value_format_name: percent_1
    - _kind_hint: measure
      table_calculation: average_cost_per_month
      _type_hint: number
      category: table_calculation
      expression: "${cur2.total_blended_cost}/3"
      label: "Monthly Avg."
      value_format: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      value_format_name: ""
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: "10"
    rows_font_size: "10"
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: google
      palette_id: "google-categorical-0"
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      cur2.total_blended_cost: "Total Cost"
      cur2.total_unblended_cost: "Total Unblended Cost"
      average_cost_per_month: "Monthly Avg."
    series_column_widths: {}
    series_cell_visualizations:
      cur2.total_blended_cost:
        is_active: true
        palette:
          palette_id: "fd01fd1a-7713-dbe1-266f-9d58b0e32fc3"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
      cur2.total_unblended_cost:
        is_active: true
        palette:
          palette_id: "111a0970-bbea-4ba8-795e-c9a726d409c8"
          collection_id: google
          custom_colors:
          - "#ff9900"
          - "#146EB4"
          - "#e47911"
    series_value_format:
      cur2.total_blended_cost: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
      average_cost_per_month: "[<=1000000]$0.0,\"K\";$0.0,,\"M\""
    defaults_version: 1
    hidden_fields:
    - cur2.total_unblended_cost
    listen:
      "Usage Start Date": cur2.line_item_usage_start_date
      "Product Name": cur2.line_item_product_code
      "Resource ID": cur2.line_item_resource_id
    row: 33
    col: 12
    width: 12
    height: 5

  # Dashboard Filters (already defined at top level, but included here for reference)
  filters:
  - name: "Usage Start Date"
    title: "Usage Start Date"
    type: field_filter
    default_value: "365 day"
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: "Product Name"
    title: "Product Name"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_product_code

  - name: "Resource ID"
    title: "Resource ID"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_resource_id