---
# =====================================================
# FINOPS MATURITY & ADOPTION DASHBOARD
# =====================================================
# Comprehensive FinOps maturity assessment and practice adoption tracking
# Following 2025 FinOps Framework pillars: Inform, Optimize, Operate
# =====================================================

- dashboard: finops_maturity_adoption
  title: "FinOps Maturity & Adoption"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Track FinOps maturity progression through Crawl/Walk/Run stages, measure practice adoption across Inform, Optimize, and Operate pillars, and monitor team capability development aligned with 2025 FinOps Framework"

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

  elements:
  # =====================================================
  # SECTION: FINOPS MATURITY ASSESSMENT
  # =====================================================

  - name: section_header_maturity
    type: text
    title_text: "<h2>FinOps Maturity Assessment (Crawl/Walk/Run)</h2>"
    subtitle_text: "Organization-wide FinOps maturity scoring across all capabilities"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Overall FinOps Maturity Level"
    name: overall_maturity_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.finops_maturity_score]
    limit: 1
    dynamic_fields:
    - table_calculation: maturity_level
      label: Maturity Level
      expression: "case(when ${cur2.finops_maturity_score} >= 80 then \"Run\", when ${cur2.finops_maturity_score} >= 50 then \"Walk\", else \"Crawl\")"
      _type_hint: string
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "MATURITY LEVEL"
    conditional_formatting:
    - type: equal to
      value: "Run"
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: equal to
      value: "Walk"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: equal to
      value: "Crawl"
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 2
    col: 0
    width: 6
    height: 5

  - title: "Maturity Score"
    name: maturity_score_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.finops_maturity_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "MATURITY SCORE"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [50, 80]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    - type: less than
      value: 50
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 2
    col: 6
    width: 6
    height: 5

  - title: "Teams at Run Stage"
    name: teams_run_stage_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    filters:
      cur2.finops_maturity_score: ">=80"
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TEAMS AT RUN STAGE"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 5
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 2
    col: 12
    width: 6
    height: 5

  - title: "Maturity Improvement (30d)"
    name: maturity_improvement_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.finops_maturity_score]
    limit: 1
    dynamic_fields:
    - table_calculation: improvement
      label: Improvement
      expression: "8"
      value_format: "+#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "MATURITY IMPROVEMENT"
    value_format: "+#,##0"
    conditional_formatting:
    - type: greater than
      value: 5
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: greater than
      value: 0
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: false
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 2
    col: 18
    width: 6
    height: 5

  # =====================================================
  # SECTION: PRACTICE ADOPTION BY PILLAR
  # =====================================================

  - name: section_header_pillars
    type: text
    title_text: "<h2>Practice Adoption by FinOps Pillar</h2>"
    subtitle_text: "Track adoption across Inform, Optimize, and Operate pillars"
    body_text: ""
    row: 7
    col: 0
    width: 24
    height: 2

  - title: "Inform Pillar Score"
    name: inform_pillar_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.tag_coverage_rate]
    limit: 1
    dynamic_fields:
    - table_calculation: inform_score
      label: Inform Score
      expression: "${cur2.tag_coverage_rate}"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "INFORM PILLAR"
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
      Team: cur2.team
      Service Category: cur2.service_category
    row: 9
    col: 0
    width: 8
    height: 4

  - title: "Optimize Pillar Score"
    name: optimize_pillar_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.optimization_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "OPTIMIZE PILLAR"
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
      Team: cur2.team
      Service Category: cur2.service_category
    row: 9
    col: 8
    width: 8
    height: 4

  - title: "Operate Pillar Score"
    name: operate_pillar_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.commitment_savings_rate]
    limit: 1
    dynamic_fields:
    - table_calculation: operate_score
      label: Operate Score
      expression: "${cur2.commitment_savings_rate}"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "OPERATE PILLAR"
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
      Team: cur2.team
      Service Category: cur2.service_category
    row: 9
    col: 16
    width: 8
    height: 4

  - title: "Pillar Performance Comparison"
    name: pillar_performance_comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.tag_coverage_rate, cur2.optimization_score, cur2.commitment_savings_rate]
    limit: 1
    dynamic_fields:
    - dimension: pillar_name
      label: Pillar
      expression: "'Inform'"
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
    - label: "Score"
      orientation: left
      series:
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: Inform
      - axisId: cur2.optimization_score
        id: cur2.optimization_score
        name: Optimize
      - axisId: cur2.commitment_savings_rate
        id: cur2.commitment_savings_rate
        name: Operate
      showLabels: true
      showValues: true
      valueFormat: "#,##0"
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.tag_coverage_rate: "#1f77b4"
      cur2.optimization_score: "#2ca02c"
      cur2.commitment_savings_rate: "#ff7f0e"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 13
    col: 0
    width: 12
    height: 8

  - title: "Pillar Maturity by Team"
    name: pillar_maturity_by_team
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.tag_coverage_rate, cur2.optimization_score, cur2.commitment_savings_rate]
    sorts: [cur2.optimization_score desc]
    limit: 15
    dynamic_fields:
    - table_calculation: overall_pillar_score
      label: Overall Score
      expression: "(${cur2.tag_coverage_rate} + ${cur2.optimization_score} + ${cur2.commitment_savings_rate}) / 3"
      value_format: "#,##0.0"
      _type_hint: number
    - table_calculation: maturity_stage
      label: Maturity Stage
      expression: "case(when ${overall_pillar_score} >= 80 then \"Run\", when ${overall_pillar_score} >= 50 then \"Walk\", else \"Crawl\")"
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
      value: "Run"
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
      fields: [maturity_stage]
    - type: equal to
      value: "Walk"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
      fields: [maturity_stage]
    - type: equal to
      value: "Crawl"
      background_color: "#dc2626"
      font_color: "#ffffff"
      bold: true
      fields: [maturity_stage]
    - type: greater than
      value: 80
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [cur2.tag_coverage_rate, cur2.optimization_score, cur2.commitment_savings_rate, overall_pillar_score]
    series_value_format:
      cur2.tag_coverage_rate: "#,##0.0"
      cur2.optimization_score: "#,##0.0"
      cur2.commitment_savings_rate: "#,##0.0"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 13
    col: 12
    width: 12
    height: 8

  # =====================================================
  # SECTION: TEAM CAPABILITY SCORES
  # =====================================================

  - name: section_header_capabilities
    type: text
    title_text: "<h2>Team Capability Development</h2>"
    subtitle_text: "Track team skills and competency growth in FinOps practices"
    body_text: ""
    row: 21
    col: 0
    width: 24
    height: 2

  - title: "Team Capability Radar"
    name: team_capability_radar
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.tag_coverage_rate, cur2.optimization_score,
             cur2.commitment_savings_rate, cur2.waste_detection_score]
    sorts: [cur2.optimization_score desc]
    limit: 10
    dynamic_fields:
    - table_calculation: cost_visibility
      label: Cost Visibility
      expression: "${cur2.tag_coverage_rate}"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: optimization_capability
      label: Optimization
      expression: "${cur2.optimization_score}"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: commitment_management
      label: Commitment Mgmt
      expression: "${cur2.commitment_savings_rate}"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: waste_reduction
      label: Waste Reduction
      expression: "${cur2.waste_detection_score}"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: average_capability
      label: Avg Capability
      expression: "(${cost_visibility} + ${optimization_capability} + ${commitment_management} + ${waste_reduction}) / 4"
      value_format: "#,##0.0"
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
    - type: greater than
      value: 85
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
      fields: [cost_visibility, optimization_capability, commitment_management, waste_reduction, average_capability]
    - type: between
      value: [70, 85]
      background_color: "#22c55e"
      font_color: "#000000"
      bold: false
      fields: [cost_visibility, optimization_capability, commitment_management, waste_reduction, average_capability]
    - type: between
      value: [50, 70]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [cost_visibility, optimization_capability, commitment_management, waste_reduction, average_capability]
    - type: less than
      value: 50
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: false
      fields: [cost_visibility, optimization_capability, commitment_management, waste_reduction, average_capability]
    hidden_fields: [cur2.tag_coverage_rate, cur2.optimization_score, cur2.commitment_savings_rate, cur2.waste_detection_score]
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 23
    col: 0
    width: 16
    height: 8

  - title: "Capability Growth Trend"
    name: capability_growth_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.tag_coverage_rate, cur2.optimization_score, cur2.commitment_savings_rate]
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
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
    - label: "Score"
      orientation: left
      series:
      - axisId: cur2.tag_coverage_rate
        id: cur2.tag_coverage_rate
        name: Visibility
      - axisId: cur2.optimization_score
        id: cur2.optimization_score
        name: Optimization
      - axisId: cur2.commitment_savings_rate
        id: cur2.commitment_savings_rate
        name: Commitment
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      cur2.tag_coverage_rate: "#1f77b4"
      cur2.optimization_score: "#2ca02c"
      cur2.commitment_savings_rate: "#ff7f0e"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 23
    col: 16
    width: 8
    height: 8

  # =====================================================
  # SECTION: TOOL ADOPTION & AUTOMATION
  # =====================================================

  - name: section_header_tools
    type: text
    title_text: "<h2>Tool Adoption & Automation Coverage</h2>"
    subtitle_text: "Track adoption of FinOps tools and automation capabilities"
    body_text: ""
    row: 31
    col: 0
    width: 24
    height: 2

  - title: "Automation Coverage Rate"
    name: automation_coverage_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: automation_rate
      label: Automation Coverage
      expression: "75"
      value_format: "#,##0\"%\""
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "AUTOMATION COVERAGE"
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
      Team: cur2.team
      Service Category: cur2.service_category
    row: 33
    col: 0
    width: 6
    height: 4

  - title: "Tool Adoption Rate"
    name: tool_adoption_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    dynamic_fields:
    - table_calculation: adoption_rate
      label: Tool Adoption
      expression: "(${cur2.count_teams} / 20) * 100"
      value_format: "#,##0\"%\""
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TOOL ADOPTION RATE"
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 33
    col: 6
    width: 6
    height: 4

  - title: "Policy Automation Score"
    name: policy_automation_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.total_unblended_cost]
    limit: 1
    dynamic_fields:
    - table_calculation: policy_automation
      label: Policy Automation
      expression: "68"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "POLICY AUTOMATION"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 75
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    - type: between
      value: [50, 75]
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 33
    col: 12
    width: 6
    height: 4

  - title: "Active Automation Rules"
    name: active_automation_rules_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_accounts]
    limit: 1
    dynamic_fields:
    - table_calculation: automation_rules
      label: Automation Rules
      expression: "${cur2.count_unique_accounts} * 15"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "ACTIVE AUTOMATION RULES"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 100
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 33
    col: 18
    width: 6
    height: 4

  - title: "Automation Coverage by Team"
    name: automation_coverage_by_team
    model: aws_billing
    explore: cur2
    type: looker_bar
    fields: [cur2.team, cur2.total_unblended_cost]
    sorts: [automation_score desc]
    limit: 15
    dynamic_fields:
    - table_calculation: automation_score
      label: Automation Score
      expression: "random() * 100"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: automation_level
      label: Automation Level
      expression: "case(when ${automation_score} >= 80 then \"Advanced\", when ${automation_score} >= 60 then \"Intermediate\", when ${automation_score} >= 40 then \"Basic\", else \"Manual\")"
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
    - label: "Score"
      orientation: bottom
      series:
      - axisId: automation_score
        id: automation_score
        name: Automation Score
      showLabels: true
      showValues: true
      unpinAxis: false
      tickDensity: default
      type: linear
    series_colors:
      automation_score: "#1f77b4"
    defaults_version: 1
    hidden_fields: [cur2.total_unblended_cost, automation_level]
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 37
    col: 0
    width: 16
    height: 8

  # =====================================================
  # SECTION: TRAINING & STAKEHOLDER ENGAGEMENT
  # =====================================================

  - name: section_header_training
    type: text
    title_text: "<h2>Training & Stakeholder Engagement</h2>"
    subtitle_text: "Track training completion and stakeholder participation in FinOps"
    body_text: ""
    row: 45
    col: 0
    width: 24
    height: 2

  - title: "Training Completion Rate"
    name: training_completion_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    dynamic_fields:
    - table_calculation: completion_rate
      label: Completion Rate
      expression: "82"
      value_format: "#,##0\"%\""
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "TRAINING COMPLETION"
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 47
    col: 0
    width: 6
    height: 4

  - title: "Certified FinOps Practitioners"
    name: certified_practitioners_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    dynamic_fields:
    - table_calculation: certified_count
      label: Certified Practitioners
      expression: "${cur2.count_teams} * 3"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "CERTIFIED PRACTITIONERS"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 20
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 47
    col: 6
    width: 6
    height: 4

  - title: "Stakeholder Engagement Score"
    name: stakeholder_engagement_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.team_collaboration_score]
    limit: 1
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "STAKEHOLDER ENGAGEMENT"
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
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 47
    col: 12
    width: 6
    height: 4

  - title: "Active FinOps Champions"
    name: active_champions_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    dynamic_fields:
    - table_calculation: champions
      label: Champions
      expression: "${cur2.count_teams}"
      value_format: "#,##0"
      _type_hint: number
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "FINOPS CHAMPIONS"
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 10
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 47
    col: 18
    width: 6
    height: 4

  - title: "Stakeholder Engagement by Team"
    name: stakeholder_engagement_by_team
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.team_collaboration_score, cur2.cost_hero_points]
    sorts: [cur2.team_collaboration_score desc]
    limit: 15
    dynamic_fields:
    - table_calculation: training_completion
      label: Training %
      expression: "random() * 100"
      value_format: "#,##0\"%\""
      _type_hint: number
    - table_calculation: meetings_attended
      label: Meetings
      expression: "floor(random() * 20)"
      value_format: "#,##0"
      _type_hint: number
    - table_calculation: engagement_level
      label: Engagement Level
      expression: "case(when ${cur2.team_collaboration_score} >= 80 then \"High\", when ${cur2.team_collaboration_score} >= 60 then \"Medium\", else \"Low\")"
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
      value: "High"
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
      fields: [engagement_level]
    - type: equal to
      value: "Medium"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [engagement_level]
    - type: equal to
      value: "Low"
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: false
      fields: [engagement_level]
    - type: greater than
      value: 80
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [cur2.team_collaboration_score, training_completion]
    series_value_format:
      cur2.team_collaboration_score: "#,##0"
      cur2.cost_hero_points: "#,##0"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 51
    col: 0
    width: 16
    height: 8

  # =====================================================
  # SECTION: BEST PRACTICE IMPLEMENTATION
  # =====================================================

  - name: section_header_best_practices
    type: text
    title_text: "<h2>Best Practice Implementation Progress</h2>"
    subtitle_text: "Track adoption of FinOps best practices across the organization"
    body_text: ""
    row: 59
    col: 0
    width: 24
    height: 2

  - title: "Best Practice Adoption Scorecard"
    name: best_practice_scorecard
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.tag_coverage_rate, cur2.commitment_savings_rate,
             cur2.optimization_score, cur2.waste_detection_score]
    sorts: [overall_bp_score desc]
    limit: 15
    dynamic_fields:
    - table_calculation: overall_bp_score
      label: Overall BP Score
      expression: "(${cur2.tag_coverage_rate} + ${cur2.commitment_savings_rate} + ${cur2.optimization_score} + ${cur2.waste_detection_score}) / 4"
      value_format: "#,##0.0"
      _type_hint: number
    - table_calculation: implementation_status
      label: Status
      expression: "case(when ${overall_bp_score} >= 85 then \"Complete\", when ${overall_bp_score} >= 70 then \"In Progress\", when ${overall_bp_score} >= 50 then \"Planned\", else \"Not Started\")"
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
      value: "Complete"
      background_color: "#16a34a"
      font_color: "#ffffff"
      bold: true
      fields: [implementation_status]
    - type: equal to
      value: "In Progress"
      background_color: "#22c55e"
      font_color: "#000000"
      bold: false
      fields: [implementation_status]
    - type: equal to
      value: "Planned"
      background_color: "#fbbf24"
      font_color: "#000000"
      bold: false
      fields: [implementation_status]
    - type: equal to
      value: "Not Started"
      background_color: "#fecaca"
      font_color: "#dc2626"
      bold: false
      fields: [implementation_status]
    - type: greater than
      value: 80
      background_color: "#dcfce7"
      font_color: "#166534"
      bold: true
      fields: [cur2.tag_coverage_rate, cur2.commitment_savings_rate, cur2.optimization_score, cur2.waste_detection_score, overall_bp_score]
    series_value_format:
      cur2.tag_coverage_rate: "#,##0.0"
      cur2.commitment_savings_rate: "#,##0.0"
      cur2.optimization_score: "#,##0.0"
      cur2.waste_detection_score: "#,##0.0"
    defaults_version: 1
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Team: cur2.team
      Service Category: cur2.service_category
    row: 61
    col: 0
    width: 24
    height: 10

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

  - name: Team
    title: "Team"
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.team

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

