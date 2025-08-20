---
- dashboard: resource_usage_pattern_analysis
  title: 📈 Resource Usage Pattern Analysis
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Advanced pattern detection, behavioral analysis, and predictive insights for resource consumption across AWS services'
  elements:
  - title: Pattern Predictability Score
    name: pattern_predictability_score
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.pattern_predictability_score]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
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
    single_value_title: Predictability
    value_format: '0"%"'
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 0
    col: 0
    width: 6
    height: 4

  - title: Usage Volatility Index
    name: usage_volatility_index
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.usage_volatility_index]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: less than
      value: 20
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [20, 50]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: greater than
      value: 50
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Volatility Index
    value_format: '0.0'
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 0
    col: 6
    width: 6
    height: 4

  - title: Seasonal Pattern Strength
    name: seasonal_pattern_strength
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.seasonal_pattern_strength]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 70
      background_color: '#1A73E8'
      font_color: '#FFFFFF'
    - type: between
      value: [40, 70]
      background_color: '#4285F4'
      font_color: '#FFFFFF'
    - type: less than
      value: 40
      background_color: '#8AB4F8'
      font_color: '#000000'
    single_value_title: Seasonal Strength
    value_format: '0"%"'
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 0
    col: 12
    width: 6
    height: 4

  - title: Pattern Anomalies (30d)
    name: pattern_anomaly_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.pattern_anomaly_count]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: equal to
      value: 0
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [1, 5]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: greater than
      value: 5
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Anomalies
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 0
    col: 18
    width: 6
    height: 4

  - title: Weekly Usage Pattern Heatmap (Hour x Day)
    name: weekly_usage_pattern_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_hour_of_day, cur2.line_item_usage_day_of_week, cur2.average_usage_amount]
    pivots: [cur2.line_item_usage_day_of_week]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.line_item_usage_hour_of_day, cur2.line_item_usage_day_of_week]
    limit: 500
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
    header_text_alignment: center
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
          id: usage-heatmap
          label: Usage Intensity
          type: continuous
          stops:
          - color: '#E8F0FE'
            offset: 0
          - color: '#4285F4'
            offset: 30
          - color: '#1A73E8'
            offset: 60
          - color: '#0D47A1'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: !!null ''
    series_cell_visualizations:
      cur2.average_usage_amount:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 4
    col: 0
    width: 12
    height: 8

  - title: Usage Pattern Classification by Service
    name: usage_pattern_classification
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.usage_pattern_type, cur2.service_count]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
    sorts: [cur2.service_count desc]
    limit: 500
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    series_colors:
      Steady: '#34A853'
      Periodic: '#4285F4'
      Bursty: '#FBBC04'
      Random: '#EA4335'
      Seasonal: '#9C27B0'
      Declining: '#FF6D01'
      Growing: '#1A73E8'
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 4
    col: 12
    width: 12
    height: 8

  - title: Predictive Usage Forecast (Next 7 Days)
    name: predictive_usage_forecast
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.forecast_date, cur2.historical_usage_amount, cur2.predicted_usage_amount, cur2.confidence_interval_upper, cur2.confidence_interval_lower]
    filters:
      cur2.forecast_date: '7 days ago for 14 days'
    sorts: [cur2.forecast_date]
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
    show_null_points: false
    interpolation: linear
    series_types:
      cur2.confidence_interval_upper: area
      cur2.confidence_interval_lower: area
    series_colors:
      cur2.historical_usage_amount: '#1A73E8'
      cur2.predicted_usage_amount: '#EA4335'
      cur2.confidence_interval_upper: '#E8F0FE'
      cur2.confidence_interval_lower: '#E8F0FE'
    reference_lines:
    - reference_type: line
      line_value: mean
      range_start: max
      range_end: min
      margin_top: deviation
      margin_value: mean
      margin_bottom: deviation
      label_position: right
      color: '#000000'
    x_axis_label: Date
    y_axis_label: Usage Amount
    listen:
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 12
    col: 0
    width: 12
    height: 8

  - title: Service Usage Pattern Matrix
    name: service_usage_pattern_matrix
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_product_code, cur2.usage_consistency_score, cur2.peak_to_average_ratio, cur2.total_line_item_usage_amount, cur2.usage_pattern_type]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.total_line_item_usage_amount desc]
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
    plot_size_by_field: cur2.total_line_item_usage_amount
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: linear
    y_axis_combined: true
    show_null_points: false
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b4c6
      options:
        steps: 5
    x_axis_label: 'Usage Consistency Score (0-100)'
    y_axis_label: Peak-to-Average Ratio
    quadrants_enabled: true
    quadrant_lines:
    - x: 50
      y: 3
    quadrant_labels:
    - Inconsistent Low-Peak
    - Consistent Low-Peak
    - Inconsistent High-Peak
    - Consistent High-Peak
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 12
    col: 12
    width: 12
    height: 8

  - title: Pattern Stability Analysis by Time Period
    name: pattern_stability_analysis
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_start_week, cur2.pattern_stability_score, cur2.usage_variance_coefficient, cur2.pattern_change_events]
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
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    y_axes:
    - label: Stability Score / Variance Coefficient
      orientation: left
      series:
      - axisId: cur2.pattern_stability_score
        id: cur2.pattern_stability_score
        name: Stability Score
      - axisId: cur2.usage_variance_coefficient
        id: cur2.usage_variance_coefficient
        name: Variance Coefficient
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Pattern Change Events
      orientation: right
      series:
      - axisId: cur2.pattern_change_events
        id: cur2.pattern_change_events
        name: Change Events
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.pattern_change_events: line
    series_colors:
      cur2.pattern_stability_score: '#34A853'
      cur2.usage_variance_coefficient: '#FBBC04'
      cur2.pattern_change_events: '#EA4335'
    x_axis_label: Week
    listen:
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 20
    col: 0
    width: 24
    height: 8

  - title: Detailed Pattern Breakdown by Resource
    name: detailed_pattern_breakdown
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.usage_pattern_type, cur2.pattern_predictability_score, cur2.peak_usage_time, cur2.usage_frequency, cur2.seasonal_component, cur2.trend_component, cur2.noise_level]
    filters:
      cur2.line_item_usage_start_date: '30 days ago for 30 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.pattern_predictability_score desc]
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
    - type: equal to
      value: Steady
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_pattern_type]
    - type: equal to
      value: Periodic
      background_color: '#4285F4'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_pattern_type]
    - type: equal to
      value: Bursty
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_pattern_type]
    - type: equal to
      value: Random
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_pattern_type]
    series_labels:
      cur2.line_item_resource_id: Resource ID
      cur2.line_item_product_code: Service
      cur2.usage_pattern_type: Pattern Type
      cur2.pattern_predictability_score: 'Predictability %'
      cur2.peak_usage_time: Peak Time
      cur2.usage_frequency: Frequency
      cur2.seasonal_component: 'Seasonal %'
      cur2.trend_component: 'Trend %'
      cur2.noise_level: 'Noise %'
    series_column_widths:
      cur2.line_item_resource_id: 180
      cur2.line_item_product_code: 100
      cur2.usage_pattern_type: 100
      cur2.pattern_predictability_score: 100
      cur2.peak_usage_time: 100
    series_cell_visualizations:
      cur2.pattern_predictability_score:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    listen:
      Pattern Period: cur2.line_item_usage_start_date
      Pattern Granularity: cur2.pattern_analysis_granularity
      Service Category: cur2.service_category
      Workload Type: cur2.workload_type
    row: 28
    col: 0
    width: 24
    height: 8

  - name: pattern_analysis_methodology
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ## 📈 Usage Pattern Analysis Methodology

      **Pattern Classification Types**:
      - **Steady**: Consistent usage with minimal variation
      - **Periodic**: Regular cyclical patterns (daily/weekly)
      - **Bursty**: Irregular spikes with quiet periods
      - **Seasonal**: Long-term cyclical patterns (monthly/quarterly)
      - **Random**: No discernible pattern
      - **Trending**: Consistent growth or decline

      **Key Metrics**:
      - **Predictability Score**: How well future usage can be forecasted
      - **Volatility Index**: Measure of usage variation
      - **Consistency Score**: Reliability of usage patterns
      - **Peak-to-Average Ratio**: Usage intensity variation

      **Analysis Components**:
      - **Trend**: Long-term direction of usage
      - **Seasonality**: Recurring cyclical patterns
      - **Noise**: Random fluctuations in usage
      - **Anomalies**: Unexpected deviations from patterns
    row: 36
    col: 0
    width: 12
    height: 8

  - name: pattern_optimization_strategies
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ## 🎯 Pattern-Based Optimization Strategies

      ### **Steady Patterns (High Predictability)**:
      - ✅ **Reserved Instances**: Predictable capacity
      - ✅ **Savings Plans**: Long-term commitments
      - ✅ **Right-sizing**: Optimize for consistent load
      - 📊 **Baseline monitoring**: Detect deviations

      ### **Periodic Patterns (Cyclical Usage)**:
      - ⏰ **Scheduled Scaling**: Auto-scale on schedule
      - 🔄 **Predictive Scaling**: Anticipate demand
      - 💾 **Pre-scaling**: Prepare for known peaks
      - 📈 **Capacity Planning**: Size for peak periods

      ### **Bursty Patterns (Irregular Spikes)**:
      - ⚡ **Auto Scaling**: React to demand changes
      - 🎯 **Spot Instances**: Cost-effective burst capacity
      - 📊 **Monitoring**: Real-time usage tracking
      - 🛡️ **Burst Credits**: Manage burst capacity

      ### **Random Patterns (Unpredictable)**:
      - 🔍 **Investigation**: Identify root causes
      - 📊 **Enhanced Monitoring**: Deeper visibility
      - 🎛️ **Manual Control**: Avoid automation
      - 🔄 **Pattern Discovery**: Look for hidden patterns

      ### **Forecasting Applications**:
      - **Capacity Planning**: Future resource needs
      - **Budget Forecasting**: Predict usage costs
      - **Anomaly Detection**: Identify unusual behavior
      - **Optimization Timing**: When to apply changes
    row: 36
    col: 12
    width: 12
    height: 8

  filters:
  - name: Pattern Period
    title: Pattern Analysis Period
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

  - name: Pattern Granularity
    title: Pattern Granularity
    type: field_filter
    default_value: hourly
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_group
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.pattern_analysis_granularity

  - name: Service Category
    title: Service Category
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
    field: cur2.service_category

  - name: Workload Type
    title: Workload Type
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
    field: cur2.workload_type