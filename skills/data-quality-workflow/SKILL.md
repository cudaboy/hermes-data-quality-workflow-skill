---
name: data-quality-workflow
description: Use when performing data quality checks, dataset QA, validation, or correction planning. Collect errors first, group by pattern or root cause, choose scoped correction strategies, then apply or propose fixes and re-check results.
version: 1.0.0
author: Jeon Un-yeol
license: MIT
metadata:
  hermes:
    tags: [data-quality, validation, qa, dataset, correction, error-register]
    related_skills: [data-validation-workflows]
---

# Data Quality Workflow

## Overview

Use this skill to keep data quality work from becoming one-error-at-a-time repair.

Do not treat QA as:

```text
find one error → fix one error → find another error → fix another error
```

Instead, separate the work into:

```text
detection → patterning → correction strategy → implementation/proposal → re-check
```

The goal is to identify repeated patterns, likely root causes, safe correction strategies, and residual risk before changing data or documents.

## Core Rule

Do not treat QA as "find one error, fix one error."

First collect errors, group them by pattern or likely root cause, choose the best correction strategy, then apply or propose fixes and re-check the result.

If the user only asks for diagnosis, do not edit data.

If mutation permission is unclear and fixes may change files, data, documents, tools, settings, database records, or repository contents, ask before modifying.

## When to Use

Use this skill when the user asks to:

- validate a dataset;
- inspect data quality;
- check CSV, JSON, Excel, database, or document records;
- find inconsistent rows or fields;
- prepare a correction plan;
- clean data before modeling, RAG evaluation, reporting, or submission;
- audit records against a schema, business rule, or authoritative source;
- diagnose repeated errors in transformed or generated data.

## Do Not Use When

Do not use this skill as the main workflow when:

- the user asks for a single known typo fix;
- the task is only exploratory EDA without quality judgment;
- the validation standard is completely unavailable and cannot be inferred;
- the user explicitly wants fast manual editing rather than systematic QA.

If standards are missing, state assumptions before judging records.

---

# Workflow

## 1. Define Scope and Validation Standard

Before judging records, identify:

| Item | Examples |
|---|---|
| Files or sources | CSV, JSON, DB table, report, generated dataset |
| Rows or records | all rows, sample rows, failed records, recent batch |
| Columns or fields | date, id, label, amount, text, metadata |
| Schema | required fields, types, allowed values |
| Business rules | date ranges, uniqueness, domain-specific constraints |
| Authoritative source | original DB, API, official document, user-provided rule |
| Acceptance criteria | zero critical errors, less than 1% minor issues, all IDs valid |

State assumptions and missing standards before judging records.

Example:

```text
Assumption: date fields should be ISO-8601 format.
Missing standard: no authoritative source was provided for category labels.
```

## 2. Collect Evidence Before Fixing

Inspect enough data to discover repeated patterns.

Record examples with stable locators:

| Locator Type | Example |
|---|---|
| File | `data/orders.csv` |
| Row | row 1532 |
| ID | `order_id=ORD-2026-001` |
| Field | `delivery_date` |
| Source | API batch `2026-05-28` |
| Document section | `section 2.1`, `table 4` |

Avoid editing during first-pass inspection unless:

1. the task is tiny;
2. the user explicitly authorized edits;
3. the fix is reversible and low-risk.

## 3. Group Errors

Cluster errors by:

- validation rule;
- field or column;
- source system;
- transformation stage;
- symptom;
- likely root cause;
- affected record type;
- confidence level.

Distinguish:

| Type | Meaning |
|---|---|
| One-off defect | isolated typo or exceptional record |
| Systematic defect | repeated pattern caused by pipeline, mapping, encoding, schema, or prompt issue |

Estimate affected range and confidence.

Example:

```text
Pattern P-001: 38 rows have invalid month values in `date`.
Likely root cause: source system emitted MM/DD/YYYY but parser expected YYYY-MM-DD.
Confidence: high.
```

## 4. Choose a Correction Strategy

Prefer one scoped correction per error pattern.

Compare the following strategies:

| Strategy | Use When | Risk |
|---|---|---|
| Direct edit | few obvious errors | manual mistakes |
| Scripted transform | repeated deterministic pattern | over-correction |
| Source-pipeline fix | root cause is upstream | requires pipeline access |
| Manual review queue | ambiguity cannot be resolved safely | slower |
| Rejection | records are unreliable | data loss |
| No-op with note | issue is acceptable or unverifiable | residual risk remains |

State:

- rationale;
- risks;
- ambiguous cases;
- what cannot be inferred safely.

## 5. Apply or Propose Fixes

If authorized, implement the minimal scoped correction.

If not authorized, produce:

- patch plan;
- correction table;
- SQL update proposal;
- script proposal;
- manual review queue.

Keep original identifiers stable whenever possible.

Do not silently change:

- primary keys;
- record IDs;
- timestamps;
- provenance fields;
- source references;
- user-authored content.

## 6. Re-check

After correction or proposed correction, validate against the same standard.

Perform:

1. targeted checks for each error pattern;
2. spot checks outside the affected range;
3. schema validation if applicable;
4. count comparison before and after;
5. residual-risk summary.

Report unverified assumptions.

---

# Error Register

Use a compact error register when the task has more than a few findings.

| Error ID | Location | Field | Symptom | Example | Likely Root Cause | Affected Range | Strategy | Status |
|---|---|---|---|---|---|---|---|---|
| E-001 | `orders.csv:1532` | `date` | invalid date | `2026-13-01` | date parsing issue | 38 rows | manual review or scripted transform | open |
| E-002 | `users.json:id=U-82` | `name` | encoding corruption | `���` | UTF-8/EUC-KR mismatch | unknown | source re-extraction | open |
| E-003 | `report.md:table 2` | `count` | mismatch | `1,200` vs actual `1,248` | outdated report | one table | update report claim | proposed |

For large datasets, summarize examples and provide machine-readable output separately if needed.

---

# Output Shape

End reports with the following sections:

## Scope Inspected

State exactly what was inspected.

## Validation Standard Used

List schema, rules, assumptions, and authoritative sources.

## Error Patterns Found

Group findings by pattern, not by isolated row only.

## Fixes Recommended or Implemented

Clearly distinguish:

```text
recommended
implemented
not changed
requires user decision
```

## Re-checks Performed

List the checks run after correction or after preparing the correction plan.

## Residual Risk

State what remains uncertain, unverified, ambiguous, or potentially affected.

---

# Common Pitfalls

1. **Fixing too early**

   Do not edit after finding the first error. First inspect enough data to identify patterns.

2. **No validation standard**

   Do not label records as wrong without a schema, rule, authoritative source, or stated assumption.

3. **Over-correcting ambiguous data**

   If a value can be interpreted multiple ways, add it to manual review rather than guessing.

4. **Destroying provenance**

   Preserve original IDs, source references, and raw values when possible.

5. **Skipping re-check**

   A correction is not complete until the same validation standard is applied again.

6. **Confusing diagnosis with permission to mutate**

   If the user asks only for diagnosis, report findings and proposed fixes. Do not modify files or data.

---

# Verification Checklist

Before finalizing:

- [ ] Scope was defined.
- [ ] Validation standard or assumptions were stated.
- [ ] Evidence was collected before fixing.
- [ ] Errors were grouped by pattern or likely root cause.
- [ ] One-off defects and systematic defects were distinguished.
- [ ] Correction strategy was selected per pattern.
- [ ] Mutation permission was confirmed if changes were made.
- [ ] Re-checks were performed or explicitly marked as not performed.
- [ ] Residual risk was reported.
