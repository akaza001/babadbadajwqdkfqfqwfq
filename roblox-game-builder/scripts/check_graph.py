#!/usr/bin/env python3
"""Validate dependency graph and optionally print a requested prerequisite closure."""
import argparse
import json
from pathlib import Path

def validate(data):
    nodes = data['nodes']
    ids = [node['id'] for node in nodes]
    if len(set(ids)) != len(ids):
        raise ValueError('Duplicate node ID')
    lookup = {node['id']: node for node in nodes}
    active, done, order = set(), set(), []
    def visit(key):
        if key in active:
            raise ValueError(f'Dependency cycle at {key}')
        if key in done:
            return
        active.add(key)
        for dep in lookup[key]['requires']:
            visit(dep)
        active.remove(key)
        done.add(key)
        order.append(key)
    for node in nodes:
        if not node.get('output') or not node.get('verify'):
            raise ValueError(f'Missing outcome/check: {node["id"]}')
        for key in node['requires'] + node.get('related', []):
            if key not in lookup:
                raise ValueError(f'Unknown node: {key}')
    for key in ids:
        visit(key)
    return lookup, order

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--graph', type=Path, default=Path(__file__).resolve().parents[1] / 'references/graph.json')
    parser.add_argument('--target', help='Print required nodes for this target in execution order')
    args = parser.parse_args()
    lookup, order = validate(json.loads(args.graph.read_text()))
    if args.target:
        if args.target not in lookup:
            parser.error(f'Unknown target {args.target}')
        needed = set()
        def collect(key):
            if key in needed:
                return
            needed.add(key)
            for dep in lookup[key]['requires']:
                collect(dep)
        collect(args.target)
        print(' -> '.join(key for key in order if key in needed))
    else:
        print(f'Valid graph: {len(lookup)} nodes')
if __name__ == '__main__':
    main()
