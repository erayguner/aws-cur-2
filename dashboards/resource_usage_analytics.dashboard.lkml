---
- dashboard: resource_usage_analytics
  title: 📊 Resource Usage Analytics
  layout: newspaper
  preferred_viewer: dashboards-next
  description: 'Comprehensive analysis of resource consumption amounts, utilization rates, and capacity metrics across AWS services'
  elements:
  - title: Total Usage Amount
    name: total_usage_amount
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_line_item_usage_amount]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    custom_color_enabled: true
    custom_color: '#1A73E8'
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    comparison_label: vs Previous Period
    single_value_title: Total Usage
    value_format: '#,##0.00'
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 0
    col: 0
    width: 6
    height: 4

  - title: Active Resources
    name: unique_resources_count
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_resources]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    custom_color_enabled: true
    custom_color: '#34A853'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Active Resources
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 0
    col: 6
    width: 6
    height: 4

  - title: Average Utilization Rate
    name: average_utilization_rate
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.average_utilization_rate]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#34A853'
      font_color: '#FFFFFF'
    - type: between
      value: [50, 80]
      background_color: '#FBBC04'
      font_color: '#000000'
    - type: less than
      value: 50
      background_color: '#EA4335'
      font_color: '#FFFFFF'
    single_value_title: Avg Utilization
    value_format: '0.0"%"'
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 0
    col: 12
    width: 6
    height: 4

  - title: Peak Usage Hour
    name: peak_usage_hour
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.peak_usage_hour_of_day]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
    custom_color_enabled: true
    custom_color: '#FF6D01'
    show_single_value_title: true
    show_comparison: false
    single_value_title: Peak Hour
    value_format: '0":00"'
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 0
    col: 18
    width: 6
    height: 4

  - title: Usage Amount by AWS Service
    name: service_usage_breakdown
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.line_item_product_code, cur2.total_line_item_usage_amount]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.total_line_item_usage_amount desc]
    limit: 15
    value_labels: legend
    label_type: labPer
    inner_radius: 40
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    series_colors:
      AmazonEC2: '#FF9900'
      AmazonRDS: '#4B9CD3'
      AmazonS3: '#8C4FFF'
      AWSLambda: '#FF6D01'
      AmazonEBS: '#8CC04B'
      AmazonCloudFront: '#FF4B4B'
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 4
    col: 0
    width: 12
    height: 8

  - title: Usage Amount Trends (Daily)
    name: usage_trends_timeline
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_line_item_usage_amount, cur2.line_item_product_code]
    pivots: [cur2.line_item_product_code]
    fill_fields: [cur2.line_item_usage_start_date]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.line_item_usage_start_date, cur2.line_item_product_code]
    limit: 500
    column_limit: 10
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
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b4c6
    x_axis_label: Date
    y_axis_label: Usage Amount
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 4
    col: 12
    width: 12
    height: 8

  - title: Detailed Usage Type Analysis
    name: usage_type_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.line_item_usage_type, cur2.line_item_operation, cur2.total_line_item_usage_amount, cur2.pricing_unit, cur2.count_unique_resources, cur2.average_daily_usage, cur2.peak_usage_amount]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.total_line_item_usage_amount desc]
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
          id: usage-intensity-scale
          label: Usage Intensity
          type: continuous
          stops:
          - color: '#E8F0FE'
            offset: 0
          - color: '#4285F4'
            offset: 50
          - color: '#1A73E8'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.total_line_item_usage_amount]
    series_labels:
      cur2.line_item_product_code: Service
      cur2.line_item_usage_type: Usage Type
      cur2.line_item_operation: Operation
      cur2.total_line_item_usage_amount: Total Usage
      cur2.pricing_unit: Unit
      cur2.count_unique_resources: Resources
      cur2.average_daily_usage: Daily Avg
      cur2.peak_usage_amount: Peak Usage
    series_column_widths:
      cur2.line_item_product_code: 120
      cur2.line_item_usage_type: 200
      cur2.line_item_operation: 150
      cur2.total_line_item_usage_amount: 120
      cur2.pricing_unit: 80
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 12
    col: 0
    width: 24
    height: 8

  - title: Hourly Usage Patterns (24-Hour View)
    name: hourly_usage_patterns
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_hour_of_day, cur2.total_line_item_usage_amount, cur2.average_hourly_usage]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.line_item_usage_hour_of_day]
    limit: 24
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
    - label: Usage Amount
      orientation: left
      series:
      - axisId: cur2.total_line_item_usage_amount
        id: cur2.total_line_item_usage_amount
        name: Total Usage
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Average Usage
      orientation: right
      series:
      - axisId: cur2.average_hourly_usage
        id: cur2.average_hourly_usage
        name: Average Usage
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      cur2.average_hourly_usage: line
    series_colors:
      cur2.total_line_item_usage_amount: '#4285F4'
      cur2.average_hourly_usage: '#EA4335'
    x_axis_label: Hour of Day
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 20
    col: 0
    width: 12
    height: 8

  - title: Resource Utilization by Account & Service
    name: resource_utilization_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_id, cur2.line_item_product_code, cur2.total_line_item_usage_amount, cur2.utilization_percentage]
    pivots: [cur2.line_item_product_code]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.line_item_usage_account_id, cur2.line_item_product_code]
    limit: 500
    column_limit: 20
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
          id: utilization-heatmap
          label: Utilization Heatmap
          type: continuous
          stops:
          - color: '#FFFFFF'
            offset: 0
          - color: '#FBBC04'
            offset: 50
          - color: '#EA4335'
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: !!null ''
    series_cell_visualizations:
      cur2.total_line_item_usage_amount:
        is_active: true
        palette:
          palette_id: 1e4d66b9-f066-4c33-b0b7-cc10b4810688
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 20
    col: 12
    width: 12
    height: 8

  - title: Usage Anomaly Detection & Outliers
    name: usage_anomaly_detection
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.total_line_item_usage_amount, cur2.usage_anomaly_score, cur2.baseline_usage_amount, cur2.usage_variance_percentage]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.usage_anomaly_score: '>50'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.usage_anomaly_score desc]
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
    x_axis_label: Baseline Usage Amount
    y_axis_label: Current Usage Amount
    hidden_fields: [cur2.line_item_resource_id]
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 28
    col: 0
    width: 12
    height: 8

  - title: Top Resource Consumers by Usage Amount
    name: top_resource_consumers
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_resource_id, cur2.line_item_product_code, cur2.line_item_usage_type, cur2.line_item_usage_account_id, cur2.total_line_item_usage_amount, cur2.percentage_of_total_usage, cur2.usage_growth_rate, cur2.last_usage_date]
    filters:
      cur2.line_item_usage_start_date: '7 days ago for 7 days'
      cur2.line_item_usage_amount: '>0'
    sorts: [cur2.total_line_item_usage_amount desc]
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
      value: 50
      background_color: '#EA4335'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_growth_rate]
    - type: between
      value: [10, 50]
      background_color: '#FBBC04'
      font_color: '#000000'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_growth_rate]
    - type: less than
      value: 10
      background_color: '#34A853'
      font_color: '#FFFFFF'
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.usage_growth_rate]
    series_labels:
      cur2.line_item_resource_id: Resource ID
      cur2.line_item_product_code: Service
      cur2.line_item_usage_type: Usage Type
      cur2.line_item_usage_account_id: Account
      cur2.total_line_item_usage_amount: Total Usage
      cur2.percentage_of_total_usage: '% of Total'
      cur2.usage_growth_rate: Growth Rate %
      cur2.last_usage_date: Last Used
    series_column_widths:
      cur2.line_item_resource_id: 200
      cur2.line_item_product_code: 100
      cur2.line_item_usage_type: 150
      cur2.total_line_item_usage_amount: 120
    listen:
      Usage Period: cur2.line_item_usage_start_date
      AWS Service: cur2.line_item_product_code
      Usage Type: cur2.line_item_usage_type
      AWS Account: cur2.line_item_usage_account_id
      AWS Region: cur2.line_item_availability_zone
    row: 28
    col: 12
    width: 12
    height: 8

  - name: usage_analytics_overview
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ## 📊 Resource Usage Analytics Overview

      **Usage Amount Analysis**:
      - Total consumption across all AWS services
      - Service-specific usage breakdowns
      - Resource-level consumption tracking
      - Utilization rate calculations

      **Pattern Detection**:
      - Hourly usage patterns (24-hour view)
      - Daily, weekly, and monthly trends
      - Seasonal usage variations
      - Peak usage identification

      **Anomaly Detection**:
      - Usage spikes and drops
      - Baseline variance analysis
      - Resource consumption outliers
      - Growth rate monitoring

      **Key Metrics**:
      - **Usage Amount**: Raw consumption quantities
      - **Utilization Rate**: Efficiency of resource usage
      - **Growth Rate**: Period-over-period changes
      - **Anomaly Score**: Deviation from baseline patterns
    row: 36
    col: 0
    width: 12
    height: 8

  - name: usage_optimization_insights
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ## 🎯 Usage Optimization Insights

      ### **High Utilization (>80%)**:
      - ✅ **Excellent efficiency**
      - ✅ **Right-sized resources**
      - ⚠️ **Monitor for capacity constraints**
      - 📊 **Consider scaling strategies**

      ### **Medium Utilization (50-80%)**:
      - 🟡 **Good baseline usage**
      - 🔍 **Investigate optimization opportunities**
      - 📈 **Track usage trends**
      - ⚡ **Potential for auto-scaling**

      ### **Low Utilization (<50%)**:
      - 🔴 **Over-provisioned resources**
      - 💰 **Cost optimization opportunity**
      - 📉 **Consider downsizing**
      - 🛑 **Review necessity**

      ### **Usage Pattern Analysis**:
      - **Peak Hours**: Schedule-based scaling
      - **Consistent Usage**: Reserved capacity
      - **Sporadic Usage**: On-demand optimization
      - **Seasonal Patterns**: Predictive scaling

      ### **Anomaly Response**:
      - **Sudden Spikes**: Investigate application changes
      - **Gradual Increases**: Plan capacity expansion
      - **Usage Drops**: Check for service issues
      - **Irregular Patterns**: Review automation logic
    row: 36
    col: 12
    width: 12
    height: 8

  filters:
  - name: Usage Period
    title: Usage Analysis Period
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

  - name: AWS Service
    title: AWS Service
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
    field: cur2.line_item_product_code

  - name: Usage Type
    title: Usage Type Category
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
    field: cur2.line_item_usage_type

  - name: AWS Account
    title: AWS Account
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
    field: cur2.line_item_usage_account_id

  - name: AWS Region
    title: AWS Region
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
    field: cur2.line_item_availability_zone