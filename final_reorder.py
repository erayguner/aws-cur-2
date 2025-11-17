#!/usr/bin/env python3
import re
from pathlib import Path

DASHBOARDS = [
    'realtime_cost_visibility', 'ml_anomaly_detection_advanced',
    'predictive_cost_forecasting_p10_p50_p90', 'commitment_optimization_ri_sp',
    'unit_economics_business_metrics', 'tagging_compliance_governance',
    'ccoe_kpi_dashboard', 'resource_rightsizing_waste',
    'showback_chargeback_billing', 'ec2_cost_deep_dive',
    's3_storage_optimization', 'rds_database_cost_analysis',
    'lambda_serverless_cost', 'budget_tracking_predictive_alerts',
    'finops_maturity_adoption', 'sustainability_carbon_footprint',
]

for name in DASHBOARDS:
    filepath = Path(f'/home/user/aws-cur-2/dashboards/{name}.dashboard.lookml')
    with open(filepath, 'r') as f:
        content = f.read()
    
    # Fix element property order: move listen and position AFTER viz_config and note_text
    # Pattern: match element, extract parts, reorder
    def fix_elem_order(match):
        elem = match.group(0)
        # Extract sections
        listen_match = re.search(r'(    listen:.*?)(?=\n    (?:row|visualization_config|note_text|$))', elem, re.DOTALL)
        position_match = re.search(r'(    row:.*?height: \d+)', elem, re.DOTALL)
        viz_match = re.search(r'(    visualization_config:.*?)(?=\n    (?:note_text|listen|row|$))', elem, re.DOTALL)
        note_match = re.search(r'(    note_text: .+)', elem)
        
        if not (viz_match or note_match):
            return elem  # No changes needed
        
        # Remove these sections from original
        elem_clean = elem
        if listen_match:
            elem_clean = elem_clean.replace(listen_match.group(1), '', 1)
        if position_match:
            elem_clean = elem_clean.replace(position_match.group(1), '', 1)
        
        # Rebuild: metadata, viz_config, note_text, listen, position
        parts = [elem_clean.rstrip()]
        if viz_match:
            parts.append('\n' + viz_match.group(1))
        if note_match:
            parts.append('\n' + note_match.group(1))
        if listen_match:
            parts.append('\n' + listen_match.group(1))
        if position_match:
            parts.append('\n' + position_match.group(1))
        
        return ''.join(parts)
    
    # Apply fix to all elements
    content = re.sub(r'  - title:.*?(?=\n  - title:|\n  filters:|\Z)', fix_elem_order, content, flags=re.DOTALL)
    
    with open(filepath, 'w') as f:
        f.write(content)
    
    print(f"✓ Reordered {name}")

print("\nAll dashboards reordered!")
