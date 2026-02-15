#!/bin/bash
# Claude Dotfiles - Install Script
# https://github.com/JuChLi/claude-dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.claude/skills"

echo "Installing Claude Code skills..."
echo "Source: $SCRIPT_DIR/skills/"
echo "Target: $TARGET_DIR"
echo ""

for skill_dir in "$SCRIPT_DIR/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    mkdir -p "$TARGET_DIR/$skill_name"
    cp "$skill_dir"* "$TARGET_DIR/$skill_name/"
    echo "  /$skill_name"
done

echo ""
echo "Done! Restart Claude Code or start a new session to use the skills."
