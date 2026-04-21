# Firmware Buffer Overflow in Embedded Devices Lab

This repository contains a hands-on, reproducible firmware vulnerability research lab focused on buffer overflow discovery workflows.

## 1) Setup
Why: installing a known-good tooling baseline avoids analysis drift.

```bash
chmod +x setup.sh
./setup.sh
```

Validate installed tools:

```bash
./setup.sh --check
```

## 2) Place Firmware Sample
Why: keeping originals in a stable location preserves chain of custody.

```bash
cp <downloaded_firmware.bin> firmware/raw/
```

## 3) Extract Firmware
Why: extraction exposes filesystem and binaries for triage.

```bash
./scripts/extract_firmware.sh firmware/raw/<downloaded_firmware.bin>
```

## 4) Static Triage
Why: quickly identifies likely attack surface and risky APIs.

```bash
./scripts/analyze.sh firmware/extracted/<downloaded_firmware.bin>.extracted
```

Outputs are stored in `analysis/`.

## 5) Next steps
- Map web and network entry points from extracted `/bin`, `/etc`, and `/www`.
- Identify binaries that reference `strcpy`, `memcpy`, `sprintf`.
- Attempt emulation with QEMU user-mode and test malformed inputs.
- Document all findings in `analysis/findings.md`.
