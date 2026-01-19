def run(args):
    """Find where to catch a Pokemon: poke find Mimikyu"""
    if not args:
        print("Usage: poke find <pokemon-name>")
        return
    
    pokemon_name = ' '.join(args).lower()
    
    # Determine current game from CLAUDE.md or context
    current_game = detect_current_game()
    
    # Load game-specific dex
    dex_file = Path(__file__).parent.parent.parent / f'data/game-dex/{current_game}.json'
    
    with open(dex_file) as f:
        dex = json.load(f)
    
    entry = next((p for p in dex['available_species'] if p['name'].lower() == pokemon_name), None)
    
    if entry:
        print(f"\n🎯 {entry['name'].title()}")
        print(f"   Location: {entry['catchable_location']}")
        print(f"   Game: {current_game.replace('-', ' ').title()}")
    else:
        print(f"\n❌ {pokemon_name.title()} not available in {current_game.replace('-', ' ').title()}")
