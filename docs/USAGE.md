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
