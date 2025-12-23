# drdad

**Daily Report of Developer Activity Data**

Git productivity tracking with AI-powered summaries using Claude Haiku.

## Features

- Track daily commits, lines changed, and file modifications
- AI-generated summaries of each day's work
- Aggregate weekly and monthly reports
- Issue reference extraction
- Commit type classification (feat, fix, docs, test, refactor, etc.)
- JSONL output for easy analysis

## Installation

```bash
# Clone the repository
git clone https://github.com/delano/drdad.git

# Add to your PATH
export PATH="$PATH:/path/to/drdad/bin"

# Or symlink
ln -s /path/to/drdad/bin/drdad /usr/local/bin/drdad
```

## Requirements

- Ruby 3.0+
- Git
- `ANTHROPIC_API_KEY` environment variable (for AI summaries)

## Usage

```bash
# Today's report for current repo
drdad

# Specific repository
drdad --repo ~/Projects/myapp

# Specific date
drdad --date 2024-12-01

# Date range (with AI summaries)
drdad --from 2024-01-01 --to 2024-12-31

# Date range without AI (fast)
drdad --from 2024-01-01 --to 2024-12-31 --no-ai

# Slower API throttle (be nice to the API)
drdad --from 2024-01-01 --to 2024-12-31 --throttle 500

# Weekly aggregate
drdad --weekly 2024-W50

# Monthly aggregate
drdad --monthly 2024-12
```

## Output

Reports are written to `<repo>/.claude/reports/`:
- `daily.jsonl` - One JSON object per day
- `weekly.jsonl` - Weekly aggregates
- `monthly.jsonl` - Monthly aggregates

### Sample Daily Record

```json
{
  "date": "2025-12-13",
  "generated_at": "2025-12-16T18:19:08Z",
  "repo": "myapp",
  "timing": {
    "total_seconds": 2.43,
    "ai_seconds": 2.12
  },
  "quantitative": {
    "commits": 24,
    "by_type": {"feat": 5, "fix": 10, "docs": 3, "other": 6},
    "lines_added": 746,
    "lines_removed": 290,
    "files_changed": 46,
    "issues_referenced": ["2174", "2177"],
    "prs_merged": 0
  },
  "qualitative": {
    "focus_score": 0.41,
    "primary_theme": "#2174",
    "work_categories": {"feature": 0.59, "bugfix": 0.35, "tech_debt": 0.06},
    "complexity": "high",
    "ai_summary": "Implemented domain context override for persona-based testing..."
  }
}
```

## Automated Scheduling (macOS)

Use launchd to run drdad automatically. Reports are generated silently and written to each repository's `.claude/reports/` directory.

### Daily Reports

Generate a report for yesterday's work every morning at 6 AM:

First, create a wrapper script. This is necessary because launchd doesn't inherit your shell environment (PATH, API keys, locale) and can't compute relative dates like "yesterday":

**`~/bin/drdad-yesterday`**
```bash
#!/bin/bash
# drdad-yesterday - Wrapper for launchd to run drdad for yesterday's date
#
# Why this exists: launchd doesn't inherit shell environment (PATH, API keys,
# locale) and can't compute dates. This wrapper sources ~/.zshenv, sets UTF-8
# locale, and calculates yesterday's date for the daily report.

set -e
source ~/.zshenv
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
YESTERDAY=$(date -v-1d +%Y-%m-%d)
/path/to/drdad/bin/drdad --repo "$1" --date "$YESTERDAY"
```

Make it executable: `chmod +x ~/bin/drdad-yesterday`

**`~/Library/LaunchAgents/com.drdad.daily.plist`**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.drdad.daily</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/you/bin/drdad-yesterday</string>
        <string>/Users/you/Projects/myapp</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin</string>
    </dict>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Hour</key>
        <integer>6</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/drdad-daily.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/drdad-daily.err</string>
</dict>
</plist>
```

### Weekly Reports

Generate weekly aggregates every Monday at 7 AM:

**`~/Library/LaunchAgents/com.drdad.weekly.plist`**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.drdad.weekly</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/you/bin/drdad-weekly</string>
        <string>/Users/you/Projects/myapp</string>
    </array>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>/usr/local/bin:/usr/bin:/bin</string>
    </dict>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Weekday</key>
        <integer>1</integer>
        <key>Hour</key>
        <integer>7</integer>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
    <key>StandardOutPath</key>
    <string>/tmp/drdad-weekly.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/drdad-weekly.err</string>
</dict>
</plist>
```

**`~/bin/drdad-weekly`**
```bash
#!/bin/bash
# drdad-weekly - Wrapper for launchd to generate last week's aggregate report
#
# Calculates the ISO week number for 7 days ago and generates the weekly report.

set -e
source ~/.zshenv
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
LAST_WEEK=$(date -v-7d +%G-W%V)
/path/to/drdad/bin/drdad --repo "$1" --weekly "$LAST_WEEK"
```

### Multiple Repositories

Create a wrapper to process all your repos:

**`~/bin/drdad-all-repos`**
```bash
#!/bin/bash
# drdad-all-repos - Process multiple repositories in one run
#
# Usage: drdad-all-repos [DATE]
# If DATE is omitted, defaults to yesterday.

set -e
source ~/.zshenv
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

REPOS=(
    "/Users/you/Projects/app1"
    "/Users/you/Projects/app2"
    "/Users/you/Projects/app3"
)

DATE=${1:-$(date -v-1d +%Y-%m-%d)}

for repo in "${REPOS[@]}"; do
    echo "Processing $repo for $DATE..."
    /path/to/drdad/bin/drdad --repo "$repo" --date "$DATE"
done
```

### Managing Launch Agents

```bash
# Load (start) an agent
launchctl load ~/Library/LaunchAgents/com.drdad.daily.plist

# Unload (stop) an agent
launchctl unload ~/Library/LaunchAgents/com.drdad.daily.plist

# Run immediately (test)
launchctl start com.drdad.daily

# Check status
launchctl list | grep drdad

# View logs
tail -f /tmp/drdad-daily.log
```

### Troubleshooting

**Agent not running?**
- Check logs: `cat /tmp/drdad-daily.err`
- Verify paths are absolute (no `~`)
- Ensure scripts are executable: `chmod +x ~/bin/drdad-*`
- Check agent is loaded: `launchctl list | grep drdad`

**Missing environment?**
- launchd doesn't inherit your shell's PATH/environment
- Wrapper scripts `source ~/.zshenv` to load `ANTHROPIC_API_KEY` and PATH
- Alternatively, set environment variables explicitly in the plist

**Encoding errors?**
- `invalid byte sequence in US-ASCII` means locale isn't set
- Add `export LANG=en_US.UTF-8` and `export LC_ALL=en_US.UTF-8` to wrapper scripts

**API rate limits?**
- Add `--throttle 500` for longer delays between AI calls
- Use `--no-ai` for fast runs without summaries

## License

MIT
