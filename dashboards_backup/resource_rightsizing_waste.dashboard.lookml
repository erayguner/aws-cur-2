---
# =====================================================
# RESOURCE RIGHTSIZING & WASTE REDUCTION DASHBOARD
# =====================================================
# Comprehensive dashboard for identifying and eliminating cloud waste
# Following 2025 FinOps best practices for resource optimization
# =====================================================

- dashboard: resource_rightsizing_waste
  title: "Resource Rightsizing & Waste Reduction"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Identify idle resources, underutilized instances, orphaned resources, and optimization opportunities aligned with 2025 FinOps Framework and AWS Well-Architected best practices"

  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
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
  # =====================================================
  # SECTION: WASTE DETECTION OVERVIEW
  # =====================================================

  - name: section_header_waste_overview
    type: text
    title_text: "<h2>Waste Detection Overview</h2>"
    subtitle_text: "Executive summary of cloud waste and optimization opportunities"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total Rightsizing Opportunity"
    name: rightsizing_opportunity_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "RIGHTSIZING OPPORTUNITY"
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 10000
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [5000, 10000]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: less than
      value: 5000
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 2
    col: 0
    width: 4
    height: 4

  - title: "Idle Resource Cost"
    name: idle_resource_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.total_usage_amount: "0"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "IDLE RESOURCE COST"
    value_format: "$#,##0"
    conditional_formatting:
    - type: less than
      value: 1000
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 5000
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 2
    col: 4
    width: 4
    height: 4

  - title: "Underutilized Resources Cost"
    name: underutilized_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.total_usage_amount: ">0,<10"
    limit: 1
    dynamic_fields:
    - table_calculation: potential_savings
      label: Potential Savings
      expression: "${cur2.total_unblended_cost} * 0.5"
      value_format: "$#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "UNDERUTILIZED COST"
    value_format: "$#,##0"
    conditional_formatting:
    - type: less than
      value: 2000
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 8000
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 2
    col: 8
    width: 4
    height: 4

  - title: "Idle Resource Count"
    name: idle_resource_count_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    filters:
      cur2.total_usage_amount: "0"
      cur2.line_item_resource_id: "-NULL"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "IDLE RESOURCES"
    value_format: "#,##0"
    conditional_formatting:
    - type: equal to
      value: 0
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 50
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 2
    col: 12
    width: 4
    height: 4

  - title: "Waste as % of Total Spend"
    name: waste_percentage_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.right_sizing_opportunity]
    limit: 1
    dynamic_fields:
    - table_calculation: waste_percentage
      label: Waste Percentage
      expression: "(${cur2.right_sizing_opportunity} / nullif(${cur2.total_unblended_cost}, 0)) * 100"
      value_format: "#,##0.0\"%\""
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "WASTE % OF TOTAL SPEND"
    value_format: "#,##0.0\"%\""
    conditional_formatting:
    - type: less than
      value: 5
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [5, 15]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: greater than
      value: 15
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 2
    col: 16
    width: 4
    height: 4

  - title: "Annual Waste Projection"
    name: annual_waste_projection_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.right_sizing_opportunity]
    limit: 1
    dynamic_fields:
    - table_calculation: annual_projection
      label: Annual Projection
      expression: "${cur2.right_sizing_opportunity} * 12"
      value_format: "$#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "ANNUAL WASTE PROJECTION"
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 100000
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 2
    col: 20
    width: 4
    height: 4

  # =====================================================
  # SECTION: IDLE RESOURCE DETECTION
  # =====================================================

  - name: section_header_idle_resources
    type: text
    title_text: "<h2>Idle Resource Detection</h2>"
    subtitle_text: "Resources with zero usage that should be terminated immediately"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Idle Resources by Service"
    name: idle_resources_by_service
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.total_usage_amount: "0"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
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
        name: Idle Cost
      showLabels: true
      showValues: true
      valueFormat: "$#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Resource Count"
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: Resource Count
      showLabels: true
      showValues: true
      valueFormat: "#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.count_unique_resources: line
    series_colors:
      cur2.total_unblended_cost: "#dc2626"
      cur2.count_unique_resources: "#1f77b4"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 8
    col: 0
    width: 12
    height: 8

  - title: "Idle Resources Detail"
    name: idle_resources_detail
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.line_item_usage_account_name,
             cur2.product_instance_type, cur2.line_item_availability_zone, cur2.total_unblended_cost,
             cur2.total_usage_amount, cur2.environment]
    filters:
      cur2.total_usage_amount: "0"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: recommended_action
      label: Recommended Action
      expression: "\"TERMINATE IMMEDIATELY\""
      _type_hint: string
    - table_calculation: monthly_savings
      label: Monthly Savings
      expression: "${cur2.total_unblended_cost}"
      value_format: "$#,##0.00"
      _type_hint: number
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
    - type: equal to
      value: "TERMINATE IMMEDIATELY"
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
      fields: [recommended_action]
    - type: greater than
      value: 100
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.total_unblended_cost]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
      cur2.total_usage_amount: "#,##0.000"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
      Waste Threshold: cur2.total_unblended_cost
    row: 8
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: UNDERUTILIZED RESOURCES
  # =====================================================

  - name: section_header_underutilized
    type: text
    title_text: "<h2>Underutilized Resource Recommendations</h2>"
    subtitle_text: "Resources with low utilization that can be rightsized or optimized"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Underutilization Distribution"
    name: underutilization_distribution
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_resource_id, cur2.total_usage_amount, cur2.total_unblended_cost, cur2.line_item_product_code]
    filters:
      cur2.total_usage_amount: ">0,<100"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 200
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
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    size_by_field: cur2.total_unblended_cost
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    x_axis_label: "Usage Amount"
    y_axis_labels: ["Cost"]
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 18
    col: 0
    width: 16
    height: 8

  - title: "Underutilized Resources by Account"
    name: underutilized_by_account
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_usage_account_name, cur2.total_unblended_cost]
    filters:
      cur2.total_usage_amount: ">0,<10"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
    row: 18
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: RIGHTSIZING RECOMMENDATIONS
  # =====================================================

  - name: section_header_rightsizing
    type: text
    title_text: "<h2>Rightsizing Recommendations</h2>"
    subtitle_text: "Detailed recommendations for instance rightsizing and optimization"
    body_text: ""
    row: 26
    col: 0
    width: 24
    height: 2

  - title: "Rightsizing Recommendations by Instance Type"
    name: rightsizing_by_instance_type
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_instance_type, cur2.product_instance_family, cur2.count_unique_resources,
             cur2.total_unblended_cost, cur2.total_usage_amount, cur2.right_sizing_opportunity]
    filters:
      cur2.service_category: "Compute"
      cur2.product_instance_type: "-NULL"
    sorts: [cur2.right_sizing_opportunity desc]
    limit: 30
    dynamic_fields:
    - table_calculation: avg_utilization
      label: Avg Utilization
      expression: "${cur2.total_usage_amount} / nullif(${cur2.count_unique_resources}, 0)"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: recommended_instance_type
      label: Recommended Instance Type
      expression: "case(when ${avg_utilization} < 10 then \"t3.micro\", when ${avg_utilization} < 50 then \"t3.small\", when ${avg_utilization} < 100 then \"t3.medium\", else \"Keep Current\")"
      _type_hint: string
    - table_calculation: savings_percentage
      label: Savings %
      expression: "(${cur2.right_sizing_opportunity} / nullif(${cur2.total_unblended_cost}, 0)) * 100"
      value_format: "#,##0.0\"%\""
      _type_hint: number
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
      value: 30
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [savings_percentage]
    - type: greater than
      value: 1000
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.right_sizing_opportunity]
    - type: not equal to
      value: "Keep Current"
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      fields: [recommended_instance_type]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
      cur2.total_usage_amount: "#,##0.00"
      cur2.right_sizing_opportunity: "$#,##0.00"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 28
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION: ORPHANED RESOURCES
  # =====================================================

  - name: section_header_orphaned
    type: text
    title_text: "<h2>Orphaned Resource Tracking</h2>"
    subtitle_text: "Identify resources that may be orphaned or abandoned"
    body_text: ""
    row: 38
    col: 0
    width: 24
    height: 2

  - title: "Potentially Orphaned Resources"
    name: orphaned_resources
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.line_item_usage_account_name,
             cur2.total_unblended_cost, cur2.has_tags, cur2.tag_count, cur2.total_usage_amount]
    filters:
      cur2.has_tags: "No"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: orphan_likelihood
      label: Orphan Likelihood
      expression: "case(when not ${cur2.has_tags} and ${cur2.total_usage_amount} = 0 then \"Very High\", when not ${cur2.has_tags} and ${cur2.total_usage_amount} < 5 then \"High\", when not ${cur2.has_tags} then \"Medium\", else \"Low\")"
      _type_hint: string
    - table_calculation: action_required
      label: Action Required
      expression: "case(when ${orphan_likelihood} = \"Very High\" then \"Terminate\", when ${orphan_likelihood} = \"High\" then \"Investigate & Tag\", else \"Tag\")"
      _type_hint: string
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
    - type: equal to
      value: "Very High"
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
      fields: [orphan_likelihood]
    - type: equal to
      value: "High"
      background_color: "#f59e0b"
      font_color: "#ffffff"
      bold: false
      fields: [orphan_likelihood]
    - type: equal to
      value: "Medium"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [orphan_likelihood]
    - type: equal to
      value: "Terminate"
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: true
      fields: [action_required]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
      cur2.total_usage_amount: "#,##0.000"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Environment: cur2.environment
      Waste Threshold: cur2.total_unblended_cost
    row: 40
    col: 0
    width: 24
    height: 10

  # =====================================================
  # SECTION: STORAGE OPTIMIZATION
  # =====================================================

  - name: section_header_storage
    type: text
    title_text: "<h2>Storage Optimization Opportunities</h2>"
    subtitle_text: "Identify opportunities for storage class optimization and cleanup"
    body_text: ""
    row: 50
    col: 0
    width: 24
    height: 2

  - title: "Storage Cost by Service"
    name: storage_cost_by_service
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.total_usage_amount]
    filters:
      cur2.service_category: "Storage"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: cost_per_gb
      label: Cost Per GB
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.total_usage_amount}, 0)"
      value_format: "$#,##0.0000"
      _type_hint: number
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
      cur2.total_unblended_cost: "#1f77b4"
    defaults_version: 1
    hidden_fields: [cur2.total_usage_amount, cost_per_gb]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 52
    col: 0
    width: 12
    height: 8

  - title: "Network & Data Transfer Waste"
    name: network_waste
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_usage_account_name, cur2.data_transfer_cost, cur2.data_transfer_gb]
    sorts: [cur2.data_transfer_cost desc]
    limit: 15
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
      - axisId: cur2.data_transfer_cost
        id: cur2.data_transfer_cost
        name: Data Transfer Cost
      showLabels: true
      showValues: true
      valueFormat: "$#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.data_transfer_cost: "#f59e0b"
    defaults_version: 1
    hidden_fields: [cur2.data_transfer_gb]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Environment: cur2.environment
    row: 52
    col: 12
    width: 12
    height: 8

  filters:
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

  - name: Waste Threshold
    title: "Minimum Waste Amount ($)"
    type: field_filter
    default_value: "100"
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

