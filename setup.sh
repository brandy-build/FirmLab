#!/usr/bin/env bash
set -euo pipefail

# Firmware security lab bootstrap script for Ubuntu/Kali.
# Usage:
#   ./setup.sh            # install dependencies
#   ./setup.sh --check    # validate tool availability and print versions

REQUIRED_CMDS=(binwalk qemu-mips-static gdb-multiarch python3 pip3 file strings grep)
APT_PACKAGES=(binwalk qemu-user-static gdb-multiarch python3 python3-pip file binutils grep)

run_apt() {
  if command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    "$@"
  fi
}
APT_PACKAGES=(binwalk qemu-user-static gdb-multiarch python3 python3-pip file)

print_versions() {
  echo "[+] Tool versions"
  binwalk --version 2>/dev/null || true
  qemu-mips-static --version 2>/dev/null | head -n 1 || true
  gdb-multiarch --version 2>/dev/null | head -n 1 || true
  python3 --version 2>/dev/null || true
  pip3 --version 2>/dev/null || true
  file --version 2>/dev/null | head -n 1 || true
  strings --version 2>/dev/null | head -n 1 || true
  grep --version 2>/dev/null | head -n 1 || true
}

check_tools() {
  local missing=0
  for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "[-] Missing: $cmd"
      missing=1
    fi
  done

  if [[ "$missing" -eq 1 ]]; then
    echo "[!] One or more required tools are missing. Run: ./setup.sh"
    return 1
  fi

  echo "[+] All required tools are available."
  print_versions
}

install_tools() {
  echo "[+] Installing firmware lab dependencies (Ubuntu/Kali)..."
  if ! command -v apt-get >/dev/null 2>&1; then
    echo "[-] apt-get not found. This script currently supports Debian/Ubuntu/Kali style systems."
    exit 1
  fi

  export DEBIAN_FRONTEND=noninteractive
  run_apt apt-get update
  run_apt apt-get install -y "${APT_PACKAGES[@]}"
  sudo apt-get update
  sudo apt-get install -y "${APT_PACKAGES[@]}"
  echo "[+] Installation complete. Running validation..."
  check_tools
}

main() {
  if [[ "${1:-}" == "--check" ]]; then
    check_tools
  else
    install_tools
  fi
}

main "$@"
