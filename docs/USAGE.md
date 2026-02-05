# Usage: Starter Skills Examples

This document contains concise examples demonstrating how to run the four starter skills using the operational runner.

## system_health
Run a system health check and collect artifacts:

```bash
./tools/jarvas_lite_run.sh run --action system_health --command "./skills/system_health/system_health.sh" --run-id demo-system-health-$(date -u +%Y%m%dT%H%M%SZ)
```

## canary_deploy (canary_check)
Check Docker and service status for canary hosts:

```bash
./tools/jarvas_lite_run.sh run --action canary_check --command "./skills/canary_deploy/canary_check.sh" --run-id demo-canary-$(date -u +%Y%m%dT%H%M%SZ)
```

## security_audit (security_scan)
Perform a basic security scan (open ports, SSH config summary):

```bash
./tools/jarvas_lite_run.sh run --action security_scan --command "./skills/security_audit/security_scan.sh" --run-id demo-security-$(date -u +%Y%m%dT%H%M%SZ)
```

## smart_cleanup (cleanup)
Inspect temp files and show Docker usage (non‑destructive):

```bash
./tools/jarvas_lite_run.sh run --action smart_cleanup --command "./skills/smart_cleanup/cleanup.sh" --run-id demo-cleanup-$(date -u +%Y%m%dT%H%M%SZ)
```

Notes
- The examples assume the runner `tools/jarvas_lite_run.sh` is present and executable.
- Artifacts are created under `runs/<run_id>/artifacts` and logs under `runs/<run_id>/logs`.

## Enterprise Orchestration (Canary Rollouts)

The `ansible/playbooks/deploy.yml` playbook provides a safety‑first orchestration example for running Jarvas skills across multiple hosts. It demonstrates a canary‑first approach where a small subset of hosts is validated before promoting the action to a full rollout.

Concept
- Canary phase: execute the skill on a small percentage of hosts (recommendation: ~5% of the fleet or 1–2 hosts) and validate success criteria (service health, absence of errors, performance thresholds).
- Full rollout: after canary success, promote the same action to the remainder of the hosts.

Example command

```bash
ansible-playbook ansible/playbooks/deploy.yml -e "CANARY_HOSTS=test-srv01" -e "FULL_HOSTS=prod-srv01,prod-srv02"
```

Prerequisites
- Ansible must be installed on the control node that runs the playbook.
- Ensure the control node has SSH connectivity to target hosts or that the playbook is adapted for your agent model.
- Ensure snapshots/backups exist for critical hosts before running upgrades or changes.

Operational notes
- The playbook uses the operational runner to execute the skill and collect artifacts under `runs/<run_id>/artifacts`.
- The canary RC is checked; if non‑zero, the playbook aborts the rollout and provides logs for post‑mortem.
