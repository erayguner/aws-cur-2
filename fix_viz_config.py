#!/usr/bin/env python3
"""
Step 2: Wrap visualization properties in visualization_config and add note_text
"""

from pathlib import Path
import re

DASHBOARDS = [
    'realtime_cost_visibility.dashboard.lookml',
    'ml_anomaly_detection_advanced.dashboard.lookml',
    'predictive_cost_forecasting_p10_p50_p90.dashboard.lookml',
    'commitment_optimization_ri_sp.dashboard.lookml',
    'unit_economics_business_metrics.dashboard.lookml',
    'tagging_compliance_governance.dashboard.lookml',
    'ccoe_kpi_dashboard.dashboard.lookml',
    'resource_rightsizing_waste.dashboard.lookml',
    'showback_chargeback_billing.dashboard.lookml',
    'ec2_cost_deep_dive.dashboard.lookml',
    's3_storage_optimization.dashboard.lookml',
    'rds_database_cost_analysis.dashboard.lookml',
    'lambda_serverless_cost.dashboard.lookml',
    'budget_tracking_predictive_alerts.dashboard.lookml',
    'finops_maturity_adoption.dashboard.lookml',
    'sustainability_carbon_footprint.dashboard.lookml',
]

# Properties to wrap in visualization_config
VIZ_PROPS = [
    'custom_color_enabled', 'show_single_value_title', 'show_comparison',
    'comparison_type', 'comparison_reverse_colors', 'show_comparison_label',
    'single_value_title', 'value_format', 'comparison_label',
    'conditional_formatting', 'x_axis_gridlines', 'y_axis_gridlines',
    'show_view_names', 'show_y_axis_labels', 'show_y_axis_ticks',
    'y_axis_tick_density', 'show_x_axis_label', 'show_x_axis_ticks',
    'y_axis_scale_mode', 'x_axis_reversed', 'y_axis_reversed',
    'plot_size_by_dimension', 'trellis', 'stacking', 'limit_displayed_rows',
    'legend_position', 'point_style', 'show_value_labels', 'label_density',
    'x_axis_scale', 'y_axis_combined', 'show_null_points', 'interpolation',
    'show_totals_labels', 'show_silhouette', 'totals_color',
    'color_application', 'y_axes', 'series_colors', 'series_types',
    'series_point_styles', 'reference_lines', 'ordering',
    'show_null_labels', 'show_row_numbers', 'transpose', 'truncate_text',
    'hide_totals', 'hide_row_totals', 'size_to_fit', 'table_theme',
    'enable_conditional_formatting', 'header_text_alignment',
    'header_font_size', 'rows_font_size', 'value_labels', 'label_type',
    'inner_radius', 'map', 'map_projection', 'quantize_colors',
    'color_range', 'groupBars', 'labelSize', 'showLegend',
    'column_limit', 'plot_size_by_field', 'x_axis_label', 'y_axis_label',
    'conditional_formatting_include_totals', 'conditional_formatting_include_nulls',
    'series_value_format', 'series_cell_visualizations', 'font_size', 'text_color',
    'defaults_version', 'hidden_fields',
]

# Properties that should NOT be wrapped
KEEP_PROPS = [
    'title', 'name', 'model', 'explore', 'type', 'fields', 'filters', 'sorts',
    'limit', 'listen', 'row', 'col', 'width', 'height', 'dynamic_fields',
    'pivots', 'note_text', 'visualization_config', 'title_text', 'subtitle_text',
    'body_text',
]

def get_indent_level(line):
    """Get indentation level"""
    return len(line) - len(line.lstrip())

