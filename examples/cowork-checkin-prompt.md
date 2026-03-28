# Daily Work Check-in

This task runs at **5:00 AM PDT** to capture late-night coding sessions.

## Date Framing (Critical)

- **Report date**: Today (when this runs)
- **Analysis period**: Yesterday (the full previous calendar day)
- **Example**: Running at 5am Saturday → report dated Saturday → analyzes Friday's work

**Output header format**:
```
# Is It Important? — [Today's Day], [Today's Date]

## What happened [Yesterday's Day] (full day recap)
```

## Context

I have solopreneur capex and opex work (figuratively speaking):
- **Capex**: New progress on Onetime Secret the project and product
- **Opex**: Supporting and learning from custom install customers

## Instructions

1. Run `./gather-reports.sh` to collect the latest drdad reports
2. Read the JSON files in `./reports-snapshot/` for quantitative data (commits, lines changed, focus areas)
3. Reference the drdad tool documentation if needed: `/Users/d/Projects/opensource/delano/drdad/README.md`
4. Synthesize findings into:
   - What was accomplished yesterday
   - Capex vs opex balance
   - Whether the work aligns with high-priority goals
   - A question to prompt reflection on today's priorities

## Output

Write your analysis to a file named `is-it-important-YYYY-MM-DD.md` where the date is **today's date** (the report date, not the analysis date).

## If the script fails

If `./gather-reports.sh` fails to run or produces errors, suggest adding a launchd plist to run the script on a schedule outside of this task. For context:

- Existing drdad launch config: `~/.config/launchd/com.drdad.daily.plist`
- Symlinked from: `~/Library/LaunchAgents/com.drdad.daily.plist`
- Wrapper script pattern: `~/.config/launchd/drdad-yesterday`

A similar plist could run `gather-reports.sh` before this scheduled task runs, so the reports-snapshot is pre-populated.
