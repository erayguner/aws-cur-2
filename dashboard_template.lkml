# =====================================================
# AWS CUR 2.0 LOOKER DASHBOARD TEMPLATE
# =====================================================
# Standardized dashboard template following LookML best practices
# Based on analysis of LookML Dashboard Parameters documentation
# 
# Author: Claude Swarm Dashboard Optimizer
# Last Updated: 2025-08-19
# =====================================================

---
- dashboard: template_dashboard
  title: 📊 Dashboard Title Here
  description: 'Brief description of dashboard purpose and audience'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations (Required)
  auto_run: false                    # Prevent automatic query execution
  refresh: 60 minutes               # Cache refresh interval
  load_configuration: wait          # Wait for user interaction
  crossfilter_enabled: true         # Enable cross-filtering between elements
  
  # Standard AWS CUR Dashboard Filters (Required)
  filters:
  - name: Billing Period
    title: 📅 Billing Period
    type: field_filter
    default_value: '1 months ago for 1 months'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: AWS Account
    title: 🏢 AWS Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service, Environment, Cost Category]
    field: cur2.line_item_usage_account_name

  - name: AWS Service
    title: 🔧 AWS Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account, Cost Category]
    field: cur2.line_item_product_code

  - name: Environment
    title: 🌍 Environment
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account, AWS Service]
    field: cur2.environment

  - name: Cost Category
    title: 📊 Cost Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service, AWS Account]
    field: cur2.service_category

  - name: AWS Region
    title: 🌎 AWS Region
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Service, AWS Account]
    field: cur2.product_region_code

  - name: Team
    title: 👥 Team
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [AWS Account, Environment]
    field: cur2.team

  - name: Cost Threshold
    title: 💰 Minimum Cost ($)
    type: field_filter
    default_value: '0'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 100000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost

  elements:
  # Example KPI Element
  - title: Total Cost KPI
    name: total_cost_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
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
    - type: greater than
      value: '@{COST_THRESHOLD_HIGH}'
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: cost-threshold-alert
          label: Cost Threshold Alert
          type: continuous
          stops:
          - color: '#16a34a'
            offset: 0
          - color: '#eab308'
            offset: 50
          - color: '#dc2626'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    # Standard listen configuration (Required for all elements)
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 8
    height: 4

  # Example Chart Element with optimal configuration
  - title: Cost Trend Over Time
    name: cost_trend_chart
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    sorts: [cur2.line_item_usage_start_date]
    limit: 31
    column_limit: 50
    # Chart optimization settings
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
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    # Standard listen configuration
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 8
    width: 8
    height: 4

  # Example Table Element with enhanced features
  - title: Detailed Cost Breakdown
    name: cost_breakdown_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.line_item_usage_type,
      cur2.total_unblended_cost,
      cur2.total_usage_amount
    ]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    column_limit: 50
    # Table optimization settings
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
      value: '@{COST_THRESHOLD_MEDIUM}'
      background_color: '#fef3c7'
      font_color: '#92400e'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: cost-warning
          label: Cost Warning
          type: continuous
          stops:
          - color: '#ffffff'
            offset: 0
          - color: '#fef3c7'
            offset: 50
          - color: '#fed7aa'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_unblended_cost]
    # Standard listen configuration
    listen:
      Billing Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      AWS Service: cur2.line_item_product_code
      Environment: cur2.environment
      Cost Category: cur2.service_category
      AWS Region: cur2.product_region_code
      Team: cur2.team
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 0
    width: 16
    height: 8

# =====================================================
# TEMPLATE USAGE INSTRUCTIONS
# =====================================================
#
# 1. Copy this template for new dashboard creation
# 2. Update dashboard name, title, and description
# 3. Modify elements as needed for specific use case
# 4. Ensure all elements include standard listen configuration
# 5. Test cross-filtering functionality
# 6. Validate performance with auto_run: false
#
# Required Standards:
# - All dashboards MUST include standard filter set
# - All elements MUST include standard listen configuration
# - Performance settings MUST be included
# - Cross-filtering MUST be enabled
# - Conditional formatting MUST use @{} constants
# - UI icons MUST be used for better UX
#
# Filter Standards:
# - Billing Period: 📅 (relative_timeframes, inline)
# - AWS Account: 🏢 (dropdown_menu, inline)
# - AWS Service: 🔧 (dropdown_menu, inline)
# - Environment: 🌍 (tag_list, inline)
# - Cost Category: 📊 (dropdown_menu, inline)
# - AWS Region: 🌎 (dropdown_menu, inline)
# - Team: 👥 (tag_list, inline)
# - Cost Threshold: 💰 (range_slider, inline)
#
# Cross-filtering Rules:
# - Account filters should listen to Service/Environment
# - Service filters should listen to Account/Category
# - Environment filters should listen to Account/Service
# - Region filters should listen to Service/Account
# - Team filters should listen to Account/Environment
# - Cost Threshold filters should not listen to others
#
# =====================================================