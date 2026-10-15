---
name: afk
description: Use only when the user invokes /afk or says they are stepping away and want autonomous work without being asked for input.
disable-model-invocation: true
argument-hint: [optional task to focus on while I'm gone]
---

# AFK mode: I'm away from keyboard

I'm leaving my computer. Work autonomously and make the best progress you can **without waiting on me for anything**. Don't end your turn to ask a question; keep going until the work is genuinely done or every remaining path is blocked by the boundaries below.

## Focus

If I named a task along with this command, focus on it. Otherwise continue with whatever task is already in progress in this conversation.

## How to operate while I'm gone

1. **Never block on input.** Do not ask me questions or stop and wait for my reply. If you'd normally ask me something, decide it yourself per the next rule.

2. **Decide and document.** At any ambiguity, missing detail, or fork in the road, pick the most reasonable interpretation and proceed. Record every such judgment call so you can surface it loudly when I return; these are the things I'll most want to review.

3. **Stay local and reversible.** You may freely:
   - edit, create, and refactor files
   - run tests, builds, linters, and other local/read-only commands
   - make **local** git commits

   You may **NOT**, without me present:
   - `git push`, open/merge PRs, deploy, or release
   - delete or overwrite files you did not create this session
   - send anything to a network/external service (emails, messages, API posts)
   - install packages or modify global/system state
   - run any other destructive or hard-to-reverse action

   If completing the task *requires* one of these, do everything up to that line, then park the rest and note it in the log.

4. **Keep a running AFK log.** Maintain a timestamped markdown file at
   `~/.local/state/agent-afk-logs/YYYY-MM-DD-HHMM-afk.md` (create the directory if needed).
   Update it as you go with:
   - **Done:** what you completed
   - **Decisions:** every judgment call from rule 2, with the assumption you made and why
   - **Blocked / skipped:** anything you parked, and what I need to do to unblock it
   - **Next:** suggested next steps if work remains

5. **When I'm back, report in both places.** Your final chat message must:
   - **lead with a loud `## DECISIONS TO REVIEW` section** listing every judgment call (rule 2); this comes first, before the normal summary
   - then summarize what you did and what's left
   - end with the path to the AFK log file you wrote

Work steadily and verify your work as you go (run the tests, check the output) rather than assuming success. I'd rather come back to solid, reviewable progress than a fragile sprint.
