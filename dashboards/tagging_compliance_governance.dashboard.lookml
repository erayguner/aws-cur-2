---
# =====================================================
# TAGGING COMPLIANCE & GOVERNANCE DASHBOARD
# =====================================================
# Comprehensive tagging compliance and governance tracking
# Following 2025 FinOps best practices for tag management
# =====================================================

- dashboard: tagging_compliance_governance
  title: "Tagging Compliance & Governance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Track tagging compliance, identify untagged resources, monitor tag coverage trends, and enforce mandatory tagging policies aligned with 2025 FinOps Framework"

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

  - name: Tag Compliance
    title: "Tag Compliance Level"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.tag_completeness

  elements:
  # =====================================================
  # SECTION: EXECUTIVE TAGGING COMPLIANCE KPIs
  # =====================================================

  - name: section_header_compliance_kpis
    type: text
    title_text: "<h2>Tagging Compliance Overview</h2>"
    subtitle_text: "Executive view of tagging coverage and compliance status"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Overall Tag Coverage"
    name: overall_tag_coverage_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.tag_coverage_rate]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "OVERALL TAG COVERAGE"
    value_format: "#,##0.0\"%\""
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [70, 90]
      background_color: "#eab308"
      font_color: "#000000"
      bold: true
    - type: less than
      value: 70
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 2
    col: 0
    width: 4
    height: 4

  - title: "Tagged Resources Cost"
    name: tagged_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_tagged_cost]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TAGGED RESOURCES COST"
    value_format: "$#,##0"
    conditional_formatting:
    - type: greater than
      value: 100000
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 2
    col: 4
    width: 4
    height: 4

  - title: "Untagged Resources Cost"
    name: untagged_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_untagged_cost]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "UNTAGGED RESOURCES COST"
    value_format: "$#,##0"
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 2
    col: 8
    width: 4
    height: 4

  - title: "Unique Tagged Resources"
    name: unique_tagged_resources_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    filters:
      cur2.has_tags: "Yes"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "UNIQUE TAGGED RESOURCES"
    value_format: "#,##0"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 2
    col: 12
    width: 4
    height: 4

  - title: "Unique Untagged Resources"
    name: unique_untagged_resources_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    filters:
      cur2.has_tags: "No"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "UNIQUE UNTAGGED RESOURCES"
    value_format: "#,##0"
    conditional_formatting:
    - type: less than
      value: 10
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 100
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 2
    col: 16
    width: 4
    height: 4

  - title: "Average Tags Per Resource"
    name: average_tags_per_resource_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.tag_count, cur2.count_unique_resources]
    filters:
      cur2.has_tags: "Yes"
    limit: 1
    dynamic_fields:
    - table_calculation: avg_tags_per_resource
      label: Avg Tags Per Resource
      expression: "mean(${cur2.tag_count})"
      value_format: "#,##0.0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "AVG TAGS PER RESOURCE"
    value_format: "#,##0.0"
    conditional_formatting:
    - type: greater than
      value: 5
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: less than
      value: 3
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 2
    col: 20
    width: 4
    height: 4

  # =====================================================
  # SECTION: TAG COVERAGE BY ACCOUNT AND SERVICE
  # =====================================================

  - name: section_header_coverage
    type: text
    title_text: "<h2>Tag Coverage Analysis</h2>"
    subtitle_text: "Detailed breakdown of tagging coverage by account and service"
    body_text: ""
    row: 6
    col: 0
    width: 24
    height: 2

  - title: "Tag Coverage by AWS Account"
    name: tag_coverage_by_account
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_account_name, cur2.total_tagged_cost, cur2.total_untagged_cost, cur2.tag_coverage_rate]
    sorts: [cur2.tag_coverage_rate desc]
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
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
      - axisId: cur2.total_tagged_cost
        id: cur2.total_tagged_cost
        name: Tagged Cost
      - axisId: cur2.total_untagged_cost
        id: cur2.total_untagged_cost
        name: Untagged Cost
      showLabels: true
      showValues: true
      valueFormat: "$#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Coverage %"
      orientation: right
      series:
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: Tag Coverage Rate
      showLabels: true
      showValues: true
      valueFormat: "#,##0\"%\""
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.tag_coverage_rate: line
    series_colors:
      cur2.total_tagged_cost: "#16a34a"
      cur2.total_untagged_cost: "#dc2626"
      cur2.tag_coverage_rate: "#1f77b4"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 8
    col: 0
    width: 12
    height: 8

  - title: "Tag Coverage by AWS Service"
    name: tag_coverage_by_service
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_product_code, cur2.total_tagged_cost, cur2.total_untagged_cost, cur2.tag_coverage_rate]
    sorts: [cur2.total_untagged_cost desc]
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
    stacking: percent
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
    - label: ""
      orientation: bottom
      series:
      - axisId: cur2.total_tagged_cost
        id: cur2.total_tagged_cost
        name: Tagged Cost
      - axisId: cur2.total_untagged_cost
        id: cur2.total_untagged_cost
        name: Untagged Cost
      showLabels: true
      showValues: true
      valueFormat: "#,##0\"%\""
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.total_tagged_cost: "#16a34a"
      cur2.total_untagged_cost: "#dc2626"
    defaults_version: 1
    hidden_fields: [cur2.tag_coverage_rate]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 8
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: UNTAGGED RESOURCE DETECTION
  # =====================================================

  - name: section_header_untagged
    type: text
    title_text: "<h2>Untagged Resource Detection</h2>"
    subtitle_text: "Identify and track resources without proper tagging"
    body_text: ""
    row: 16
    col: 0
    width: 24
    height: 2

  - title: "Top Untagged Resources by Cost"
    name: top_untagged_resources
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.line_item_usage_account_name,
             cur2.line_item_availability_zone, cur2.product_instance_type, cur2.total_unblended_cost,
             cur2.tag_count]
    filters:
      cur2.has_tags: "No"
      cur2.line_item_resource_id: "-NULL"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
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
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: greater than
      value: 500
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [cur2.total_unblended_cost]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
    row: 18
    col: 0
    width: 16
    height: 10

  - title: "Untagged Resources by Service"
    name: untagged_by_service_pie
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_product_code, cur2.total_untagged_cost]
    filters:
      cur2.has_tags: "No"
    sorts: [cur2.total_untagged_cost desc]
    limit: 10
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      AmazonEC2: "#dc2626"
      AmazonS3: "#f59e0b"
      AmazonRDS: "#fbbf24"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
    row: 18
    col: 16
    width: 8
    height: 10

  # =====================================================
  # SECTION: TAG COMPLIANCE TRENDS
  # =====================================================

  - name: section_header_trends
    type: text
    title_text: "<h2>Tag Compliance Trends</h2>"
    subtitle_text: "Track tagging compliance improvements over time"
    body_text: ""
    row: 28
    col: 0
    width: 24
    height: 2

  - title: "Tag Coverage Trend Over Time"
    name: tag_coverage_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.tag_coverage_rate, cur2.total_tagged_cost, cur2.total_untagged_cost]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
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
    - label: "Coverage %"
      orientation: left
      series:
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: Tag Coverage Rate
      showLabels: true
      showValues: true
      valueFormat: "#,##0\"%\""
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Cost"
      orientation: right
      series:
      - axisId: cur2.total_tagged_cost
        id: cur2.total_tagged_cost
        name: Tagged Cost
      - axisId: cur2.total_untagged_cost
        id: cur2.total_untagged_cost
        name: Untagged Cost
      showLabels: true
      showValues: true
      valueFormat: "$#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.total_tagged_cost: area
      cur2.total_untagged_cost: area
    series_colors:
      cur2.tag_coverage_rate: "#1f77b4"
      cur2.total_tagged_cost: "#16a34a"
      cur2.total_untagged_cost: "#dc2626"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 30
    col: 0
    width: 16
    height: 8

  - title: "Tag Compliance Distribution"
    name: tag_compliance_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.tag_completeness, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    series_colors:
      Fully Tagged: "#16a34a"
      Partially Tagged: "#fbbf24"
      No Tags: "#dc2626"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
    row: 30
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: TAG KEY/VALUE DISTRIBUTION
  # =====================================================

  - name: section_header_tag_distribution
    type: text
    title_text: "<h2>Tag Key/Value Distribution</h2>"
    subtitle_text: "Analyze tag usage patterns and popular tag keys"
    body_text: ""
    row: 38
    col: 0
    width: 24
    height: 2

  - title: "Cost by Environment Tag"
    name: cost_by_environment_tag
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.environment, cur2.total_unblended_cost, cur2.count_unique_resources]
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
        name: Total Cost
      showLabels: true
      showValues: true
      valueFormat: "$#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      prod: "#dc2626"
      production: "#dc2626"
      dev: "#16a34a"
      development: "#16a34a"
      staging: "#fbbf24"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 40
    col: 0
    width: 8
    height: 8

  - title: "Cost by Team Tag"
    name: cost_by_team_tag
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.team, cur2.total_unblended_cost, cur2.tag_coverage_rate]
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
      Tag Compliance: cur2.tag_completeness
    row: 40
    col: 8
    width: 8
    height: 8

  - title: "Cost by Project Tag"
    name: cost_by_project_tag
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.project, cur2.total_unblended_cost]
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
      Tag Compliance: cur2.tag_completeness
    row: 40
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: MANDATORY TAG ENFORCEMENT
  # =====================================================

  - name: section_header_enforcement
    type: text
    title_text: "<h2>Mandatory Tag Enforcement Tracking</h2>"
    subtitle_text: "Monitor compliance with mandatory tagging policies"
    body_text: ""
    row: 48
    col: 0
    width: 24
    height: 2

  - title: "Mandatory Tag Compliance Report"
    name: mandatory_tag_compliance
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.line_item_product_code,
             cur2.has_environment_tag, cur2.has_team_tag, cur2.total_unblended_cost,
             cur2.count_unique_resources, cur2.tag_coverage_rate]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: compliance_status
      label: Compliance Status
      expression: "if(${cur2.has_environment_tag} AND ${cur2.has_team_tag}, \"Compliant\", \"Non-Compliant\")"
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
      value: "Compliant"
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [compliance_status]
    - type: equal to
      value: "Non-Compliant"
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: true
      fields: [compliance_status]
    - type: less than
      value: 90
      background_color: "#fef3c7"
      font_color: "#92400e"
      bold: false
      fields: [cur2.tag_coverage_rate]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0.00"
      cur2.tag_coverage_rate: "#,##0.0\"%\""
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service: cur2.line_item_product_code
    row: 50
    col: 0
    width: 24
    height: 10
