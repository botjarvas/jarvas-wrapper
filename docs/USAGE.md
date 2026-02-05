# Jarvas Enterprise Suite — 8 Pillars Overview

This repository ships the Jarvas Enterprise Suite consisting of 8 operational pillars. Each pillar contains professional scripts designed for safe diagnostics, audit, and remediation. All scripts follow the PixelX DevSecOps header and are non-destructive by default.

Pillars and scripts:

1) 01_business_continuity/
  - drp_audit.sh
  - backup_integrity.sh
  - failover_readiness.sh

2) 02_devsecops/
  - hardening_audit.sh
  - canary_gate.sh
  - drift_detection.sh

3) 03_cyber_security/
  - secret_scanner.sh
  - pii_audit.sh
  - ai_policy_check.sh

4) 04_sre_observability/
  - resource_invariants.sh
  - zombie_cleanup.sh
  - io_wait_monitor.sh

5) 05_finops_cost/
  - unused_volume_check.sh
  - orphan_image_cleanup.sh
  - resource_rightsizing.sh

6) 06_network_connectivity/
  - latency_audit.sh
  - ssl_expiry_check.sh
  - dns_integrity.sh

7) 07_database_governance/
  - db_connectivity_test.sh
  - slow_query_log_audit.sh
  - table_corruption_check.sh

8) 08_identity_access/
  - sudoers_audit.sh
  - ssh_key_rotation_check.sh
  - orphan_user_audit.sh

Refer to individual scripts for invocation examples. All scripts are designed to be invoked via the operational runner:

```bash
$PWD/tools/jarvas_lite_run.sh run --action <action_name> --command "$PWD/skills/<pillar>/<script>" --run-id demo-$(date -u +%Y%m%dT%H%M%SZ)
```

