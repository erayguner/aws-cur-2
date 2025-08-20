---
# =====================================================
# GAMIFIED COST OPTIMIZATION DASHBOARD
# =====================================================
# Engaging gamification dashboard to drive cost optimization behaviors
# Following Looker best practices for interactive user engagement
# 
# Author: Claude Gamification Generator
# Last Updated: 2025-08-19
# =====================================================

- dashboard: gamified_cost_optimization
  title: 🎮 Cost Optimization Game Center
  description: 'Engaging gamification dashboard to motivate teams and individuals towards better cost optimization practices'
  layout: newspaper
  preferred_viewer: dashboards-next
  
  # Interactive dashboard optimization
  auto_run: false
  refresh: 60 minutes
  load_configuration: wait
  crossfilter_enabled: true
  
  # Gamification styling
  embed_style:
    background_color: '#0f172a'
    show_title: true
    show_filters_bar: true
    tile_text_color: '#f1f5f9'
    tile_background_color: '#1e293b'
    show_title: true
  
  filters:
  - name: Competition Period
    title: 🏆 Competition Period
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
        - 'this quarter'
        - 'last quarter'
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.line_item_usage_start_date

  - name: Team Filter
    title: 👥 Team
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Environment Filter, Account Filter]
    field: cur2.team

  - name: Environment Filter
    title: 🌍 Environment
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: aws_billing
    explore: cur2
    listens_to_filters: [Team Filter, Account Filter]
    field: cur2.environment

  - name: Account Filter
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
    listens_to_filters: [Team Filter, Environment Filter]
    field: cur2.line_item_usage_account_name

  - name: Achievement Level
    title: 🎯 Achievement Level
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options:
        - 'Bronze (0-999 points)'
        - 'Silver (1000-2499 points)'
        - 'Gold (2500-4999 points)'
        - 'Platinum (5000+ points)'
    model: aws_billing
    explore: cur2
    listens_to_filters: []
    field: cur2.level_progress

  elements:
  # =====================================================
  # LEADERBOARD & RANKINGS
  # =====================================================
  
  - title: 🥇 Ultimate Cost Hero Leaderboard
    name: cost_hero_leaderboard
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.team, cur2.cost_hero_points, cur2.sustainability_champion_score,
             cur2.waste_warrior_achievements, cur2.team_collaboration_score, cur2.level_progress]
    sorts: [cur2.cost_hero_points desc]
    limit: 20
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 14
    rows_font_size: 12
    conditional_formatting:
    # Ranking badges
    - type: equal to
      value: 1
      background_color: '#ffd700'
      font_color: '#000000'
      bold: true
      italic: false
      strikethrough: false
    - type: equal to
      value: 2
      background_color: '#c0c0c0'
      font_color: '#000000'
      bold: true
      italic: false
      strikethrough: false
    - type: equal to
      value: 3
      background_color: '#cd7f32'
      font_color: '#ffffff'
      bold: true
      italic: false
      strikethrough: false
    # Achievement levels
    - type: greater than
      value: 2500
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.cost_hero_points]
    - type: between
      value: [1000, 2500]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.cost_hero_points]
    - type: between
      value: [500, 1000]
      background_color: '#f97316'
      font_color: '#ffffff'
      bold: false
      fields: [cur2.cost_hero_points]
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 0
    col: 0
    width: 12
    height: 12

  - title: 🏆 Achievement Badges
    name: achievement_badges
    model: aws_billing
    explore: cur2
    type: single_value
    fields: [cur2.cost_hero_points]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: YOUR TOTAL POINTS
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 5000
      background_color: '#6b46c1'
      font_color: '#ffffff'
      bold: true
    - type: greater than
      value: 2500
      background_color: '#ffd700'
      font_color: '#000000'
      bold: true
    - type: greater than
      value: 1000
      background_color: '#c0c0c0'
      font_color: '#000000'
      bold: true
    - type: greater than
      value: 500
      background_color: '#cd7f32'
      font_color: '#ffffff'
      bold: true
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 0
    col: 12
    width: 4
    height: 6

  - title: 🎮 Level Progress
    name: level_progress_gauge
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields: [cur2.level_progress]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    single_value_title: LEVEL PROGRESS
    value_format: "#,##0"
    conditional_formatting:
    - type: greater than
      value: 80
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
    - type: between
      value: [50, 80]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
    - type: less than
      value: 50
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 6
    col: 12
    width: 4
    height: 6

  # =====================================================
  # ACHIEVEMENT CATEGORIES
  # =====================================================

  - title: 💰 Cost Hero Achievements
    name: cost_hero_achievements
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields: [cur2.month_over_month_change, cur2.total_unblended_cost, cur2.cost_hero_points]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: cost-hero-colors
        label: Cost Hero Colors
        type: continuous
        stops:
        - color: '#dc2626'
          offset: 0
        - color: '#eab308'
          offset: 50
        - color: '#16a34a'
          offset: 100
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 12
    col: 0
    width: 6
    height: 6

  - title: 🌱 Sustainability Champion
    name: sustainability_champion_score
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields: [cur2.sustainability_champion_score, cur2.carbon_efficiency_score, cur2.estimated_carbon_impact]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: sustainability-colors
        label: Sustainability Colors
        type: continuous
        stops:
        - color: '#16a34a'
          offset: 0
        - color: '#22c55e'
          offset: 25
        - color: '#eab308'
          offset: 75
        - color: '#dc2626'
          offset: 100
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 12
    col: 6
    width: 6
    height: 6

  - title: 🗑️ Waste Warrior Achievements
    name: waste_warrior_achievements
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields: [cur2.waste_warrior_achievements, cur2.right_sizing_opportunity, cur2.total_untagged_cost]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: waste-warrior-colors
        label: Waste Warrior Colors
        type: continuous
        stops:
        - color: '#dc2626'
          offset: 0
        - color: '#f97316'
          offset: 25
        - color: '#eab308'
          offset: 50
        - color: '#16a34a'
          offset: 100
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 12
    col: 12
    width: 4
    height: 6

  # =====================================================
  # TEAM COLLABORATION & COMPETITION
  # =====================================================

  - title: 🤝 Team Collaboration Scores
    name: team_collaboration_chart
    model: aws_billing
    explore: cur2
    type: looker_column
    fields: [cur2.team, cur2.team_collaboration_score, cur2.tag_coverage_rate, 
             cur2.total_unblended_cost]
    sorts: [cur2.team_collaboration_score desc]
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: collaboration-colors
        label: Collaboration Colors
        type: categorical
        stops:
        - color: '#6366f1'
          offset: 0
        - color: '#8b5cf6'
          offset: 1
        - color: '#a855f7'
          offset: 2
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 18
    col: 0
    width: 16
    height: 8

  # =====================================================
  # ACHIEVEMENT PROGRESS TRACKING
  # =====================================================

  - title: 📈 Achievement Progress Over Time
    name: achievement_progress_timeline
    model: aws_billing
    explore: cur2
    type: looker_area
    fields: [cur2.line_item_usage_start_date, cur2.cost_hero_points,
             cur2.sustainability_champion_score, cur2.waste_warrior_achievements]
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
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
    stacking: normal
    limit_displayed_rows: false
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: achievement-timeline
        label: Achievement Timeline
        type: categorical
        stops:
        - color: '#ffd700'
          offset: 0
        - color: '#22c55e'
          offset: 1
        - color: '#f97316'
          offset: 2
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 26
    col: 0
    width: 16
    height: 8

  # =====================================================
  # OPTIMIZATION CHALLENGES
  # =====================================================

  - title: 🎯 Monthly Optimization Challenges
    name: optimization_challenges
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields: [cur2.service_category, cur2.optimization_score, cur2.right_sizing_opportunity,
             cur2.commitment_savings_rate, cur2.tag_coverage_rate, cur2.waste_detection_score]
    sorts: [cur2.optimization_score asc]
    limit: 15
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 11
    conditional_formatting:
    # Challenge difficulty levels
    - type: less than
      value: 40
      background_color: '#dc2626'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.optimization_score]
    - type: between
      value: [40, 70]
      background_color: '#eab308'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.optimization_score]
    - type: greater than
      value: 70
      background_color: '#16a34a'
      font_color: '#ffffff'
      bold: true
      fields: [cur2.optimization_score]
    # Opportunity highlighting
    - type: greater than
      value: 1000
      background_color: '#fecaca'
      font_color: '#dc2626'
      bold: true
      fields: [cur2.right_sizing_opportunity]
    listen:
      Competition Period: cur2.line_item_usage_start_date
      Team Filter: cur2.team
      Environment Filter: cur2.environment
      Account Filter: cur2.line_item_usage_account_name
    row: 34
    col: 0
    width: 16
    height: 10