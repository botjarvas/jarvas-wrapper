# Project Documentation

## Visão e Motivação

### Problema que o wrapper resolve

- Situação atual (dor)
  - Operações dispersas: as equipas usam scripts ad‑hoc, playbooks e UIs diferentes para gerir skills/agents; cada mudança exige passos manuais, testes e validação repetitiva.
  - Falta de governação: updates críticos são realizados sem provas auditáveis, sem SHOW_COMMANDS previsíveis nem aprovação humana padronizada.
  - Risco de downtime: upgrades em massa ou automatizados sem canary/rollout plan levam a regressões que afetam produção.
  - Dificuldade em monetizar: não existe um formato padronizado e empacotável que permita vender repetidamente.
  - Segurança e compliance fracos: falta de trilha de auditoria tamper‑evident e requisitos de não‑interatividade em upgrades.

- Consequências tangíveis
  - Tempo humano elevado por mudança.
  - Incidentes nocturnos e rollbacks demorados.
  - Impossibilidade de provar conformidade para clientes/reguladores.
  - Barreiras a transformar automações em produto.

- Como o wrapper resolve
  - Padroniza artefactos: empacota skills + testes + CI numa unidade re‑utilizável e versionada.
  - Governa fluxos: impõe SHOW_COMMANDS + HITL approvals antes de ações com impacto, gerando evidência.
  - Automatiza releases & canary: CI constrói, publica e permite canary deploys automatizados com rollback criterions.
  - Reduz risco de bloqueios: implementa invariantes operacionais (ex.: APT non‑interactive + NEEDRESTART_MODE=a + lock‑wait).
  - Observabilidade e evidência: cada run produz apt_upgrade.raw, apt_upgrade.json, step logs e um run_id ligado ao audit.
  - Produto vendável: cria um pacote repetível que permite oferecer templates pagos, suporte gerido e serviços de integração.

- Benefícios medíveis
  - Redução do tempo de rollout.
  - Menor MTTR.
  - Compliancy facilitada.
  - Escalabilidade do negócio.

## Arquitetura

- Repo: jarvas-wrapper
  - .github/workflows/ci.yml — build/test pipeline
  - .github/workflows/release.yml — publish on release
  - .github/workflows/canary-deploy.yml — manual canary via Actions
  - ansible/playbooks/deploy.yml — playbook para canary + rollout
  - tools/jarvas-lite-run.sh — runner governado
  - docs/ONBOARDING.md — quick onboarding
  - scripts/release.sh, Makefile, Dockerfile

- Runtimes: GitHub Actions, runner host (botjarvas) com jarvas-lite-run.sh
- Secrets: GH_PAT, SSH_DEPLOY_KEY
- Audit model: runs/<run_id>/artifacts + audit JSONL

## Fluxo padrão (end-to-end)

1. Dev → push → PR → CI
2. Merge → release workflow available
3. Trigger Canary Deploy → Ansible playbook → jarvas-lite-run.sh executes linux.apt_upgrade on canary hosts
4. If canary OK → promote rollout
5. Per run: artifacts + audit appended; PHASE markers recorded

## Regras operacionais e governança

- SHOW_COMMANDS antes de ações que escrevem.
- HITL phrases: "OK executar" / "OK destrutivo".
- APT upgrade invariant está registado em MEMORY.md (DEBIAN_FRONTEND=noninteractive, NEEDRESTART_MODE=a, dpkg_options=force-confdef,force-confold, lock-wait 10min, artefactos obrigatórios).
- Secrets nunca imprimidos; audit append-only.

## Deployment & Canary details

- Canary group selection via variáveis no playbook.
- Canary run: executa apt_upgrade em canary, recolhe RC e artefacts, valida com smoke tests.
- Promotion: rollout automático se canary RC==0.

## Monetização / GTM

- Ofertas: Skill Packs, Managed Jarvas, Integration & Onboarding.
- Modelos: Freemium + premium packs, Hosted managed instances, Consultoria.
- Pricing examples: Templates pack: $49; Managed: $99–399/mo; Enterprise: $5k–25k.

## Roadmap & next steps

- 0–14 dias: polish CI, smoke tests, artefacts.
- 15–30 dias: package 2–3 skill packs + landing page.
- 30–60 dias: onboard first paying customer.

## Runbook (operacional)

- How to run canary: Actions → Canary Deploy or ansible-playbook ansible/playbooks/deploy.yml
- Inspect artifacts: ls runs/<run_id>/artifacts
- Rollback: restore snapshot or manual remediation.

## Contribuição e responsabilidades

- Contribuir via PRs; code owners / reviewers para merges.
- Secret handling policy and rotation.

