---
# =====================================================
# S3 STORAGE OPTIMIZATION DASHBOARD
# =====================================================
# Comprehensive S3 cost analysis and optimization dashboard
# Aligned with 2025 FinOps best practices for storage optimization
# =====================================================

- dashboard: s3_storage_optimization
  title: "S3 Storage Optimization"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive S3 storage analysis including storage class distribution, lifecycle policies, data transfer costs, and optimization recommendations"

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

  - name: Storage Class
    title: "Storage Class"
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
    field: cur2.product_storage_class

  - name: Bucket Name
    title: "Bucket Name"
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
    field: cur2.resource_tags_user_bucket

  elements:
  # =====================================================
  # SECTION: EXECUTIVE SUMMARY - KPI TILES
  # =====================================================

  - name: section_header_summary
    type: text
    title_text: "<h2>S3 Cost Summary</h2>"
    subtitle_text: "Executive overview of S3 storage spending"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total S3 Spend"
    name: total_s3_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TOTAL S3 SPEND"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#FF9900"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 2
    col: 0
    width: 4
    height: 4

  - title: "Storage Cost"
    name: storage_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "STORAGE COST"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#146EB4"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 2
    col: 4
    width: 4
    height: 4

  - title: "Data Transfer Cost"
    name: data_transfer_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Data Transfer"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "DATA TRANSFER COST"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#E8EAED"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 2
    col: 8
    width: 4
    height: 4

  - title: "API Request Cost"
    name: api_request_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.line_item_usage_type: "%Requests%"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "API REQUEST COST"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#48a3c6"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 2
    col: 12
    width: 4
    height: 4

  - title: "Total Storage (TB)"
    name: total_storage_tb
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
    limit: 1
    dynamic_fields:
    - table_calculation: storage_tb
      label: Storage TB
      expression: "${cur2.line_item_usage_amount} / 1000000"
      value_format: "#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TOTAL STORAGE (TB)"
    value_format: "#,##0.00"
    custom_color: "#23223e"
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 2
    col: 16
    width: 4
    height: 4

  - title: "Avg Cost Per TB"
    name: avg_cost_per_tb
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
    limit: 1
    dynamic_fields:
    - table_calculation: cost_per_tb
      label: Cost Per TB
      expression: "${cur2.total_unblended_cost} / (${cur2.line_item_usage_amount} / 1000000)"
      value_format: "$#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "AVG COST PER TB"
    value_format: "$#,##0.00"
    custom_color: "#007eb9"
    hidden_fields: [cur2.total_unblended_cost, cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 2
    col: 20
    width: 4
    height: 4

  # =====================================================
  # SECTION: STORAGE CLASS DISTRIBUTION
  # =====================================================

  - name: section_header_storage_classes
    type: text
    title_text: "<h2>Storage Class Distribution</h2>"
    subtitle_text: "Analysis of storage costs across different S3 storage classes"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Storage Class Cost Distribution"
    name: storage_class_pie
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_storage_class, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
      cur2.product_storage_class: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      "Standard": "#FF9900"
      "Intelligent-Tiering": "#146EB4"
      "Standard-IA": "#E8EAED"
      "One Zone-IA": "#48a3c6"
      "Glacier": "#23223e"
      "Glacier Deep Archive": "#007eb9"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 8
    col: 0
    width: 8
    height: 8

  - title: "Storage Class Trend Over Time"
    name: storage_class_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, cur2.product_storage_class]
    pivots: [cur2.product_storage_class]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
      cur2.product_storage_class: "-NULL"
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 500
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
        id: Standard - cur2.total_unblended_cost
        name: Standard
      - axisId: cur2.total_unblended_cost
        id: Intelligent-Tiering - cur2.total_unblended_cost
        name: Intelligent-Tiering
      - axisId: cur2.total_unblended_cost
        id: Standard-IA - cur2.total_unblended_cost
        name: Standard-IA
      showLabels: true
      showValues: true
      valueFormat: "$0,\"K\""
      unpinAxis: false
      tickDensity: default
      type: linear
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 8
    col: 8
    width: 16
    height: 8

  # =====================================================
  # SECTION: STORAGE CLASS ANALYSIS GRID
  # =====================================================

  - title: "Storage Class Analysis"
    name: storage_class_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_storage_class, cur2.total_unblended_cost, cur2.line_item_usage_amount,
             cur2.product_region_code]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
      cur2.product_storage_class: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: storage_gb
      label: Storage (GB)
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: cost_per_gb
      label: Cost Per GB
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
      value_format: "$#,##0.0000"
      _type_hint: number
    - table_calculation: cost_percentage
      label: Cost %
      expression: "${cur2.total_unblended_cost} / sum(${cur2.total_unblended_cost})"
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
      value: 0.05
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      fields: [cost_per_gb]
    - type: between
      value: [0.02, 0.05]
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      fields: [cost_per_gb]
    - type: less than
      value: 0.02
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: false
      fields: [cost_per_gb]
    series_value_format:
      cur2.total_unblended_cost: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 16
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION: BUCKET-LEVEL ANALYSIS
  # =====================================================

  - name: section_header_buckets
    type: text
    title_text: "<h2>Bucket-Level Cost Analysis</h2>"
    subtitle_text: "Detailed cost breakdown by S3 bucket"
    body_text: ""
    row: 24
    col: 0
    width: 24
    height: 2

  - title: "Top 15 Buckets by Cost"
    name: top_buckets_by_cost
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.resource_tags_user_bucket, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.resource_tags_user_bucket: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 26
    col: 0
    width: 12
    height: 8

  - title: "Bucket Cost Details"
    name: bucket_cost_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.resource_tags_user_bucket, cur2.product_region_code, cur2.total_unblended_cost,
             cur2.line_item_usage_amount, cur2.product_storage_class]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.resource_tags_user_bucket: "-NULL"
      cur2.product_product_family: "Storage"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: storage_tb
      label: Storage (TB)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: monthly_cost
      label: Monthly Cost
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
    - type: greater than
      value: 1000
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 10
      background_color: "#e0f2fe"
      font_color: "#075985"
      bold: false
      fields: [storage_tb]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount, cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 26
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: DATA TRANSFER ANALYSIS
  # =====================================================

  - name: section_header_data_transfer
    type: text
    title_text: "<h2>Data Transfer Cost Analysis</h2>"
    subtitle_text: "Analysis of data transfer costs and patterns"
    body_text: ""
    row: 34
    col: 0
    width: 24
    height: 2

  - title: "Data Transfer Cost by Type"
    name: data_transfer_by_type
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_type, cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Data Transfer"
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
    dynamic_fields:
    - table_calculation: data_transfer_gb
      label: Data Transfer (GB)
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: cost_per_gb
      label: Cost Per GB
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
      value_format: "$#,##0.0000"
      _type_hint: number
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
    - label: "Data Transfer (GB)"
      orientation: right
      series:
      - axisId: data_transfer_gb
        id: data_transfer_gb
        name: Data Transfer (GB)
      showLabels: true
      showValues: true
      valueFormat: "#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      data_transfer_gb: line
    series_colors:
      cur2.total_unblended_cost: "#FF9900"
      data_transfer_gb: "#146EB4"
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount, cost_per_gb]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Bucket Name: cur2.resource_tags_user_bucket
    row: 36
    col: 0
    width: 16
    height: 8

  - title: "Data Transfer Cost Trend"
    name: data_transfer_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Data Transfer"
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 500
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Bucket Name: cur2.resource_tags_user_bucket
    row: 36
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: API REQUEST ANALYSIS
  # =====================================================

  - name: section_header_api_requests
    type: text
    title_text: "<h2>API Request Cost Analysis</h2>"
    subtitle_text: "Analysis of S3 API request costs and patterns"
    body_text: ""
    row: 44
    col: 0
    width: 24
    height: 2

  - title: "API Request Cost by Type"
    name: api_request_cost_by_type
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_operation, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.line_item_usage_type: "%Requests%"
      cur2.line_item_operation: "-NULL"
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
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 46
    col: 0
    width: 8
    height: 8

  - title: "API Request Details"
    name: api_request_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_operation, cur2.total_unblended_cost, cur2.line_item_usage_amount,
             cur2.product_region_code]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.line_item_usage_type: "%Requests%"
      cur2.line_item_operation: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 30
    dynamic_fields:
    - table_calculation: request_count
      label: Request Count
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: cost_per_1k_requests
      label: Cost Per 1K Requests
      expression: "(${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)) * 1000"
      value_format: "$#,##0.0000"
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
      value: 100
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 0.01
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: false
      fields: [cost_per_1k_requests]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 46
    col: 8
    width: 16
    height: 8

  # =====================================================
  # SECTION: STORAGE GROWTH TRENDS
  # =====================================================

  - name: section_header_storage_growth
    type: text
    title_text: "<h2>Storage Growth Trends</h2>"
    subtitle_text: "Track storage growth patterns over time"
    body_text: ""
    row: 54
    col: 0
    width: 24
    height: 2

  - title: "Storage Growth by Class"
    name: storage_growth_by_class
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.line_item_usage_amount, cur2.product_storage_class]
    pivots: [cur2.product_storage_class]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
      cur2.product_storage_class: "-NULL"
    sorts: [cur2.line_item_usage_start_date desc]
    limit: 500
    dynamic_fields:
    - table_calculation: storage_tb
      label: Storage (TB)
      expression: "${cur2.line_item_usage_amount} / 1000000"
      value_format: "#,##0.00"
      _type_hint: number
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
    - label: "Storage (TB)"
      orientation: left
      series:
      - axisId: storage_tb
        id: Standard - storage_tb
        name: Standard
      - axisId: storage_tb
        id: Intelligent-Tiering - storage_tb
        name: Intelligent-Tiering
      showLabels: true
      showValues: true
      valueFormat: "#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 56
    col: 0
    width: 16
    height: 8

  - title: "Cost Growth Trend"
    name: cost_growth_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost]
    fill_fields: [cur2.line_item_usage_start_month]
    filters:
      cur2.line_item_product_code: "AmazonS3"
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
    dynamic_fields:
    - table_calculation: mom_growth
      label: MoM Growth %
      expression: "(${cur2.total_unblended_cost} - offset(${cur2.total_unblended_cost}, 1)) / nullif(offset(${cur2.total_unblended_cost}, 1), 0)"
      value_format: "#,##0.0\"%\""
      _type_hint: number
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
    point_style: circle
    show_value_labels: true
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
      valueFormat: "$0,\"K\""
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "MoM Growth %"
      orientation: right
      series:
      - axisId: mom_growth
        id: mom_growth
        name: MoM Growth %
      showLabels: true
      showValues: true
      valueFormat: "#,##0.0\"%\""
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      mom_growth: column
    series_colors:
      cur2.total_unblended_cost: "#FF9900"
      mom_growth: "#146EB4"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Storage Class: cur2.product_storage_class
      Bucket Name: cur2.resource_tags_user_bucket
    row: 56
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: OPTIMIZATION RECOMMENDATIONS
  # =====================================================

  - name: section_header_optimization
    type: text
    title_text: "<h2>Optimization Recommendations</h2>"
    subtitle_text: "Actionable recommendations to reduce S3 costs"
    body_text: ""
    row: 64
    col: 0
    width: 24
    height: 2

  - title: "Storage Class Optimization Opportunities"
    name: optimization_opportunities
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.resource_tags_user_bucket, cur2.product_storage_class, cur2.total_unblended_cost,
             cur2.line_item_usage_amount, cur2.product_region_code]
    filters:
      cur2.line_item_product_code: "AmazonS3"
      cur2.product_product_family: "Storage"
      cur2.product_storage_class: "Standard"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: storage_gb
      label: Storage (GB)
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: potential_savings_ia
      label: Potential Savings (IA)
      expression: "${cur2.total_unblended_cost} * 0.45"
      value_format: "$#,##0.00"
      _type_hint: number
    - table_calculation: potential_savings_glacier
      label: Potential Savings (Glacier)
      expression: "${cur2.total_unblended_cost} * 0.80"
      value_format: "$#,##0.00"
      _type_hint: number
    - table_calculation: recommendation
      label: Recommendation
      expression: "if(${storage_gb} > 100000, \"Consider Intelligent-Tiering or Glacier for archival data\", if(${storage_gb} > 10000, \"Review access patterns for IA eligibility\", \"Monitor growth\"))"
      _type_hint: string
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
      value: 500
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [potential_savings_ia, potential_savings_glacier]
    - type: contains
      value: "Intelligent-Tiering"
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      fields: [recommendation]
    - type: contains
      value: "Review access"
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      fields: [recommendation]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Bucket Name: cur2.resource_tags_user_bucket
    row: 66
    col: 0
    width: 24
    height: 10
