#!/bin/bash

# WIP!

# TEMP!

if [ -z "$CLAUDE_PLUGIN_ROOT" ]; then
  CLAUDE_PLUGIN_ROOT=~/Developer/claudex/plugin
fi

if [ -z "$CLAUDE_PROJECT_DIR" ]; then
  CLAUDE_PROJECT_DIR=~/Developer/claudex/games/ultra-sun
fi

# TEMP!

USER_GAME_DIRECTORY_PATH=$CLAUDE_PROJECT_DIR

# "Current"

current_game() {
  if [ -f "$CURRENT_GAME" ]; then
    echo "$CURRENT_GAME"
    exit 0
  fi
  local USER_INFO_PATH="${CLAUDE_PROJECT_DIR}/info.json"
  local GAME_NAME
  if [ -f "$USER_INFO_PATH" ]; then
    # Extract contextFile field from JSON (requires jq)
    GAME_NAME=$(jq -r '.game' "$USER_INFO_PATH")
  else
    echo "$USER_INFO_PATH not found"
    exit 1
  fi
  echo $GAME_NAME
}
CURRENT_GAME=$(current_game)

PROMPTS_DIRECTORY_PATH="$CLAUDE_PLUGIN_ROOT/other/prompts"
CURRENT_GAME_PROMPTS_DIRECTORY_PATH="$PROMPTS_DIRECTORY_PATH/per-game/${CURRENT_GAME}"
CURRENT_GAME_GENERATED_DIRECTORY_PATH="$CLAUDE_PLUGIN_ROOT/other/generated/${CURRENT_GAME}"

current_game_info_path() {
  echo "$CURRENT_GAME_GENERATED_DIRECTORY_PATH/info.json"
}

POKEAPI_DATA="${CLAUDE_PLUGIN_ROOT}/other/pokeapi-data/api/v2"

# Versions

current_version_id() {
  echo $(jq -r '.version' $(current_game_info_path))
}
version_json_path() {
  local ID="$1"
  echo "$POKEAPI_DATA/version/$ID/index.json"
}
current_version_json_path() {
  echo "$(version_json_path $(current_version_id))"
}

# Version Groups

current_version_group_id() {
  echo $(jq -r '.version_group' $(current_game_info_path))
}
version_group_json_path() {
  local ID="$1"
  echo "$POKEAPI_DATA/version-group/$ID/index.json"
}
current_version_group_json_path() {
  echo "$(version_group_json_path $(current_version_group_id))"
}

# Generations

current_generation_id() {
  echo $(jq -r '.generation' $(current_game_info_path))
}
generation_json_path() {
  local ID="$1"
  echo "$POKEAPI_DATA/generation/$ID/index.json"
}
current_generation_json_path() {
  echo "$(generation_json_path $(current_generation_id))"
}

# Region

current_region_id() {
  echo $(jq -r '.main_region' $(current_game_info_path))
}
region_json_path() {
  local ID="$1"
  echo "$POKEAPI_DATA/region/$ID/index.json"
}
current_region_json_path() {
  echo "$(region_json_path $(current_region_id))"
}

VERSION_NAME=$(jq -r '.name' $(current_version_json_path))
VERSION_GROUP_NAME=$(jq -r '.name' $(current_version_group_json_path))
GENERATION_NAME=$(jq -r '.name' $(current_generation_json_path))
REGION_NAME=$(jq -r '.name' $(current_region_json_path))

CONTEXT="
$(cat "$PROMPTS_DIRECTORY_PATH/system_prompt.md")

# Game info

VERSION:       $VERSION_NAME ($(current_version_id))
VERSION_GROUP: $VERSION_GROUP_NAME ($(current_version_group_id))
GENERATION:    $GENERATION_NAME ($(current_generation_id))
REGION:        $REGION_NAME ($(current_region_id))

$(cat "$CURRENT_GAME_PROMPTS_DIRECTORY_PATH/recommendations.md")

$(cat "$USER_GAME_DIRECTORY_PATH/team.md")

$(cat "$USER_GAME_DIRECTORY_PATH/progress.md")

$(cat "$USER_GAME_DIRECTORY_PATH/notes.md")
"

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
