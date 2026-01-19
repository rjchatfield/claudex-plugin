import json
from pathlib import Path
from lib.pokemon_db import get_type_chart

def run(args):
    """Check type effectiveness: poke type Electric Water,Flying"""
    if len(args) < 2:
        print("Usage: poke type <attacking> <defending>")
        return
    
    attacking = args[0]
    defending = args[1].split(',')
    
    chart = get_type_chart()
    multiplier = 1.0
    
    for def_type in defending:
        effectiveness = chart[attacking.lower()].get(def_type.lower(), 1.0)
        multiplier *= effectiveness
    
    # Pretty output
    emoji = "🔥" if multiplier > 1 else "🛡️" if multiplier < 1 else "⚔️"
    
    print(f"\n{emoji} {attacking} → {'/'.join(defending)}")
    print(f"   Damage: {multiplier}x", end='')
    
    if multiplier >= 2:
        print(" (Super effective!)")
    elif multiplier > 1:
        print(" (Effective)")
    elif multiplier == 1:
        print(" (Normal)")
    elif multiplier > 0:
        print(" (Not very effective...)")
    else:
        print(" (No effect!)")
