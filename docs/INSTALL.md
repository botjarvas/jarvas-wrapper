# Installation Guide (Production-Ready)

This document provides concise, reproducible steps to install and operate Jarvas Wrapper in a self‑hosted environment.

Prerequisites
- Linux host (Ubuntu 22.04+ recommended)
- git
- Docker Engine and Docker Compose plugin
- Sufficient privileges to manage Docker and system services

Installation
1. Clone the repository and switch to the main branch:

```bash
git clone https://github.com/<owner>/jarvas-wrapper.git
cd jarvas-wrapper
git checkout main
```

2. Configure environment and prepare directories:

```bash
cp .env.example .env
# Edit .env to set CONFIG_DIR, RUNS_DIR, CONTROL_URL as required
./install.sh
```

3. Start services with Docker Compose:

```bash
sudo docker compose up --build -d
```

Validation
- Confirm services are running:
  - `sudo docker compose ps`
  - `curl -sS ${CONTROL_URL:-http://localhost:5000}/task`

Operational considerations
- Manage secrets externally; do not store credentials in the repository.
- Configure persistent storage for `runs/` if you require long‑term artifact retention.
