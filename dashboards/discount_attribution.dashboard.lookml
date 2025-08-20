---
- dashboard: discount_attribution
  title: Discount Attribution & Commitment Management
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Comprehensive discount tracking and commitment lifecycle management using CUR 2.0'
  elements:
  - title: Total Savings vs On-Demand
    name: total_savings
    model: aws_billing
    explore: discount_attribution
    type: single_value
    fields: [discount_attribution.total_savings_vs_on_demand]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Total Savings vs On-Demand
    value_format: '$#,##0'
    font_size: large
    text_color: '#0f7b0f'
    listen:
      Date Range: discount_attribution.usage_date
      Commitment Status: discount_attribution.commitment_status
      AWS Service: discount_attribution.service_code
    row: 0
    col: 0
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
    explore: discount_attribution
    listens_to_filters: []
    field: discount_attribution.usage_date

  - name: Commitment Status
    title: Commitment Status
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: discount_attribution
    listens_to_filters: []
    field: discount_attribution.commitment_status

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
    explore: discount_attribution
    listens_to_filters: []
    field: discount_attribution.service_code