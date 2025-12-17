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

## License

MIT
