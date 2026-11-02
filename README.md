# reborn

Reopen your Claude Code tabs after a restart.

Once a minute, reborn notes which Claude Code sessions are open in your terminal tabs. After a restart it opens one iTerm tab per session and continues each conversation where it left off. A tab you close is forgotten within a few minutes, so only what you actually had open comes back.

## Install

```sh
git clone https://github.com/yozzz/reborn ~/reborn
ln -s ~/reborn/bin/reborn ~/.local/bin/reborn   # any directory on your PATH
reborn install
```

Needs macOS, iTerm, `jq` (built into recent macOS) and Claude Code (tested with 2.1.316).

## Commands

| Command | Does |
|---|---|
| `reborn status` | show the Claude tabs that would come back after a restart |
| `reborn restore` | reopen them in iTerm; runs at login (log: `~/Library/Logs/reborn.log`) |
| `reborn snapshot` | note which Claude tabs are open; runs every minute |
| `reborn install` | set up both login items |
| `reborn uninstall` | remove them |

## How it works

Claude Code keeps a live list of its running sessions in `~/.claude/sessions/`. Every minute reborn copies the ones running in a terminal to `~/.local/state/reborn/open-tabs.tsv`. A session that disappears stays on the list for about 2½ minutes, because a shutdown closes every tab at once and the list has to survive that. At login, reborn runs `claude --resume <id>` in its folder for each session from before the restart. It uses the empty tabs iTerm restores on its own first, and opens new tabs only when there aren't enough.

Tabs showing a background session with `claude attach <id>` are remembered too, and come back with `claude attach`.

## Limits

- **It reads internal files.** `~/.claude/sessions/` and `~/.claude/daemon/roster.json` aren't a public API, and a Claude Code update could change them.
- **Timing.** A tab closed in the last ~2 minutes before a restart may come back; one opened in the last minute may not.
- **The agent view isn't tracked.** Claude doesn't record which session a `claude agents` tab is showing, so those tabs don't come back. For a background session you want kept, use `claude attach <id>`.
- **Tabs need permission.** The first time, macOS asks whether reborn may control iTerm. At login the request may be shown as `zsh` or `osascript`.

## License

MIT, see [LICENSE](LICENSE).
