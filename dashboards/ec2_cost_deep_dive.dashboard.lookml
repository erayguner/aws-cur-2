---
# =====================================================
# EC2 COST DEEP DIVE DASHBOARD
# =====================================================
# Comprehensive EC2 cost analysis and optimization dashboard
# Aligned with 2025 FinOps best practices for compute optimization
# =====================================================

- dashboard: ec2_cost_deep_dive
  title: "EC2 Cost Deep Dive"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive EC2 cost analysis including instance types, purchase options, rightsizing opportunities, and regional spend optimization"

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
  - name: section_header_summary
    type: text
    title_text: "<h2>EC2 Cost Summary</h2>"
    subtitle_text: "Executive overview of EC2 spending and key metrics"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total EC2 Spend"
    name: total_ec2_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
    limit: 1
    custom_color: "#FF9900"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL EC2 SPEND"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 0
    width: 4
    height: 4
  - title: "On-Demand Cost"
    name: on_demand_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.pricing_term: "OnDemand"
    limit: 1
    custom_color: "#146EB4"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ON-DEMAND COST"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 4
    width: 4
    height: 4
  - title: "Reserved Instance Cost"
    name: reserved_instance_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.pricing_term: "Reserved"
    limit: 1
    custom_color: "#E8EAED"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "RESERVED INSTANCE COST"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 8
    width: 4
    height: 4
  - title: "Spot Instance Cost"
    name: spot_instance_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.line_item_usage_type: "%SpotUsage%"
    limit: 1
    custom_color: "#48a3c6"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "SPOT INSTANCE COST"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 12
    width: 4
    height: 4
  - title: "Running Instances"
    name: running_instances
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.line_item_usage_type: "%BoxUsage%"
      cur2.line_item_resource_id: "-NULL"
    limit: 1
    custom_color: "#23223e"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "RUNNING INSTANCES"
      value_format: "#,##0"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 16
    width: 4
    height: 4
  - title: "Avg Cost Per Instance"
    name: avg_cost_per_instance
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.line_item_usage_type: "%BoxUsage%"
      cur2.line_item_resource_id: "-NULL"
    limit: 1
    dynamic_fields:
    - table_calculation: avg_cost
      label: Avg Cost
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      _type_hint: number
    custom_color: "#007eb9"
  # =====================================================
  # SECTION: PURCHASE OPTION DISTRIBUTION
  # =====================================================
    visualization_config:
        value_format: "$#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "AVG COST PER INSTANCE"
      value_format: "$#,##0.00"
      hidden_fields: [cur2.total_unblended_cost, cur2.count_unique_resources]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 20
    width: 4
    height: 4
  - name: section_header_purchase_options
    type: text
    title_text: "<h2>Purchase Option Distribution</h2>"
    subtitle_text: "On-Demand vs Reserved vs Spot usage patterns"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Purchase Option Distribution"
    name: purchase_option_pie
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.pricing_term, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.pricing_term: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: billing
        palette_id: "billing-categorical-0"
        options:
          steps: 5
      series_colors:
        "OnDemand": "#FF9900"
        "Reserved": "#E8EAED"
        "Spot": "#48a3c6"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 8
    col: 0
    width: 8
    height: 8
  - title: "Purchase Option Trend Over Time"
    name: purchase_option_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, cur2.pricing_term]
    pivots: [cur2.pricing_term]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.pricing_term: "-NULL"
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 500
  # =====================================================
  # SECTION: INSTANCE TYPE ANALYSIS
  # =====================================================
    visualization_config:
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
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
      show_null_points: true
      interpolation: linear
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
        - axisId: cur2.total_unblended_cost
          id: OnDemand - cur2.total_unblended_cost
          name: OnDemand
        - axisId: cur2.total_unblended_cost
          id: Reserved - cur2.total_unblended_cost
          name: Reserved
        - axisId: cur2.total_unblended_cost
          id: Spot - cur2.total_unblended_cost
          name: Spot
        showLabels: true
        showValues: true
        valueFormat: "$0,\"K\""
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        "OnDemand - cur2.total_unblended_cost": "#FF9900"
        "Reserved - cur2.total_unblended_cost": "#E8EAED"
        "Spot - cur2.total_unblended_cost": "#48a3c6"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 8
    col: 8
    width: 16
    height: 8
  - name: section_header_instance_types
    type: text
    title_text: "<h2>Instance Type Cost Breakdown</h2>"
    subtitle_text: "Detailed analysis by instance type and family"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Top 10 Instance Types by Cost"
    name: top_instance_types
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.product_instance_type, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_instance_type: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
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
        valueFormat: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_unblended_cost: "#FF9900"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 18
    col: 0
    width: 12
    height: 8
  - title: "Instance Family Distribution"
    name: instance_family_distribution
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_instance_family, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_instance_family: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
  # =====================================================
  # SECTION: INSTANCE TYPE DETAILS GRID
  # =====================================================
    visualization_config:
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
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
        valueFormat: "$0,\"K\""
        unpinAxis: false
        tickDensity: default
        type: linear
      - label: "Instance Count"
        orientation: right
        series:
        - axisId: cur2.count_unique_resources
          id: cur2.count_unique_resources
          name: Instance Count
        showLabels: true
        showValues: true
        valueFormat: "#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        cur2.count_unique_resources: line
      series_colors:
        cur2.total_unblended_cost: "#FF9900"
        cur2.count_unique_resources: "#146EB4"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 18
    col: 12
    width: 12
    height: 8
  - title: "Instance Type Details"
    name: instance_type_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_instance_type, cur2.product_instance_family, cur2.pricing_term,
             cur2.total_unblended_cost, cur2.line_item_usage_amount, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_instance_type: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: avg_hourly_cost
      label: Avg Hourly Cost
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
      _type_hint: number
    - table_calculation: cost_per_instance
      label: Cost Per Instance
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      _type_hint: number
  # =====================================================
  # SECTION: REGIONAL DISTRIBUTION
  # =====================================================
    visualization_config:
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
        value: 1000
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: true
        fields: [cur2.total_unblended_cost]
      - type: greater than
        value: 5
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: false
        fields: [avg_hourly_cost]
      series_value_format:
        cur2.total_unblended_cost: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
        cur2.line_item_usage_amount: "#,##0.0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 26
    col: 0
    width: 24
    height: 8
  - name: section_header_regional
    type: text
    title_text: "<h2>Regional EC2 Spend Distribution</h2>"
    subtitle_text: "Geographic distribution of EC2 costs"
    body_text: ""
    row: 34
    col: 0
    width: 24
    height: 2

  - title: "EC2 Cost by Region"
    name: ec2_cost_by_region
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_region_code, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_region_code: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    visualization_config:
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
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
        valueFormat: "$0,\"K\""
        unpinAxis: false
        tickDensity: default
        type: linear
      - label: "Instance Count"
        orientation: right
        series:
        - axisId: cur2.count_unique_resources
          id: cur2.count_unique_resources
          name: Instance Count
        showLabels: true
        showValues: true
        valueFormat: "#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        cur2.count_unique_resources: line
      series_colors:
        cur2.total_unblended_cost: "#FF9900"
        cur2.count_unique_resources: "#146EB4"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 36
    col: 0
    width: 16
    height: 8
  - title: "Regional Cost Distribution"
    name: regional_cost_pie
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_region_code, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_region_code: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
  # =====================================================
  # SECTION: RIGHTSIZING OPPORTUNITIES
  # =====================================================
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
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 36
    col: 16
    width: 8
    height: 8
  - name: section_header_rightsizing
    type: text
    title_text: "<h2>Rightsizing Opportunities</h2>"
    subtitle_text: "Identify underutilized instances and optimization opportunities"
    body_text: ""
    row: 44
    col: 0
    width: 24
    height: 2

  - title: "Rightsizing Recommendations"
    name: rightsizing_recommendations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.product_instance_type, cur2.product_region_code,
             cur2.line_item_usage_account_name, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.line_item_usage_type: "%BoxUsage%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: utilization_hours
      label: Utilization Hours
      expression: "${cur2.line_item_usage_amount}"
      _type_hint: number
    - table_calculation: monthly_cost
      label: Monthly Cost
      expression: "${cur2.total_unblended_cost}"
      _type_hint: number
    - table_calculation: recommendation
      label: Recommendation
      expression: "if(${utilization_hours} < 100, \"Consider Spot or Smaller Instance\", if(${utilization_hours} < 500, \"Review Utilization\", \"Optimized\"))"
      _type_hint: string
  # =====================================================
  # SECTION: EBS VOLUME COSTS
  # =====================================================
    visualization_config:
        value_format: "#,##0.0"
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
      - type: equal to
        value: "Consider Spot or Smaller Instance"
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
        fields: [recommendation]
      - type: equal to
        value: "Review Utilization"
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [recommendation]
      - type: equal to
        value: "Optimized"
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [recommendation]
      - type: greater than
        value: 100
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [cur2.total_unblended_cost]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.line_item_usage_amount: "#,##0.0"
      defaults_version: 1
      hidden_fields: [cur2.total_unblended_cost, cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Instance Type: cur2.product_instance_type
      Environment: cur2.resource_tags_user_environment
    row: 46
    col: 0
    width: 24
    height: 10
  - name: section_header_ebs
    type: text
    title_text: "<h2>EBS Volume Costs</h2>"
    subtitle_text: "Elastic Block Store volume cost analysis"
    body_text: ""
    row: 56
    col: 0
    width: 24
    height: 2

  - title: "EBS Volume Type Distribution"
    name: ebs_volume_type_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_volume_api_name, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_product_family: "Storage"
      cur2.product_volume_api_name: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    visualization_config:
      value_labels: legend
      label_type: labPer
      inner_radius: 50
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      series_colors:
        "gp2": "#FF9900"
        "gp3": "#146EB4"
        "io1": "#E8EAED"
        "io2": "#48a3c6"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Environment: cur2.resource_tags_user_environment
    row: 58
    col: 0
    width: 8
    height: 8
  - title: "EBS Cost by Volume Type"
    name: ebs_cost_by_volume_type
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_volume_api_name, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonEC2"
      cur2.product_product_family: "Storage"
      cur2.product_volume_api_name: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    dynamic_fields:
    - table_calculation: cost_per_gb
      label: Cost Per GB-Month
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
      _type_hint: number
  filters:
    visualization_config:
        value_format: "$#,##0.0000"
      x_axis_gridlines: false
      y_axis_gridlines: true
      show_view_names: false
      show_y_axis_labels: true
      show_y_axis_ticks: true
      y_axis_tick_density: default
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
        valueFormat: "$0,\"K\""
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.total_unblended_cost: "#FF9900"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount, cost_per_gb]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Environment: cur2.resource_tags_user_environment
    row: 58
    col: 8
    width: 16
    height: 8
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
  - name: Region
    title: "AWS Region"
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
    field: cur2.product_region_code
    note_text: "AWS Region visualization"
  - name: Instance Type
    title: "Instance Type"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.product_instance_type
    note_text: "Instance Type visualization"
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
    field: cur2.resource_tags_user_environment
    note_text: "Environment visualization"
