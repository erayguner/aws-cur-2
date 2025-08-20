---
- dashboard: visible_business_impact
  title: 📊 Visible Business Impact
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Demonstrate the tangible impact of dynamic resourcing on mission-critical applications and business outcomes'
  elements:
  - title: Total Business Value Generated
    name: total_business_value_generated
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_business_value_generated]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    custom_color: '#34A853'
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs Previous Period
    single_value_title: Business Value
    value_format: '$#,##0'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 0
    col: 0
    width: 6
    height: 4

  - title: Cost Optimization Savings
    name: cost_optimization_savings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_cost_savings]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    custom_color: '#1A73E8'
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs Previous Period
    single_value_title: Cost Savings
    value_format: '$#,##0'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 0
    col: 6
    width: 6
    height: 4

  - title: Performance Improvement Index
    name: performance_improvement_index
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.performance_improvement_index]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 110
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [95, 110]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 95
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Performance Index
    value_format: '0.0'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 0
    col: 12
    width: 6
    height: 4

  - title: Developer Satisfaction Score
    name: developer_satisfaction_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.developer_satisfaction_score]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 8.0
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [6.0, 8.0]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 6.0
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Dev Satisfaction
    value_format: '0.0"/10"'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 0
    col: 18
    width: 6
    height: 4

  - title: Business Impact Breakdown (Monthly)
    name: business_impact_waterfall
    model: aws_billing
    explore: cur2
    type: looker_waterfall
    fields: [cur2.baseline_costs, cur2.optimization_savings, cur2.performance_gains, cur2.risk_reduction_value, cur2.developer_productivity_gains, cur2.total_business_impact]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    limit: 500
    up_color: '#34A853'
    down_color: '#EA4335'
    total_color: '#1A73E8'
    show_value_labels: true
    show_x_axis_ticks: true
    show_x_axis_label: true
    x_axis_label: Impact Categories
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_label: 'Financial Impact ($)'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 4
    col: 0
    width: 12
    height: 8

  - title: Application Performance vs Cost Impact Matrix
    name: performance_cost_matrix
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.resource_tags_application, cur2.performance_improvement_percentage, cur2.cost_reduction_percentage, cur2.application_criticality_score, cur2.total_impact_value]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
      cur2.resource_tags_application: '-EMPTY'
    sorts: [cur2.total_impact_value desc]
    limit: 100
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
    plot_size_by_field: cur2.total_impact_value
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: linear
    y_axis_combined: true
    show_null_points: false
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b4c6
    x_axis_label: 'Cost Reduction (%)'
    y_axis_label: 'Performance Improvement (%)'
    quadrants_enabled: true
    quadrant_lines:
    - x: 15
      y: 10
    quadrant_labels:
    - Low Impact
    - Cost Focus
    - Performance Focus
    - High Impact
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 4
    col: 12
    width: 12
    height: 8

  - title: Mission-Critical Application Impact Dashboard
    name: mission_critical_app_impact
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.resource_tags_application, cur2.application_criticality, cur2.sla_compliance_before, cur2.sla_compliance_after, cur2.performance_improvement_percentage, cur2.cost_reduction_amount, cur2.downtime_reduction_hours, cur2.developer_feedback_score]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
      cur2.application_criticality: 'critical,high'
    sorts: [cur2.cost_reduction_amount desc]
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
    - type: greater than
      value: 99.9
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.sla_compliance_after]
    - type: between
      value: [99.0, 99.9]
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.sla_compliance_after]
    - type: less than
      value: 99.0
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.sla_compliance_after]
    series_labels:
      cur2.resource_tags_application: Application
      cur2.application_criticality: Criticality
      cur2.sla_compliance_before: 'SLA Before (%)'
      cur2.sla_compliance_after: 'SLA After (%)'
      cur2.performance_improvement_percentage: 'Perf Gain (%)'
      cur2.cost_reduction_amount: 'Cost Savings ($)'
      cur2.downtime_reduction_hours: 'Downtime Reduced (hrs)'
      cur2.developer_feedback_score: Dev Score
    series_column_widths:
      cur2.resource_tags_application: 150
      cur2.application_criticality: 80
      cur2.cost_reduction_amount: 100
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 12
    col: 0
    width: 24
    height: 8

  - title: Stakeholder Trust & Confidence Trends
    name: stakeholder_trust_metrics
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_week, cur2.developer_trust_score, cur2.operations_confidence_score, cur2.business_stakeholder_satisfaction, cur2.automation_acceptance_rate]
    fill_fields: [cur2.line_item_usage_start_week]
    filters:
      cur2.line_item_usage_start_date: '12 weeks ago for 12 weeks'
    sorts: [cur2.line_item_usage_start_week]
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
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: 'Trust & Confidence Score (0-10)'
      orientation: left
      series:
      - axisId: cur2.developer_trust_score
        id: cur2.developer_trust_score
        name: Developer Trust
      - axisId: cur2.operations_confidence_score
        id: cur2.operations_confidence_score
        name: Operations Confidence
      - axisId: cur2.business_stakeholder_satisfaction
        id: cur2.business_stakeholder_satisfaction
        name: Business Satisfaction
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
      minValue: 0
      maxValue: 10
    - label: 'Automation Acceptance Rate (%)'
      orientation: right
      series:
      - axisId: cur2.automation_acceptance_rate
        id: cur2.automation_acceptance_rate
        name: Automation Acceptance
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
      minValue: 0
      maxValue: 100
    series_colors:
      cur2.developer_trust_score: '#4285F4'
      cur2.operations_confidence_score: '#34A853'
      cur2.business_stakeholder_satisfaction: '#FBBC04'
      cur2.automation_acceptance_rate: '#EA4335'
    listen:
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 20
    col: 0
    width: 12
    height: 8

  - title: ROI & Financial Impact Analysis
    name: roi_financial_impact
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.business_unit, cur2.total_investment, cur2.total_savings, cur2.roi_percentage, cur2.payback_period_months, cur2.net_present_value]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    sorts: [cur2.roi_percentage desc]
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
    - label: 'Financial Amount ($)'
      orientation: left
      series:
      - axisId: cur2.total_investment
        id: cur2.total_investment
        name: Investment
      - axisId: cur2.total_savings
        id: cur2.total_savings
        name: Savings
      - axisId: cur2.net_present_value
        id: cur2.net_present_value
        name: NPV
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: 'ROI (%) / Payback (Months)'
      orientation: right
      series:
      - axisId: cur2.roi_percentage
        id: cur2.roi_percentage
        name: 'ROI %'
      - axisId: cur2.payback_period_months
        id: cur2.payback_period_months
        name: Payback Months
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.roi_percentage: line
      cur2.payback_period_months: line
    series_colors:
      cur2.total_investment: '#EA4335'
      cur2.total_savings: '#34A853'
      cur2.net_present_value: '#1A73E8'
      cur2.roi_percentage: '#FBBC04'
      cur2.payback_period_months: '#9C27B0'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 20
    col: 12
    width: 12
    height: 8

  - title: Developer Productivity & Experience Impact
    name: developer_productivity_impact
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.development_team, cur2.deployment_frequency_improvement, cur2.lead_time_reduction_percentage, cur2.mttr_improvement_percentage, cur2.change_failure_rate_reduction, cur2.developer_satisfaction_improvement, cur2.productivity_time_saved_hours]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    sorts: [cur2.productivity_time_saved_hours desc]
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
    - type: greater than
      value: 20
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.deployment_frequency_improvement, cur2.lead_time_reduction_percentage, cur2.mttr_improvement_percentage]
    - type: between
      value: [10, 20]
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.deployment_frequency_improvement, cur2.lead_time_reduction_percentage, cur2.mttr_improvement_percentage]
    - type: less than
      value: 10
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.deployment_frequency_improvement, cur2.lead_time_reduction_percentage, cur2.mttr_improvement_percentage]
    series_labels:
      cur2.development_team: Team
      cur2.deployment_frequency_improvement: 'Deploy Freq ↑ (%)'
      cur2.lead_time_reduction_percentage: 'Lead Time ↓ (%)'
      cur2.mttr_improvement_percentage: 'MTTR ↓ (%)'
      cur2.change_failure_rate_reduction: 'Failure Rate ↓ (%)'
      cur2.developer_satisfaction_improvement: 'Satisfaction ↑'
      cur2.productivity_time_saved_hours: 'Time Saved (hrs)'
    listen:
      Impact Period: cur2.line_item_usage_start_date
      Application Criticality: cur2.application_criticality
      Stakeholder View: cur2.stakeholder_view_type
      Business Unit: cur2.business_unit
    row: 28
    col: 0
    width: 24
    height: 8

  filters:
  - name: Impact Period
    title: Impact Analysis Period
    type: field_filter
    default_value: '30 days ago for 30 days'
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

  - name: Application Criticality
    title: Application Criticality
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.application_criticality

  - name: Stakeholder View
    title: Stakeholder View
    type: field_filter
    default_value: executive
    allow_multiple_values: false
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.stakeholder_view_type

  - name: Business Unit
    title: Business Unit
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
    field: cur2.business_unit