#!/bin/bash
# install.sh — Install EDNA skill globally

REPO_URL="https://github.com/arinadi/EDNA"
SKILL_NAME="edna"

install_to() {
  DIR="$1/$SKILL_NAME"
  if [ -d "$DIR" ]; then
    echo "🔄 Updating EDNA in $DIR..."
    cd "$DIR" && git pull --quiet
  else
    echo "📦 Installing EDNA to $DIR..."
    mkdir -p "$1"
    git clone "$REPO_URL" "$DIR" --quiet
  fi
  echo "✅ Done: $DIR"
}

# Install to common agent skill directories
install_to "$HOME/.claude/skills"      # Claude Code
install_to "$HOME/.gemini/skills"      # Gemini CLI
install_to "$HOME/.antigravity/skills" # Antigravity

echo ""
echo "EDNA Skill installed successfully."
echo "Restart your agent and run '/skills' (Claude) or check your skill list to verify."
