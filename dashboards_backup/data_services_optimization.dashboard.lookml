---
- dashboard: data_services_optimization
  title: Data Services Optimization - RDS, DynamoDB & ElastiCache
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Comprehensive optimization analysis for AWS data services including RDS, DynamoDB, and ElastiCache'
  elements:
  - title: Total Data Services Cost
    name: total_data_cost
    model: aws_billing
    explore: data_services_optimization
    type: single_value
    fields: [data_services_cur2.total_unblended_cost]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Total Data Services Cost
    value_format: '$#,##0'
    font_size: large
    text_color: '#1f3a5f'
    listen:
      Date Range: data_services_cur2.usage_date
      Data Service: data_services_cur2.data_service
      Optimization Priority: data_services_cur2.optimization_priority
    row: 0
    col: 0
    width: 6
    height: 3

  - title: Potential Savings
    name: potential_savings
    model: aws_billing
    explore: data_services_optimization
    type: single_value
    fields: [data_services_cur2.total_potential_savings]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Total Potential Savings
    value_format: '$#,##0'
    font_size: large
    text_color: '#0f7b0f'
    listen:
      Date Range: data_services_cur2.usage_date
      Data Service: data_services_cur2.data_service
      Optimization Priority: data_services_cur2.optimization_priority
    row: 0
    col: 6
    width: 6
    height: 3

  filters:
  - name: Date Range
    title: Date Range
    type: field_filter
    default_value: '30 days ago for 30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: aws_billing
    explore: data_services_optimization
    listens_to_filters: []
    field: data_services_cur2.usage_date

  - name: Data Service
    title: Data Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: data_services_optimization
    listens_to_filters: []
    field: data_services_cur2.data_service

  - name: Optimization Priority
    title: Optimization Priority
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: data_services_optimization
    listens_to_filters: []
    field: data_services_cur2.optimization_priority