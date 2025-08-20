---
- dashboard: capacity_planning_utilization
  title: ⚡ Capacity Planning & Utilization
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Strategic capacity planning, utilization monitoring, and resource allocation optimization across AWS infrastructure'
  elements:
  - title: Total Provisioned Capacity
    name: total_provisioned_capacity
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_provisioned_capacity]
    filters:
      cur2.line_item_usage_start_date: '90 days ago for 90 days'
    custom_color_enabled: true
    custom_color: '#1A73E8'
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs Previous Period
    single_value_title: Provisioned Capacity
    value_format: '#,##0'
    listen:
      Planning Horizon: cur2.line_item_usage_start_date
      Capacity Metric: cur2.capacity_metric_type
      Utilization Threshold: cur2.utilization_threshold_filter
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 0
    col: 0
    width: 6
    height: 4

  - title: Current Utilization Rate
    name: current_utilization_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.current_utilization_rate]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 90
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    - type: between
      value: [70, 90]
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [40, 70]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 40
      background_color: '#9AA0A6'
      font_color: '#FFFFFF'
    single_value_title: Current Utilization
    value_format: '0.1"%"'
    listen:
      Capacity Metric: cur2.capacity_metric_type
      Utilization Threshold: cur2.utilization_threshold_filter
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 0
    col: 6
    width: 6
    height: 4

  - title: Capacity Headroom
    name: capacity_headroom
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.capacity_headroom_percentage]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 30
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [15, 30]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 15
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Headroom
    value_format: '0.1"%"'
    listen:
      Capacity Metric: cur2.capacity_metric_type
      Utilization Threshold: cur2.utilization_threshold_filter
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 0
    col: 12
    width: 6
    height: 4

  - title: 30-Day Capacity Projection
    name: projected_capacity_need
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.projected_capacity_need_30d]
    filters:
      cur2.line_item_usage_start_date: '90 days ago for 90 days'
    custom_color_enabled: true
    custom_color: '#FF6D01'
    show_single_value_title: true
    show_comparison: false
    single_value_title: 30d Projection
    value_format: '#,##0'
    listen:
      Planning Horizon: cur2.line_item_usage_start_date
      Capacity Metric: cur2.capacity_metric_type
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 0
    col: 18
    width: 6
    height: 4

  - title: Real-Time Utilization Monitoring (Last 24 Hours)
    name: realtime_utilization_monitoring
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_hour, cur2.cpu_utilization, cur2.memory_utilization, cur2.disk_utilization, cur2.network_utilization]
    fill_fields: [cur2.line_item_usage_start_hour]
    filters:
      cur2.line_item_usage_start_date: '24 hours ago for 24 hours'
    sorts: [cur2.line_item_usage_start_hour]
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
    - label: Utilization Percentage
      orientation: left
      series:
      - axisId: cur2.cpu_utilization
        id: cur2.cpu_utilization
        name: CPU
      - axisId: cur2.memory_utilization
        id: cur2.memory_utilization
        name: Memory
      - axisId: cur2.disk_utilization
        id: cur2.disk_utilization
        name: Disk
      - axisId: cur2.network_utilization
        id: cur2.network_utilization
        name: Network
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
      minValue: 0
      maxValue: 100
    reference_lines:
    - reference_type: line
      line_value: 80
      range_start: max
      range_end: min
      margin_top: deviation
      margin_value: mean
      margin_bottom: deviation
      label_position: right
      color: '#EA4335'
      label: Threshold
    series_colors:
      cur2.cpu_utilization: '#1A73E8'
      cur2.memory_utilization: '#34A853'
      cur2.disk_utilization: '#FBBC04'
      cur2.network_utilization: '#9C27B0'
    x_axis_label: Hour
    y_axis_label: 'Utilization %'
    listen:
      Capacity Metric: cur2.capacity_metric_type
      Utilization Threshold: cur2.utilization_threshold_filter
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 4
    col: 0
    width: 12
    height: 8

  - title: Capacity Utilization Distribution by Service
    name: capacity_utilization_distribution
    model: aws_billing
    explore: cur2
    type: looker_boxplot
    fields: [cur2.line_item_product_code, cur2.utilization_percentage]
    filters:
      cur2.line_item_usage_start_date: '90 days ago for 90 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.line_item_product_code]
    limit: 500
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    y_axis_combined: true
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b4c6
    x_axis_label: AWS Service
    y_axis_label: 'Utilization %'
    listen:
      Planning Horizon: cur2.line_item_usage_start_date
      Capacity Metric: cur2.capacity_metric_type
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 4
    col: 12
    width: 12
    height: 8

  - title: Capacity Planning Forecast (Next 90 Days)
    name: capacity_planning_forecast
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.forecast_date, cur2.current_capacity, cur2.projected_demand, cur2.recommended_capacity, cur2.capacity_gap]
    filters:
      cur2.forecast_date: '30 days ago for 120 days'
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
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: '#808080'
    series_types:
      cur2.capacity_gap: line
    series_colors:
      cur2.current_capacity: '#4285F4'
      cur2.projected_demand: '#EA4335'
      cur2.recommended_capacity: '#34A853'
      cur2.capacity_gap: '#FBBC04'
    x_axis_label: Date
    y_axis_label: Capacity Units
    listen:
      Capacity Metric: cur2.capacity_metric_type
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 12
    col: 0
    width: 24
    height: 8

  - title: Resource Utilization Heatmap (Account x Service)
    name: resource_utilization_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_id, cur2.line_item_product_code, cur2.average_utilization_rate, cur2.peak_utilization_rate, cur2.capacity_efficiency_score]
    pivots: [cur2.line_item_product_code]
    filters:
      cur2.line_item_usage_start_date: '90 days ago for 90 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.line_item_usage_account_id, cur2.line_item_product_code]
    limit: 500
    column_limit: 15
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
          id: utilization-efficiency-scale
          label: Utilization Efficiency
          type: continuous
          stops:
          - color: '#EA4335'
            offset: 0
          - color: '#FBBC04'
            offset: 40
          - color: '#34A853'
            offset: 80
          - color: '#1A73E8'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: !!null ''
    series_cell_visualizations:
      cur2.average_utilization_rate:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    listen:
      Planning Horizon: cur2.line_item_usage_start_date
      Capacity Metric: cur2.capacity_metric_type
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 20
    col: 0
    width: 24
    height: 8

  - title: Capacity Optimization Opportunities
    name: capacity_optimization_opportunities
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.current_capacity, cur2.average_utilization_rate, cur2.recommended_capacity, cur2.optimization_type, cur2.potential_capacity_savings, cur2.implementation_effort, cur2.business_impact_risk]
    filters:
      cur2.line_item_usage_start_date: '90 days ago for 90 days'
      cur2.optimization_opportunity: 'yes'
    sorts: [cur2.potential_capacity_savings desc]
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
      value: downsize
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.optimization_type]
    - type: equal to
      value: upsize
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.optimization_type]
    - type: equal to
      value: rightsize
      background_color: '#1A73E8'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.optimization_type]
    - type: equal to
      value: low
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.business_impact_risk]
    - type: equal to
      value: medium
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.business_impact_risk]
    - type: equal to
      value: high
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.business_impact_risk]
    series_labels:
      cur2.line_item_resource_id: Resource ID
      cur2.line_item_product_code: Service
      cur2.current_capacity: Current
      cur2.average_utilization_rate: 'Utilization %'
      cur2.recommended_capacity: Recommended
      cur2.optimization_type: Action
      cur2.potential_capacity_savings: Savings
      cur2.implementation_effort: Effort
      cur2.business_impact_risk: Risk
    series_column_widths:
      cur2.line_item_resource_id: 180
      cur2.line_item_product_code: 100
      cur2.optimization_type: 100
      cur2.business_impact_risk: 100
    listen:
      Planning Horizon: cur2.line_item_usage_start_date
      Capacity Metric: cur2.capacity_metric_type
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 28
    col: 0
    width: 24
    height: 8

  - title: Capacity Scaling Events Timeline
    name: capacity_scaling_events
    model: aws_billing
    explore: cur2
    type: looker_timeline
    fields: [cur2.scaling_event_timestamp, cur2.line_item_resource_id, cur2.scaling_action, cur2.capacity_before, cur2.capacity_after, cur2.scaling_trigger, cur2.scaling_duration_minutes]
    filters:
      cur2.line_item_usage_start_date: '90 days ago for 90 days'
      cur2.scaling_event_timestamp: '-NULL'
    sorts: [cur2.scaling_event_timestamp desc]
    limit: 100
    groupBars: true
    labelSize: 10pt
    showLegend: true
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    series_colors:
      scale_up: '#34A853'
      scale_down: '#EA4335'
      scale_out: '#4285F4'
      scale_in: '#FBBC04'
      replace: '#9C27B0'
    listen:
      Planning Horizon: cur2.line_item_usage_start_date
      Environment: cur2.environment
      Resource Tier: cur2.resource_tier
    row: 36
    col: 0
    width: 24
    height: 6

  - name: capacity_planning_framework
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ## ⚡ Capacity Planning Framework

      **Strategic Planning Horizons**:
      - **Short-term (7-30 days)**: Immediate capacity adjustments
      - **Medium-term (1-6 months)**: Seasonal and growth planning
      - **Long-term (6+ months)**: Strategic infrastructure scaling

      **Key Capacity Metrics**:
      - **Utilization Rate**: Current resource usage efficiency
      - **Headroom**: Available capacity buffer
      - **Peak-to-Average**: Usage variability assessment
      - **Growth Rate**: Trend-based projection

      **Planning Methodologies**:
      - **Trend Analysis**: Historical growth patterns
      - **Seasonal Modeling**: Cyclical demand patterns
      - **Business Forecast**: Application-driven planning
      - **Scenario Planning**: What-if capacity modeling

      **Optimization Targets**:
      - **CPU**: 70-85% average utilization
      - **Memory**: 75-90% average utilization
      - **Storage**: 80-95% average utilization
      - **Network**: 60-80% average utilization
    row: 42
    col: 0
    width: 12
    height: 8

  - name: utilization_optimization_guide
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ## 🎯 Utilization Optimization Guide

      ### **High Utilization (>90%)**:
      - 🔴 **Risk**: Performance degradation, outages
      - 🚨 **Action**: Immediate capacity expansion
      - 📊 **Monitor**: Real-time performance metrics
      - ⚡ **Scale**: Auto-scaling enabled

      ### **Optimal Utilization (70-90%)**:
      - ✅ **Status**: Efficient resource usage
      - 📈 **Monitor**: Trend analysis
      - 🎯 **Maintain**: Current capacity levels
      - 📊 **Plan**: Future growth projections

      ### **Under-Utilization (40-70%)**:
      - 🟡 **Opportunity**: Cost optimization potential
      - 🔍 **Analyze**: Usage patterns and peaks
      - 📉 **Consider**: Downsizing options
      - 💰 **Calculate**: Potential savings

      ### **Low Utilization (<40%)**:
      - 🔴 **Issue**: Significant over-provisioning
      - 💸 **Impact**: High cost inefficiency
      - 🛠️ **Action**: Immediate rightsizing
      - 🔄 **Review**: Necessity of resources

      ### **Scaling Strategies**:
      - **Vertical**: Increase/decrease instance size
      - **Horizontal**: Add/remove instances
      - **Auto Scaling**: Dynamic capacity adjustment
      - **Scheduled**: Predictable capacity changes
      - **Predictive**: ML-based capacity planning
    row: 42
    col: 12
    width: 12
    height: 8

  filters:
  - name: Planning Horizon
    title: Planning Horizon
    type: field_filter
    default_value: '90 days ago for 90 days'
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

  - name: Capacity Metric
    title: Capacity Metric
    type: field_filter
    default_value: cpu_utilization
    allow_multiple_values: false
    required: false
    ui_config:
      type: tag_list
      display: popover
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.capacity_metric_type

  - name: Utilization Threshold
    title: 'Utilization Threshold (%)'
    type: number_filter
    default_value: '80'
    allow_multiple_values: false
    required: false

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

  - name: Resource Tier
    title: Resource Tier
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
    field: cur2.resource_tier