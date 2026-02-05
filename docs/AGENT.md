# Jarvas Agent — Technical Overview

This document describes the architecture, responsibilities and communication protocol of the Jarvas Agent.

## Purpose
The Jarvas Agent executes tasks locally on behalf of the Control Plane. It provides a minimal surface area: secure registration, task polling, execution via the operational runner, and artifact upload or placement.

## Responsibilities
- Securely register with the Control Plane and maintain heartbeat information.
- Poll the Control Plane for tasks at a configurable interval.
- Validate and execute assigned tasks using the operational runner (`jarvas_lite_run`).
- Persist artifacts and logs to local storage and optionally upload to a configured storage backend.
- Report task completion status and metadata back to the Control Plane.

## Communication Model
- Pull model (default): Agent issues `GET /task` to retrieve tasks. This model avoids opening inbound ports on customer networks.
- Registration: `POST /register` with agent metadata (agent_id, capabilities). The Control Plane returns optional configuration.

## Security
- Authentication: Agents must be authenticated via tokens or mTLS in production deployments. The repo includes a stubbed polling agent for testing only.
- Least privilege: The agent must not run as root; commands executed should be confined by OS policies and containers where possible.

## Execution
- Tasks contain: action name, command to execute, and optional artifacts destinations.
- The Agent invokes `jarvas_lite_run run --action <action> --command '<cmd>' --run-id <id>` to perform execution and artifact collection.

## Deployment
- The agent is delivered as a container image (tools/Dockerfile.agent) or as a binary/script for systemd deployment.
- Configuration recommended via environment variables or mounted configuration files (CONFIG_DIR, RUNS_DIR, CONTROL_URL).

