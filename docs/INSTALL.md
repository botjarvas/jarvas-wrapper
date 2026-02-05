# Installation Guide (Quickstart)

This guide provides concise, reproducible steps to install Jarvas Wrapper in a self‑hosted environment for evaluation.

Prerequisites
- Linux host (Ubuntu 22.04+ recommended)
- git, sudo
- Docker Engine and Docker Compose plugin

Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/<owner>/jarvas-wrapper.git
   cd jarvas-wrapper
   git checkout main
   ```

2. Configure environment:
   ```bash
   cp .env.example .env
   # Edit .env to set CONFIG_DIR, RUNS_DIR, CONTROL_URL as required
   ./install.sh
   ```

3. Start services:
   ```bash
   sudo docker compose up --build -d
   ```

4. Verify:
   ```bash
   docker compose ps
   curl -sS $CONTROL_URL/task
   ```

5. Run a demo:
   ```bash
   ./tools/jarvas_lite_run.sh run --action system_health --command "./skills/system_health/system_health.sh"
   ls -la runs/<run_id>/artifacts
   ```

Operational Notes
- Do not commit secrets to the repository. Use environment variables or a secrets manager.
- For production deployments, configure secure authentication between Agents and the Control Plane.

