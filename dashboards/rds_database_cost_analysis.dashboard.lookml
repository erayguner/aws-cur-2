---
# =====================================================
# RDS DATABASE COST ANALYSIS DASHBOARD
# =====================================================
# Comprehensive RDS cost analysis and optimization dashboard
# Aligned with 2025 FinOps best practices for database optimization
# =====================================================

- dashboard: rds_database_cost_analysis
  title: "RDS Database Cost Analysis"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Comprehensive RDS cost analysis including database engines, instance types, storage, Multi-AZ deployments, and optimization recommendations"

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

  - name: Database Engine
    title: "Database Engine"
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
    field: cur2.product_database_engine

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

  elements:
  # =====================================================
  # SECTION: EXECUTIVE SUMMARY - KPI TILES
  # =====================================================

  - name: section_header_summary
    type: text
    title_text: "<h2>RDS Cost Summary</h2>"
    subtitle_text: "Executive overview of RDS database spending"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Total RDS Spend"
    name: total_rds_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TOTAL RDS SPEND"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#FF9900"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 2
    col: 0
    width: 4
    height: 4

  - title: "Instance Cost"
    name: instance_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "INSTANCE COST"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#146EB4"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 2
    col: 4
    width: 4
    height: 4

  - title: "Storage Cost"
    name: storage_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Storage"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "STORAGE COST"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#E8EAED"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 2
    col: 8
    width: 4
    height: 4

  - title: "Backup/Snapshot Cost"
    name: backup_snapshot_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%BackupUsage%,%SnapshotUsage%"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "BACKUP/SNAPSHOT COST"
    value_format: "[>=1000000]$0.00,,\"M\";$0.00,\"K\""
    custom_color: "#48a3c6"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 2
    col: 12
    width: 4
    height: 4

  - title: "Running Databases"
    name: running_databases
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.line_item_resource_id: "-NULL"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "RUNNING DATABASES"
    value_format: "#,##0"
    custom_color: "#23223e"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 2
    col: 16
    width: 4
    height: 4

  - title: "Avg Cost Per Database"
    name: avg_cost_per_database
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.line_item_resource_id: "-NULL"
    limit: 1
    dynamic_fields:
    - table_calculation: avg_cost
      label: Avg Cost
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      value_format: "$#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "AVG COST PER DATABASE"
    value_format: "$#,##0.00"
    custom_color: "#007eb9"
    hidden_fields: [cur2.total_unblended_cost, cur2.count_unique_resources]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 2
    col: 20
    width: 4
    height: 4

  # =====================================================
  # SECTION: DATABASE ENGINE ANALYSIS
  # =====================================================

  - name: section_header_engines
    type: text
    title_text: "<h2>Database Engine Cost Breakdown</h2>"
    subtitle_text: "Cost analysis by database engine type"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Cost by Database Engine"
    name: cost_by_engine
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_database_engine, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_database_engine: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      "MySQL": "#FF9900"
      "PostgreSQL": "#146EB4"
      "Aurora MySQL": "#E8EAED"
      "Aurora PostgreSQL": "#48a3c6"
      "MariaDB": "#23223e"
      "Oracle": "#007eb9"
      "SQL Server": "#e47911"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 8
    col: 0
    width: 8
    height: 8

  - title: "Database Engine Trend"
    name: database_engine_trend
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost, cur2.product_database_engine]
    pivots: [cur2.product_database_engine]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_database_engine: "-NULL"
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
        id: MySQL - cur2.total_unblended_cost
        name: MySQL
      - axisId: cur2.total_unblended_cost
        id: PostgreSQL - cur2.total_unblended_cost
        name: PostgreSQL
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
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 8
    col: 8
    width: 16
    height: 8

  # =====================================================
  # SECTION: ENGINE DETAILS GRID
  # =====================================================

  - title: "Database Engine Cost Details"
    name: engine_cost_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_database_engine, cur2.total_unblended_cost, cur2.line_item_usage_amount,
             cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.product_database_engine: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 20
    dynamic_fields:
    - table_calculation: usage_hours
      label: Usage Hours
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0.0"
      _type_hint: number
    - table_calculation: avg_cost_per_instance
      label: Avg Cost Per Instance
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
      value_format: "$#,##0.00"
      _type_hint: number
    - table_calculation: hourly_rate
      label: Avg Hourly Rate
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
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
      value: 5000
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 5
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: false
      fields: [hourly_rate]
    series_value_format:
      cur2.total_unblended_cost: "[>=1000000]$0.0,,\"M\";$0.0,\"K\""
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 16
    col: 0
    width: 24
    height: 8

  # =====================================================
  # SECTION: INSTANCE TYPE ANALYSIS
  # =====================================================

  - name: section_header_instance_types
    type: text
    title_text: "<h2>Instance Type Cost Breakdown</h2>"
    subtitle_text: "Detailed analysis by RDS instance type"
    body_text: ""
    row: 24
    col: 0
    width: 24
    height: 2

  - title: "Top Instance Types by Cost"
    name: top_instance_types
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.product_instance_type, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.product_instance_type: "-NULL"
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
    hidden_fields: [cur2.count_unique_resources]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 26
    col: 0
    width: 12
    height: 8

  - title: "Instance Type Distribution"
    name: instance_type_distribution
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_instance_type, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.product_instance_type: "-NULL"
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 26
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: MULTI-AZ ANALYSIS
  # =====================================================

  - name: section_header_multi_az
    type: text
    title_text: "<h2>Multi-AZ vs Single-AZ Cost Analysis</h2>"
    subtitle_text: "Compare costs for highly available deployments"
    body_text: ""
    row: 34
    col: 0
    width: 24
    height: 2

  - title: "Multi-AZ vs Single-AZ Distribution"
    name: multi_az_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_deployment_option, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.product_deployment_option: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      "Multi-AZ": "#FF9900"
      "Single-AZ": "#146EB4"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 36
    col: 0
    width: 8
    height: 8

  - title: "Multi-AZ Cost Details by Engine"
    name: multi_az_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_database_engine, cur2.product_deployment_option, cur2.total_unblended_cost,
             cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Instance"
      cur2.product_deployment_option: "-NULL"
      cur2.product_database_engine: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: cost_per_instance
      label: Cost Per Instance
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.count_unique_resources}, 0)"
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
      value: "Multi-AZ"
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      fields: [cur2.product_deployment_option]
    - type: greater than
      value: 1000
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      fields: [cur2.total_unblended_cost]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
      Instance Type: cur2.product_instance_type
    row: 36
    col: 8
    width: 16
    height: 8

  # =====================================================
  # SECTION: STORAGE TYPE ANALYSIS
  # =====================================================

  - name: section_header_storage
    type: text
    title_text: "<h2>Storage Type Cost Analysis</h2>"
    subtitle_text: "Compare costs across different storage types (GP2, GP3, io1, io2)"
    body_text: ""
    row: 44
    col: 0
    width: 24
    height: 2

  - title: "Storage Type Distribution"
    name: storage_type_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.product_volume_type, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Storage"
      cur2.product_volume_type: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      "General Purpose-Aurora": "#FF9900"
      "General Purpose (SSD)": "#146EB4"
      "Provisioned IOPS": "#E8EAED"
      "Magnetic": "#48a3c6"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 46
    col: 0
    width: 8
    height: 8

  - title: "Storage Cost by Type and Engine"
    name: storage_cost_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.product_database_engine, cur2.product_volume_type, cur2.total_unblended_cost,
             cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.product_product_family: "Database Storage"
      cur2.product_volume_type: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: storage_gb
      label: Storage (GB)
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: cost_per_gb
      label: Cost Per GB-Month
      expression: "${cur2.total_unblended_cost} / nullif(${cur2.line_item_usage_amount}, 0)"
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
      value: 0.2
      background_color: "#fee2e2"
      font_color: "#991b1b"
      bold: true
      fields: [cost_per_gb]
    - type: between
      value: [0.1, 0.2]
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      fields: [cost_per_gb]
    - type: less than
      value: 0.1
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: false
      fields: [cost_per_gb]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 46
    col: 8
    width: 16
    height: 8

  # =====================================================
  # SECTION: BACKUP AND SNAPSHOT COSTS
  # =====================================================

  - name: section_header_backup
    type: text
    title_text: "<h2>Backup and Snapshot Cost Analysis</h2>"
    subtitle_text: "Track backup and snapshot storage costs"
    body_text: ""
    row: 54
    col: 0
    width: 24
    height: 2

  - title: "Backup Cost Trend"
    name: backup_cost_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%BackupUsage%,%SnapshotUsage%"
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
        name: Backup Cost
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
      Database Engine: cur2.product_database_engine
    row: 56
    col: 0
    width: 12
    height: 8

  - title: "Backup Cost by Database"
    name: backup_cost_by_database
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.product_database_engine, cur2.total_unblended_cost,
             cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%BackupUsage%,%SnapshotUsage%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 30
    dynamic_fields:
    - table_calculation: backup_size_gb
      label: Backup Size (GB)
      expression: "${cur2.line_item_usage_amount}"
      value_format: "#,##0.00"
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
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    hidden_fields: [cur2.line_item_usage_amount]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 56
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: READ REPLICA ANALYSIS
  # =====================================================

  - name: section_header_read_replicas
    type: text
    title_text: "<h2>Read Replica Cost Analysis</h2>"
    subtitle_text: "Analyze costs of read replica deployments"
    body_text: ""
    row: 64
    col: 0
    width: 24
    height: 2

  - title: "Read Replica Costs"
    name: read_replica_costs
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.product_region_code, cur2.total_unblended_cost, cur2.count_unique_resources]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%ReadReplica%"
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
    - label: "Replica Count"
      orientation: right
      series:
      - axisId: cur2.count_unique_resources
        id: cur2.count_unique_resources
        name: Replica Count
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 66
    col: 0
    width: 16
    height: 8

  - title: "Read Replica Details"
    name: read_replica_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.product_database_engine, cur2.product_instance_type,
             cur2.product_region_code, cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%ReadReplica%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 30
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
      value: 500
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.total_unblended_cost]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 66
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: PERFORMANCE INSIGHTS
  # =====================================================

  - name: section_header_performance_insights
    type: text
    title_text: "<h2>Performance Insights Cost Analysis</h2>"
    subtitle_text: "Track costs for RDS Performance Insights"
    body_text: ""
    row: 74
    col: 0
    width: 24
    height: 2

  - title: "Performance Insights Cost"
    name: performance_insights_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%PerformanceInsights%"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TOTAL PERFORMANCE INSIGHTS COST"
    value_format: "$#,##0.00"
    custom_color: "#FF9900"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 76
    col: 0
    width: 8
    height: 4

  - title: "Performance Insights by Database"
    name: performance_insights_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.product_database_engine, cur2.product_region_code,
             cur2.total_unblended_cost, cur2.line_item_usage_amount]
    filters:
      cur2.line_item_product_code: "AmazonRDS"
      cur2.line_item_usage_type: "%PerformanceInsights%"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 30
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
      value: 50
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: true
      fields: [cur2.total_unblended_cost]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
      cur2.line_item_usage_amount: "#,##0.00"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region_code
      Database Engine: cur2.product_database_engine
    row: 76
    col: 8
    width: 16
    height: 8
