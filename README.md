# Claude Dotfiles

Personal Claude Code configuration with custom skills for project progress tracking.

## Skills

| Skill | Description |
|-------|-------------|
| `/save` | Save current project progress to `.claude/progress.md` with auto-archiving history |
| `/load` | Load saved progress, show summary, compare git state, and list history |

### How It Works

These skills implement a "game save/load" pattern for coding sessions:

1. **`/save`** — Analyzes conversation context and git history, writes a structured summary to `.claude/progress.md`. If a previous save exists, it gets archived to `.claude/progress-history.md`.
2. **`/load`** — Reads `progress.md` and `progress-history.md`, compares current git state with saved state, and asks which TODO to continue.

This enables seamless context handoff between sessions.

### Project File Structure

After using `/save`, your project will contain:

```
your-project/
└── .claude/
    ├── progress.md           ← Latest saved progress
    └── progress-history.md   ← Archived history (newest first)
```

## Install

All methods below install to `~/.claude/skills/` (user-level), so `/save` and `/load` are available **globally across all projects**.

### Option 1: Install Script (Recommended)

```bash
# Clone
git clone https://github.com/JuChLi/claude-dotfiles.git ~/claude-dotfiles-temp
cd ~/claude-dotfiles-temp

# Install (copies skills to ~/.claude/skills/)
./install.sh        # Linux / macOS / Git Bash
.\install.ps1       # Windows PowerShell

# Cleanup
cd ~ && rm -rf ~/claude-dotfiles-temp
```

### Option 2: Ask Claude

In any Claude Code session, say:

```
請幫我從 https://github.com/JuChLi/claude-dotfiles clone 並執行安裝腳本
```

### Option 3: One-liner

```bash
git clone https://github.com/JuChLi/claude-dotfiles.git /tmp/claude-dotfiles && /tmp/claude-dotfiles/install.sh && rm -rf /tmp/claude-dotfiles
```

PowerShell:

```powershell
git clone https://github.com/JuChLi/claude-dotfiles.git $env:TEMP\claude-dotfiles; & "$env:TEMP\claude-dotfiles\install.ps1"; Remove-Item -Recurse -Force "$env:TEMP\claude-dotfiles"
```

## Uninstall

```bash
rm -rf ~/.claude/skills/save ~/.claude/skills/load
```

## Repository Structure

```
claude-dotfiles/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest (for /plugin install)
├── skills/
│   ├── save/
│   │   └── SKILL.md     # /save skill
│   └── load/
│       └── SKILL.md     # /load skill
├── install.sh           # Linux/macOS/Git Bash installer
├── install.ps1          # Windows PowerShell installer
└── README.md            # This file
```

## Adding New Skills

1. Create a directory under `skills/` with a `SKILL.md` file
2. Add YAML frontmatter (`name`, `description`, `user-invocable`, etc.)
3. Write the prompt template using [Claude Code skill syntax](https://docs.anthropic.com/en/docs/claude-code/skills)
4. Push to GitHub
5. Re-run install script on other machines

## Reference

- [Claude Code Skills Documentation](https://docs.anthropic.com/en/docs/claude-code/skills)
- [Claude Code Plugins Documentation](https://docs.anthropic.com/en/docs/claude-code/plugins)
