---
# =====================================================
# CLOUD CENTER OF EXCELLENCE (CCoE) KPI DASHBOARD
# =====================================================
# Comprehensive CCoE dashboard tracking FinOps maturity and governance
# Following 2025 FinOps best practices for organizational excellence
# =====================================================

- dashboard: ccoe_kpi_dashboard
  title: "Cloud Center of Excellence (CCoE) KPI Dashboard"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: "Track FinOps maturity, policy compliance, cost optimization adoption, team engagement, and governance violations aligned with 2025 FinOps Framework and CCoE best practices"

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
  - name: section_header_maturity
    type: text
    title_text: "<h2>FinOps Maturity Scorecard</h2>"
    subtitle_text: "Executive view of organizational FinOps maturity and readiness"
    body_text: ""
    row: 0
    col: 0
    width: 24
    height: 2

  - title: "Overall FinOps Maturity Score"
    name: finops_maturity_score_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.finops_maturity_score]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "FINOPS MATURITY SCORE"
      value_format: "#,##0"
      conditional_formatting:
      - type: greater than
        value: 80
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [60, 80]
        background_color: "#eab308"
        font_color: "#000000"
        bold: true
      - type: less than
        value: 60
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 2
    col: 0
    width: 6
    height: 5
  - title: "Optimization Score"
    name: optimization_score_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.optimization_score]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "OPTIMIZATION SCORE"
      value_format: "#,##0.0"
      conditional_formatting:
      - type: greater than
        value: 85
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [70, 85]
        background_color: "#eab308"
        font_color: "#000000"
        bold: true
      - type: less than
        value: 70
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 2
    col: 6
    width: 6
    height: 5
  - title: "Waste Detection Score"
    name: waste_detection_score_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.waste_detection_score]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "WASTE DETECTION SCORE"
      value_format: "#,##0"
      conditional_formatting:
      - type: greater than
        value: 80
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [60, 80]
        background_color: "#eab308"
        font_color: "#000000"
        bold: true
      - type: less than
        value: 60
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 2
    col: 12
    width: 6
    height: 5
  - title: "Tag Coverage Rate"
    name: tag_coverage_rate_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.tag_coverage_rate]
    limit: 1
  # =====================================================
  # SECTION: POLICY COMPLIANCE TRACKING
  # =====================================================
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TAG COVERAGE RATE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 90
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [70, 90]
        background_color: "#eab308"
        font_color: "#000000"
        bold: true
      - type: less than
        value: 70
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 2
    col: 18
    width: 6
    height: 5
  - name: section_header_compliance
    type: text
    title_text: "<h2>Policy Compliance Tracking</h2>"
    subtitle_text: "Monitor adherence to cloud governance policies and best practices"
    body_text: ""
    row: 7
    col: 0
    width: 24
    height: 2

  - title: "Commitment Coverage Rate"
    name: commitment_coverage_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.commitment_savings_rate]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "COMMITMENT COVERAGE"
      value_format: "#,##0.0\"%\""
      conditional_formatting:
      - type: greater than
        value: 70
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: between
        value: [50, 70]
        background_color: "#eab308"
        font_color: "#000000"
        bold: true
      - type: less than
        value: 50
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 9
    col: 0
    width: 4
    height: 4
  - title: "Accounts with Compliance Issues"
    name: non_compliant_accounts_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_accounts]
    filters:
      cur2.tag_coverage_rate: "<70"
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "NON-COMPLIANT ACCOUNTS"
      value_format: "#,##0"
      conditional_formatting:
      - type: equal to
        value: 0
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
      - type: greater than
        value: 5
        background_color: "#dc2626"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 9
    col: 4
    width: 4
    height: 4
  - title: "Teams Engaged in FinOps"
    name: teams_engaged_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_teams]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "TEAMS ENGAGED"
      value_format: "#,##0"
      conditional_formatting:
      - type: greater than
        value: 10
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 9
    col: 8
    width: 4
    height: 4
  - title: "Unique Environments"
    name: unique_environments_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_environments]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "UNIQUE ENVIRONMENTS"
      value_format: "#,##0"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 9
    col: 12
    width: 4
    height: 4
  - title: "Active Projects"
    name: active_projects_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_projects]
    limit: 1
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "ACTIVE PROJECTS"
      value_format: "#,##0"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 9
    col: 16
    width: 4
    height: 4
  - title: "Services in Use"
    name: services_in_use_kpi
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.count_unique_services]
    limit: 1
  # =====================================================
  # SECTION: COST OPTIMIZATION ADOPTION
  # =====================================================
    visualization_config:
      custom_color_enabled: true
      show_single_value_title: true
      show_comparison: false
      single_value_title: "SERVICES IN USE"
      value_format: "#,##0"
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 9
    col: 20
    width: 4
    height: 4
  - name: section_header_optimization_adoption
    type: text
    title_text: "<h2>Cost Optimization Adoption Rates</h2>"
    subtitle_text: "Track adoption of cost optimization best practices across teams"
    body_text: ""
    row: 13
    col: 0
    width: 24
    height: 2

  - title: "RI & Savings Plan Coverage by Account"
    name: commitment_coverage_by_account
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.line_item_usage_account_name, cur2.total_ri_cost, cur2.total_savings_plan_cost,
             cur2.total_on_demand_cost, cur2.commitment_savings_rate]
    sorts: [cur2.commitment_savings_rate desc]
    limit: 15
    visualization_config:
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
      stacking: normal
      limit_displayed_rows: false
      legend_position: center
      point_style: circle
      show_value_labels: false
      label_density: 25
      x_axis_scale: auto
      y_axis_combined: true
      ordering: none
      show_null_labels: false
      show_totals_labels: true
      show_silhouette: false
      totals_color: "#808080"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
      y_axes:
      - label: "Cost"
        orientation: left
        series:
        - axisId: cur2.total_ri_cost
          id: cur2.total_ri_cost
          name: RI Cost
        - axisId: cur2.total_savings_plan_cost
          id: cur2.total_savings_plan_cost
          name: SP Cost
        - axisId: cur2.total_on_demand_cost
          id: cur2.total_on_demand_cost
          name: OnDemand Cost
        showLabels: true
        showValues: true
        valueFormat: "$#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      - label: "Coverage %"
        orientation: right
        series:
        - axisId: cur2.commitment_savings_rate
          id: cur2.commitment_savings_rate
          name: Coverage Rate
        showLabels: true
        showValues: true
        valueFormat: "#,##0\"%\""
        unpinAxis: false
        tickDensity: default
        type: linear
      series_types:
        cur2.commitment_savings_rate: line
      series_colors:
        cur2.total_ri_cost: "#16a34a"
        cur2.total_savings_plan_cost: "#22c55e"
        cur2.total_on_demand_cost: "#dc2626"
        cur2.commitment_savings_rate: "#1f77b4"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 15
    col: 0
    width: 16
    height: 8
  - title: "Optimization Adoption Summary"
    name: optimization_adoption_summary
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.commitment_savings_rate, cur2.tag_coverage_rate,
             cur2.optimization_score, cur2.total_unblended_cost]
    sorts: [cur2.optimization_score desc]
    limit: 20
    dynamic_fields:
    - table_calculation: maturity_level
      label: Maturity Level
      expression: "case(when ${cur2.optimization_score} >= 85 then \"Advanced\", when ${cur2.optimization_score} >= 70 then \"Intermediate\", when ${cur2.optimization_score} >= 50 then \"Developing\", else \"Beginning\")"
      _type_hint: string
  # =====================================================
  # SECTION: TEAM ENGAGEMENT METRICS
  # =====================================================
    visualization_config:
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
        value: "Advanced"
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
        fields: [maturity_level]
      - type: equal to
        value: "Intermediate"
        background_color: "#22c55e"
        font_color: "#000000"
        bold: false
        fields: [maturity_level]
      - type: equal to
        value: "Developing"
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
        fields: [maturity_level]
      - type: equal to
        value: "Beginning"
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: false
        fields: [maturity_level]
      - type: greater than
        value: 85
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [cur2.optimization_score]
      series_value_format:
        cur2.commitment_savings_rate: "#,##0.0\"%\""
        cur2.tag_coverage_rate: "#,##0.0\"%\""
        cur2.optimization_score: "#,##0.0"
        cur2.total_unblended_cost: "$#,##0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 15
    col: 16
    width: 8
    height: 8
  - name: section_header_team_engagement
    type: text
    title_text: "<h2>Team Engagement & Collaboration Metrics</h2>"
    subtitle_text: "Measure team participation and collaboration in FinOps practices"
    body_text: ""
    row: 23
    col: 0
    width: 24
    height: 2

  - title: "Team Cost Hero Leaderboard"
    name: team_leaderboard
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.cost_hero_points, cur2.sustainability_champion_score,
             cur2.waste_warrior_achievements, cur2.team_collaboration_score, cur2.total_unblended_cost]
    sorts: [cur2.cost_hero_points desc]
    limit: 20
    dynamic_fields:
    - table_calculation: total_achievement_points
      label: Total Achievement Points
      expression: "${cur2.cost_hero_points} + ${cur2.sustainability_champion_score} + ${cur2.waste_warrior_achievements}"
      _type_hint: number
    - table_calculation: rank
      label: Rank
      expression: "rank(${total_achievement_points})"
      _type_hint: number
    visualization_config:
        value_format: "#,##0"
        value_format: "#,##0"
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
      header_font_size: 12
      rows_font_size: 12
      conditional_formatting:
      - type: equal to
        value: 1
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: true
        fields: [rank]
      - type: equal to
        value: 2
        background_color: "#e5e7eb"
        font_color: "#000000"
        bold: true
        fields: [rank]
      - type: equal to
        value: 3
        background_color: "#fcd34d"
        font_color: "#000000"
        bold: true
        fields: [rank]
      - type: greater than
        value: 1000
        background_color: "#dcfce7"
        font_color: "#166534"
        bold: true
        fields: [cur2.cost_hero_points]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 25
    col: 0
    width: 16
    height: 10
  - title: "Team Collaboration Score Distribution"
    name: team_collaboration_distribution
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.team_collaboration_score]
    sorts: [cur2.team_collaboration_score desc]
    limit: 15
  # =====================================================
  # SECTION: BEST PRACTICES IMPLEMENTATION
  # =====================================================
    visualization_config:
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
      - label: "Collaboration Score"
        orientation: left
        series:
        - axisId: cur2.team_collaboration_score
          id: cur2.team_collaboration_score
          name: Collaboration Score
        showLabels: true
        showValues: true
        valueFormat: "#,##0"
        unpinAxis: false
        tickDensity: default
        type: linear
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 25
    col: 16
    width: 8
    height: 10
  - name: section_header_best_practices
    type: text
    title_text: "<h2>Best Practices Implementation Status</h2>"
    subtitle_text: "Track implementation of AWS and FinOps best practices"
    body_text: ""
    row: 35
    col: 0
    width: 24
    height: 2

  - title: "Best Practices Adoption Heatmap"
    name: best_practices_heatmap
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.commitment_savings_rate, cur2.tag_coverage_rate,
             cur2.waste_detection_score, cur2.optimization_score]
    sorts: [cur2.optimization_score desc]
    limit: 15
    visualization_config:
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
      - type: greater than
        value: 80
        background_color: "#16a34a"
        font_color: "#ffffff"
        bold: true
        fields: [cur2.commitment_savings_rate, cur2.tag_coverage_rate, cur2.waste_detection_score, cur2.optimization_score]
      - type: between
        value: [60, 80]
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
        fields: [cur2.commitment_savings_rate, cur2.tag_coverage_rate, cur2.waste_detection_score, cur2.optimization_score]
      - type: less than
        value: 60
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: false
        fields: [cur2.commitment_savings_rate, cur2.tag_coverage_rate, cur2.waste_detection_score, cur2.optimization_score]
      series_cell_visualizations:
        cur2.commitment_savings_rate:
          is_active: true
          palette:
            palette_id: custom_diverging
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#dc2626"
            - "#fbbf24"
            - "#16a34a"
        cur2.tag_coverage_rate:
          is_active: true
          palette:
            palette_id: custom_diverging
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#dc2626"
            - "#fbbf24"
            - "#16a34a"
        cur2.waste_detection_score:
          is_active: true
          palette:
            palette_id: custom_diverging
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#dc2626"
            - "#fbbf24"
            - "#16a34a"
        cur2.optimization_score:
          is_active: true
          palette:
            palette_id: custom_diverging
            collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
            custom_colors:
            - "#dc2626"
            - "#fbbf24"
            - "#16a34a"
      series_value_format:
        cur2.commitment_savings_rate: "#,##0.0\"%\""
        cur2.tag_coverage_rate: "#,##0.0\"%\""
        cur2.waste_detection_score: "#,##0"
        cur2.optimization_score: "#,##0.0"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 37
    col: 0
    width: 16
    height: 10
  - title: "Best Practices Progress Over Time"
    name: best_practices_trend
    model: aws_billing
    explore: cur2
    type: looker_line
    fields: [cur2.line_item_usage_start_month, cur2.commitment_savings_rate, cur2.tag_coverage_rate,
             cur2.waste_detection_score, cur2.optimization_score]
    sorts: [cur2.line_item_usage_start_month]
    limit: 12
  # =====================================================
  # SECTION: GOVERNANCE VIOLATIONS
  # =====================================================
    visualization_config:
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
        - axisId: cur2.commitment_savings_rate
          id: cur2.commitment_savings_rate
          name: Commitment Coverage
        - axisId: cur2.tag_coverage_rate
          id: cur2.tag_coverage_rate
          name: Tag Coverage
        - axisId: cur2.waste_detection_score
          id: cur2.waste_detection_score
          name: Waste Detection
        - axisId: cur2.optimization_score
          id: cur2.optimization_score
          name: Optimization
        showLabels: true
        showValues: true
        unpinAxis: false
        tickDensity: default
        type: linear
      series_colors:
        cur2.commitment_savings_rate: "#1f77b4"
        cur2.tag_coverage_rate: "#16a34a"
        cur2.waste_detection_score: "#fbbf24"
        cur2.optimization_score: "#dc2626"
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 37
    col: 16
    width: 8
    height: 10
  - name: section_header_violations
    type: text
    title_text: "<h2>Governance Violations & Remediation</h2>"
    subtitle_text: "Identify and track policy violations requiring immediate attention"
    body_text: ""
    row: 47
    col: 0
    width: 24
    height: 2

  - title: "Critical Governance Violations"
    name: critical_violations
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.line_item_usage_account_name, cur2.line_item_product_code, cur2.line_item_resource_id,
             cur2.total_unblended_cost, cur2.has_tags, cur2.tag_coverage_rate]
    filters:
      cur2.tag_coverage_rate: "<50"
      cur2.total_unblended_cost: ">100"
    sorts: [cur2.total_unblended_cost desc]
    limit: 50
    dynamic_fields:
    - table_calculation: violation_type
      label: Violation Type
      expression: "case(when not ${cur2.has_tags} then \"No Tags\", when ${cur2.tag_coverage_rate} < 50 then \"Low Tag Coverage\", else \"Other\")"
      _type_hint: string
    - table_calculation: severity
      label: Severity
      expression: "case(when ${cur2.total_unblended_cost} > 1000 then \"Critical\", when ${cur2.total_unblended_cost} > 500 then \"High\", when ${cur2.total_unblended_cost} > 100 then \"Medium\", else \"Low\")"
      _type_hint: string
  filters:
    visualization_config:
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
        fields: [severity]
      - type: equal to
        value: "High"
        background_color: "#f59e0b"
        font_color: "#ffffff"
        bold: false
        fields: [severity]
      - type: equal to
        value: "Medium"
        background_color: "#fbbf24"
        font_color: "#000000"
        bold: false
        fields: [severity]
      - type: equal to
        value: "No Tags"
        background_color: "#fecaca"
        font_color: "#dc2626"
        bold: true
        fields: [violation_type]
      series_value_format:
        cur2.total_unblended_cost: "$#,##0.00"
        cur2.tag_coverage_rate: "#,##0.0\"%\""
      defaults_version: 1
    note_text: "Element visualization"
    listen:
      Time Period: cur2.line_item_usage_start_date
      AWS Account: cur2.line_item_usage_account_name
      Service Category: cur2.service_category
      Team: cur2.team
    row: 49
    col: 0
    width: 24
    height: 12
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
    note_text: "Time Period visualization"
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
    note_text: "AWS Account visualization"
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
    note_text: "Service Category visualization"
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
    note_text: "Team visualization"
