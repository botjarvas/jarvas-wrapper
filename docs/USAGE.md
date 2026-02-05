# Jarvas Wrapper v1.0.0 — Usage Guide

Product Name: Jarvas Wrapper v1.0.0 by PixelX

Value Proposition: The ultimate DevSecOps & Business Continuity Governance Suite.

## The 8 Pillars of Excellence
1. Business Continuity
2. DevSecOps
3. Cyber Security
4. SRE & Observability
5. FinOps & Cost Governance
6. Network Connectivity
7. Database Governance
8. Identity & Access Management

The suite provides 24 professional automation skills aligned to these pillars.

## Key Features
- Immutable Audit Trail: Every action produces a `runs/<run_id>/` folder containing `artifacts/output.raw`, `artifacts/summary.json`, and `logs/step_<action>.log`.
- Sensitive Data Redaction: The secret scanner masks detected secrets and reports filenames and patterns only.
- Canary‑Ready Deployments: The Ansible playbook supports canary execution flows and guarded promotion.

## How to run a skill via the operational runner

Example: Secret Scanner

```bash
$PWD/tools/jarvas_lite_run.sh run --action secret_scan --run-id demo-secret --command "$PWD/skills/03_cyber_security/secret_scanner.sh $PWD"
```

Interpretation:
- Check `runs/demo-secret/artifacts/summary.json` for a JSON summary with `exit_code` and `status`.
- If `status` is `FAILED`, inspect `runs/demo-secret/artifacts/output.raw` and `runs/demo-secret/logs/step_secret_scan.log` for redacted findings and remediation pointers.

## Enterprise Usage Notes
- Agents operate in a pull model and must authenticate to the Control Plane in production.
- Configure persistent storage for `runs/` for long‑term evidence retention.
- All scripts are non‑destructive by default; any destructive action requires explicit approval and '--apply' style flags.

