# File: scripts/venv-launch.sh
# Usage (recommended):
#   source scripts/venv-launch.sh
# Optional:
#   source scripts/venv-launch.sh .venv
#   source scripts/venv-launch.sh .venv "python -m pip list"
#
# What it does:
# - creates venv if missing
# - activates it in your *current* shell
# - upgrades pip only on first creation
# - optionally runs a command inside the venv

#!/usr/bin/env bash
set -euo pipefail

VENV_DIR="${1:-.venv}"
RUN_CMD="${2:-}"

pick_python() {
  command -v python3 >/dev/null 2>&1 && { echo python3; return; }
  command -v python  >/dev/null 2>&1 && { echo python;  return; }
  return 1
}

activate_path() {
  [[ -f "$VENV_DIR/bin/activate" ]] && { echo "$VENV_DIR/bin/activate"; return; }          # mac/linux
  [[ -f "$VENV_DIR/Scripts/activate" ]] && { echo "$VENV_DIR/Scripts/activate"; return; }  # Git Bash
  return 1
}

PY="$(pick_python)" || { echo "error: python3/python not found on PATH" >&2; return 127 2>/dev/null || exit 127; }

created=0
if [[ ! -d "$VENV_DIR" ]]; then
  "$PY" -m venv "$VENV_DIR" || { echo "error: failed to create venv at $VENV_DIR" >&2; return 1 2>/dev/null || exit 1; }
  created=1
fi

ACT="$(activate_path)" || { echo "error: cannot find activate script under $VENV_DIR" >&2; return 1 2>/dev/null || exit 1; }

# Must be sourced to affect current shell
# shellcheck disable=SC1090
source "$ACT" || { echo "error: failed to activate venv" >&2; return 1 2>/dev/null || exit 1; }

if [[ "$created" -eq 1 ]]; then
  python -m pip install -U pip || { echo "error: pip upgrade failed" >&2; return 1 2>/dev/null || exit 1; }
fi

echo "✅ Activated: ${VIRTUAL_ENV:-$VENV_DIR}"
echo "ℹ️  Leave with: deactivate"

if [[ -n "$RUN_CMD" ]]; then
  bash -lc "$RUN_CMD"
fi
