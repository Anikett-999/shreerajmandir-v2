# Shree Rajmandir V2 Stability Protocol

This document defines the strict governance and modularity rules for the Shree Rajmandir POS project. Its primary goal is to protect the stable **Waiter Module** from regressions while building new features, specifically the **Admin Module**.

## 1. Directory Structure & Governance

The project follows a role-based modularity in `lib/presentation/screens/`:

- **`/waiter`**: **LOCKDOWN ZONE**. This directory contains all waiter-facing workflows. 
    - *Rule*: NO modifications allowed here unless specifically requested for a Waiter feature. Any Admin-related changes must NOT touch this directory.
- **`/admin`**: **ACTIVE DEVELOPMENT ZONE**. All new administrative features, user management, and reporting must be built here.
- **`/shared`**: **COMMON ZONE**. Contains screens used by all roles (Login, Home, Settings, KOT Viewer). 
    - *Rule*: Exercise extreme caution. Changes here affect all users.

## 2. Shared Service Governance

When modifying services (e.g., `MenuService`, `AuthService`, `TableService`) in `lib/services/` for Admin features:

1. **Do Not Modify Existing Methods**: If a method is used by the Waiter module, do not change its signature or return data structure.
2. **Add Dedicated Methods**: Create new methods specifically for admin needs.
    - *Example*: Instead of modifying `getMenuData()`, add `getAdminMenuData()`.
3. **Immutability of Waiter Logic**: The business logic governing KOT generation and Waiter-initiated table status changes must remain immutable during Admin development.

## 3. "PROTECTED" Source Headers

All files in `lib/presentation/screens/waiter/` must contain the following header to warn developers and AI agents:

```dart
/// PROTECTED MODULE: WAITER
/// DO NOT MODIFY this file for Admin feature development.
/// Contact system architect before changing core waiter workflows.
```

## 4. Regression Testing (The "Waiter Smoke Test")

Before any commit or deployment of Admin features, the following **Waiter Smoke Test** must be performed manually or verified via automation:

1. **Login**: Successfully log in as a Waiter.
2. **Table Selection**: Navigate to an "Available" table.
3. **Cart Workflow**: Add at least 2 items to the cart.
4. **KOT Generation**: Tap "Send to Kitchen" and confirm the KOT success notification.
5. **State Verification**: Verify the table status has updated to "Occupied" on the home screen.

## 5. Violations & Enforcement

- Any PR/Change containing modifications to the `/waiter` directory during an Admin task will be rejected.
- Use of "Shared Logic" without adding dedicated admin methods is considered a technical debt violation.

---
**Last Updated**: 2026-04-10
**Owner**: System Architect / Antigravity AI
