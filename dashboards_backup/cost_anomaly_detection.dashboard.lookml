---
- dashboard: cost_anomaly_detection
  title: Cost Anomaly Detection
  description: 'Detect unusual spending patterns, cost spikes, and anomalies for proactive cost management'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  elements:
  - title: Anomaly Detection Summary
    name: anomaly_summary
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    dynamic_fields:
    - table_calculation: daily_cost_change
      label: Daily Cost Change %
      expression: 'percent_of_previous(${cur2.total_unblended_cost})'
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: anomaly_count
      label: Total Anomalies Detected
      expression: 'count(if(abs(${daily_cost_change}) > {% parameter anomaly_threshold %}/100, ${cur2.line_item_usage_start_date}, null))'
      value_format: null
      value_format_name: decimal_0
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: highest_spike
      label: Highest Cost Spike %
      expression: 'max(${daily_cost_change})'
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: largest_drop
      label: Largest Cost Drop %
      expression: 'min(${daily_cost_change})'
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: '{% parameter billing_period_filter %}'
      cur2.line_item_usage_account_name: '{% parameter account_filter %}'
      cur2.total_unblended_cost: '>{% parameter minimum_cost_filter %}'
    sorts: [cur2.line_item_usage_start_date]
    limit: 100
    column_limit: 50
    width: 16
    height: 4
    row: 0
    col: 0

  - title: Daily Cost Trend with Anomaly Detection
    name: cost_trend_with_anomalies
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    dynamic_fields:
    - table_calculation: moving_average_7d
      label: 7-Day Moving Average
      expression: 'mean(offset_list(${cur2.total_unblended_cost},-6,7))'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: upper_bound
      label: Upper Anomaly Bound (+2 StdDev)
      expression: '${moving_average_7d} + (2 * ${cur2.total_unblended_cost:standard_deviation})'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: lower_bound
      label: Lower Anomaly Bound (-2 StdDev)
      expression: '${moving_average_7d} - (2 * ${cur2.total_unblended_cost:standard_deviation})'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: anomaly_flag
      label: Anomaly Flag
      expression: 'if(${cur2.total_unblended_cost} > ${upper_bound} OR ${cur2.total_unblended_cost} < ${lower_bound}, ${cur2.total_unblended_cost}, null)'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: '{% parameter billing_period_filter %}'
      cur2.line_item_usage_account_name: '{% parameter account_filter %}'
      cur2.total_unblended_cost: '>{% parameter minimum_cost_filter %}'
    sorts: [cur2.line_item_usage_start_date]
    limit: 100
    column_limit: 50
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
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    series_types:
      anomaly_flag: scatter
      moving_average_7d: line
      upper_bound: line
      lower_bound: line
    series_colors:
      cur2.total_unblended_cost: '#1f77b4'
      moving_average_7d: '#2ca02c'
      upper_bound: '#ff7f0e'
      lower_bound: '#ff7f0e'
      anomaly_flag: '#d62728'
    width: 16
    height: 8
    row: 4
    col: 0

  - title: Service-Level Anomaly Heatmap
    name: service_anomaly_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_product_code,
      cur2.line_item_usage_start_date,
      cur2.total_unblended_cost
    ]
    pivots: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_usage_start_date: '{% parameter billing_period_filter %}'
      cur2.line_item_usage_account_name: '{% parameter account_filter %}'
      cur2.total_unblended_cost: '>{% parameter minimum_cost_filter %}'
    sorts: [cur2.total_unblended_cost desc 0, cur2.line_item_usage_start_date]
    limit: 20
    column_limit: 31
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
      value: '@{COST_THRESHOLD_HIGH}'
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: anomaly-heatmap
          label: Anomaly Heatmap
          type: continuous
          stops:
          - color: '#f0f9ff'
            offset: 0
          - color: '#0ea5e9'
            offset: 25
          - color: '#f59e0b'
            offset: 75
          - color: '#dc2626'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: null
    width: 16
    height: 8
    row: 12
    col: 0

  - title: Top Cost Spikes (Day-over-Day)
    name: top_cost_spikes
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_usage_start_date,
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost
    ]
    dynamic_fields:
    - table_calculation: previous_day_cost
      label: Previous Day Cost
      expression: 'offset(${cur2.total_unblended_cost}, 1)'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: cost_change_percent
      label: Cost Change %
      expression: 'if(is_null(${previous_day_cost}) OR ${previous_day_cost} = 0, null, ((${cur2.total_unblended_cost} - ${previous_day_cost}) / ${previous_day_cost}) * 100)'
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: cost_change_absolute
      label: Cost Change ($)
      expression: 'if(is_null(${previous_day_cost}), null, ${cur2.total_unblended_cost} - ${previous_day_cost})'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: spike_severity
      label: Spike Severity
      expression: 'case(
        when ${cost_change_percent} > 200 then "Critical"
        when ${cost_change_percent} > 100 then "High"
        when ${cost_change_percent} > 50 then "Medium"
        when ${cost_change_percent} > 25 then "Low"
        else "Normal"
      end'
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: '{% parameter billing_period_filter %}'
      cur2.line_item_usage_account_name: '{% parameter account_filter %}'
      cur2.total_unblended_cost: '>{% parameter minimum_cost_filter %}'
    sorts: [cost_change_percent desc]
    limit: 50
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: 25
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    conditional_formatting:
    - type: equal to
      value: Critical
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: spike-severity
          label: Spike Severity
          type: categorical
          colors: ['#dc2626', '#f59e0b', '#eab308', '#16a34a', '#6b7280']
      bold: true
      italic: false
      strikethrough: false
      fields: [spike_severity]
    - type: equal to
      value: High
      background_color: '#f59e0b'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: false
      italic: false
      strikethrough: false
      fields: [spike_severity]
    - type: greater than
      value: '{% parameter anomaly_threshold %}'
      background_color: '#fef3c7'
      font_color: '#000000'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: false
      italic: false
      strikethrough: false
      fields: [cost_change_percent]
    width: 8
    height: 10
    row: 20
    col: 0

  - title: Account-Level Anomaly Summary
    name: account_anomaly_summary
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [
      cur2.line_item_usage_account_name,
      cur2.total_unblended_cost
    ]
    dynamic_fields:
    - table_calculation: account_avg_cost
      label: Account Average Daily Cost
      expression: 'mean(${cur2.total_unblended_cost})'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: cost_variance
      label: Cost Variance (StdDev)
      expression: 'stddev_pop(${cur2.total_unblended_cost})'
      value_format: null
      value_format_name: usd
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: volatility_score
      label: Volatility Score
      expression: 'if(${account_avg_cost} = 0, 0, (${cost_variance} / ${account_avg_cost}) * 100)'
      value_format: null
      value_format_name: percent_2
      _kind_hint: measure
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: '{% parameter billing_period_filter %}'
      cur2.line_item_usage_account_name: '{% parameter account_filter %}'
      cur2.total_unblended_cost: '>{% parameter minimum_cost_filter %}'
    sorts: [volatility_score desc]
    limit: 15
    column_limit: 50
    width: 8
    height: 10
    row: 20
    col: 8

  - title: Anomaly Detection Rules & Recommendations
    name: anomaly_rules_table
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [
      cur2.line_item_product_code,
      cur2.line_item_usage_account_name,
      cur2.line_item_usage_start_date,
      cur2.total_unblended_cost
    ]
    dynamic_fields:
    - table_calculation: cost_z_score
      label: Cost Z-Score
      expression: '(${cur2.total_unblended_cost} - mean(${cur2.total_unblended_cost})) / stddev_pop(${cur2.total_unblended_cost})'
      value_format: null
      value_format_name: decimal_2
      _kind_hint: measure
      _type_hint: type_unspecified
    - table_calculation: anomaly_type
      label: Anomaly Type
      expression: 'case(
        when ${cost_z_score} > 3 then "Extreme High"
        when ${cost_z_score} > 2 then "High Outlier"
        when ${cost_z_score} < -3 then "Extreme Low"
        when ${cost_z_score} < -2 then "Low Outlier"
        else "Normal"
      end'
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    - table_calculation: investigation_priority
      label: Investigation Priority
      expression: 'case(
        when ${anomaly_type} = "Extreme High" AND ${cur2.total_unblended_cost} > @{COST_THRESHOLD_HIGH} then "Immediate"
        when ${anomaly_type} = "High Outlier" AND ${cur2.total_unblended_cost} > @{COST_THRESHOLD_MEDIUM} then "High"
        when ${anomaly_type} = "Extreme Low" then "Monitor"
        when ${anomaly_type} = "Low Outlier" then "Low"
        else "Normal"
      end'
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    - table_calculation: recommended_action
      label: Recommended Action
      expression: 'case(
        when ${investigation_priority} = "Immediate" then "Alert team immediately, investigate root cause"
        when ${investigation_priority} = "High" then "Review usage patterns and recent changes"
        when ${investigation_priority} = "Monitor" then "Monitor for sustained low usage"
        when ${investigation_priority} = "Low" then "Log for trend analysis"
        else "No action required"
      end'
      value_format: null
      value_format_name: null
      _kind_hint: dimension
      _type_hint: type_unspecified
    filters:
      cur2.line_item_usage_start_date: '{% parameter billing_period_filter %}'
      cur2.line_item_usage_account_name: '{% parameter account_filter %}'
      cur2.total_unblended_cost: '>{% parameter minimum_cost_filter %}'
    having_filters:
      cost_z_score: '>2,-2'
    sorts: [cost_z_score desc]
    limit: 100
    column_limit: 50
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
    - type: equal to
      value: Immediate
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: priority-alerts
          label: Priority Alerts
          type: categorical
          colors: ['#dc2626', '#f59e0b', '#16a34a', '#6b7280', '#e5e7eb']
      bold: true
      italic: false
      strikethrough: false
      fields: [investigation_priority]
    - type: equal to
      value: High
      background_color: '#f59e0b'
      font_color: '#000000'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: false
      italic: false
      strikethrough: false
      fields: [investigation_priority]
    - type: equal to
      value: Extreme High
      background_color: '#dc2626'
      font_color: '#ffffff'
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: true
      italic: false
      strikethrough: false
      fields: [anomaly_type]
    width: 16
    height: 12
    row: 30
    col: 0

  filters:
  - name: Analysis Period
    title: Analysis Period
    type: field_filter
    default_value: '3 months ago for 3 months'
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
    title: AWS Account
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_account_name

  - name: Anomaly Threshold (% Change)
    title: Anomaly Threshold (% Change)
    type: number_filter
    default_value: '50'
    allow_multiple_values: false
    required: false

  - name: Minimum Cost for Analysis ($)
    title: Minimum Cost for Analysis ($)
    type: number_filter
    default_value: '100'
    allow_multiple_values: false
    required: false