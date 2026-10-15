---
name: handoff-resume
description: Use only when the user invokes /handoff-resume or asks to resume from a saved handoff file after a restart.
disable-model-invocation: true
argument-hint: [optional handoff file path or note]
---

# Resume from handoff

I saved a handoff with `/handoff-save` and am back. Pick up where that session left off.

If I named a handoff file along with this command, use it.

## Steps

1. **Find the handoff.** Handoffs are in `~/.local/state/agent-handoffs/`, named `YYYY-MM-DD-HHMM-<project-dir-name>.md`. Unless I named one, pick the newest file whose `<project-dir-name>` matches the basename of the current working directory. If none matches, list the five newest handoffs and ask me which one to use. If the matching one's working directory differs from the current one, tell me and stop.

2. **Read it fully**, then check it against reality:
   - `git status` and `git log --oneline -10`: do the uncommitted changes and recent commits match what the handoff describes? Flag any drift (changes made after the handoff was written, or missing ones).
   - Read the project's TODO or status file if it keeps one (such as `docs/TODO.md`), and any spec or plan the handoff links.

3. **Restart anything stopped mid-flight** that the handoff says to restart (servers, background jobs, interrupted subagent tasks). Run long-running things in the background.

4. **Brief me in a few lines:** the goal, where things stand, any drift found in step 2, open questions waiting on me, and the next action.

5. **Continue.** If nothing is waiting on me, go straight into the handoff's next step and follow your standing instructions (for example, keep executing an approved plan through to the end). If a listed open question blocks the next step, ask it.

6. **Retire the handoff.** Once the work has resumed, move the file to `~/.local/state/agent-handoffs/done/` so it isn't picked up again.
