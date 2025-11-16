---
- dashboard: multi_account_cost_allocation
  title: Multi-Account Cost Allocation & Chargeback
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Account hierarchy cost flow visualization with department allocation and tag compliance'
  
  elements:
  - title: Total Allocated Cost
    name: total_allocated_cost
    model: aws_billing
    explore: cost_allocation
    type: single_value
    fields: [cost_allocation.total_unblended_cost]
    filters:
      cost_allocation.usage_date: '30 days'
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: Total Allocated Cost
    value_format: '$#,##0'
    font_size: large
    text_color: '#1f3a5f'
    listen:
      Date Range: cost_allocation.usage_date
      Account: cost_allocation.usage_account_name
      AWS Service: cost_allocation.service_code
    row: 0
    col: 0
    width: 6
    height: 3

  - title: Tag Compliance Rate
    name: tag_compliance_rate
    model: aws_billing
    explore: cost_allocation
    type: single_value
    fields: [cost_allocation.tag_compliance_rate]
    filters:
      cost_allocation.usage_date: '30 days'
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: Tag Compliance Rate
    value_format: '0.0%'
    font_size: large
    text_color: '#0f7b0f'
    listen:
      Date Range: cost_allocation.usage_date
      Account: cost_allocation.usage_account_name
      AWS Service: cost_allocation.service_code
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
      type: relative_timeframes
      display: inline
      options: []
    model: aws_billing
    explore: cost_allocation
    listens_to_filters: []
    field: cost_allocation.usage_date

  - name: Account
    title: Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: cost_allocation
    listens_to_filters: []
    field: cost_allocation.usage_account_name

  - name: AWS Service
    title: AWS Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: cost_allocation
    listens_to_filters: []
    field: cost_allocation.service_code