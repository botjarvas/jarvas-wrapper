# Jarvas Wrapper — Governed CI/CD & Self‑Hosted Agent for OpenClaw

Jarvas Wrapper provides an auditable, governed automation pipeline for packaging, testing, and deploying OpenClaw "skills" with safe canary rollouts, human‑in‑the‑loop (HITL) approvals and per‑run evidence.

---

## Value proposition

Operations are often manual, inconsistent and hard to audit. Jarvas Wrapper standardizes skill packaging, enforces SHOW_COMMANDS and explicit approvals, automates canary rollouts and collects tamper‑evident artifacts so teams can prove what was executed and who approved it.

## What it includes

- CI workflows: build, test, package skills
- Canary deploy workflow (manual trigger) for safe rollouts
- Self‑hosted agent + control plane (containerized) for running tasks inside your network
- Tooling for packaging skills, smoke tests, artifact collection and a safe apt‑upgrade pattern
- Documentation, installer script and an audit trail pattern for evidence collection

## Quickstart (5–10 minutes)

Prerequisites:
- Linux (Ubuntu 22.04+ recommended)
- git
- Docker Engine & Docker Compose plugin
- Optional: python3 + pip + ansible (for running playbooks locally)

Install & run:

```bash
git clone https://github.com/botjarvas/jarvas-wrapper.git
cd jarvas-wrapper
cp .env.example .env
# edit .env if needed
./install.sh
# start services
sudo docker compose up --build -d
# run a quick smoke check
./scripts/smoke_http_check.sh http://localhost:5000/
```

Simulated canary (non‑destructive stub):

```bash
$PWD/tools/jarvas_lite_run.sh run --action linux.apt_upgrade --scope "hosts=canary1,canary2" --run-id "demo-$(date -u +%Y%m%dT%H%M%SZ)"
```


## What to expect

- A control service at ${CONTROL_URL:-http://localhost:5000} exposing `/task` and `/register` endpoints.
- An agent container polling the control plane in `agent` mode.
- For simulated runs: artifacts under `runs/<run_id>/artifacts`:
  - `apt_upgrade.raw` — raw output
  - `apt_upgrade.json` — structured result
  - `runs/<run_id>/logs/step_apt_upgrade.log` — step logs with PHASE markers


## Safety & Governance (must read)

- SHOW_COMMANDS: every significant write/destructive action must be prepared as a deterministic plan and presented before execution.
- HITL approval phrases (exact):
  - `OK executar` — approve normal run
  - `OK destrutivo` — approve destructive/irreversible action

APT upgrade invariants (applies to automated apt upgrades):
- `DEBIAN_FRONTEND=noninteractive`
- `NEEDRESTART_MODE=a`
- `dpkg_options=force-confdef,force-confold`
- Lock‑wait loop prior to execution (10 minute timeout) and an `APT_LOCK_TIMEOUT` artifact on timeout


## Running a real canary (recommended checklist)

1. Verify inventory and host reachability
2. Take snapshots/backups of critical hosts
3. Present SHOW_COMMANDS and request HITL approval (`OK executar`)
4. Run canary on a tiny group (1–2 hosts)
5. Validate smoke tests and monitoring for a defined window
6. Promote or rollback based on objective criteria


## Packaging skills (developer flow)

1. Create a skill directory with metadata, tests and README
2. Package with:

```bash
./scripts/package_skill.sh <name> <version>
```

The package is a tarball containing the skill, metadata and tests ready for distribution.


## Artifacts & audit

Each run should produce:
- raw output (e.g. `apt_upgrade.raw`)
- structured JSON (`apt_upgrade.json`)
- per‑step logs (`runs/<run_id>/logs/step_*.log`)
- an audit JSONL record with `prev_audit_hash` + `audit_hash` and run metadata


## Support & commercial options

- Self‑hosted: you run the control plane and agents in your infrastructure. We provide packaging, documentation and support contracts.
- Managed (coming soon): a hosted control plane with SLA, onboarding and billing.

Contact & sales: PixelX


## Contributing

Contributions welcome via PR. For changes that affect runtime or require secrets, follow the SHOW_COMMANDS checklist and record approval phrases in the audit.


## Security notes

- Do not store secrets in this repo. Use GitHub Secrets, Vault or environment variables.
- If sensitive data is accidentally committed, follow the documented redaction and remediation steps in `docs/SECURITY.md`.

---

For full architecture, roadmap and GTM details see `docs/PROJECT_DOCUMENTATION.md` and `docs/INSTALL.md`.
