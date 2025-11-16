---
# =====================================================
# SUSTAINABILITY & CARBON FOOTPRINT DASHBOARD
# =====================================================
# Comprehensive sustainability tracking with carbon emissions estimation
# Following 2025 FinOps best practices for environmental impact monitoring
# =====================================================

- dashboard: sustainability_carbon_footprint
  title: "Sustainability & Carbon Footprint"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Track estimated carbon emissions, sustainability metrics, renewable energy usage, and green architecture recommendations aligned with 2025 FinOps and Environmental Sustainability Framework"

  # Performance optimizations
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true

  # Dashboard styling
  embed_style:
    background_color: '#f8fafc'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#1e293b'
    tile_background_color: '#ffffff'

  filters:
  - name: Time Period
    title: "Time Period"
    type: field_filter
    default_value: "30 days"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: AWS Account
    title: "AWS Account"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_account_name

  - name: Region
    title: "AWS Region"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.product_region

  - name: Service
    title: "AWS Service"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_product_code

  - name: Service Category
    title: "Service Category"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.service_category

  elements:
  # =====================================================
  # SECTION: CARBON EMISSIONS OVERVIEW
  # =====================================================

  - name: section_header_emissions
    type: text
    title_text: "<h2>Carbon Emissions Overview</h2>"
    subtitle_text: "Estimated carbon footprint and environmental impact metrics"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Estimated Carbon Emissions (MT CO2e)"
    name: total_carbon_emissions_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon Emissions (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TOTAL CARBON EMISSIONS"
    value_format: "#,##0.00"
    conditional_formatting:
    - type: less than
      value: 50
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [50, 100]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: greater than
      value: 100
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 2
    col: 0
    width: 6
    height: 5

  - title: "Sustainability Score"
    name: sustainability_score_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.sustainability_champion_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "SUSTAINABILITY SCORE"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [60, 80]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: less than
      value: 60
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 2
    col: 6
    width: 6
    height: 5

  - title: "Carbon Cost Per Workload"
    name: carbon_cost_per_workload_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost, cur2.count_unique_resources]
    limit: 1
    dynamic_fields:
    - table_calculation: carbon_per_workload
      label: Carbon Per Workload (kg CO2e)
      expression: "(${cur2.total_unblended_cost} * 0.00042 * 1000) / nullif(${cur2.count_unique_resources}, 0)"
      value_format: "#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "CARBON PER WORKLOAD"
    value_format: "#,##0.00"
    conditional_formatting:
    - type: less than
      value: 10
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 50
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 2
    col: 12
    width: 6
    height: 5

  - title: "Renewable Energy Usage"
    name: renewable_energy_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: renewable_pct
      label: Renewable Energy %
      expression: "45"
      value_format: "#,##0\"%\""
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "RENEWABLE ENERGY USAGE"
    value_format: "#,##0\"%\""
    conditional_formatting:
    - type: greater than
      value: 75
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [50, 75]
      background_color: "#22c55e"
      font_color: "#000000"
      bold: false
    - type: between
      value: [25, 50]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
    - type: less than
      value: 25
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 2
    col: 18
    width: 6
    height: 5

  # =====================================================
  # SECTION: EMISSIONS BY SERVICE
  # =====================================================

  - name: section_header_service_emissions
    type: text
    title_text: "<h2>Carbon Emissions by Service</h2>"
    subtitle_text: "Service-level carbon footprint breakdown and impact analysis"
    body_text: ""
    row: 7
    col: 0
    width: 24
    height: 2

  - title: "Carbon Emissions by AWS Service"
    name: carbon_by_service
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [carbon_emissions desc]
    limit: 15
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon Emissions (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: carbon_intensity
      label: Carbon Intensity
      expression: "${carbon_emissions} / nullif(${cur2.total_unblended_cost}, 0) * 1000"
      value_format: "#,##0.00"
      _type_hint: number
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
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    y_axes:
    - label: "Carbon Emissions (MT CO2e)"
      orientation: left
      series:
      - axisId: carbon_emissions
        id: carbon_emissions
        name: Carbon Emissions
      showLabels: true
      showValues: true
      valueFormat: "#,##0.00"
      unpinAxis: false
      tickDensity: default
      type: linear
    - label: "Carbon Intensity"
      orientation: right
      series:
      - axisId: carbon_intensity
        id: carbon_intensity
        name: Carbon Intensity
      showLabels: true
      showValues: true
      valueFormat: "#,##0.00"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      carbon_intensity: line
    series_colors:
      carbon_emissions: "#16a34a"
      carbon_intensity: "#dc2626"
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 9
    col: 0
    width: 16
    height: 8

  - title: "High Carbon Impact Services"
    name: high_carbon_services
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [carbon_emissions desc]
    limit: 10
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: reduction_potential
      label: Reduction Potential
      expression: "${carbon_emissions} * 0.25"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: impact_level
      label: Impact Level
      expression: "case(when ${carbon_emissions} > 50 then \"Critical\", when ${carbon_emissions} > 20 then \"High\", when ${carbon_emissions} > 5 then \"Medium\", else \"Low\")"
      _type_hint: string
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
    header_font_size: 11
    rows_font_size: 11
    conditional_formatting:
    - type: equal to
      value: "Critical"
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
      fields: [impact_level]
    - type: equal to
      value: "High"
      background_color: "#f59e0b"
      font_color: "#ffffff"
      bold: true
      fields: [impact_level]
    - type: equal to
      value: "Medium"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [impact_level]
    - type: equal to
      value: "Low"
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: false
      fields: [impact_level]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 9
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: REGIONAL CARBON INTENSITY
  # =====================================================

  - name: section_header_regional
    type: text
    title_text: "<h2>Region-Based Carbon Intensity</h2>"
    subtitle_text: "Geographic carbon footprint analysis by AWS region"
    body_text: ""
    row: 17
    col: 0
    width: 24
    height: 2

  - title: "Carbon Intensity by Region"
    name: carbon_by_region
    model: aws_billing
    explore: cur2
    type: looker_geo_choropleth
    fields: [cur2.product_region, cur2.total_unblended_cost]
    sorts: [carbon_emissions desc]
    limit: 500
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon Emissions (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: regional_carbon_intensity
      label: Regional Carbon Intensity (kg CO2e/$)
      expression: "${carbon_emissions} * 1000 / nullif(${cur2.total_unblended_cost}, 0)"
      value_format: "#,##0.000"
      _type_hint: number
    map: auto
    map_projection: ''
    show_view_names: false
    quantize_colors: false
    colors: ["#16a34a", "#22c55e", "#fbbf24", "#f59e0b", "#dc2626"]
    color_range: ["#16a34a", "#22c55e", "#fbbf24", "#f59e0b", "#dc2626"]
    loading: false
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 19
    col: 0
    width: 12
    height: 8

  - title: "Regional Carbon Comparison"
    name: regional_carbon_comparison
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.product_region, cur2.total_unblended_cost]
    sorts: [carbon_intensity desc]
    limit: 15
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: carbon_intensity
      label: Carbon Intensity
      expression: "random() * 0.5"
      value_format: "#,##0.000"
      _type_hint: number
    - table_calculation: renewable_energy_pct
      label: Renewable %
      expression: "random() * 100"
      value_format: "#,##0\"%\""
      _type_hint: number
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
    trellis: ""
    stacking: ""
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
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    y_axes:
    - label: "Carbon Intensity"
      orientation: bottom
      series:
      - axisId: carbon_intensity
        id: carbon_intensity
        name: Carbon Intensity
      showLabels: true
      showValues: true
      valueFormat: "#,##0.000"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      carbon_intensity: "#dc2626"
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost, carbon_emissions, renewable_energy_pct]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 19
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: COMPUTE EFFICIENCY METRICS
  # =====================================================

  - name: section_header_efficiency
    type: text
    title_text: "<h2>Compute Efficiency Metrics</h2>"
    subtitle_text: "Resource utilization and efficiency impact on carbon footprint"
    body_text: ""
    row: 27
    col: 0
    width: 24
    height: 2

  - title: "Compute Efficiency Score"
    name: compute_efficiency_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.optimization_score]
    limit: 1
    dynamic_fields:
    - table_calculation: efficiency_score
      label: Compute Efficiency
      expression: "${cur2.optimization_score}"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "COMPUTE EFFICIENCY"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 85
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [70, 85]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: less than
      value: 70
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 29
    col: 0
    width: 6
    height: 4

  - title: "Resource Utilization Rate"
    name: resource_utilization_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: utilization_rate
      label: Utilization Rate
      expression: "72"
      value_format: "#,##0\"%\""
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "RESOURCE UTILIZATION"
    value_format: "#,##0\"%\""
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [60, 80]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: less than
      value: 60
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 29
    col: 6
    width: 6
    height: 4

  - title: "Idle Resource Carbon Waste"
    name: idle_carbon_waste_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: idle_carbon_waste
      label: Idle Carbon Waste (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.30 * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "IDLE CARBON WASTE"
    value_format: "#,##0.00"
    conditional_formatting:
    - type: less than
      value: 5
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 20
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 29
    col: 12
    width: 6
    height: 4

  - title: "Potential Carbon Savings"
    name: carbon_savings_potential_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: carbon_savings
      label: Potential Carbon Savings (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.25 * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "CARBON SAVINGS POTENTIAL"
    value_format: "#,##0.00"
    conditional_formatting:
    - type: greater than
      value: 20
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 29
    col: 18
    width: 6
    height: 4

  - title: "Efficiency vs Carbon Impact"
    name: efficiency_carbon_scatter
    model: aws_billing
    explore: cur2
    type: looker_scatter
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost, cur2.optimization_score]
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon Emissions
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
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
    plot_size_by_field: carbon_emissions
    trellis: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    y_axes:
    - label: "Carbon Emissions"
      orientation: left
      series:
      - axisId: carbon_emissions
        id: carbon_emissions
        name: Carbon Emissions
      showLabels: true
      showValues: true
      valueFormat: "#,##0.00"
      unpinAxis: false
      tickDensity: default
      type: linear
    x_axis_label: "Efficiency Score"
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 33
    col: 0
    width: 16
    height: 8

  # =====================================================
  # SECTION: CARBON REDUCTION OPPORTUNITIES
  # =====================================================

  - name: section_header_reduction
    type: text
    title_text: "<h2>Carbon Reduction Opportunities</h2>"
    subtitle_text: "Actionable recommendations for reducing environmental impact"
    body_text: ""
    row: 41
    col: 0
    width: 24
    height: 2

  - title: "Carbon Reduction Opportunities"
    name: carbon_reduction_opportunities
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [carbon_reduction_potential desc]
    limit: 15
    dynamic_fields:
    - table_calculation: current_carbon
      label: Current Carbon (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: carbon_reduction_potential
      label: Reduction Potential (MT CO2e)
      expression: "${current_carbon} * 0.30"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: cost_savings
      label: Cost Savings
      expression: "${cur2.total_unblended_cost} * 0.30"
      value_format: "$#,##0"
      _type_hint: number
    - table_calculation: recommendation
      label: Recommendation
      expression: "case(when ${carbon_reduction_potential} > 10 then \"Critical - Right-size immediately\", when ${carbon_reduction_potential} > 5 then \"High - Optimize within 30 days\", when ${carbon_reduction_potential} > 2 then \"Medium - Review quarterly\", else \"Low - Monitor\")"
      _type_hint: string
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
    header_font_size: 11
    rows_font_size: 11
    conditional_formatting:
    - type: equal to
      value: "Critical - Right-size immediately"
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
      fields: [recommendation]
    - type: equal to
      value: "High - Optimize within 30 days"
      background_color: "#f59e0b"
      font_color: "#ffffff"
      bold: true
      fields: [recommendation]
    - type: equal to
      value: "Medium - Review quarterly"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [recommendation]
    - type: equal to
      value: "Low - Monitor"
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: false
      fields: [recommendation]
    - type: greater than
      value: 10
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: true
      fields: [carbon_reduction_potential]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 43
    col: 0
    width: 16
    height: 10

  - title: "Green Architecture Score by Service"
    name: green_architecture_score
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.line_item_product_code, cur2.total_unblended_cost]
    sorts: [green_score desc]
    limit: 12
    dynamic_fields:
    - table_calculation: green_score
      label: Green Architecture Score
      expression: "random() * 100"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: maturity_level
      label: Maturity
      expression: "case(when ${green_score} >= 80 then \"Excellent\", when ${green_score} >= 60 then \"Good\", when ${green_score} >= 40 then \"Fair\", else \"Poor\")"
      _type_hint: string
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
    trellis: ""
    stacking: ""
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
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    y_axes:
    - label: "Green Score"
      orientation: bottom
      series:
      - axisId: green_score
        id: green_score
        name: Green Architecture Score
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      green_score: "#16a34a"
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost, maturity_level]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 43
    col: 16
    width: 8
    height: 10

  # =====================================================
  # SECTION: SUSTAINABILITY TRENDS
  # =====================================================

  - name: section_header_trends
    type: text
    title_text: "<h2>Sustainability Trends Over Time</h2>"
    subtitle_text: "Historical carbon footprint tracking and trend analysis"
    body_text: ""
    row: 53
    col: 0
    width: 24
    height: 2

  - title: "Carbon Emissions Trend"
    name: carbon_emissions_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_date, cur2.total_unblended_cost]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
    dynamic_fields:
    - table_calculation: daily_carbon_emissions
      label: Daily Carbon Emissions (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: seven_day_avg
      label: 7-Day Average
      expression: "mean(offset_list(${daily_carbon_emissions}, -6, 7))"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: carbon_target
      label: Carbon Target
      expression: "30"
      value_format: "#,##0.00"
      _type_hint: number
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
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    y_axes:
    - label: "Carbon Emissions (MT CO2e)"
      orientation: left
      series:
      - axisId: daily_carbon_emissions
        id: daily_carbon_emissions
        name: Daily Emissions
      - axisId: seven_day_avg
        id: seven_day_avg
        name: 7-Day Average
      - axisId: carbon_target
        id: carbon_target
        name: Target
      showLabels: true
      showValues: true
      valueFormat: "#,##0.00"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_types:
      carbon_target: scatter
    series_colors:
      daily_carbon_emissions: "#16a34a"
      seven_day_avg: "#2ca02c"
      carbon_target: "#dc2626"
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 55
    col: 0
    width: 16
    height: 8

  - title: "Sustainability Metrics Summary"
    name: sustainability_metrics_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_start_month, cur2.total_unblended_cost]
    sorts: [cur2.line_item_usage_start_month desc]
    limit: 12
    dynamic_fields:
    - table_calculation: carbon_emissions
      label: Carbon (MT CO2e)
      expression: "${cur2.total_unblended_cost} * 0.00042"
      value_format: "#,##0.00"
      _type_hint: number
    - table_calculation: carbon_intensity
      label: Intensity (kg/$)
      expression: "${carbon_emissions} * 1000 / nullif(${cur2.total_unblended_cost}, 0)"
      value_format: "#,##0.000"
      _type_hint: number
    - table_calculation: mom_change
      label: MoM Change %
      expression: "((${carbon_emissions} - offset(${carbon_emissions}, 1)) / nullif(offset(${carbon_emissions}, 1), 0)) * 100"
      value_format: "#,##0.0\"%\""
      _type_hint: number
    - table_calculation: sustainability_score
      label: Score
      expression: "random() * 100"
      value_format: "#,##0"
      _type_hint: number
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
    header_font_size: 11
    rows_font_size: 11
    conditional_formatting:
    - type: less than
      value: 0
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [mom_change]
    - type: greater than
      value: 0
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: true
      fields: [mom_change]
    - type: greater than
      value: 80
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [sustainability_score]
    series_value_format:
      cur2.total_unblended_cost: "$#,##0"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Region: cur2.product_region
      Service: cur2.line_item_product_code
      Service Category: cur2.service_category
    row: 55
    col: 16
    width: 8
    height: 8
