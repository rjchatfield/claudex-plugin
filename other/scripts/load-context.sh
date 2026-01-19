#!/bin/bash

# WIP!

USER_INFO_PATH="${CLAUDE_PROJECT_DIR}/.claude/plugin-config.json"

if [ -f "$USER_INFO_PATH" ]; then
  # Extract contextFile field from JSON (requires jq)
  GAME_NAME=$(jq -r '.game // "'"$DEFAULT_CONTEXT"'"' "$USER_INFO_PATH")
else
  GAME_NAME="_"
fi

GAME_INFO_PATH="${CLAUDE_PLUGIN_ROOT}/other/games/${GAME_NAME}/info.md"

# Extract game metadata from info.json
VERSION_ID=$(jq -r '.version.id' $GAME_INFO_PATH)
VERSION_GROUP_ID=$(jq -r '.version_group.id' $GAME_INFO_PATH)
GENERATION_ID=$(jq -r '.generation' $GAME_INFO_PATH)
REGION_ID=$(jq -r '.main_region.id' $GAME_INFO_PATH)
POKEDEX_IDS=$(jq -r '.pokedexes[].id' $GAME_INFO_PATH)

VERSION_JSON_PATH="${CLAUDE_PLUGIN_ROOT}/other/pokeapi"
VERSION_GROUP_JSON_PATH="${CLAUDE_PLUGIN_ROOT}/other/pokeapi"
GENERATION_JSON_PATH="${CLAUDE_PLUGIN_ROOT}/other/pokeapi"
REGION_JSON_PATH="${CLAUDE_PLUGIN_ROOT}/other/pokeapi"

if [ -f "$GAME_INFO_PATH" ]; then
  CONTEXT=$(cat "$GAME_INFO_PATH")
else
  CONTEXT="# Warning: Context file ${GAME_NAME}.md not found"
fi

# Output with additionalContext
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "${CONTEXT}"
  }
}
EOF

exit 0
