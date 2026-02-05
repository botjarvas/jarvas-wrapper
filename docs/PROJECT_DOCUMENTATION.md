# Project Technical Architecture

This document describes the technical architecture and system flow of the Jarvas Wrapper product. It focuses on components, interfaces, data flows and operational considerations for deployment in production.

## Components

- Control Plane: a central service (HTTP) that manages tasks, agents and metadata. Responsibilities include task scheduling, artifact indexing, and audit collection.
- Agent: a lightweight process running inside customer infrastructure that polls the control plane for tasks, executes actions using the operational runner and returns artifacts and status.
- Operational Runner (jarvas_lite_run): a local execution engine responsible for running commands, collecting artifacts, producing phase markers and structured summaries.
- Artifact Store: file system or object storage where runs/<run_id>/artifacts and logs are stored. Designed to be mounted into the control plane or backed by S3-compatible storage for long-term retention.
- CI/CD Pipelines: GitHub Actions workflows for build/test, release and canary orchestration.

## System Flow

1. Developer packages a skill and creates a PR in the repository. CI validates the package, runs unit/smoke tests and builds artifacts.
2. On merge, the control plane can schedule or accept manual triggers (workflow_dispatch) to run a canary.
3. Agents poll the control plane `/task` endpoint. When tasks are assigned, the agent executes the `jarvas_lite_run` in `run` mode with the provided command.
4. The runner creates `runs/<run_id>/artifacts` and `runs/<run_id>/logs`, writes `artifacts/summary.json` and returns metadata to the control plane.
5. Operators review artifacts and decide to promote or abort the rollout based on predefined criteria.

## Interfaces

- Control Plane API (HTTP)
  - `GET /task` — agent poll for tasks
  - `POST /register` — agent registration
  - `POST /tasks` — create task (internal/operator)

- Artifact format
  - `artifacts/output.raw` — raw stdout/stderr
  - `artifacts/summary.json` — JSON with fields {run_id, action, timestamp, exit_code, status}
  - `logs/step_<action>.log` — per-step logs with PHASE markers

## Operational Considerations

- Agents should run as unprivileged processes and execute only verified commands.
- Artifacts must be stored on durable storage with retention policies configured per tenant.
- Secrets must be managed outside the repo (Vault, GitHub Secrets, or environment variables).
- Monitoring: collect metrics for run durations, success/failure rates and artifact sizes.

