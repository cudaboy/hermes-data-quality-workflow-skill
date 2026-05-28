#!/usr/bin/env bash
set -euo pipefail

SKILL_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/skills/data-quality-workflow/SKILL.md"
TARGET_DIR="${HOME}/.hermes/skills/data-quality-workflow"

mkdir -p "${TARGET_DIR}"
cp "${SKILL_PATH}" "${TARGET_DIR}/SKILL.md"

echo "Installed local Hermes skill: ${TARGET_DIR}/SKILL.md"
echo "Verify in a new Hermes session with:"
echo "  /skill data-quality-workflow"
