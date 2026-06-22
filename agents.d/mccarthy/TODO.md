# TODO

## Bugs

### memory_tools.el: C-c m timeout on long conversations (FIXED)
- **Date discovered:** 2026-06-22
- **Date fixed:** 2026-06-22
- **Root cause:** The `my-gptel--memory-call-ollama` function passed the JSON
  payload as a direct command-line argument to curl (`-d <string>`). Linux
  imposes a MAX_ARG_STRLEN limit of 128KB per single argument. Long
  conversations with tool I/O easily exceed this, causing `execve` to fail
  silently with E2BIG -- the process never starts, so curl produces no output,
  and the function times out waiting.
- **Fix applied:**
  - Payload is now written to a temp file and passed as `curl -d @file`,
    bypassing the ARG_MAX limit entirely. Temp file is cleaned up after.
  - Conversation text is truncated to 100,000 chars (configurable via
    `my-gptel-memory-max-conversation-chars`) to prevent extremely large
    payloads that could cause model-side timeouts.
  - Timeout increased from 120s to 300s to accommodate large contexts.
  - `num_ctx` increased from 32768 to 131072; `num_predict` from 4096 to 8192.
  - Diagnostic message now shows payload and conversation size on trigger.
- **Note:** reload_os was initially suspected but ruled out by the user.
  The bug was in the curl invocation, not the reload path.

## Features

### Elisp checker tool
- **Status:** In progress (2026-06-22)
- **Description:** Tool to check .el files for syntax errors, unbalanced
  parentheses, and byte-compilation warnings without modifying the file.