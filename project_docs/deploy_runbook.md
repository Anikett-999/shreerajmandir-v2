# Deployment & Rollback Runbook (template)

## Pre-deploy checklist
- CI green for `main` branch
- Backup Firestore export completed
- Stakeholders notified
- Release tag created

## Deploy steps (example using Firebase)
1. Merge to `main` and push tag
2. CI will run and deploy Firestore rules and other artifacts
3. Verify rules deployed: `firebase deploy --only firestore:rules`
4. Smoke test critical flows (KOT creation, billing)

## Rollback
- For rules/hosting: deploy previous tag
- For data corruption: restore from Firestore export

## Post-deploy verification
- Run smoke tests
- Check logs for errors

> Provide CI details and verification owners to complete this runbook.