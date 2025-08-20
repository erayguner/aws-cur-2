---
- dashboard: simplified_action_execution
  title: ⚡ Simplified Action Execution
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Automate optimization actions with organizational pipeline integration and immediate execution tracking'
  elements:
  - title: Actions Executed (24h)
    name: total_actions_executed
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_actions_executed]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    custom_color: '#1A73E8'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Executed
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 0
    col: 0
    width: 4
    height: 3

  - title: In Progress
    name: actions_in_progress
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.actions_in_progress]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    custom_color: '#FBBC04'
    show_single_value_title: true
    show_comparison: false
    single_value_title: In Progress
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 0
    col: 4
    width: 4
    height: 3

  - title: Queued
    name: actions_queued
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.actions_queued]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    custom_color: '#9AA0A6'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Queued
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 0
    col: 8
    width: 4
    height: 3

  - title: Success Rate (24h)
    name: execution_success_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.execution_success_rate]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 95
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [85, 95]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 85
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Success Rate
    value_format: '0.0"%"'
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 0
    col: 12
    width: 4
    height: 3

  - title: Immediate Savings (24h)
    name: immediate_savings_realized
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.immediate_savings_realized]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
      cur2.action_status: completed
    custom_color_enabled: true
    custom_color: '#34A853'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Savings Realized
    value_format: '$#,##0'
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 0
    col: 16
    width: 4
    height: 3

  - title: Pipeline Health
    name: pipeline_health_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.pipeline_health_score]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [70, 90]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 70
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Health Score
    value_format: '0"%"'
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 0
    col: 20
    width: 4
    height: 3

  - title: Real-Time Execution Pipeline Flow
    name: execution_pipeline_flow
    model: aws_billing
    explore: cur2
    type: looker_timeline
    fields: [cur2.action_timestamp, cur2.action_id, cur2.action_type, cur2.execution_stage, cur2.pipeline_name, cur2.execution_duration_minutes]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    sorts: [cur2.action_timestamp desc]
    limit: 100
    groupBars: true
    labelSize: 10pt
    showLegend: true
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    series_colors:
      queued: '#9AA0A6'
      in_progress: '#FBBC04'
      validation: '#4285F4'
      executing: '#FF6D01'
      completed: '#34A853'
      failed: '#EA4335'
      rolled_back: '#9C27B0'
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 3
    col: 0
    width: 24
    height: 6

  - title: Automation Level Distribution
    name: automation_level_distribution
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.automation_level, cur2.actions_count]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    sorts: [cur2.actions_count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b4c6
    series_colors:
      automatic: '#34A853'
      semi_automatic: '#FBBC04'
      manual_approval: '#FF6D01'
      manual_only: '#EA4335'
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 9
    col: 0
    width: 8
    height: 6

  - title: Pipeline Integration Status
    name: pipeline_integration_status
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.pipeline_name, cur2.integration_type, cur2.pipeline_status, cur2.actions_processed_24h, cur2.average_execution_time, cur2.success_rate, cur2.last_execution_time]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    sorts: [cur2.actions_processed_24h desc]
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting:
    - type: equal to
      value: healthy
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.pipeline_status]
    - type: equal to
      value: degraded
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.pipeline_status]
    - type: equal to
      value: failed
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.pipeline_status]
    series_labels:
      cur2.pipeline_name: Pipeline
      cur2.integration_type: Type
      cur2.pipeline_status: Status
      cur2.actions_processed_24h: 24h Actions
      cur2.average_execution_time: Avg Time
      cur2.success_rate: Success %
      cur2.last_execution_time: Last Run
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 9
    col: 8
    width: 16
    height: 6

  - title: Action Type Performance Metrics
    name: action_type_performance
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.action_type, cur2.total_executions, cur2.success_rate, cur2.average_execution_time, cur2.total_savings_impact]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    sorts: [cur2.total_executions desc]
    limit: 500
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
    totals_color: '#808080'
    y_axes:
    - label: Number of Executions
      orientation: left
      series:
      - axisId: cur2.total_executions
        id: cur2.total_executions
        name: Total Executions
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: 'Success Rate (%)'
      orientation: right
      series:
      - axisId: cur2.success_rate
        id: cur2.success_rate
        name: Success Rate
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.success_rate: line
      cur2.average_execution_time: line
    series_colors:
      cur2.total_executions: '#1A73E8'
      cur2.success_rate: '#34A853'
      cur2.average_execution_time: '#FBBC04'
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 15
    col: 0
    width: 12
    height: 8

  - title: Execution Timeline & Trends (Last 7 Days)
    name: execution_timeline_trends
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.total_actions_executed, cur2.successful_actions, cur2.failed_actions, cur2.cumulative_savings]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    sorts: [cur2.line_item_usage_start_date]
    limit: 500
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
    stacking: normal
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
    totals_color: '#808080'
    y_axes:
    - label: Actions Count
      orientation: left
      series:
      - axisId: cur2.total_actions_executed
        id: cur2.total_actions_executed
        name: Total Actions
      - axisId: cur2.successful_actions
        id: cur2.successful_actions
        name: Successful
      - axisId: cur2.failed_actions
        id: cur2.failed_actions
        name: Failed
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: 'Cumulative Savings ($)'
      orientation: right
      series:
      - axisId: cur2.cumulative_savings
        id: cur2.cumulative_savings
        name: Cumulative Savings
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.cumulative_savings: line
    series_colors:
      cur2.total_actions_executed: '#1A73E8'
      cur2.successful_actions: '#34A853'
      cur2.failed_actions: '#EA4335'
      cur2.cumulative_savings: '#FF6D01'
    listen:
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 15
    col: 12
    width: 12
    height: 8

  - title: Integration Workflow Configuration
    name: integration_workflow_details
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.workflow_name, cur2.trigger_type, cur2.approval_required, cur2.rollback_enabled, cur2.notification_channels, cur2.execution_window, cur2.max_concurrent_actions]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    sorts: [cur2.workflow_name]
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting:
    - type: equal to
      value: 'true'
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.rollback_enabled]
    - type: equal to
      value: 'false'
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.rollback_enabled]
    series_labels:
      cur2.workflow_name: Workflow
      cur2.trigger_type: Trigger
      cur2.approval_required: Approval
      cur2.rollback_enabled: Rollback
      cur2.notification_channels: Notifications
      cur2.execution_window: Exec Window
      cur2.max_concurrent_actions: Max Concurrent
    listen:
      Execution Period: cur2.line_item_usage_start_date
      Pipeline: cur2.execution_pipeline
      Automation Level: cur2.automation_level
    row: 23
    col: 0
    width: 24
    height: 6

  filters:
  - name: Execution Period
    title: Execution Period
    type: field_filter
    default_value: '24 hours ago for 24 hours'
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: Pipeline
    title: Execution Pipeline
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.execution_pipeline

  - name: Automation Level
    title: Automation Level
    type: field_filter
    default_value: automatic
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_group
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.automation_level