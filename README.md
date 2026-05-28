# Hermes Data Quality Workflow Skill

A reusable [Hermes Agent](https://hermes-agent.nousresearch.com/docs) skill for systematic data quality validation and correction planning.

This skill prevents data QA work from becoming one-error-at-a-time repair. It guides the agent to:

1. define scope and validation standards;
2. collect evidence before fixing;
3. group errors by pattern or root cause;
4. choose correction strategies;
5. apply or propose minimal scoped fixes;
6. re-check and report residual risk.

---

## Skill Metadata

| Field | Value |
|---|---|
| Skill name | `data-quality-workflow` |
| Version | `1.0.0` |
| Author | `Jeon Un-yeol` |
| License | `MIT` |
| Tags | `data-quality`, `validation`, `qa`, `dataset`, `correction`, `error-register` |
| Related skill | `data-validation-workflows` |

---

## When to Use

Use this skill for:

- dataset validation;
- CSV/JSON/Excel QA;
- database record validation;
- RAG evaluation dataset QA;
- generated-data quality checks;
- correction planning;
- schema and business-rule validation;
- repeated error pattern discovery;
- pre-modeling or pre-submission data quality checks.

Do **not** use it as a heavy workflow for a single obvious typo or a trivial one-line correction.

---

## Core Rule

Do not treat QA as:

```text
find one error → fix one error → find another error → fix another error
```

Instead, use this sequence:

```text
define scope → collect evidence → group errors → choose strategy → apply/propose fixes → re-check
```

If the user only asks for diagnosis, do not edit data. If mutation permission is unclear, ask before modifying files, data, documents, tools, settings, database records, or repository contents.

---

## Repository Structure

```text
hermes-data-quality-workflow-skill/
├── LICENSE
├── README.md
├── scripts/
│   ├── create_github_repo_and_push.sh
│   └── install_local_skill.sh
└── skills/
    └── data-quality-workflow/
        └── SKILL.md
```

| Path | Purpose |
|---|---|
| `skills/data-quality-workflow/SKILL.md` | Main Hermes skill file |
| `scripts/install_local_skill.sh` | Copies the skill into `~/.hermes/skills/data-quality-workflow/` for local use |
| `scripts/create_github_repo_and_push.sh` | Optional helper for creating/pushing this repository with `GITHUB_TOKEN` |
| `LICENSE` | MIT license |

---

## Install in Hermes

### Option A. Inspect from GitHub first

```bash
hermes skills inspect https://raw.githubusercontent.com/cudaboy/hermes-data-quality-workflow-skill/main/skills/data-quality-workflow/SKILL.md
```

### Option B. Install from GitHub

```bash
hermes skills install https://raw.githubusercontent.com/cudaboy/hermes-data-quality-workflow-skill/main/skills/data-quality-workflow/SKILL.md
```

### Option C. Install from a local clone

```bash
git clone https://github.com/cudaboy/hermes-data-quality-workflow-skill.git
cd hermes-data-quality-workflow-skill
bash scripts/install_local_skill.sh
```

The local installer copies the skill to:

```text
~/.hermes/skills/data-quality-workflow/SKILL.md
```

---

## Verify Installation

List installed skills:

```bash
hermes skills list | grep data-quality-workflow
```

Load it in a new Hermes CLI session:

```bash
hermes -s data-quality-workflow
```

Or load it inside an active Hermes session:

```text
/skill data-quality-workflow
```

For Discord/Telegram gateway sessions, start a new session or restart the gateway if recently installed skills are not visible yet.

---

## Example Prompts

Diagnosis only:

```text
Use data-quality-workflow to inspect this CSV for quality issues.
Do not modify files. Produce an error register and correction plan only.
```

Correction planning:

```text
Validate this RAG evaluation dataset. Group errors by pattern, estimate affected range, and recommend a correction strategy for each pattern.
```

Authorized fix:

```text
Use data-quality-workflow. You may modify the generated JSON file, but only for deterministic formatting errors. Keep original IDs stable and re-check after the fix.
```

---

## Expected Report Shape

The skill instructs the agent to end QA reports with these sections:

```text
Scope Inspected
Validation Standard Used
Error Patterns Found
Fixes Recommended or Implemented
Re-checks Performed
Residual Risk
```

For larger findings, it also encourages an error register like:

| Error ID | Location | Field | Symptom | Likely Root Cause | Strategy | Status |
|---|---|---|---|---|---|---|
| E-001 | `orders.csv:1532` | `date` | invalid date | parser/schema mismatch | manual review or transform | open |

---

## Development and Validation

Validate the `SKILL.md` frontmatter locally:

```bash
python3 - <<'PY'
from pathlib import Path
import re
import yaml

path = Path("skills/data-quality-workflow/SKILL.md")
content = path.read_text(encoding="utf-8")
assert content.startswith("---"), "SKILL.md must start with ---"
match = re.search(r"\n---\s*\n", content[3:])
assert match, "Closing frontmatter --- not found"
frontmatter = content[3:match.start() + 3]
data = yaml.safe_load(frontmatter)
assert isinstance(data, dict), "frontmatter must be YAML mapping"
assert data.get("name") == "data-quality-workflow"
assert data.get("description")
assert len(data["description"]) <= 1024
assert len(content) <= 100000
print("✅ SKILL.md validation passed")
PY
```

Check the GitHub raw URL:

```bash
hermes skills inspect https://raw.githubusercontent.com/cudaboy/hermes-data-quality-workflow-skill/main/skills/data-quality-workflow/SKILL.md
```

---

## Update

Pull the latest repository changes:

```bash
git pull
```

Then reinstall locally if you use the local-copy method:

```bash
bash scripts/install_local_skill.sh
```

If you installed from the Hermes skill source URL, reinstall or update through Hermes skill management when available:

```bash
hermes skills install https://raw.githubusercontent.com/cudaboy/hermes-data-quality-workflow-skill/main/skills/data-quality-workflow/SKILL.md
```

---

## Uninstall

If installed as a local skill, remove it with:

```bash
rm -rf ~/.hermes/skills/data-quality-workflow
```

Then start a new Hermes session.

---

## Security Notes

- The skill explicitly distinguishes diagnosis from mutation.
- It instructs the agent not to modify data unless permission is clear.
- It favors correction plans, manual review queues, and re-checks when data is ambiguous.
- The helper script `create_github_repo_and_push.sh` expects `GITHUB_TOKEN` in the environment. Do not commit tokens or paste them into public files.

---

## Acknowledgements

This skill was adapted into Hermes Agent skill format by Jeon Un-yeol.

It was conceptually inspired by systematic data quality and validation workflows, and it is aligned with caution-first AI agent principles such as those described in:

- https://github.com/multica-ai/andrej-karpathy-skills

---

## License

MIT. See [`LICENSE`](./LICENSE).
