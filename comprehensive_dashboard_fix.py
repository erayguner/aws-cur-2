#!/usr/bin/env python3
"""
Comprehensive Dashboard Fixer - Single pass solution
Fixes all 16 dashboards to match the correct LookML syntax pattern
"""

import re
from pathlib import Path
from typing import List, Tuple

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

# Properties that should be in visualization_config
VIZ_PROPS = {
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
}

def fix_dashboard_comprehensive(filepath: Path) -> bool:
    """Comprehensively fix a dashboard file"""
    try:
        print(f"Processing {filepath.name}...")

        with open(filepath, 'r') as f:
            content = f.read()

        # Step 1: Move filters to bottom
        filters_match = re.search(r'(  filters:.*?)(?=\n  elements:|$)', content, re.DOTALL)
        if filters_match:
            filters_section = filters_match.group(1)
            content = content.replace(filters_section, '', 1)
        else:
            filters_section = None

        # Step 2: Process each element
        # Find elements section
        elements_match = re.search(r'(  elements:.*?)(?=\n  filters:|$)', content, re.DOTALL)
        if not elements_match:
            print(f"  ✗ No elements section found")
            return False

        elements_content = elements_match.group(1)

        # Split into individual elements
        element_pattern = r'(  - (?:title|name):.*?)(?=\n  - (?:title|name):|$)'
        elements = re.findall(element_pattern, elements_content, re.DOTALL)

        if not elements:
            print(f"  ✗ No elements found")
            return False

        # Fix each element
        fixed_elements = []
        for elem_text in elements:
            fixed_elem = fix_single_element(elem_text)
            fixed_elements.append(fixed_elem)

        # Rebuild content
        new_elements_section = '  elements:\n' + '\n'.join(fixed_elements)

        # Replace old elements with new
        content = re.sub(r'  elements:.*?(?=\n  filters:|$)', new_elements_section, content, flags=re.DOTALL)

        # Add filters at the end
        if filters_section:
            content = content.rstrip() + '\n\n' + filters_section

        # Write back
        with open(filepath, 'w') as f:
            f.write(content)

        print(f"  ✓ Successfully fixed")
        return True

    except Exception as e:
        print(f"  ✗ Error: {e}")
        import traceback
        traceback.print_exc()
        return False

def fix_single_element(elem_text: str) -> str:
    """Fix a single element"""
    lines = elem_text.split('\n')

    # Check if it's a text element
    if any('type: text' in line for line in lines):
        return elem_text

    # Parse element
    metadata_lines = []
    viz_config_lines = []
    listen_lines = []
    position_lines = []

    title = "Element"
    has_note_text = False
    has_viz_config = False

    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if not stripped:
            i += 1
            continue

        # Extract title
        if stripped.startswith('title:'):
            title_match = re.search(r'title:\s*["\']?(.+?)["\']?\s*$', stripped)
            if title_match:
                title = title_match.group(1).strip('"\'')

        # Check for note_text
        if stripped.startswith('note_text:'):
            has_note_text = True

        # Check for visualization_config
        if stripped.startswith('visualization_config:'):
            has_viz_config = True

        # Position properties
        if stripped.startswith(('row:', 'col:', 'width:', 'height:')):
            position_lines.append(line)
            i += 1
            continue

        # Listen block
        if stripped.startswith('listen:'):
            # Capture entire listen block
            listen_lines.append(line)
            i += 1
            while i < len(lines) and lines[i].strip() and not lines[i].strip().startswith(('row:', 'col:', 'width:', 'height:', '- title:', '- name:')):
                if len(lines[i]) - len(lines[i].lstrip()) > len(line) - len(line.lstrip()):
                    listen_lines.append(lines[i])
                    i += 1
                else:
                    break
            continue

        # Visualization property
        prop_name = stripped.split(':')[0] if ':' in stripped else ''
        if prop_name in VIZ_PROPS and not has_viz_config:
            # Capture this property and any nested content
            viz_config_lines.append(line)
            i += 1
            indent_level = len(line) - len(line.lstrip())
            while i < len(lines) and lines[i].strip():
                next_indent = len(lines[i]) - len(lines[i].lstrip())
                if next_indent > indent_level:
                    viz_config_lines.append(lines[i])
                    i += 1
                else:
                    break
            continue

        # Everything else is metadata
        metadata_lines.append(line)
        i += 1

    # Rebuild element
    result = []

    # 1. Metadata
    for line in metadata_lines:
        if not line.strip().startswith(('listen:', 'row:', 'col:', 'width:', 'height:')):
            result.append(line)

    # 2. Visualization_config
    if viz_config_lines and not has_viz_config:
        base_indent = '    '  # 4 spaces for element properties
        result.append(base_indent + 'visualization_config:\n')
        for line in viz_config_lines:
            # Adjust indentation
            content = line.lstrip()
            result.append(base_indent + '  ' + content + '\n')

    # 3. Note_text
    if not has_note_text:
        base_indent = '    '
        result.append(base_indent + f'note_text: "{title} visualization"\n')

    # 4. Listen block
    result.extend([line + '\n' for line in listen_lines])

    # 5. Position properties
    result.extend([line + '\n' for line in position_lines])

    return ''.join(result).rstrip()

def main():
    """Main function"""
    dashboards_dir = Path('/home/user/aws-cur-2/dashboards')

    success_count = 0
    for dashboard_name in DASHBOARDS:
        filepath = dashboards_dir / dashboard_name
        if filepath.exists():
            if fix_dashboard_comprehensive(filepath):
                success_count += 1
        else:
            print(f"✗ File not found: {dashboard_name}")

    print(f"\n{'='*60}")
    print(f"Completed! Fixed {success_count}/{len(DASHBOARDS)} dashboards")
    print(f"{'='*60}")

if __name__ == '__main__':
    main()
