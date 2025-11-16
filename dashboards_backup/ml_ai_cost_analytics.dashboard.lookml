---
# =====================================================
# ML/AI SERVICES COST ANALYTICS DASHBOARD
# =====================================================
# Comprehensive cost analysis for AWS ML/AI services
# SageMaker, Bedrock, Comprehend, Textract, Rekognition, etc.
# 
# Author: Claude Dashboard Generator
# Last Updated: 2025-08-20
# =====================================================

- dashboard: ml_ai_cost_analytics
  title: 🤖 ML/AI Services Cost Analytics
  description: 'Comprehensive cost analysis and optimization dashboard for AWS Machine Learning and AI services'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Performance optimizations
  auto_run: false
  refresh: 30 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  # Professional dashboard styling with color-blind friendly design
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'
  
  filters:
  - name: Time Period
    title: 📅 Analysis Period
    type: field_filter
    default_value: '30 days ago for 30 days'
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options:
        - '7 days ago for 7 days'
        - '30 days ago for 30 days'
        - '90 days ago for 90 days'
        - '6 months ago for 6 months'
        - '1 year ago for 1 year'
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: AWS Account
    title: 🏢 AWS Account
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

  - name: ML Service
    title: 🤖 ML/AI Service
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.ml_service_type

  - name: Cost Threshold
    title: 💰 Minimum Cost ($)
    type: field_filter
    default_value: '1'
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
      min: 0
      max: 10000
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.total_unblended_cost

  elements:
  # =====================================================
  # EXECUTIVE SUMMARY METRICS
  # =====================================================
  
  - title: 💰 Total ML/AI Spend
    name: total_ml_spend
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_ml_ai_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: TOTAL ML/AI SPEND
    value_format: "$#,##0.00"
    font_size: large
    text_color: '#1f77b4'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 0
    width: 3
    height: 4

  - title: 🚀 SageMaker Cost
    name: sagemaker_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.sagemaker_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: SAGEMAKER
    value_format: "$#,##0.00"
    font_size: large
    text_color: '#ff7f0e'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 3
    width: 3
    height: 4

  - title: 🧠 Bedrock Cost
    name: bedrock_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.bedrock_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: BEDROCK
    value_format: "$#,##0.00"
    font_size: large
    text_color: '#9467bd'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 6
    width: 3
    height: 4

  - title: 👁️ Computer Vision
    name: computer_vision_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.computer_vision_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: VISION SERVICES
    value_format: "$#,##0.00"
    font_size: large
    text_color: '#8c564b'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 9
    width: 3
    height: 4

  - title: 💬 Language Services
    name: language_services_cost
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.language_services_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: LANGUAGE SERVICES
    value_format: "$#,##0.00"
    font_size: large
    text_color: '#e377c2'
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 0
    col: 12
    width: 4
    height: 4

  # =====================================================
  # ML LIFECYCLE ANALYSIS
  # =====================================================

  - title: 🔄 ML Lifecycle Costs (Training vs Inference)
    name: ml_lifecycle_costs
    model: aws_billing
    explore: cur2
    type: looker_pie
    fields: [cur2.ml_lifecycle_stage, cur2.total_unblended_cost]
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    column_limit: 50
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: ml-lifecycle-colors
        label: ML Lifecycle Colors (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue - Training
          offset: 0
        - color: '#ff7f0e'  # Safe orange - Inference
          offset: 1
        - color: '#9467bd'  # Safe purple - Development
          offset: 2
        - color: '#8c564b'  # Safe brown - Data Processing
          offset: 3
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 0
    width: 8
    height: 6

  - title: 📊 ML Services Cost Distribution
    name: ml_services_distribution
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.ml_usage_hours]
    filters:
      cur2.line_item_product_code: 'AmazonSageMaker,AmazonBedrock,AmazonTextract,AmazonRekognition,AmazonComprehend,AmazonLex,AmazonPolly,AmazonTranscribe,AmazonTranslate,AmazonPersonalize'
    sorts: [cur2.total_unblended_cost desc]
    limit: 10
    column_limit: 50
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
    plot_size_by_dimension: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
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
    - label: Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_unblended_cost
        id: cur2.total_unblended_cost
        name: Total Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Usage Hours
      orientation: right
      series:
      - axisId: cur2.ml_usage_hours
        id: cur2.ml_usage_hours
        name: Usage Hours
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: ml-services-colors
        label: ML Services Colors (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue
          offset: 0
        - color: '#ff7f0e'  # Safe orange
          offset: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 4
    col: 8
    width: 8
    height: 6

  # =====================================================
  # USAGE PATTERNS AND OPTIMIZATION
  # =====================================================

  - title: 🚀 SageMaker Instance Usage Analysis
    name: sagemaker_instance_analysis
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.sagemaker_instance_type, cur2.total_unblended_cost, cur2.ml_usage_hours,
             cur2.sagemaker_cost_per_hour, cur2.ml_efficiency_score, cur2.ml_utilization_rate]
    filters:
      cur2.line_item_product_code: 'AmazonSageMaker'
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
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
    conditional_formatting:
    # Color-blind friendly: High cost instances
    - type: greater than
      value: 1000
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.total_unblended_cost]
    - type: between
      value: [100, 1000]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.total_unblended_cost]
    # Efficiency highlighting
    - type: greater than
      value: 80
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.ml_efficiency_score]
    - type: less than
      value: 50
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.ml_efficiency_score]
    # Utilization highlighting
    - type: greater than
      value: 90
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.ml_utilization_rate]
    - type: less than
      value: 30
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.ml_utilization_rate]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 10
    col: 0
    width: 16
    height: 8

  # =====================================================
  # TRENDS AND FORECASTING
  # =====================================================

  - title: 📈 ML/AI Cost Trends Over Time
    name: ml_cost_trends
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.total_ml_ai_cost, cur2.sagemaker_cost,
             cur2.bedrock_cost, cur2.computer_vision_cost, cur2.language_services_cost]
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
    column_limit: 50
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
    plot_size_by_dimension: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: ml-trends-colorblind
        label: ML Trends (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue
          offset: 0
        - color: '#ff7f0e'  # Safe orange
          offset: 1
        - color: '#9467bd'  # Safe purple
          offset: 2
        - color: '#8c564b'  # Safe brown
          offset: 3
        - color: '#e377c2'  # Safe pink
          offset: 4
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 18
    col: 0
    width: 16
    height: 8

  # =====================================================
  # MODEL USAGE AND OPTIMIZATION
  # =====================================================

  - title: 🧠 Bedrock Model Usage Analysis
    name: bedrock_model_usage
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.bedrock_model_name, cur2.total_unblended_cost, cur2.bedrock_input_tokens,
             cur2.bedrock_output_tokens, cur2.bedrock_cost_per_1k_tokens, cur2.bedrock_model_efficiency]
    filters:
      cur2.line_item_product_code: 'AmazonBedrock'
    sorts: [cur2.total_unblended_cost desc]
    limit: 15
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
    conditional_formatting:
    # Cost per token highlighting
    - type: greater than
      value: 0.1
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.bedrock_cost_per_1k_tokens]
    - type: less than
      value: 0.01
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.bedrock_cost_per_1k_tokens]
    # Token volume highlighting
    - type: greater than
      value: 1000000
      background_color: '#e6f2ff'  # Very light blue
      font_color: '#0052cc'  # Medium blue
      bold: true
      fields: [cur2.bedrock_input_tokens, cur2.bedrock_output_tokens]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 26
    col: 0
    width: 8
    height: 8

  - title: 🎯 ML Service Optimization Opportunities
    name: ml_optimization_opportunities
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.ml_optimization_potential,
             cur2.ml_rightsizing_savings, cur2.ml_efficiency_score, cur2.ml_cost_trend]
    filters:
      cur2.line_item_product_code: 'AmazonSageMaker,AmazonBedrock,AmazonTextract,AmazonRekognition,AmazonComprehend'
    sorts: [cur2.ml_optimization_potential desc]
    limit: 10
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
    conditional_formatting:
    # Optimization potential highlighting
    - type: greater than
      value: 30
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.ml_optimization_potential]
    - type: between
      value: [10, 30]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.ml_optimization_potential]
    # Savings potential highlighting
    - type: greater than
      value: 500
      background_color: '#cce5ff'  # Light blue
      font_color: '#003d82'  # Dark blue
      bold: true
      fields: [cur2.ml_rightsizing_savings]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 26
    col: 8
    width: 8
    height: 8

  # =====================================================
  # TEAM AND PROJECT BREAKDOWN
  # =====================================================

  - title: 👥 ML/AI Spending by Team
    name: ml_spending_by_team
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.total_ml_ai_cost, cur2.ml_project_count, cur2.ml_efficiency_score]
    sorts: [cur2.total_ml_ai_cost desc]
    limit: 15
    column_limit: 50
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
    plot_size_by_dimension: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
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
    - label: ML/AI Cost ($)
      orientation: left
      series:
      - axisId: cur2.total_ml_ai_cost
        id: cur2.total_ml_ai_cost
        name: ML/AI Cost
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: Project Count
      orientation: right
      series:
      - axisId: cur2.ml_project_count
        id: cur2.ml_project_count
        name: ML Projects
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: team-ml-colors
        label: Team ML Colors (Colorblind Safe)
        type: categorical
        stops:
        - color: '#1f77b4'  # Safe blue
          offset: 0
        - color: '#ff7f0e'  # Safe orange
          offset: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 34
    col: 0
    width: 16
    height: 8

  # =====================================================
  # RECOMMENDATIONS AND ALERTS
  # =====================================================

  - title: ⚠️ ML/AI Cost Anomalies and Recommendations
    name: ml_cost_anomalies
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.line_item_usage_account_name, cur2.total_unblended_cost,
             cur2.ml_cost_anomaly_score, cur2.ml_optimization_recommendation, cur2.ml_cost_trend]
    filters:
      cur2.ml_cost_anomaly_score: '>50'
    sorts: [cur2.ml_cost_anomaly_score desc]
    limit: 20
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting:
    # Anomaly score highlighting
    - type: greater than
      value: 80
      background_color: '#ffcccc'  # Light red-pink
      font_color: '#8b0000'  # Dark red
      bold: true
      fields: [cur2.ml_cost_anomaly_score]
    - type: between
      value: [60, 80]
      background_color: '#ffe5b4'  # Light orange
      font_color: '#8b4513'  # Dark brown
      bold: true
      fields: [cur2.ml_cost_anomaly_score]
    - type: between
      value: [50, 60]
      background_color: '#fff2cc'  # Light yellow
      font_color: '#bf9000'  # Dark yellow
      bold: true
      fields: [cur2.ml_cost_anomaly_score]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      ML Service: cur2.ml_service_type
      Cost Threshold: cur2.total_unblended_cost
    row: 42
    col: 0
    width: 16
    height: 10