# Start every Claude Code session in the background so reborn can bring it back.
# Source this from ~/.zshrc (or ~/.bashrc).
#
#   claude           start a background session and open it
#   Ctrl+Z           leave it running
#   claude attach    go back to the session started in this tab
#
# Anything else, like `claude -p` or `claude agents`, goes straight to the real CLI.
claude() {
  if [ $# -eq 0 ]; then
    local id
    id=$(command claude --bg 2>&1 | grep -o 'backgrounded · [0-9a-f]\{8\}' | awk '{print $3}')
    if [ -n "$id" ]; then
      CLAUDE_BG_ID=$id
      echo "background session $id (after Ctrl+Z, run: claude attach)"
      command claude attach "$id"
    else
      command claude
    fi
  elif [ "$1" = attach ] && [ $# -eq 1 ] && [ -n "${CLAUDE_BG_ID:-}" ]; then
    command claude attach "$CLAUDE_BG_ID"
  else
    command claude "$@"
  fi
}
