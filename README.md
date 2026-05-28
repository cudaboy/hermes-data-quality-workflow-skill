# Hermes Data Quality Workflow Skill

A reusable Hermes Agent skill for systematic data quality validation and correction planning.

This skill prevents data QA work from becoming one-error-at-a-time repair. It guides the agent to:

1. define scope and validation standards;
2. collect evidence before fixing;
3. group errors by pattern or root cause;
4. choose correction strategies;
5. apply or propose minimal scoped fixes;
6. re-check and report residual risk.

## Skill Name

```text
data-quality-workflow
```

## Repository Structure

```text
skills/
└── data-quality-workflow/
    └── SKILL.md
```

## Install in Hermes

Inspect first:

```bash
hermes skills inspect https://raw.githubusercontent.com/cudaboy/hermes-data-quality-workflow-skill/main/skills/data-quality-workflow/SKILL.md
```

Install directly from the raw GitHub URL:

```bash
hermes skills install https://raw.githubusercontent.com/cudaboy/hermes-data-quality-workflow-skill/main/skills/data-quality-workflow/SKILL.md
```

After installation, load it explicitly in a session:

```bash
hermes -s data-quality-workflow
```

or inside a Hermes session:

```text
/skill data-quality-workflow
```

## When to Use

Use this skill for:

- dataset validation;
- CSV/JSON/Excel QA;
- database record validation;
- RAG evaluation dataset QA;
- generated-data quality checks;
- correction planning;
- schema and business-rule validation.

## Acknowledgements

This skill was adapted into Hermes Agent skill format by Jeon Un-yeol.

It was conceptually inspired by systematic data quality and validation workflows, and it is aligned with caution-first AI agent principles such as those described in:

- https://github.com/multica-ai/andrej-karpathy-skills

## License

MIT
