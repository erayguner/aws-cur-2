---
# =====================================================
# LAMBDA SERVERLESS COST DASHBOARD
# =====================================================
# Comprehensive Lambda cost analysis and optimization dashboard
# Aligned with 2025 FinOps best practices for serverless optimization
# =====================================================

- dashboard: lambda_serverless_cost
  title: "Lambda Serverless Cost Analysis"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive Lambda cost analysis including function-level costs, memory optimization, execution duration, invocation patterns, and architecture comparison"

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
    title_text: "<h2>Lambda Cost Summary</h2>"
    subtitle_text: "Executive overview of Lambda serverless spending"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total Lambda Spend"
    name: total_lambda_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
    limit: 1
    custom_color: "#FF9900"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL LAMBDA SPEND"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 0
    width: 4
    height: 4
  - title: "Compute Cost"
    name: compute_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
    limit: 1
    custom_color: "#146EB4"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COMPUTE COST"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 4
    width: 4
    height: 4
  - title: "Request Cost"
    name: request_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Request%"
    limit: 1
    custom_color: "#E8EAED"
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "REQUEST COST"
      value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 8
    width: 4
    height: 4
  - title: "Total Invocations"
    name: total_invocations
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Request%"
    limit: 1
    dynamic_fields:
    - table_calculation: invocations_millions
      label: Invocations (M)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      _type_hint: number
    custom_color: "#48a3c6"
    visualization_config:
        value_format: "#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TOTAL INVOCATIONS (M)"
      value_format: "#,##0.00"
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 12
    width: 4
    height: 4
  - title: "GB-Seconds Used"
    name: gb_seconds_used
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
    limit: 1
    dynamic_fields:
    - table_calculation: gb_seconds_billions
      label: GB-Seconds (B)
      expression: "${cur2.line_item_usage_amount} / 1000000000"
      _type_hint: number
    custom_color: "#23223e"
    visualization_config:
        value_format: "#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "GB-SECONDS (B)"
      value_format: "#,##0.00"
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 16
    width: 4
    height: 4
  - title: "Avg Cost Per Million Invocations"
    name: avg_cost_per_million
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Request%"
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_million
      label: Cost Per Million
      expression: "(${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)) * 1000000"
      _type_hint: number
    custom_color: "#007eb9"
  # =====================================================
  # SECTION: COST BREAKDOWN
  # =====================================================
    visualization_config:
        value_format: "$#,##0.00"
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COST PER MILLION INVOCATIONS"
      value_format: "$#,##0.00"
      hidden_fields: [cur2.total_unblended_cost, cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 2
    col: 20
    width: 4
    height: 4
  - name: section_header_cost_breakdown
    type: text
    title_text: "<h2>Lambda Cost Breakdown</h2>"
    subtitle_text: "Detailed cost analysis by cost type"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Cost Type Distribution"
    name: cost_type_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_usage_type, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
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
        "Lambda-GB-Second": "#FF9900"
        "Request": "#146EB4"
        "Lambda-Edge-GB-Second": "#E8EAED"
        "Lambda-Edge-Request": "#48a3c6"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 8
    col: 0
    width: 8
    height: 8
  - title: "Lambda Cost Trend Over Time"
    name: lambda_cost_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, cur2.line_item_usage_type]
    pivots: [cur2.line_item_usage_type]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AWSLambda"
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 500
  # =====================================================
  # SECTION: FUNCTION-LEVEL ANALYSIS
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
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: ""
        orientation: left
        series:
        - axisId: cur2.total_unblended_cost
          id: Lambda-GB-Second - cur2.total_unblended_cost
          name: Compute Cost
        - axisId: cur2.total_unblended_cost
          id: Request - cur2.total_unblended_cost
          name: Request Cost
        showLabels: true
        showValues: true
        valueFormat: "$0,\"K\""
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 8
    col: 8
    width: 16
    height: 8
  - name: section_header_function_level
    type: text
    title_text: "<h2>Function-Level Cost Breakdown</h2>"
    subtitle_text: "Top Lambda functions by cost"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Top 20 Functions by Cost"
    name: top_functions_by_cost
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_resource_id, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_resource_id: "-NULL"
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
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 18
    col: 0
    width: 12
    height: 10
  - title: "Function Cost Details"
    name: function_cost_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.product_region_code, cur2.total_unblended_cost,
             cur2.line_item_usage_amount, cur2.line_item_usage_type]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: usage_metric
      label: Usage Metric
      expression: "if(contains(${cur2.line_item_usage_type}, \"Request\"), ${cur2.line_item_usage_amount} / 1000000, ${cur2.line_item_usage_amount})"
      _type_hint: number
    - table_calculation: unit
      label: Unit
      expression: "if(contains(${cur2.line_item_usage_type}, \"Request\"), \"M Requests\", \"GB-Seconds\")"
      _type_hint: string
  # =====================================================
  # SECTION: MEMORY OPTIMIZATION
  # =====================================================
    visualization_config:
        value_format: "#,##0.00"
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
        value: 100
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: false
        fields: [usage_metric]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 18
    col: 12
    width: 12
    height: 10
  - name: section_header_memory_optimization
    type: text
    title_text: "<h2>Memory Allocation Optimization</h2>"
    subtitle_text: "Analyze memory allocation efficiency and optimization opportunities"
    body_text: ""
    row: 28
    col: 0
    width: 24
    height: 2

  - title: "Cost by Memory Allocation"
    name: cost_by_memory
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_group, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
      cur2.product_group: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: memory_mb
      label: Memory (MB)
      expression: "if(contains(${cur2.product_group}, \"Lambda\"), extract_numbers(${cur2.product_group}), null)"
      _type_hint: number
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
      series_colors:
        cur2.total_unblended_cost: "#FF9900"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount, memory_mb]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 30
    col: 0
    width: 16
    height: 8
  - title: "Memory Allocation Summary"
    name: memory_allocation_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_group, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
      cur2.product_group: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: gb_seconds
      label: GB-Seconds (M)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      _type_hint: number
    - table_calculation: cost_per_gb_second
      label: Cost Per GB-Second
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
      _type_hint: number
  # =====================================================
  # SECTION: EXECUTION DURATION ANALYSIS
  # =====================================================
    visualization_config:
        value_format: "#,##0.00"
        value_format: "$#,##0.000000"
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
        value: 0.000020
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
        fields: [cost_per_gb_second]
      - type: between
        value: [0.000015, 0.000020]
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [cost_per_gb_second]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 30
    col: 16
    width: 8
    height: 8
  - name: section_header_execution_duration
    type: text
    title_text: "<h2>Execution Duration Analysis</h2>"
    subtitle_text: "Analyze function execution patterns and duration efficiency"
    body_text: ""
    row: 38
    col: 0
    width: 24
    height: 2

  - title: "Execution Duration Distribution"
    name: execution_duration_distribution
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_resource_id, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 100
    dynamic_fields:
    - table_calculation: gb_seconds
      label: GB-Seconds
      expression: "${cur2.line_item_usage_amount}"
      _type_hint: number
    size_by_field: cur2.total_unblended_cost
    y_axis_labels: ["Cost"]
    visualization_config:
        value_format: "#,##0"
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
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      x_axis_label: "GB-Seconds"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 40
    col: 0
    width: 16
    height: 8
  - title: "Top Functions by Duration"
    name: top_functions_by_duration
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.line_item_usage_amount desc]
    limit: 30
    dynamic_fields:
    - table_calculation: gb_seconds
      label: GB-Seconds
      expression: "${cur2.line_item_usage_amount}"
      _type_hint: number
    - table_calculation: optimization_score
      label: Optimization Score
      expression: "if(${cur2.total_unblended_cost} > 100 and ${gb_seconds} > 1000000, \"High Priority\", if(${cur2.total_unblended_cost} > 50, \"Medium Priority\", \"Low Priority\"))"
      _type_hint: string
  # =====================================================
  # SECTION: INVOCATION PATTERNS
  # =====================================================
    visualization_config:
        value_format: "#,##0.00"
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
        value: "High Priority"
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
        fields: [optimization_score]
      - type: equal to
        value: "Medium Priority"
        background_color: "#fef3c7"
        font_color: "#92400e"
        bold: false
        fields: [optimization_score]
      - type: equal to
        value: "Low Priority"
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: false
        fields: [optimization_score]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 40
    col: 16
    width: 8
    height: 8
  - name: section_header_invocation_patterns
    type: text
    title_text: "<h2>Invocation Patterns Analysis</h2>"
    subtitle_text: "Understand function invocation patterns and frequency"
    body_text: ""
    row: 48
    col: 0
    width: 24
    height: 2

  - title: "Invocation Trend Over Time"
    name: invocation_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.line_item_usage_amount]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Request%"
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 500
    dynamic_fields:
    - table_calculation: invocations_millions
      label: Invocations (M)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      _type_hint: number
    visualization_config:
        value_format: "#,##0.00"
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
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: "Invocations (M)"
        orientation: left
        series:
        - axisId: invocations_millions
          id: invocations_millions
          name: Invocations (M)
        showLabels: true
        showValues: true
        valueFormat: "#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        invocations_millions: "#FF9900"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 50
    col: 0
    width: 16
    height: 8
  - title: "Top Functions by Invocations"
    name: top_functions_by_invocations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_usage_amount, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Request%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.line_item_usage_amount desc]
    limit: 30
    dynamic_fields:
    - table_calculation: invocations_millions
      label: Invocations (M)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      _type_hint: number
    - table_calculation: cost_per_million
      label: Cost Per Million
      expression: "(${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)) * 1000000"
      _type_hint: number
  # =====================================================
  # SECTION: ARCHITECTURE COMPARISON (x86 vs ARM)
  # =====================================================
    visualization_config:
        value_format: "#,##0.00"
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
        value: 100
        background_color: "#e0f2fe"
        font_color: "#075985"
        bold: false
        fields: [invocations_millions]
      - type: greater than
        value: 1
        background_color: "#fee2e2"
        font_color: "#991b1b"
        bold: true
        fields: [cost_per_million]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 50
    col: 16
    width: 8
    height: 8
  - name: section_header_architecture
    type: text
    title_text: "<h2>Architecture Cost Comparison</h2>"
    subtitle_text: "Compare costs between x86 and ARM (Graviton2) architectures"
    body_text: ""
    row: 58
    col: 0
    width: 24
    height: 2

  - title: "Cost by Architecture"
    name: cost_by_architecture
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_processor_features, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.product_processor_features: "-NULL"
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
        "x86": "#FF9900"
        "ARM": "#146EB4"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 60
    col: 0
    width: 8
    height: 8
  - title: "Architecture Cost Comparison"
    name: architecture_comparison
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_processor_features, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.line_item_usage_type: "%Lambda-GB-Second%"
      cur2.product_processor_features: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    dynamic_fields:
    - table_calculation: gb_seconds
      label: GB-Seconds (M)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      _type_hint: number
    - table_calculation: cost_per_gb_second
      label: Cost Per GB-Second
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
      _type_hint: number
    - table_calculation: potential_arm_savings
      label: Potential ARM Savings (20%)
      expression: "if(${cur2.product_processor_features} = \"x86\", ${cur2.total_unblended_cost} * 0.20, 0)"
      _type_hint: number
  # =====================================================
  # SECTION: REGIONAL DISTRIBUTION
  # =====================================================
    visualization_config:
        value_format: "#,##0.00"
        value_format: "$#,##0.000000"
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
        value: 0
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [potential_arm_savings]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
      defaults_version: 1
      hidden_fields: [cur2.line_item_usage_amount]
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 60
    col: 8
    width: 16
    height: 8
  - name: section_header_regional
    type: text
    title_text: "<h2>Regional Cost Distribution</h2>"
    subtitle_text: "Lambda costs across different AWS regions"
    body_text: ""
    row: 68
    col: 0
    width: 24
    height: 2

  - title: "Lambda Cost by Region"
    name: lambda_cost_by_region
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_region_code, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
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
      series_colors:
        cur2.total_unblended_cost: "#FF9900"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 70
    col: 0
    width: 16
    height: 8
  - title: "Regional Distribution Pie"
    name: regional_distribution_pie
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_region_code, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AWSLambda"
      cur2.product_region_code: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
  filters:
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
      Function Name: cur2.resource_tags_user_function_name
      Environment: cur2.resource_tags_user_environment
    row: 70
    col: 16
    width: 8
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
  - name: Function Name
    title: "Function Name"
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
    field: cur2.resource_tags_user_function_name
    note_text: "Function Name visualization"
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
