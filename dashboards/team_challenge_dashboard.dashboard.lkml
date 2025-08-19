---
# Team Challenge Dashboard
# Collaborative team-based cost optimization challenges and social recognition

- dashboard: team_challenge_dashboard
  title: Team Cost Optimization Challenges
  description: Collaborative team challenges with shared goals, social recognition, and collective achievement tracking
  layout: newspaper
  preferred_viewer: dashboards-next
  
  filters:
  - name: challenge_period_filter
    title: Challenge Period
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

  - name: team_filter
    title: Select Team
    type: field_filter
    default_value: ""
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.team

  - name: challenge_type_filter
    title: Challenge Type
    type: field_filter
    default_value: all
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_group
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_product_code

  elements:
  # Team Challenge Banner
  - name: team_challenge_banner
    title: Active Team Challenge
    model: aws_billing
    explore: cur2
    type: kpi_vis
    fields: [cur2.team, cur2.savings_percentage, cur2.total_unblended_cost]
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "{% parameter team_filter %}"
    sorts: [cur2.savings_percentage desc]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "CHALLENGE: MAXIMIZE SAVINGS"
    value_format: "#,##0.0%"
    conditional_formatting:
    - type: greater than
      value: 0.25
      background_color: "#2ecc71"
      font_color: "#ffffff"
      color_application:
        collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      bold: true
      italic: false
      strikethrough: false
      fields: null
    width: 24
    height: 4
    row: 0
    col: 0
    
  # Team vs Team Battle Arena
  - name: team_battle_arena
    title: Team Battle Arena
    model: aws_billing
    explore: cur2
    type: bar_gauge_vis
    fields:
    - cur2.team
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "-EMPTY"
    sorts: [cur2.savings_percentage desc]
    limit: 8
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
      background_color: "#ffd700"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: null
    - type: between
      value: [0.10, 0.20]
      background_color: "#c0c0c0"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: null
    - type: between
      value: [0.05, 0.10]
      background_color: "#cd7f32"
      font_color: "#ffffff"
      bold: false
      italic: false
      strikethrough: false
      fields: null
    width: 12
    height: 10
    row: 4
    col: 0
    
  # Collaborative Goal Tracker
  - name: collaborative_goal_tracker
    title: Collaborative Goals Progress
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields:
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "{% parameter team_filter %}"
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: TEAM GOALS
    value_format: "#,##0.0%"
    gauge_fill_type: segment
    gauge_fill_colors: ["#e74c3c", "#f39c12", "#f1c40f", "#2ecc71", "#27ae60", "#ffd700"]
    angle: 90
    cutout: 50
    range_max: 100
    range_min: 0
    angle_range: 270
    gauge_value_formatting: decimal_1
    width: 12
    height: 10
    row: 4
    col: 12
    
  # Shared Achievement Unlocking
  - name: shared_achievement_unlocking
    title: Shared Achievement Unlocks
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields:
    - cur2.team
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "{% parameter team_filter %}"
      cur2.savings_percentage: ">0.15"
    limit: 1
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color_enabled: true
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: achievement-unlock
        label: Achievement Unlock
        type: categorical
        stops:
        - color: "#ffd700"
          offset: 0
        - color: "#ff6b35"
          offset: 25
        - color: "#4ecdc4"
          offset: 50
        - color: "#45b7d1"
          offset: 75
    width: 12
    height: 6
    row: 14
    col: 0
    
  # Social Recognition Wall
  - name: social_recognition_wall
    title: Social Recognition Wall
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.environment
    - cur2.team
    - cur2.tag_owner
    - cur2.savings_percentage
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "{% parameter team_filter %}"
      cur2.savings_percentage: ">0.10"
    sorts: [cur2.savings_percentage desc]
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
    header_text_alignment: center
    header_font_size: 12
    rows_font_size: 11
    conditional_formatting:
    - type: greater than
      value: 0.25
      background_color: "#ffd700"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields: [cur2.savings_percentage]
    - type: between
      value: [0.15, 0.25]
      background_color: "#c0c0c0"
      font_color: "#000000"
      bold: false
      italic: false
      strikethrough: false
      fields: [cur2.savings_percentage]
    width: 12
    height: 6
    row: 14
    col: 12
    
  # Team Collaboration Network
  - name: team_collaboration_network
    title: Team Collaboration Impact
    model: aws_billing
    explore: cur2
    type: sankey_vis
    fields:
    - cur2.team
    - cur2.environment
    - cur2.savings_vs_on_demand
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "{% parameter team_filter %}"
    sorts: [cur2.savings_vs_on_demand desc]
    limit: 20
    column_limit: 50
    show_view_names: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      custom:
        id: collaboration-network
        label: Collaboration Network
        type: continuous
        stops:
        - color: "#667eea"
          offset: 0
        - color: "#764ba2"
          offset: 50
        - color: "#f093fb"
          offset: 100
    width: 12
    height: 8
    row: 20
    col: 0
    
  # Challenge Progress Timeline
  - name: challenge_progress_timeline
    title: Challenge Progress Timeline
    model: aws_billing
    explore: cur2
    type: looker_line
    fields:
    - cur2.line_item_usage_start_date
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "{% parameter team_filter %}"
    sorts: [cur2.line_item_usage_start_date]
    limit: 90
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
      custom:
        id: challenge-timeline
        label: Challenge Timeline
        type: continuous
        stops:
        - color: "#4fc3f7"
          offset: 0
        - color: "#29b6f6"
          offset: 50
        - color: "#039be5"
          offset: 100
    width: 12
    height: 8
    row: 20
    col: 12
    
  # Team Achievement Comparison
  - name: team_achievement_comparison
    title: Team Achievement Comparison
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.team
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    filters:
      cur2.line_item_usage_start_date: "{% parameter challenge_period_filter %}"
      cur2.team: "-EMPTY"
    sorts: [cur2.savings_percentage desc]
    limit: 10
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
      custom:
        id: team-comparison
        label: Team Comparison
        type: categorical
        stops:
        - color: "#e74c3c"
          offset: 0
        - color: "#f39c12"
          offset: 20
        - color: "#f1c40f"
          offset: 40
        - color: "#2ecc71"
          offset: 60
        - color: "#3498db"
          offset: 80
        - color: "#9b59b6"
          offset: 100
    width: 24
    height: 8
    row: 28
    col: 0