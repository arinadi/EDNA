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
    git clone --depth 1 "$REPO_URL" "$DIR" --quiet
  fi
  echo "✅ Done: $DIR"
}

gemini_native_install() {
  if command -v gemini &> /dev/null; then
    echo "🚀 Using native 'gemini skills install'..."
    gemini skills install "$REPO_URL"
  else
    install_to "$HOME/.gemini/skills"
  fi
}

echo "💎 EDNA Skill Installer"
echo "Select target AI Agent(s):"
echo "1) Claude Code (~/.claude/skills)"
echo "2) Gemini CLI (Native/Manual)"
echo "3) Cursor (~/.cursor/rules)"
echo "4) Windsurf (~/.windsurf/skills)"
echo "5) Antigravity (~/.antigravity/skills)"
echo "6) All of the above"
echo "7) Cancel"
read -p "Enter choice [1-7]: " choice

case $choice in
  1) install_to "$HOME/.claude/skills" ;;
  2) gemini_native_install ;;
  3) install_to "$HOME/.cursor/rules" ;;
  4) install_to "$HOME/.windsurf/skills" ;;
  5) install_to "$HOME/.antigravity/skills" ;;
  6) 
    install_to "$HOME/.claude/skills"
    gemini_native_install
    install_to "$HOME/.cursor/rules"
    install_to "$HOME/.windsurf/skills"
    install_to "$HOME/.antigravity/skills"
    ;;
  *) echo "Installation cancelled."; exit 0 ;;
esac

echo ""
echo "EDNA Skill installed successfully."
echo "Restart your agent to apply changes."
