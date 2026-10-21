#!/usr/bin/env bash
# 每天 SessionStart 时自动创建当天的开发日志文件（若不存在）。
# 由 .claude/settings.json 的 SessionStart hook 调用。
set -u

ROOT="${CLAUDE_PROJECT_DIR:-.}"

# 若当前目录不是项目根（没有 CLAUDE.md 或 DOCS/），用脚本自身位置反推
if [ ! -f "$ROOT/CLAUDE.md" ] && [ ! -d "$ROOT/DOCS" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
  ROOT="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)"
fi

# 仍无法确认项目根目录时静默跳过，避免在错误位置生成文件
if [ ! -f "$ROOT/CLAUDE.md" ] && [ ! -d "$ROOT/DOCS" ]; then
  exit 0
fi

LOG_DIR="$ROOT/开发日志"
TODAY="$(date +%F)"
FILE="$LOG_DIR/$TODAY.md"

mkdir -p "$LOG_DIR"
if [ ! -f "$FILE" ]; then
  printf '# 开发日志 %s\n\n## 已完成\n\n## 待办\n\n' "$TODAY" > "$FILE"
fi
