# Firebase Runbook (Template)

> Fill values marked with `<<...>>` before using in CI/deployment.

## Prerequisites
- Firebase CLI installed (`npm install -g firebase-tools`)
- Service account JSON for CI with `roles/firebase.admin` / custom minimal roles
- Project ID: `<<FIREBASE_PROJECT_ID>>`
- Environment: `staging` / `production` (use separate projects)

## One-time setup
1. Create Firebase project(s) and note `projectId`.
2. Enable Firestore and Authentication (Email/Password or required providers).
3. Create a service account for CI; download JSON.
4. Store service account JSON and `projectId` as CI secrets: `FIREBASE_SERVICE_ACCOUNT`, `FIREBASE_PROJECT_ID`.
5. Add required Firestore indexes (see `project_docs/indexes.md` if needed).

## Deploying security rules
```bash
# Authenticate using service account JSON (CI)
firebase --project $FIREBASE_PROJECT_ID deploy --only firestore:rules
```

## Deploying functions / hosting (if used)
```bash
firebase --project $FIREBASE_PROJECT_ID deploy --only functions,hosting
```

## Rollback
- Firebase has limited rollback for Firestore data; use backups or restore from exports.
- For rules/hosting: deploy the previous commit/tag.

## Backups
- Use `gcloud firestore export` on a schedule to a GCS bucket.

## Contacts
- Infra owner: `<<NAME / EMAIL>>`
- App owner: `<<NAME / EMAIL>>`


> Note: Provide `FIREBASE_PROJECT_ID` and service account details so I can update the CI template with real values.