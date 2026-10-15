---
name: handoff-save
description: Use only when the user invokes /handoff-save or says they are shutting down their computer and want a handoff saved to resume later.
disable-model-invocation: true
argument-hint: [optional note, e.g. how much time you have]
---

# Shutdown mode: I'm about to power off

I need to shut down my computer soon. Stop starting new work, get to a safe stopping point quickly, and leave behind everything a fresh session needs to pick up exactly where this one left off. Speed matters more than polish: aim to finish in a few minutes.

If I gave a note along with this command and it sets a time limit, respect it. Otherwise assume a few minutes.

## Steps

1. **Stop starting things.** Do not begin any new task, subtask, or investigation. Do not ask me questions. If a subagent or background job is running, let it finish only if it will be done within about a minute; otherwise stop it and record what it was doing.

2. **Reach a safe stopping point.** Finish only the edit currently in hand if it is small. Never leave a file half-edited or syntactically broken. If the current change can't be finished quickly, leave it as-is in the working tree (uncommitted changes survive a reboot) and describe its exact state in the handoff.

3. **Commit what is done.** If your instructions let you commit, commit each completed, working unit locally; otherwise leave it uncommitted and say so in the handoff. Do not commit broken or half-done work; leave it uncommitted. Never push. Do not stash (stashes are easy to forget).

4. **Write the handoff file** at `~/.local/state/agent-handoffs/YYYY-MM-DD-HHMM-<project-dir-name>.md` (create the directory if needed). It must let a fresh session, in any agent, with no memory of this conversation resume immediately:
   - **Goal:** what we're working on overall and why
   - **Where things stand:** done, in progress, not started (link the spec/plan if there is one, and which task number we're on)
   - **Uncommitted changes:** each modified file and what state it's in; `git status` summary
   - **Stopped mid-flight:** anything interrupted (subagents, background jobs, running servers, long commands) and how to restart it
   - **Decisions and open questions:** judgment calls made, and anything waiting on me
   - **Next steps:** the exact next action, specific enough to execute without re-investigating
   - **Resume:** the working directory, which agent wrote the handoff, and the command to resume this session if you know its id (`claude --resume <id>`, `codex resume <id>`, or `agy --conversation <id>`)

5. **Update project records.** If the project keeps a TODO or status file (such as `docs/TODO.md`), update it to reflect current state (what's next, anything deferred) and commit it under the same rule as step 3. It holds current state only, not a session log; the handoff file holds the session detail. If a plan document tracks task status, mark progress there too.

6. **Final message.** Keep it short so I can shut down: one line saying it's safe to power off (or what's still unsafe, e.g. an unfinished commit), the handoff file path, and the one-line next step. Nothing else.
