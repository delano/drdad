# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-16

### Added
- Daily developer activity reports from git history
- AI-powered summaries using Claude Haiku API
- Commit classification by type (feat, fix, docs, test, refactor, chore, perf, style, ci)
- Issue reference extraction from commit messages
- Work category distribution (feature, bugfix, tech_debt, docs, test)
- Focus score calculation based on issue concentration
- Complexity indicators based on lines changed
- Date range processing for bulk report generation
- Weekly aggregate reports (ISO week format)
- Monthly aggregate reports
- JSONL output format for easy analysis
- Idempotent report updates (overwrite by date)
- Configurable API throttling for rate limiting
- `--no-ai` flag for fast processing without summaries
- Verbose output mode for debugging

### Technical Details
- Zero external gem dependencies (uses Ruby stdlib only)
- Net::HTTP for direct Anthropic API integration
- Git command integration via Open3
- Supports Ruby 3.0+
- Reports stored in `.claude/reports/` directory

[1.0.0]: https://github.com/delano/drdad/releases/tag/v1.0.0
