# agent-handoff

Three user-invoked skills for coding agents. They share one file format and
one location, so a handoff saved in one agent resumes in any of them. Packaged
for Claude Code, Codex and Antigravity (`agy`) from the same `skills/`
directory.

- `handoff-save`: you are about to shut down. The agent stops starting new
  work, reaches a safe stopping point, commits finished work (when its
  instructions allow commits), and writes a handoff file a fresh session can
  resume from with no memory of this one.
- `handoff-resume`: after a restart, finds the newest handoff for the current
  directory, checks it against git, briefs you, and continues from its next
  step.
- `afk`: you are stepping away. The agent works without asking for input,
  stays local and reversible (no push, deploy, installs, or network sends),
  logs every judgment call, and leads its final message with the decisions for
  you to review.

## Files

| What | Where |
| --- | --- |
| Handoffs | `~/.local/state/agent-handoffs/YYYY-MM-DD-HHMM-<project-dir>.md` |
| Resumed handoffs | `~/.local/state/agent-handoffs/done/` |
| AFK logs | `~/.local/state/agent-afk-logs/YYYY-MM-DD-HHMM-afk.md` |

Both directories are outside any workspace, so an agent with sandboxed or
rule-based file access needs write access to them (for example an
Antigravity `write_file(<absolute path>)` allow rule).

## Install

Claude Code:

```sh
claude plugin marketplace add tjs0/agent-handoff
claude plugin install agent-handoff@agent-handoff
```

Codex (plugin skills load in the interactive TUI, not in `codex exec`):

```sh
codex plugin marketplace add tjs0/agent-handoff
codex plugin add agent-handoff@agent-handoff
```

Antigravity:

```sh
agy plugin install https://github.com/tjs0/agent-handoff
```

Or symlink each `skills/<name>` directory into the agent's personal skills
directory (`~/.claude/skills/`, `~/.codex/skills/`,
`~/.gemini/config/skills/`).

## Use

Each skill takes an optional argument, such as a time limit for
`handoff-save` or a task to focus on for `afk`.

- Claude Code: `/agent-handoff:handoff-save`, `/agent-handoff:handoff-resume`,
  `/agent-handoff:afk`.
- Codex and Antigravity: ask for the skill by name ("use the afk skill").

The skills never trigger on their own. `disable-model-invocation: true` hides
them from the model in Claude Code and Antigravity; Codex shows them to the
model, so each description says to use it only when the user invokes it.

The handoff records which agent wrote it and, when known, the command to
resume that session (`claude --resume <id>`, `codex resume <id>`,
`agy --conversation <id>`).

## Develop

`tests/check.sh` checks that the manifests agree on name and version, the
skill frontmatter, and runs `claude plugin validate` and `agy plugin validate`
when those agents are installed. Bump the version in every manifest together.

Keep skill text agent-neutral: no tool names or paths that only one agent has.

## License

MIT
