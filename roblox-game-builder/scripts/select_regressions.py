#!/usr/bin/env python3
"""Select source-backed Roblox regression checks by development-graph topic."""
import argparse
import json
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
ALWAYS = {'latest-decision', 'idempotent-rebuild'}

def select(records, tags, all_records=False):
    return [r for r in records if all_records or r['id'] in ALWAYS or set(r['tags']) & set(tags)]

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--tags', help='Comma-separated node IDs, e.g. map,animation,combat')
    group.add_argument('--all', action='store_true', help='Checks for a whole new game')
    parser.add_argument('--json', action='store_true')
    args = parser.parse_args()
    records = json.loads((BASE / 'references/regression-cases.json').read_text())['records']
    nodes = {n['id'] for n in json.loads((BASE / 'references/graph.json').read_text())['nodes']}
    tags = {s.strip() for s in (args.tags or '').split(',') if s.strip()}
    if args.tags is not None and not tags:
        parser.error('Specify at least one topic')
    if tags - nodes:
        parser.error('Unknown graph topics: ' + ', '.join(sorted(tags - nodes)))
    selected = select(records, tags, args.all)
    if args.json:
        print(json.dumps(selected, ensure_ascii=False, indent=2))
    else:
        for r in selected:
            print(f'[{r["id"]}] {r["reported_problem"]}\nПредотвращение: {r["prevention"]}\nПриёмка: {r["acceptance_check"]}\n')

if __name__ == '__main__':
    main()
