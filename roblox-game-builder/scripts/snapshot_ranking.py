#!/usr/bin/env python3
"""Save a new, immutable top-50 snapshot of publicly tracked Roblox CCU."""
import argparse
from datetime import datetime, timezone
import json
from pathlib import Path
import subprocess

URL = 'https://www.rolimons.com/games'

def parse_ranking(html):
    marker = 'var games = '
    if marker not in html:
        raise ValueError('Source format changed: var games not found')
    games, _ = json.JSONDecoder().raw_decode(html.split(marker, 1)[1])
    if not isinstance(games, dict) or len(games) < 50:
        raise ValueError('Expected at least 50 tracked games')
    rows = []
    for place_id, game in games.items():
        if not isinstance(place_id, str) or not place_id.isdigit():
            raise ValueError('Invalid placeId')
        players = game.get('players')
        if type(players) is not int or players < 0:
            raise ValueError(f'Invalid CCU: {place_id}')
        if not isinstance(game.get('name'), str) or not game['name']:
            raise ValueError(f'Invalid name: {place_id}')
        rows.append({'place_id': place_id, 'name': game['name'], 'players': players})
    rows.sort(key=lambda row: (-row['players'], row['place_id']))
    return [dict(rank=i, **row) for i, row in enumerate(rows[:50], 1)]

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, required=True, help='New snapshot directory, must not exist')
    parser.add_argument('--html-file', type=Path, help='Parse an already downloaded public HTML file offline')
    args = parser.parse_args()
    if args.output.exists():
        parser.error('Output already exists; choose a new snapshot directory')
    if args.html_file:
        html = args.html_file.read_text()
    else:
        result = subprocess.run(['curl', '--fail', '--silent', '--show-error', '--location', '--max-time', '45', URL], capture_output=True, text=True, check=True)
        html = result.stdout
    rows = parse_ranking(html)
    # Create only after successful parsing; exclusive creation protects prior research.
    args.output.mkdir(parents=True, exist_ok=False)
    (args.output / 'ranking.json').write_text(json.dumps(rows, ensure_ascii=False, indent=2) + '\n')
    manifest = {'collected_at_utc': datetime.now(timezone.utc).isoformat(), 'source': URL, 'source_data_time': None, 'count': len(rows), 'scope': 'tracked experiences; global completeness and universe deduplication unverified', 'method': 'public HTML var games sorted by players descending', 'offline_input': bool(args.html_file), 'descriptions_reviewed': 0, 'visual_inspections': 0}
    (args.output / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n')
    print(f'Saved {len(rows)} games to {args.output}; mechanic review remains required')
if __name__ == '__main__':
    main()
