# Usage & Examples

See README for quickstart. Example commands:

- Start services: sudo docker compose up --build -d
- Run smoke check: ./scripts/smoke_http_check.sh http://localhost:5000/
- Package a skill: ./scripts/package_skill.sh myskill 0.1.0
- Run simulated canary: ./tools/jarvas-lite-run.sh run --action linux.apt_upgrade --scope "hosts=canary1" --run-id demo-$(date -u +%Y%m%dT%H%M%SZ)