def fix_element(lines, start_idx, end_idx):
    """Fix a single element"""
    element_lines = lines[start_idx:end_idx]

    # Check if it's a text element (don't modify)
    if any('type: text' in line for line in element_lines):
        return element_lines

    # Check if visualization_config already exists
    has_viz_config = any(line.strip().startswith('visualization_config:') for line in element_lines)
    if has_viz_config:
        # Already has visualization_config, just add note_text if missing
        has_note_text = any(line.strip().startswith('note_text:') for line in element_lines)
        if not has_note_text:
            # Extract title
            title = "Element"
            for line in element_lines:
                if line.strip().startswith('title:'):
                    title_match = re.search(r'title:\s*["\']?(.+?)["\']?\s*$', line.strip())
                    if title_match:
                        title = title_match.group(1).strip('"\'')
                    break
            # Find position to insert note_text (after viz_config, before listen/row/col/width/height)
            insert_idx = len(element_lines)
            for i, line in enumerate(element_lines):
                if line.strip().startswith(('listen:', 'row:', 'col:', 'width:', 'height:')):
                    insert_idx = i
                    break
            # Get indentation from the element
            base_indent = get_indent_level(element_lines[0]) + 2
            note_line = ' ' * base_indent + f'note_text: "{title} visualization"\n'
            element_lines.insert(insert_idx, note_line)
        return element_lines

    # Extract element info
    base_indent = get_indent_level(element_lines[0]) + 2
    title = "Element"

    # Parse element into sections
    metadata = []
    viz_properties = []
    position_props = []
    listen_block = []
    in_listen = False
    in_nested_viz_prop = False
    in_nested_metadata = False
    nested_prop_indent = 0

    i = 0
    while i < len(element_lines):
        line = element_lines[i]
        stripped = line.strip()
        indent = get_indent_level(line)

        # Extract title
        if stripped.startswith('title:'):
            title_match = re.search(r'title:\s*["\']?(.+?)["\']?\s*$', stripped)
            if title_match:
                title = title_match.group(1).strip('"\'')

        # Check if we're in a nested property
        if in_nested_viz_prop:
            if indent > nested_prop_indent or stripped == '':
                viz_properties.append(' ' * 4 + line[base_indent:])
                i += 1
                continue
            else:
                in_nested_viz_prop = False

        # Check if in nested metadata property (like dynamic_fields, filters with nested values)
        if in_nested_metadata:
            if indent > nested_prop_indent or stripped == '':
                metadata.append(line)
                i += 1
                continue
            else:
                in_nested_metadata = False

        # Check if in listen block
        if stripped.startswith('listen:'):
            in_listen = True
            listen_block.append(line)
            i += 1
            continue

        if in_listen:
            if indent > base_indent or stripped == '':
                listen_block.append(line)
                i += 1
                continue
            else:
                in_listen = False

        # Position properties
        if stripped.startswith(('row:', 'col:', 'width:', 'height:')):
            position_props.append(line)
            i += 1
            continue

        # Check if this is a viz property
        prop_name = stripped.split(':')[0] if ':' in stripped else ''
        if prop_name in VIZ_PROPS:
            # Add to viz_properties with adjusted indent
            viz_properties.append(' ' * 4 + stripped + '\n')
            # Check if next lines are nested (part of this property)
            nested_prop_indent = indent
            in_nested_viz_prop = True
            i += 1
            continue

        # Regular metadata
        metadata.append(line)
        # Check if this is a nested metadata property
        if prop_name in ['filters', 'dynamic_fields', 'fields']:
            nested_prop_indent = indent
            in_nested_metadata = True
        i += 1

    # Rebuild element with correct order
    result = []

    # 1. Add metadata (title, name, model, explore, type, fields, filters, sorts, limit, etc.)
    result.extend(metadata)

    # 2. Add visualization_config block if we have viz properties
    if viz_properties:
        result.append(' ' * base_indent + 'visualization_config:\n')
        result.extend(viz_properties)

    # 3. Add note_text
    has_note_text = any(line.strip().startswith('note_text:') for line in metadata)
    if not has_note_text:
        result.append(' ' * base_indent + f'note_text: "{title} visualization"\n')

    # 4. Add listen block
    result.extend(listen_block)

    # 5. Add position properties (row, col, width, height)
    result.extend(position_props)

    return result

def fix_dashboard_file(filepath):
    """Fix visualization_config in a dashboard file"""
    with open(filepath, 'r') as f:
        lines = f.readlines()

    # Find elements section
    elements_start = None
    for i, line in enumerate(lines):
        if line.strip() == 'elements:':
            elements_start = i
            break

    if elements_start is None:
        print(f"  No elements section found")
        return False

    # Find all element boundaries
    elements = []
    current_element_start = None
    base_indent = None

    for i in range(elements_start + 1, len(lines)):
        line = lines[i]
        stripped = line.strip()

        # Start of filters section
        if stripped.startswith('filters:'):
            if current_element_start is not None:
                elements.append((current_element_start, i))
            break

        # Start of new element
        if stripped.startswith('- title:') or stripped.startswith('- name:'):
            if current_element_start is not None:
                elements.append((current_element_start, i))
            current_element_start = i
            if base_indent is None:
                base_indent = get_indent_level(line)

    # Fix each element
    result = lines[:elements_start + 1]  # Keep everything before elements

    for start, end in elements:
        fixed_element = fix_element(lines, start, end)
        result.extend(fixed_element)

    # Add filters section
    for i in range(len(lines)):
        if lines[i].strip().startswith('filters:'):
            result.extend(lines[i:])
            break

    # Write back
    with open(filepath, 'w') as f:
        f.writelines(result)

    return True

# Process all dashboards
dashboards_dir = Path('dashboards')
success = 0
for dashboard_name in DASHBOARDS:
    filepath = dashboards_dir / dashboard_name
    if filepath.exists():
        print(f"Processing {dashboard_name}...")
        try:
            if fix_dashboard_file(filepath):
                print(f"  ✓ Fixed visualization_config and added note_text")
                success += 1
        except Exception as e:
            print(f"  ✗ Error: {e}")
    else:
        print(f"  ✗ File not found")

print(f"\nCompleted: {success}/{len(DASHBOARDS)} dashboards updated")
