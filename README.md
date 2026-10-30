# reborn

Bring your Claude Code sessions back after a reboot.

Claude Code can run sessions in the background (`claude --bg`) and keeps a list of the running ones. A reboot stops them, and the next time Claude's background service starts it clears that list. reborn reads the list at login, before anything else touches it, and resumes each session with `claude --bg --resume`. They come back idle, with the same ids and names. `claude attach <id>` opens one.

## Install

```sh
git clone https://github.com/yozzz/reborn ~/reborn
ln -s ~/reborn/bin/reborn ~/.local/bin/reborn   # any directory on your PATH
reborn install                                  # resume sessions at every login
```

Needs macOS, `jq` (built into recent macOS), and Claude Code with background sessions (tested with 2.1.314).

## Start sessions in the background

Only background sessions come back. Either start them with `claude --bg`, send a running one there with `/bg`, or make it the default:

```sh
echo 'source ~/reborn/shell/claude.zsh' >> ~/.zshrc
```

| Command | Does |
|---|---|
| `claude` | start a background session and open it |
| Ctrl+Z | leave it, keep it running |
| `claude attach` | go back to the session started in this tab |
| `claude attach <id or name>` | open any session |
| `claude agents` | list sessions |
| `claude stop <id>` | end a session for good; it won't come back after a reboot |

## Commands

| Command | Does |
|---|---|
| `reborn restore` | resume every session the roster lists that isn't running |
| `reborn restore --dry-run` | show what would be resumed |
| `reborn install` | add a login item that runs `reborn restore` (log: `~/Library/Logs/reborn.log`) |
| `reborn uninstall` | remove the login item |

## Limits

- **It reads an internal file.** `~/.claude/daemon/roster.json` isn't a public API, and a Claude Code update could change it.
- **Restore has to run first.** If you start a background session after a reboot before reborn runs, the list is gone. The conversations aren't: `claude --resume` still finds them.
- **Untrusted folders are skipped.** Claude won't start a background session in a folder you haven't trusted. reborn logs it and moves on. Watch for new git repos: running `git init` inside a trusted folder makes the new repo untrusted, because Claude trusts each repo separately.
- **Plain `claude` sessions aren't tracked** by Claude, so they can't be brought back. Use the shell function above.
- **Environment.** The login item runs your login shell (`$SHELL -lic`), so resumed sessions get the same environment as a terminal.
