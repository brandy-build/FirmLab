# Firmware Buffer Overflow Lab - Agent Guide

## Project goal
Build a reproducible firmware security lab that supports legal static and dynamic analysis of public firmware images, with emphasis on detecting memory-safety flaws (especially buffer overflows).

## Workflow
1. Setup dependencies with `./setup.sh`.
2. Store downloaded firmware samples in `firmware/raw/`.
3. Extract with `./scripts/extract_firmware.sh <firmware_file>`.
4. Run triage with `./scripts/analyze.sh <extracted_directory>`.
5. Record findings in `analysis/findings.md`.
6. Save reproducible artifacts and PoC notes in `results/`.

## Rules for analysis
- Analyze only firmware that is legal to download and reverse engineer.
- Do not target live systems without explicit authorization.
- Prefer repeatable scripted steps over ad-hoc manual actions.
- Keep raw files immutable; write generated outputs into `analysis/` and `results/`.
- Track assumptions, hashes, and commands used for reproducibility.

## How Codex should behave in this repository
- Default to safe, legal, offline-first analysis guidance.
- Automate repeatable tasks via scripts in `scripts/`.
- After each major step, provide validation commands and recovery actions.
- Keep explanations concise: what was done, why it matters, and what is next.
