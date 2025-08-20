---
# Project Competition Dashboard
# Real-time leaderboards and team competition gamification for cost optimization

- dashboard: project_competition_dashboard
  title: Project Cost Competition Leaderboard
  description: Gamified project-based cost optimization with real-time rankings and achievements
  layout: newspaper
  preferred_viewer: dashboards-next
  
  filters:
  - name: competition_period_filter
    title: Competition Period
    type: field_filter
    default_value: 1 months ago for 1 months
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date

  - name: minimum_spend_filter
    title: Minimum Spend Threshold
    type: field_filter
    default_value: "1000"
    allow_multiple_values: false
    required: false
    ui_config:
      type: range_slider
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.total_unblended_cost

  elements:
  # Championship Banner - Current Leader
  - name: championship_banner
    title: Current Champion
    model: aws_billing
    explore: cur2
    type: kpi_vis
    fields: [cur2.environment, cur2.total_unblended_cost, cur2.savings_percentage]
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.total_unblended_cost: ">{% parameter minimum_spend_filter %}"
    sorts: [cur2.savings_percentage desc]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: TOP COST OPTIMIZER
    conditional_formatting:
    - type: greater than
      value: 0.15
      background_color: "#ffd700"
      font_color: "#000000"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: champion-gold
          label: Champion Gold
          type: continuous
          stops:
          - color: "#ffd700"
            offset: 0
          - color: "#ffed4e"
            offset: 100
      bold: true
      italic: false
      strikethrough: false
      fields: null
    width: 24
    height: 4
    row: 0
    col: 0
    
  # Live Leaderboard with Rankings
  - name: project_leaderboard
    title: Project Cost Optimization Leaderboard
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.environment
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.total_unblended_cost: ">{% parameter minimum_spend_filter %}"
    sorts: [cur2.savings_percentage desc]
    limit: 20
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: unstyled
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: center
    header_font_size: 14
    rows_font_size: 12
    conditional_formatting:
    - type: along a scale
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: leaderboard-ranking
          label: Leaderboard Ranking
          type: continuous
          stops:
          - color: "#ffd700"
            offset: 0
          - color: "#c0c0c0"
            offset: 50
          - color: "#cd7f32"
            offset: 75
          - color: "#e74c3c"
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.savings_percentage]
    width: 12
    height: 12
    row: 4
    col: 0
    
  # Achievement Progress Meters
  - name: achievement_progress
    title: Achievement Progress Meters
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.environment, cur2.savings_percentage]
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.total_unblended_cost: ">{% parameter minimum_spend_filter %}"
    sorts: [cur2.savings_percentage desc]
    limit: 6
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    value_format: "#,##0.0%"
    gauge_fill_type: segment
    gauge_fill_colors: ["#e74c3c", "#f39c12", "#f1c40f", "#2ecc71", "#27ae60", "#ffd700"]
    angle: 90
    cutout: 50
    range_max: 50
    range_min: 0
    angle_range: 270
    gauge_value_formatting: decimal_2
    width: 12
    height: 12
    row: 4
    col: 12
    
  # Competition Timer and Countdown
  - name: competition_timer
    title: ⏱️ Competition Timer
    model: aws_billing
    explore: cur2
    type: kpi_vis
    fields: [cur2.billing_period_end_date]
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: TIME REMAINING
    conditional_formatting:
    - type: less than
      value: 7 days
      background_color: "#e74c3c"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: true
      italic: false
      strikethrough: false
      fields: null
    width: 8
    height: 4
    row: 16
    col: 0
    
  # Badge Display - Top Performers
  - name: achievement_badges
    title: Achievement Badges
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields:
    - cur2.environment
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.total_unblended_cost: ">{% parameter minimum_spend_filter %}"
      cur2.savings_percentage: ">0.10"
    sorts: [cur2.savings_percentage desc]
    limit: 3
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color_enabled: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: achievement-badges
        label: Achievement Badges
        type: categorical
        stops:
        - color: "#ffd700"
          offset: 0
        - color: "#c0c0c0"
          offset: 33
        - color: "#cd7f32"
          offset: 66
    width: 8
    height: 4
    row: 16
    col: 8
    
  # Real-time Competition Heat Map
  - name: competition_heatmap
    title: Competition Heat Map - Savings Activity
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.environment
    - cur2.team
    - cur2.savings_percentage
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.team: "-EMPTY"
      cur2.total_unblended_cost: ">{% parameter minimum_spend_filter %}"
    sorts: [cur2.savings_percentage desc]
    limit: 50
    column_limit: 50
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: unstyled
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: center
    header_font_size: 12
    rows_font_size: 11
    conditional_formatting:
    - type: along a scale
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
        custom:
          id: heat-map-savings
          label: Heat Map Savings
          type: continuous
          stops:
          - color: "#000080"
            offset: 0
          - color: "#0000ff"
            offset: 20
          - color: "#00ffff"
            offset: 40
          - color: "#ffff00"
            offset: 60
          - color: "#ff8000"
            offset: 80
          - color: "#ff0000"
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.savings_percentage]
    width: 8
    height: 4
    row: 16
    col: 16
    
  # Team vs Team Progress Bars
  - name: team_competition_progress
    title: Team vs Team Competition
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields: [cur2.team, cur2.savings_percentage, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: "{% parameter competition_period_filter %}"
      cur2.team: "-EMPTY"
      cur2.total_unblended_cost: ">{% parameter minimum_spend_filter %}"
    sorts: [cur2.savings_percentage desc]
    limit: 10
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: progress_percentage
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting:
    - type: greater than
      value: 0.20
      background_color: "#27ae60"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: true
      italic: false
      strikethrough: false
      fields: null
    width: 24
    height: 6
    row: 20
    col: 0