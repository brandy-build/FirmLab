#!/usr/bin/env bash
set -euo pipefail

# Extract firmware with binwalk and normalize output paths.
# Usage: ./scripts/extract_firmware.sh firmware/raw/<image.bin>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <firmware_file>"
  exit 1
fi

FW_FILE="$1"
RAW_DIR="firmware/raw"
EXTRACT_DIR="firmware/extracted"

if [[ ! -f "$FW_FILE" ]]; then
  echo "[-] Firmware file not found: $FW_FILE"
  exit 1
fi

mkdir -p "$EXTRACT_DIR"

base_name="$(basename "$FW_FILE")"
work_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$work_dir"
}
trap cleanup EXIT

cp "$FW_FILE" "$work_dir/$base_name"

pushd "$work_dir" >/dev/null
if ! binwalk -eM "$base_name"; then
  echo "[-] binwalk extraction failed for $FW_FILE"
  echo "[!] Recovery tips:"
  echo "    - Re-run with privileges: binwalk -eM --run-as=root $FW_FILE"
  echo "    - Try single-pass extraction: binwalk -e $FW_FILE"
  exit 1
fi
popd >/dev/null

extract_candidate="$work_dir/_${base_name}.extracted"
target_dir="$EXTRACT_DIR/${base_name}.extracted"

if [[ ! -d "$extract_candidate" ]]; then
  echo "[-] Extraction directory not found: $extract_candidate"
  echo "[!] Try manual fallback: binwalk -e --run-as=root $FW_FILE"
  exit 1
fi

rm -rf "$target_dir"
mv "$extract_candidate" "$target_dir"

echo "[+] Extraction complete: $target_dir"
