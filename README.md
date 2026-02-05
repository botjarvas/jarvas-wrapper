# Jarvas Wrapper — CI/CD, Canary Deploy & Skill Packs

Este repositório contém um wrapper e um conjunto de pipelines para empacotar, testar, publicar e fazer deploy de "skills"/wrappers para OpenClaw (Jarvas).

Objetivo
- Fornecer um fluxo governado, auditable e automatizado para transformar skills/workflows em produto vendável.

Quickstart
1. Pré-requisitos: GitHub repo, GitHub Actions secrets (GH_PAT), Deploy Key/SSH secret (SSH_DEPLOY_KEY), runner com jarvas-lite-run.sh (se usar canary local).
2. Configura secrets: GH_PAT, SSH_DEPLOY_KEY.
3. Abre/merge o PR feature/ci-cd (já criado).
4. Trigger Canary Deploy (Actions → Canary Deploy → Run workflow) ou executar localmente via ansible-playbook.

Mais detalhes em docs/PROJECT_DOCUMENTATION.md

Contato: Estoura (via este repo)

## Self-hosted product
This repository now supports a self-hosted agent and control plane for product deployment.
Run `./install.sh` to bootstrap, then `docker-compose up --build` to run agent + control locally for testing.

See docs/INSTALL.md and docs/AGENT.md for details.

## Self-hosted product
This repository now supports a self-hosted agent and control plane for product deployment.
Run `./install.sh` to bootstrap, then `docker-compose up --build` to run agent + control locally for testing.

See docs/INSTALL.md and docs/AGENT.md for details.
