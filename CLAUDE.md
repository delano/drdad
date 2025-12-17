# drdad Development Guide

## Iterative Testing Process

When making changes to drdad, follow this graduated testing approach to catch issues early while building confidence incrementally.

### Process Overview

Test changes by processing real git history in expanding batches. Each iteration:
1. **Run** - Process a date range
2. **Check** - Verify JSONL output and AI summaries
3. **Adjust** - Fix any bugs discovered
4. **Commit** - Document what worked and what was fixed
5. **Expand** - Move to larger batch

### Iteration Schedule

| Iteration | Days | Cumulative |
|-----------|------|------------|
| 1 | 1 day | 1 |
| 2 | 2 days | 3 |
| 3 | 3 days | 6 |
| 4 | 4 days | 10 |
| 5 | 5 days | 15 |
| 6 | 6 days | 21 |
| 7 | 9 days | 30 |

### Commands

```bash
# Iteration 1: Single day test
drdad --repo /path/to/repo --date 2025-12-15

# Iteration 2+: Date ranges
drdad --repo /path/to/repo --from 2025-12-13 --to 2025-12-14

# Verify output
cat /path/to/repo/.claude/reports/daily.jsonl | jq -c '{date, commits: .quantitative.commits, ai: .qualitative.ai_summary[:60]}'
```

### Verification Checklist

After each iteration, verify:

- [ ] JSONL records are well-formed (parse with `jq`)
- [ ] `repo` field present in each record
- [ ] `timing.total_seconds` and `timing.ai_seconds` populated
- [ ] AI summaries are coherent and specific (not generic)
- [ ] `quantitative.commits` matches expected count
- [ ] No errors in stderr

### Post-Hoc Review

After completing iterations, run aggregate analysis:

```bash
cat daily.jsonl | jq -s '{
  total_records: length,
  missing_ai: [.[] | select(.qualitative.ai_summary == null)] | length,
  commit_types: [.[].quantitative.by_type | to_entries[]] | group_by(.key) | map({(.[0].key): ([.[].value] | add)}) | add,
  avg_timing: ([.[].timing.total_seconds] | add / length)
}'
```

Look for:
- High "other" classification rate (>50% suggests pattern improvements needed)
- Missing AI summaries
- Timing anomalies
- Field completeness

## Environment

```bash
export ANTHROPIC_API_KEY="your-key"
```

## Testing Without AI

For rapid iteration on non-AI changes:

```bash
drdad --repo /path/to/repo --from 2025-01-01 --to 2025-12-31 --no-ai
```

This skips Haiku calls entirely (~0.1s/day vs ~2s/day).
