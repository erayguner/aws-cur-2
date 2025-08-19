---
- dashboard: container_split_analytics
  title: Container & Split Line Item Analytics
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'ECS task and Kubernetes pod cost allocation using CUR 2.0 split line items'
  
  elements:
  - title: Total Container Cost
    name: total_container_cost
    model: aws_billing
    explore: container_analytics
    type: single_value
    fields: [container_analytics.total_unblended_cost]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Total Container Cost
    value_format: '$#,##0'
    font_size: large
    text_color: '#1f3a5f'
    listen:
      Date Range: container_analytics.usage_date
      Container Type: container_analytics.container_type
      Cluster: container_analytics.ecs_cluster_name
    row: 0
    col: 0
    width: 6
    height: 3

  - title: Average Utilization
    name: average_utilization
    model: aws_billing
    explore: container_analytics
    type: single_value
    fields: [container_analytics.average_utilization]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Average Utilization
    value_format: '0.0%'
    font_size: large
    text_color: '#0f7b0f'
    listen:
      Date Range: container_analytics.usage_date
      Container Type: container_analytics.container_type
      Cluster: container_analytics.ecs_cluster_name
    row: 0
    col: 6
    width: 6
    height: 3

  - title: Container Count
    name: container_count
    model: aws_billing
    explore: container_analytics
    type: single_value
    fields: [container_analytics.container_count]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Active Containers
    value_format: '#,##0'
    font_size: large
    text_color: '#4285f4'
    listen:
      Date Range: container_analytics.usage_date
      Container Type: container_analytics.container_type
      Cluster: container_analytics.ecs_cluster_name
    row: 0
    col: 12
    width: 6
    height: 3

  - title: Potential Savings
    name: potential_savings
    model: aws_billing
    explore: container_analytics
    type: single_value
    fields: [container_analytics.potential_savings]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: Rightsizing Savings
    value_format: '$#,##0'
    font_size: large
    text_color: '#ea4335'
    listen:
      Date Range: container_analytics.usage_date
      Container Type: container_analytics.container_type
      Cluster: container_analytics.ecs_cluster_name
    row: 0
    col: 18
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
    explore: container_analytics
    listens_to_filters: []
    field: container_analytics.usage_date

  - name: Container Type
    title: Container Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: container_analytics
    listens_to_filters: []
    field: container_analytics.container_type

  - name: Cluster
    title: Cluster
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
    model: aws_billing
    explore: container_analytics
    listens_to_filters: []
    field: container_analytics.ecs_cluster_name