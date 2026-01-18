import json
from pathlib import Path

def run(args):
    """Analyze team type coverage: poke coverage"""
    
    # Find team.json (look in current dir or parent)
    team_file = Path('team.json')
    if not team_file.exists():
        team_file = Path('../team.json')
    
    if not team_file.exists():
        print("❌ No team.json found")
        return
    
    with open(team_file) as f:
        team = json.load(f)['team']
    
    # Extract all move types
    move_types = set()
    for pokemon in team:
        for move in pokemon.get('moves', []):
            move_type = lookup_move_type(move)  # From pokemon_db
            if move_type:
                move_types.add(move_type)
    
    # Check coverage against common defensive types
    defensive_types = ['Steel', 'Water', 'Dragon', 'Fairy', 'Ground', 'Ghost']
    
    print("\n📊 Team Coverage Analysis")
    print(f"   Move types: {', '.join(sorted(move_types))}\n")
    
    for def_type in defensive_types:
        best_multiplier = max(
            get_effectiveness(move_type, def_type) 
            for move_type in move_types
        )
        
        status = "✅" if best_multiplier >= 2 else "⚠️" if best_multiplier >= 1 else "❌"
        print(f"{status} {def_type:8} - {best_multiplier}x coverage")
