#!/usr/bin/env python3
"""
Claudex CLI - Fast Pokemon facts and team analysis
Usage: poke <command> [args]
"""

import sys
from pathlib import Path

# Add plugin lib to path
plugin_dir = Path(__file__).parent.parent
sys.path.insert(0, str(plugin_dir))

from cli.commands import type_check, team_coverage, find_pokemon, move_info, team_view

COMMANDS = {
    'type': type_check.run,
    'coverage': team_coverage.run,
    'find': find_pokemon.run,
    'move': move_info.run,
    'team': team_view.run,
}

def main():
    if len(sys.argv) < 2:
        print("Usage: poke <command> [args]")
        print("\nCommands:")
        print("  type <attacking> <defending>  - Check type effectiveness")
        print("  coverage                      - Analyze current team coverage")
        print("  find <pokemon>                - Where to catch a Pokemon")
        print("  move <move-name>              - Move details")
        print("  team                          - Show current team")
        sys.exit(1)
    
    command = sys.argv[1]
    args = sys.argv[2:]
    
    if command not in COMMANDS:
        print(f"Unknown command: {command}")
        sys.exit(1)
    
    COMMANDS[command](args)

if __name__ == "__main__":
    main()
