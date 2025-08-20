---
- dashboard: trustworthy_optimization_actions
  title: 🛡️ Trustworthy Optimization Actions
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'App-first, demand-based analysis ensuring safe automation across AWS, Kubernetes, and hybrid environments'
  elements:
  - title: Overall Trust Score
    name: overall_trust_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.optimization_trust_score]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
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
    single_value_title: Trust Score
    value_format: '0"%"'
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 0
    col: 0
    width: 6
    height: 4

  - title: Safe Actions Identified
    name: safe_actions_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.safe_optimization_actions_count]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.optimization_confidence: '>85'
    custom_color_enabled: true
    custom_color: '#1A73E8'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Safe Actions
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 0
    col: 6
    width: 6
    height: 4

  - title: Potential Monthly Savings
    name: potential_monthly_savings
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.potential_monthly_savings]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.optimization_confidence: '>85'
    custom_color_enabled: true
    custom_color: '#34A853'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Monthly Savings
    value_format: '$#,##0'
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 0
    col: 12
    width: 6
    height: 4

  - title: Risk Mitigation Score
    name: risk_mitigation_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.risk_mitigation_score]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 85
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [60, 85]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 60
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Risk Score
    value_format: '0"%"'
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 0
    col: 18
    width: 6
    height: 4

  - title: Application-First Optimization Matrix
    name: application_optimization_matrix
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.resource_tags_application, cur2.optimization_confidence, cur2.potential_savings_amount, cur2.application_criticality_score]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.resource_tags_application: '-EMPTY'
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
    plot_size_by_field: cur2.potential_savings_amount
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: linear
    y_axis_combined: true
    show_null_points: false
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b4c6
    x_axis_label: 'Optimization Confidence (%)'
    y_axis_label: Application Criticality Score
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 4
    col: 0
    width: 12
    height: 8

  - title: Demand Pattern Analysis (7-Day Trend)
    name: demand_pattern_analysis
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.actual_usage_hours, cur2.provisioned_capacity_hours, cur2.optimization_opportunity]
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
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes:
    - label: Hours
      orientation: left
      series:
      - axisId: cur2.actual_usage_hours
        id: cur2.actual_usage_hours
        name: Actual Usage
      - axisId: cur2.provisioned_capacity_hours
        id: cur2.provisioned_capacity_hours
        name: Provisioned Capacity
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: 'Optimization Opportunity ($)'
      orientation: right
      series:
      - axisId: cur2.optimization_opportunity
        id: cur2.optimization_opportunity
        name: Optimization Opportunity
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.actual_usage_hours: '#34A853'
      cur2.provisioned_capacity_hours: '#4285F4'
      cur2.optimization_opportunity: '#EA4335'
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 4
    col: 12
    width: 12
    height: 8

  - title: Multi-Cloud Platform Coverage
    name: platform_coverage_analysis
    model: aws_billing
    explore: cur2
    type: looker_donut_multiples
    fields: [cur2.platform_type, cur2.optimization_actions_count, cur2.platform_trust_score]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    sorts: [cur2.optimization_actions_count desc]
    limit: 500
    show_value_labels: true
    font_size: 12
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    series_colors:
      AWS: '#FF9900'
      Kubernetes: '#326CE5'
      VMware: '#607078'
      Azure: '#0078D4'
      GCP: '#4285F4'
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 12
    col: 0
    width: 8
    height: 6

  - title: Optimization Safety & Confidence Matrix
    name: safety_confidence_matrix
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.optimization_action_type, cur2.optimization_confidence, cur2.safety_score, cur2.potential_savings_amount, cur2.estimated_execution_time]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.optimization_confidence: '>85'
    sorts: [cur2.optimization_confidence desc, cur2.safety_score desc]
    limit: 100
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
    - type: along a scale...
      value: !!null ''
      background_color: !!null ''
      font_color: !!null ''
      color_application:
        collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
        custom:
          id: safety-confidence-scale
          label: Safety Confidence
          type: continuous
          stops:
          - color: '#EA4335'
            offset: 0
          - color: '#FBBC04'
            offset: 50
          - color: '#34A853'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.optimization_confidence, cur2.safety_score]
    series_column_widths:
      cur2.line_item_resource_id: 150
      cur2.optimization_action_type: 120
      cur2.optimization_confidence: 100
      cur2.safety_score: 100
      cur2.potential_savings_amount: 120
    series_cell_visualizations:
      cur2.optimization_confidence:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      cur2.safety_score:
        is_active: true
        palette:
          palette_id: 471cff94-c2ec-4fc1-9816-9897cbf8ddf1
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 12
    col: 8
    width: 16
    height: 6

  - title: Automation Safety Checks & Prerequisites
    name: automation_safety_checks
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.safety_check_category, cur2.safety_checks_passed, cur2.safety_checks_total, cur2.safety_check_pass_rate, cur2.blocking_issues_count]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    sorts: [cur2.safety_check_pass_rate desc]
    limit: 50
    dynamic_fields:
    - category: table_calculation
      expression: '${cur2.safety_checks_passed}/${cur2.safety_checks_total}'
      label: Pass Rate
      value_format: '0.0%'
      _kind_hint: measure
      table_calculation: pass_rate_calc
      _type_hint: number
    show_view_names: false
    show_row_numbers: false
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
      value: 0.95
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.safety_check_pass_rate, pass_rate_calc]
    - type: between
      value: [0.8, 0.95]
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.safety_check_pass_rate, pass_rate_calc]
    - type: less than
      value: 0.8
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.safety_check_pass_rate, pass_rate_calc]
    series_labels:
      cur2.safety_check_category: Safety Category
      cur2.safety_checks_passed: Checks Passed
      cur2.safety_checks_total: Total Checks
      cur2.safety_check_pass_rate: Pass Rate
      cur2.blocking_issues_count: Blocking Issues
    listen:
      Analysis Period: cur2.line_item_usage_start_date
      Application: cur2.resource_tags_application
      Environment: cur2.environment
    row: 18
    col: 0
    width: 24
    height: 6

  filters:
  - name: Analysis Period
    title: Analysis Period
    type: field_filter
    default_value: '7 days ago for 7 days'
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

  - name: Confidence Threshold
    title: 'Confidence Threshold (%)'
    type: number_filter
    default_value: '85'
    allow_multiple_values: false
    required: false

  - name: Application
    title: Application
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
    field: cur2.resource_tags_application

  - name: Environment
    title: Environment
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
    field: cur2.environment