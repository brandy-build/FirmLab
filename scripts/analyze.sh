#!/usr/bin/env bash
set -euo pipefail

# Basic static triage for extracted firmware content.
# Usage: ./scripts/analyze.sh firmware/extracted/<target>.extracted

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <extracted_directory>"
  exit 1
fi

TARGET_DIR="$1"
OUT_DIR="analysis"

if [[ ! -d "$TARGET_DIR" ]]; then
  echo "[-] Target directory not found: $TARGET_DIR"
  exit 1
fi

mkdir -p "$OUT_DIR"
TS="$(date +%Y%m%d_%H%M%S)"
REPORT_PREFIX="$OUT_DIR/analysis_${TS}"

file "$TARGET_DIR" > "${REPORT_PREFIX}_file.txt"

{
  echo "# Strings sample from executable-like files in $TARGET_DIR"
  find "$TARGET_DIR" -type f \( -perm -111 -o -name '*.so*' -o -name '*.cgi' -o -name '*.bin' \) 2>/dev/null \
    | head -n 50 \
    | while read -r f; do
        echo "\n## $f"
        strings "$f" 2>/dev/null | head -n 80
      done
} > "${REPORT_PREFIX}_strings.txt"

{
  echo "# Grep hits for high-signal symbols"
  echo "\n## httpd"
  grep -RIna --binary-files=text "httpd" "$TARGET_DIR" 2>/dev/null || true
  echo "\n## strcpy"
  grep -RIna --binary-files=text "strcpy" "$TARGET_DIR" 2>/dev/null || true
  echo "\n## memcpy"
  grep -RIna --binary-files=text "memcpy" "$TARGET_DIR" 2>/dev/null || true
} > "${REPORT_PREFIX}_grep.txt"

echo "[+] Analysis complete. Outputs:"
echo "    ${REPORT_PREFIX}_file.txt"
echo "    ${REPORT_PREFIX}_strings.txt"
echo "    ${REPORT_PREFIX}_grep.txt"
