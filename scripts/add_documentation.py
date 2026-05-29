#!/usr/bin/env python3
"""
Automated script to match YML columns with doc blocks and insert documentation references.
Generates placeholder doc blocks for undocumented columns.
"""

import re
from pathlib import Path
from collections import defaultdict

try:
    from ruamel.yaml import YAML
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.width = 4096
except ImportError:
    print("Warning: ruamel.yaml not found, falling back to PyYAML")
    import yaml as pyyaml
    yaml = None

class DocumentationMatcher:
    def __init__(self, docs_dir: Path, models_dir: Path):
        self.docs_dir = docs_dir
        self.models_dir = models_dir
        self.existing_docs = self._parse_existing_docs()
        self.undocumented_columns = defaultdict(list)
        self.stats = {
            'total_columns': 0,
            'documented': 0,
            'undocumented': 0,
            'files_processed': 0
        }

    def _parse_existing_docs(self) -> set:
        """Parse all doc blocks from docs/_docs_*.md files."""
        doc_blocks = set()
        for doc_file in self.docs_dir.glob("_docs_*.md"):
            with open(doc_file, 'r') as f:
                content = f.read()
                # Extract doc block names
                matches = re.findall(r'{%\s*docs\s+(\w+)\s*%}', content)
                doc_blocks.update(matches)
                print(f"  Found {len(matches)} doc blocks in {doc_file.name}")

        return doc_blocks

    def process_yml_file(self, yml_path: Path):
        """Process a YML file and add documentation references."""
        if not yml_path.exists():
            print(f"  ✗ File not found: {yml_path}")
            return

        print(f"\nProcessing {yml_path}...")

        with open(yml_path, 'r') as f:
            if yaml:
                yml_content = yaml.load(f)
            else:
                yml_content = pyyaml.safe_load(f)

        if not yml_content or 'models' not in yml_content:
            print(f"  ✗ No models found in {yml_path}")
            return

        model = yml_content['models'][0]
        model_name = model['name']

        if 'columns' not in model or not model['columns']:
            print(f"  ✗ No columns found in {model_name}")
            return

        columns_processed = 0
        columns_documented = 0

        for column in model['columns']:
            col_name = column['name']
            self.stats['total_columns'] += 1
            columns_processed += 1

            # Check if doc block exists
            if col_name in self.existing_docs:
                # Update description to reference doc block
                column['description'] = f'{{{{ doc("{col_name}") }}}}'
                self.stats['documented'] += 1
                columns_documented += 1
            else:
                # Mark as undocumented
                self.undocumented_columns[model_name].append(col_name)
                column['description'] = f'{{{{ doc("{col_name}") }}}}'
                self.stats['undocumented'] += 1

        # Write updated YML
        with open(yml_path, 'w') as f:
            if yaml:
                yaml.dump(yml_content, f)
            else:
                pyyaml.dump(yml_content, f, default_flow_style=False, sort_keys=False)

        self.stats['files_processed'] += 1
        print(f"  ✓ Processed {columns_processed} columns ({columns_documented} documented, {columns_processed - columns_documented} need docs)")

    def generate_placeholder_docs(self, output_file: Path):
        """Generate placeholder doc blocks for undocumented columns."""
        if not self.undocumented_columns:
            print("\n✓ All columns are already documented!")
            return

        with open(output_file, 'w') as f:
            f.write("# PLACEHOLDER DOCUMENTATION - NEEDS REVIEW\n")
            f.write("# Generated doc blocks for calculated/derived columns\n")
            f.write("#\n")
            f.write("# Please review and update these doc blocks with proper descriptions.\n")
            f.write("# These are referenced in the YML files but don't have documentation yet.\n\n")

            for model, columns in sorted(self.undocumented_columns.items()):
                f.write(f"\n## From model: {model}\n")
                f.write(f"## ({len(columns)} undocumented columns)\n\n")

                for col in sorted(columns):
                    f.write(f"{{% docs {col} %}}\n")
                    f.write(f"TODO: Add documentation for {col}.\n")
                    f.write("{% enddocs %}\n\n")

        print(f"\n✓ Generated placeholder docs: {output_file}")
        print(f"  {sum(len(cols) for cols in self.undocumented_columns.values())} columns need documentation")

def main():
    # Configure paths
    project_root = Path(__file__).parent.parent
    docs_dir = project_root / "docs"

    print("=" * 60)
    print("DBT Documentation Automation Script")
    print("=" * 60)

    print("\n1. Parsing existing documentation...")
    matcher = DocumentationMatcher(docs_dir, project_root / "models")
    print(f"\n✓ Found {len(matcher.existing_docs)} existing doc blocks")

    # YML files to process
    yml_files = [
        "models/silver/fact_parcels.yml",
        "models/silver/fact_streets.yml",
        "models/silver/fact_tax_roll.yml",
        "models/gold/fact_sites.yml",
        "models/gold/fact_alder_districts.yml",
        "models/gold/fact_area_plans.yml",
    ]

    print("\n2. Processing YML files...")
    for yml_file in yml_files:
        yml_path = project_root / yml_file
        matcher.process_yml_file(yml_path)

    # Generate placeholder docs
    print("\n3. Generating placeholder documentation...")
    placeholder_file = docs_dir / "_docs_calculated_placeholders.md"
    matcher.generate_placeholder_docs(placeholder_file)

    # Print summary
    print("\n" + "=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Files processed:      {matcher.stats['files_processed']}")
    print(f"Total columns:        {matcher.stats['total_columns']}")
    print(f"Already documented:   {matcher.stats['documented']}")
    print(f"Need documentation:   {matcher.stats['undocumented']}")
    print(f"Coverage:             {matcher.stats['documented'] / max(matcher.stats['total_columns'], 1) * 100:.1f}%")

    if matcher.undocumented_columns:
        print("\nUndocumented columns by model:")
        for model, cols in sorted(matcher.undocumented_columns.items()):
            print(f"  {model}: {len(cols)} columns")
            if len(cols) <= 10:
                print(f"    {', '.join(cols)}")

    print("\n✓ Done! Next steps:")
    print("  1. Review and update placeholder docs in _docs_calculated_placeholders.md")
    print("  2. Move completed doc blocks to appropriate _docs_*.md files")
    print("  3. Run 'dbt docs generate' to verify")

if __name__ == "__main__":
    main()
