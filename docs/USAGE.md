# Usage & Examples

This document shows how to use the operational runner (jarvas-lite-run.sh) and common flows for the Jarvas Wrapper product.

## Runner modes

The runner supports two modes:

- agent — long‑running agent that polls a control plane for tasks (stubbed in this repo).
- run — execute a single action/command and collect artifacts and logs.

### Run mode (operational)

This is the primary execution engine for skills. It guarantees artifact collection, phase markers, and a structured summary for each run.

Required arguments:
- `--action <ACTION>` — a short name for the action (e.g. linux.apt_upgrade)
- `--command '<SHELL COMMAND>'` — the shell command to execute (quoted)

Optional arguments:
- `--run-id <RUN_ID>` — if omitted the runner generates a timestamped run id: `run-YYYYMMDDTHHMMSSZ`

Example:

```bash
# run a simulated upgrade command and collect artifacts
./tools/jarvas-lite-run.sh run --action linux.apt_upgrade \
  --command "echo 'Simulate upgrade'; sleep 1; echo 'done'" \
  --run-id demo-20260205T012345Z
```

What it does:
1. Ensures directories exist: `runs/<RUN_ID>/artifacts` and `runs/<RUN_ID>/logs`.
2. Emits: `PHASE: STARTING_EXECUTION` to the step log.
3. Executes the provided command with `eval`, capturing stdout/stderr to `artifacts/output.raw` and appending it to `logs/step_<ACTION>.log`.
4. Emits: `PHASE: COMPLETED` and `EXIT:<code>` to the step log.
5. Writes `artifacts/summary.json` with fields: `run_id`, `action`, `timestamp`, `exit_code`, `status` (SUCCESS|FAILED).
6. Exits with the same exit code as the executed command.

Notes & security:
- `--command` is executed with `eval` to allow flexible shell expressions. Only provide trusted commands or run the agent in an isolated environment.
- Artifacts are stored under the `runs/` directory; ensure this path is on durable storage if you need long‑term retention.

## Agent mode (stub)

To run the agent that polls the control plane:

```bash
# environment variables:
# CONTROL_URL (default: http://localhost:5000)
# Run the agent:
./tools/jarvas-lite-run.sh agent
```

The agent in this repository is a minimal stub: it polls `GET $CONTROL_URL/task` every 10 seconds and is intended as a starting point for a production agent which should implement secure registration, authentication and task execution protocol.

## Example: Full simulated canary flow (local)

1. Start the control and agent with docker compose (see README):

```bash
sudo docker compose up --build -d
```

2. Run a simulated canary run using `run` mode:

```bash
./tools/jarvas-lite-run.sh run --action linux.apt_upgrade \
  --command "echo 'Simulated upgrade for canary hosts'; sleep 1; echo 'OK'"
```

3. Inspect artifacts:

```bash
ls -la runs/<RUN_ID>/artifacts
cat runs/<RUN_ID>/artifacts/output.raw
cat runs/<RUN_ID>/artifacts/summary.json
cat runs/<RUN_ID>/logs/step_linux.apt_upgrade.log
```

## Integrating skills with the runner

Design each skill so that the "work" is a single shell command (or a small wrapper script) that can be passed as the `--command` to the runner. The runner will take care of evidence collection and status reporting.

Example skill wrapper script (skill/run_upgrade.sh):

```bash
#!/usr/bin/env bash
set -euo pipefail
# perform the real steps here
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
```

And invoke it via the runner:

```bash
./tools/jarvas-lite-run.sh run --action linux.apt_upgrade --command "./skill/run_upgrade.sh"
```

## Troubleshooting

- If the runner fails with permission errors when creating `runs/` paths, check filesystem permissions.
- If `docker compose` commands fail, ensure the current user is in the `docker` group or use `sudo`.
- If you need to redact sensitive info, follow `docs/SECURITY.md` guidelines.

## Next steps

- Replace the agent stub with a secure agent that authenticates to the control plane.
- Add signing of artifacts for tamper‑evidence.
- Add per‑service smoke checks called after upgrades.

---

If you want, I'll commit this doc and update the PR with the README changes (OK executar to push).