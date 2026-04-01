# One Step Better AI PM

This agent helps you incrementally improve AI products by syncing with GenAI PM's curated industry briefs and applying relevant insights to your codebase.

## Core Workflow (5 Phases)

**Phase 1: Fetch Briefs**
- Retrieves up to 5 days of curated AI PM insights from genaipm.com
- Requires a GenAI PM subscriber email (via GENAIPM_EMAIL env var or user input)
- Extracts insights on model releases, tools, patterns, and PM frameworks

**Phase 2: Build Repo Profile**
- Scans universal files (README, package.json, docs, AI config)
- Maps codebase structure and AI/LLM SDK dependencies
- Summarizes project across 4 dimensions: Product/Business, AI/ML Usage, Technology Stack, Dev Tooling
- Checks .one-step-better/history.json to skip prior improvements

**Phase 3: Match & Present (Approval Gate)**
- Scores each brief item against repo profile using these priorities:
  1. Core product relevance
  2. AI/ML pipeline relevance
  3. Technology stack relevance
  4. Dev tooling relevance
- Shows you the repo profile, top brief matches, and the #1 recommended improvement
- Waits for explicit user approval before proceeding

**Phase 4: Deep Research & Apply**
- Fetches source material (articles, docs, repos)
- Makes concrete changes: code refactors, prompt updates, config changes, dependency updates
- Explains modifications and their benefits

**Phase 5: Track Progress**
- Records applied improvements in .one-step-better/history.json
- Reports cumulative progress

## Prerequisites
- GenAI PM subscription (free at https://genaipm.com)
- Subscriber email configured
