---
- dashboard: gamified_master_dashboard
  title: "Ultimate Cost Optimization Game Center"
  description: "Master gamified dashboard combining all competitive elements, social features, and achievement systems for cost optimization"
  layout: newspaper
  preferred_viewer: dashboards-next
  
  filters:
  - name: game_period_filter
    title: "Game Period"
    type: field_filter
    default_value: "1 months ago for 1 months"
    allow_multiple_values: false
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.line_item_usage_start_date

  - name: player_focus_filter
    title: "Player Focus"
    type: field_filter
    default_value: "all"
    allow_multiple_values: false
    required: false
    ui_config:
      type: button_group
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.environment

  - name: game_mode_filter
    title: "Game Mode"
    type: field_filter
    default_value: "global"
    allow_multiple_values: false
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
    model: aws_billing
    explore: cur2
    dimension: cur2.team

  elements:
  # Global Leaderboard Crown
  - name: "global_leaderboard_crown"
    title: "Global Leaderboard - Hall of Fame"
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.environment
    - cur2.team
    - cur2.tag_owner
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.savings_percentage: ">0.05"
    sorts:
    - cur2.savings_percentage desc
    limit: 25
    column_limit: 50
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: unstyled
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: center
    header_font_size: 14
    rows_font_size: 11
    conditional_formatting:
    - type: equal to
      value: 1
      background_color: "#ffd700"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - "$$$_row_numbers_$$$"
    - type: equal to
      value: 2
      background_color: "#c0c0c0"
      font_color: "#000000"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - "$$$_row_numbers_$$$"
    - type: equal to
      value: 3
      background_color: "#cd7f32"
      font_color: "#ffffff"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - "$$$_row_numbers_$$$"
    - type: greater than
      value: 0.30
      background_color: "#2ecc71"
      font_color: "#ffffff"
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_percentage
    width: 16
    height: 12
    row: 0
    col: 0
    
  # Achievement Gallery Showcase
  - name: "achievement_gallery_showcase"
    title: "Achievement Gallery"
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields:
    - cur2.savings_percentage
    - cur2.tag_coverage_rate
    - cur2.resource_efficiency_score
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.savings_percentage: ">0.20"
    sorts:
    - cur2.savings_percentage desc
    limit: 1
    column_limit: 50
    show_single_value_title: true
    show_comparison: false
    custom_color_enabled: true
    color_application:
      collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
      custom:
        id: "master-achievements"
        label: "Master Achievements"
        type: "categorical"
        stops:
        - color: "#ffd700"
          offset: 0
        - color: "#ff6b35"
          offset: 25
        - color: "#4ecdc4"
          offset: 50
        - color: "#45b7d1"
          offset: 75
    width: 8
    height: 12
    row: 0
    col: 16
    
  # Live Competition Heat Map
  - name: "live_competition_heatmap"
    title: "Live Competition Heat Map"
    model: aws_billing
    explore: cur2
    type: looker_grid
    fields:
    - cur2.team
    - cur2.environment
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.team: "-EMPTY"
    sorts:
    - cur2.savings_percentage desc
    limit: 100
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
    header_font_size: 11
    rows_font_size: 10
    conditional_formatting:
    - type: along a scale
      value: null
      background_color: null
      font_color: null
      color_application:
        collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
        custom:
          id: "competition-heat"
          label: "Competition Heat"
          type: "continuous"
          stops:
          - color: "#000080"
            offset: 0
          - color: "#0000ff"
            offset: 16
          - color: "#00ffff"
            offset: 32
          - color: "#00ff00"
            offset: 48
          - color: "#ffff00"
            offset: 64
          - color: "#ff8000"
            offset: 80
          - color: "#ff0000"
            offset: 100
      bold: false
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_percentage
    width: 12
    height: 8
    row: 12
    col: 0
    
  # Power-Up Progress Meters
  - name: "powerup_progress_meters"
    title: "Power-Up Progress Meters"
    model: aws_billing
    explore: cur2
    type: radial_gauge_vis
    fields:
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.environment: "-EMPTY"
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    single_value_title: "POWER LEVELS"
    value_format: "#,##0.0%"
    gauge_fill_type: "segment"
    gauge_fill_colors:
    - "#e74c3c"
    - "#f39c12"
    - "#f1c40f"
    - "#2ecc71"
    - "#27ae60"
    - "#ffd700"
    - "#9b59b6"
    angle: 90
    cutout: 40
    range_max: 100
    range_min: 0
    angle_range: 270
    gauge_value_formatting: "decimal_1"
    width: 12
    height: 8
    row: 12
    col: 12
    
  # Social Recognition Feed
  - name: "social_recognition_feed"
    title: "Social Recognition Feed"
    model: aws_billing
    explore: cur2
    type: report_table
    fields:
    - cur2.tag_owner
    - cur2.environment
    - cur2.savings_percentage
    - cur2.savings_vs_on_demand
    - cur2.line_item_usage_start_date
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.tag_owner: "-EMPTY"
      cur2.savings_percentage: ">0.15"
    sorts:
    - cur2.line_item_usage_start_date desc
    limit: 20
    column_limit: 50
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
    rows_font_size: 11
    conditional_formatting:
    - type: greater than
      value: 0.30
      background_color: "#74b9ff"
      font_color: "#ffffff"
      bold: true
      italic: false
      strikethrough: false
      fields:
      - cur2.savings_percentage
    width: 12
    height: 10
    row: 20
    col: 0
    
  # Team Battle Royale Arena
  - name: "team_battle_royale"
    title: "Team Battle Royale Arena"
    model: aws_billing
    explore: cur2
    type: looker_column
    fields:
    - cur2.team
    - cur2.savings_percentage
    - cur2.resource_efficiency_score
    - cur2.tag_coverage_rate
    - cur2.total_unblended_cost
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.team: "-EMPTY"
    sorts:
    - cur2.savings_percentage desc
    limit: 12
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
    plot_size_by_dimension: cur2.total_unblended_cost
    trellis: ""
    stacking: ""
    limit_displayed_rows: false
    legend_position: center
    point_style: circle_outline
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
      collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
      custom:
        id: "battle-royale"
        label: "Battle Royale"
        type: "categorical"
        stops:
        - color: "#ff0000"
          offset: 0
        - color: "#ff8000"
          offset: 14
        - color: "#ffff00"
          offset: 28
        - color: "#80ff00"
          offset: 42
        - color: "#00ff00"
          offset: 56
        - color: "#00ff80"
          offset: 70
        - color: "#00ffff"
          offset: 84
        - color: "#0080ff"
          offset: 100
    width: 12
    height: 10
    row: 20
    col: 12
    
  # Achievement Unlocking Timeline
  - name: "achievement_unlocking_timeline"
    title: "Achievement Unlocking Timeline"
    model: aws_billing
    explore: cur2
    type: looker_timeline
    fields:
    - cur2.line_item_usage_start_date
    - cur2.environment
    - cur2.savings_percentage
    - cur2.savings_vs_on_demand
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.environment: "-EMPTY"
      cur2.savings_percentage: ">0.10"
    sorts:
    - cur2.line_item_usage_start_date desc
    limit: 50
    column_limit: 50
    show_view_names: false
    color_application:
      collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
      custom:
        id: "achievement-timeline"
        label: "Achievement Timeline"
        type: "continuous"
        stops:
        - color: "#667eea"
          offset: 0
        - color: "#764ba2"
          offset: 33
        - color: "#f093fb"
          offset: 66
        - color: "#f093fb"
          offset: 100
    width: 12
    height: 8
    row: 30
    col: 0
    
  # Ultimate Challenge Tracker
  - name: "ultimate_challenge_tracker"
    title: "Ultimate Challenge Tracker"
    model: aws_billing
    explore: cur2
    type: waterfall_vis
    fields:
    - cur2.line_item_usage_start_month
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
      cur2.environment: "-EMPTY"
    sorts:
    - cur2.line_item_usage_start_month
    limit: 12
    column_limit: 50
    show_view_names: false
    color_application:
      collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
      custom:
        id: "ultimate-challenge"
        label: "Ultimate Challenge"
        type: "continuous"
        stops:
        - color: "#e74c3c"
          offset: 0
        - color: "#f39c12"
          offset: 25
        - color: "#f1c40f"
          offset: 50
        - color: "#2ecc71"
          offset: 75
        - color: "#3498db"
          offset: 100
    width: 12
    height: 8
    row: 30
    col: 12
    
  # Global Statistics Dashboard
  - name: "global_statistics_dashboard"
    title: "Global Game Statistics"
    model: aws_billing
    explore: cur2
    type: multiple_value
    fields:
    - cur2.count
    - cur2.count_unique_resources
    - cur2.total_unblended_cost
    - cur2.savings_vs_on_demand
    filters:
      cur2.line_item_usage_start_date: "{% parameter game_period_filter %}"
    limit: 1
    column_limit: 50
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    custom_color_enabled: true
    color_application:
      collection_id: "7c56cc21-66e4-41c9-81ce-a60e1c3967b2"
      custom:
        id: "global-stats"
        label: "Global Statistics"
        type: "categorical"
        stops:
        - color: "#3498db"
          offset: 0
        - color: "#2ecc71"
          offset: 25
        - color: "#f39c12"
          offset: 50
        - color: "#e74c3c"
          offset: 75
    width: 24
    height: 6
    row: 38
    col: 0

  listen:
    game_period_filter: cur2.line_item_usage_start_date
    player_focus_filter: cur2.environment
    game_mode_filter: cur2.team