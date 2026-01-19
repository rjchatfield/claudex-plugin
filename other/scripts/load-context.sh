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

current_game_directory_path() {
  if [ -f "$CURRENT_GAME_DIRECTORY_PATH" ]; then
    echo "$CURRENT_GAME_DIRECTORY_PATH"
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
  echo "${CLAUDE_PLUGIN_ROOT}/other/games/${GAME_NAME}"
}
CURRENT_GAME_DIRECTORY_PATH=$(current_game_directory_path)

current_game_info_path() {
  echo "$(current_game_directory_path)/info.json"
}

# Versions

current_version_id() {
  echo $(jq -r '.version' $(current_game_info_path))
}
version_json_path() {
  local ID="$1"
  echo "${CLAUDE_PLUGIN_ROOT}/other/pokeapi/version/$ID/index.json"
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
  echo "${CLAUDE_PLUGIN_ROOT}/other/pokeapi/version-group/$ID/index.json"
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
  echo "${CLAUDE_PLUGIN_ROOT}/other/pokeapi/generation/$ID/index.json"
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
  echo "${CLAUDE_PLUGIN_ROOT}/other/pokeapi/region/$ID/index.json"
}
current_region_json_path() {
  echo "$(region_json_path $(current_region_id))"
}

VERSION_NAME=$(jq -r '.name' $(current_version_json_path))
VERSION_GROUP_NAME=$(jq -r '.name' $(current_version_group_json_path))
GENERATION_NAME=$(jq -r '.name' $(current_generation_json_path))
REGION_NAME=$(jq -r '.name' $(current_region_json_path))

CONTEXT="
$(cat "$CLAUDE_PLUGIN_ROOT/other/prompts/system_prompt.md")

# Game info

VERSION:       $VERSION_NAME ($(current_version_id))
VERSION_GROUP: $VERSION_GROUP_NAME ($(current_version_group_id))
GENERATION:    $GENERATION_NAME ($(current_generation_id))
REGION:        $REGION_NAME ($(current_region_id))

$(cat "$(current_game_directory_path)/recommendations.md")

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
