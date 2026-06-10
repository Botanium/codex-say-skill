# Codex Say Skill

Local, no-key read-aloud for Codex and ChatGPT workflows on macOS.

This skill uses macOS `say` locally, so speech does not send the spoken text through a model. It is designed for cognitive offloading: read visually while listening to the same answer, Markdown report, clipboard text, or selected chat output.

## Features

- Read the latest Codex final answer from the local transcript.
- Read the next final answer automatically with `next`.
- Read clipboard text, inline text, or Markdown files.
- Use speed multipliers such as `--speed 1x`, `--speed 1.5x`, and `--speed 2x`.
- Skip fenced code blocks silently for a more natural listening flow.
- Stop active speech and stale launchd jobs with one command.

## Install

```bash
git clone https://github.com/Botanium/codex-say-skill.git
cd codex-say-skill
bash scripts/install.sh
```

The installer copies the skill to:

```bash
~/.codex/skills/say
```

It also links these commands into `~/.local/bin`:

```bash
codex-say
saychat
readchat
```

Make sure `~/.local/bin` is on your `PATH`.

## Usage

## Which Command Should I Use?

- Use `/say` or `$say` inside Codex chat.
- Use `codex-say` in Terminal.
- The skill itself runs `scripts/codex-say` under the hood.

So `codex-say` is the shell helper. `/say` is the chat shortcut you type to make Codex run that helper for you.

In Codex chat:

```text
/say
/say next
/say clipboard
/say stop

$say
$say next
$say clipboard
$say stop
```

In a terminal:

```bash
codex-say "Read this aloud"
codex-say --speed 1.5x "Read this faster"
codex-say -f report.md
codex-say --clipboard
codex-say --stop
```

Exact speech rates still work:

```bash
codex-say -r 220 report.md
```

## Token Note

The speech itself is local and does not use model tokens. A Codex chat turn still uses tokens for the prompt, response, and skill instructions. For large reports, prefer:

```bash
codex-say -f report.md
```

or:

```bash
codex-say --clipboard
```

instead of pasting the full report into chat.

## Platform

Currently macOS only. Linux and Windows can be added later with `spd-say`, `espeak`, or PowerShell voices.

## License

MIT
