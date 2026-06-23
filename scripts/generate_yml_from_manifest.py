#!/usr/bin/env python3
"""
Generate YML schema files from dbt manifest.
"""

import json
from pathlib import Path

def generate_yml_for_model(model_name, columns):
    """Generate YML content for a model."""
    yml_lines = [
        "version: 2",
        "",
        "models:",
        f"  - name: {model_name}",
        '    description: ""',
        "    columns:"
    ]

    for col_name, col_info in columns.items():
        data_type = col_info.get('data_type', col_info.get('type', 'unknown'))
        yml_lines.append(f"      - name: {col_name}")
        yml_lines.append(f"        data_type: {data_type}")
        yml_lines.append('        description: ""')
        yml_lines.append("")

    return "\n".join(yml_lines)

def main():
    project_root = Path(__file__).parent.parent
    manifest_path = project_root / "target" / "manifest.json"

    if not manifest_path.exists():
        print(f"Error: manifest.json not found at {manifest_path}")
        print("Please run 'dbt compile' first")
        return

    with open(manifest_path, 'r') as f:
        manifest = json.load(f)

    # Models to generate YML for
    models_to_generate = {
        'model.stmsn_dbt.fact_parcels': 'models/silver/fact_parcels.yml',
        'model.stmsn_dbt.fact_streets': 'models/silver/fact_streets.yml',
        'model.stmsn_dbt.fact_tax_roll': 'models/silver/fact_tax_roll.yml',
        'model.stmsn_dbt.fact_sites': 'models/gold/fact_sites.yml',
        'model.stmsn_dbt.fact_alder_districts': 'models/gold/fact_alder_districts.yml',
        'model.stmsn_dbt.fact_area_plans': 'models/gold/fact_area_plans.yml',
    }

    for model_key, yml_path in models_to_generate.items():
        if model_key in manifest['nodes']:
            model_node = manifest['nodes'][model_key]
            model_name = model_node['name']
            columns = model_node.get('columns', {})

            # Generate YML content
            yml_content = generate_yml_for_model(model_name, columns)

            # Write to file
            output_path = project_root / yml_path
            with open(output_path, 'w') as f:
                f.write(yml_content)

            print(f"✓ Generated {yml_path} with {len(columns)} columns")
        else:
            print(f"✗ Model {model_key} not found in manifest")

if __name__ == "__main__":
    main()
