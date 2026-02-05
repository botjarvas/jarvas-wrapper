# Jarvas Agent — Technical Reference

This document specifies the Jarvas Agent architecture, responsibilities and the control plane interaction model.

Overview
The Jarvas Agent is a lightweight component that executes tasks assigned by the Control Plane. It is designed for secure operation within customer networks and minimizes the attack surface by employing a pull model for task retrieval.

Core Responsibilities
- Register with the Control Plane and maintain operational metadata.
- Poll for pending tasks at a configurable interval.
- Execute approved tasks using the operational runner and capture artifacts.
- Persist and expose execution artifacts and status to the Control Plane.

Communication Protocol
- Registration: `POST /register` with agent metadata.
- Task retrieval: `GET /task` (pull model).
- Result reporting: Task completion metadata and artifact references are provided back to the control endpoint.

Security and Deployment
- Agents must authenticate to the Control Plane using secure tokens or mTLS in production.
- Run the agent as a non‑privileged service; prefer containerized deployment for isolation.
- Configure resource limits and logging to comply with operational policies.

Configuration
- Recommended configuration is provided via `.env` and mounted config files. Key settings:
  - `CONTROL_URL` — Control Plane base URL
  - `RUNS_DIR` — Local path for run artifacts and logs
