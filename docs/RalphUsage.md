---
title: Ralph Loop Usage
version: 1.0
applies-to: Agents and humans
purpose: Ralph loop autonomous execution system commands and workflow
---

```bash
make ralph_init                                      # Initialize (creates prd.json)
make ralph_run [ITERATIONS=25]                       # Run autonomous development
make ralph_status                                    # Check progress
make ralph_clean                                     # Reset state (removes prd.json, progress.txt)
make ralph_reorganize NEW_PRD=path/to/new.md [VERSION=2]  # Archive and start new iteration
```
