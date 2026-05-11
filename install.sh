#!/bin/bash
# install.sh — Install EDNA skill with provider selection

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

echo "💎 EDNA Skill Installer"
echo "Select target AI Agent(s):"
echo "1) Claude Code (~/.claude/skills)"
echo "2) Gemini CLI (~/.gemini/skills)"
echo "3) Antigravity (~/.antigravity/skills)"
echo "4) All of the above"
echo "5) Cancel"
read -p "Enter choice [1-5]: " choice

case $choice in
  1) install_to "$HOME/.claude/skills" ;;
  2) install_to "$HOME/.gemini/skills" ;;
  3) install_to "$HOME/.antigravity/skills" ;;
  4) 
    install_to "$HOME/.claude/skills"
    install_to "$HOME/.gemini/skills"
    install_to "$HOME/.antigravity/skills"
    ;;
  *) echo "Installation cancelled."; exit 0 ;;
esac

echo ""
echo "EDNA Skill installed successfully."
echo "Restart your agent to apply changes."
