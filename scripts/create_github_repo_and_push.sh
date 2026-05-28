#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="hermes-data-quality-workflow-skill"
DESCRIPTION="Hermes Agent skill for systematic data quality validation and correction planning"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "ERROR: GITHUB_TOKEN is not set." >&2
  echo "Create a GitHub Personal Access Token with repo scope, then run:" >&2
  echo "  export GITHUB_TOKEN='<token>'" >&2
  echo "  bash scripts/create_github_repo_and_push.sh" >&2
  exit 1
fi

API="https://api.github.com"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
ACCEPT_HEADER="Accept: application/vnd.github+json"

USER_LOGIN=$(python3 - <<'PY'
import json, os, urllib.request
req=urllib.request.Request(
    'https://api.github.com/user',
    headers={
        'Authorization': 'token ' + os.environ['GITHUB_TOKEN'],
        'Accept': 'application/vnd.github+json',
    },
)
with urllib.request.urlopen(req, timeout=30) as r:
    print(json.load(r)['login'])
PY
)

echo "GitHub user: ${USER_LOGIN}"

python3 - <<'PY'
import json, os, urllib.error, urllib.request
repo_name='hermes-data-quality-workflow-skill'
description='Hermes Agent skill for systematic data quality validation and correction planning'
token=os.environ['GITHUB_TOKEN']
body=json.dumps({
    'name': repo_name,
    'description': description,
    'private': False,
    'auto_init': False,
    'has_issues': True,
    'has_projects': False,
    'has_wiki': False,
}).encode()
req=urllib.request.Request(
    'https://api.github.com/user/repos',
    data=body,
    method='POST',
    headers={
        'Authorization': 'token ' + token,
        'Accept': 'application/vnd.github+json',
        'Content-Type': 'application/json',
    },
)
try:
    with urllib.request.urlopen(req, timeout=30) as r:
        data=json.load(r)
    print('created:', data['html_url'])
except urllib.error.HTTPError as e:
    detail=e.read().decode(errors='replace')
    if e.code == 422 and 'name already exists' in detail.lower():
        print('repo already exists; continuing')
    else:
        print(detail)
        raise
PY

REMOTE_URL="https://${USER_LOGIN}:${GITHUB_TOKEN}@github.com/${USER_LOGIN}/${REPO_NAME}.git"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "${REMOTE_URL}"
else
  git remote add origin "${REMOTE_URL}"
fi

git push -u origin main

# Remove token-bearing remote URL from local config after push.
git remote set-url origin "https://github.com/${USER_LOGIN}/${REPO_NAME}.git"

echo "Uploaded: https://github.com/${USER_LOGIN}/${REPO_NAME}"
echo "Raw SKILL.md: https://raw.githubusercontent.com/${USER_LOGIN}/${REPO_NAME}/main/skills/data-quality-workflow/SKILL.md"
