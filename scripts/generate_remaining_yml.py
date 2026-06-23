#!/usr/bin/env python3
"""
Generate YML files for models by querying DuckDB or reading compiled SQL.
"""

import duckdb
import re
from pathlib import Path

def get_columns_from_db(model_name):
    """Query DuckDB to get column information."""
    try:
        conn = duckdb.connect(str(Path.home() / 'stmsn_dbt' / 'dev.duckdb'), read_only=True)
        result = conn.execute(f"""
            SELECT column_name, data_type
            FROM information_schema.columns
            WHERE table_name = '{model_name}'
            AND table_schema = 'main'
            ORDER BY ordinal_position
        """).fetchall()
        conn.close()
        return [(row[0], row[1]) for row in result]
    except Exception as e:
        print(f"Error querying {model_name}: {e}")
        return []

def parse_compiled_sql_columns(compiled_sql_path):
    """Parse compiled SQL to extract column names."""
    if not compiled_sql_path.exists():
        return []

    with open(compiled_sql_path, 'r') as f:
        content = f.read()

    # Extract column names from SELECT statements
    # This is a simple heuristic - look for lines with 'as column_name'
    columns = []
    for line in content.split('\n'):
        # Match patterns like: "column_expr as column_name,"
        match = re.search(r'\s+as\s+(\w+)[,\s]*', line, re.IGNORECASE)
        if match:
            columns.append((match.group(1), 'unknown'))
        # Match simple column names
        elif re.match(r'^\s+(\w+)[,\s]*$', line):
            col = line.strip().rstrip(',')
            if col and col not in ['select', 'from', 'where', 'group', 'order', 'by', 'and', 'or']:
                columns.append((col, 'unknown'))

    return columns

def generate_yml(model_name, columns):
    """Generate YML content."""
    if not columns:
        return None

    yml_lines = [
        "version: 2",
        "",
        "models:",
        f"  - name: {model_name}",
        '    description: ""',
        "    columns:"
    ]

    for col_name, data_type in columns:
        yml_lines.append(f"      - name: {col_name}")
        yml_lines.append(f"        data_type: {data_type}")
        yml_lines.append('        description: ""')
        yml_lines.append("")

    return "\n".join(yml_lines)

def main():
    project_root = Path(__file__).parent.parent

    models = [
        ('fact_tax_roll', 'models/silver/fact_tax_roll.yml', 'db'),
        ('fact_streets', 'models/silver/fact_streets.yml', 'compiled'),
        ('fact_sites', 'models/gold/fact_sites.yml', 'compiled'),
        ('fact_alder_districts', 'models/gold/fact_alder_districts.yml', 'compiled'),
        ('fact_area_plans', 'models/gold/fact_area_plans.yml', 'compiled'),
    ]

    for model_name, yml_path, source in models:
        print(f"\nProcessing {model_name}...")

        if source == 'db':
            columns = get_columns_from_db(model_name)
        else:
            compiled_path = project_root / "target" / "compiled" / "stmsn_dbt" / "models" / yml_path.replace('.yml', '.sql').split('/')[-2:]
            # Adjust path
            if 'gold' in yml_path:
                compiled_path = project_root / "target" / "compiled" / "stmsn_dbt" / "models" / "gold" / f"{model_name}.sql"
            else:
                compiled_path = project_root / "target" / "compiled" / "stmsn_dbt" / "models" / "silver" / f"{model_name}.sql"

            columns = parse_compiled_sql_columns(compiled_path)

        if columns:
            yml_content = generate_yml(model_name, columns)
            if yml_content:
                output_path = project_root / yml_path
                with open(output_path, 'w') as f:
                    f.write(yml_content)
                print(f"✓ Generated {yml_path} with {len(columns)} columns")
        else:
            print(f"✗ No columns found for {model_name}")

if __name__ == "__main__":
    main()
