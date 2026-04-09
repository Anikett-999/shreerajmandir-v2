# 🍦 Ice Cream POS – Complete UI/UX Screen Structure (v1)

---

# 🧱 1. DESIGN PRINCIPLES

 Role-based UI (Admin / Cashier / Waiter)
 Reusable core screens (no duplication)
 Action-driven UX (fast operations)
 Real-time + fallback (offline-safe ready)
 Minimal taps (1–2 tap workflow)
 Standard confirmation dialog for ALL sensitive actions (Logout, Delete, Clear Cart).

---

# 🧭 2. GLOBAL UI LAYER (COMMON FOR ALL ROLES)

## 🔐 Authentication

 Login Screen
 Forgot Password Screen

---

## 👤 User Profile

 Profile Screen

---

## ⚙️ Settings

 App Settings Screen
    Printer Settings Screen

---

## 🧭 Navigation

 App Bar (dynamic title + actions)
 Drawer (role-based menu)
 Logout option

---

## 🌐 System States (GLOBAL UX)

 Loading Screen / Loader
 Empty State UI
 Error State UI (user-friendly messages)
 Offline Mode Indicator + Sync Status

---

# 🍽️ 3. CORE REUSABLE FLOW SCREENS (ALL ROLES)

👉 These screens are SAME for Waiter / Cashier / Admin
👉 Only permissions differ

---

## 🪑 3.1 Table Dashboard Screen (MAIN SCREEN)

### UI Elements:

 Table Grid
 Status Indicators:

  Available
  Occupied
  Billing
 Search Bar
 Filters (status-based)
 Quick stats (optional for admin/cashier)

---

## 🛒 3.2 Order / Cart Screen

### Sections:

 Left: Menu
 Right: Cart

### Features:

 Add item
 Update quantity
 Add note per item
 Remove item
 Total preview

---

## 🍦 3.3 Menu Screen (Inside Order)

### UI:

 Category list
 Items grid/list
 Availability indicator
 Variant selector (if any)

---

## 🍳 3.4 KOT Screen (Digital View)

### Features:

 List of KOTs
 KOT number
 Items with status:

  placed
  served
  rejected
 Created time

---

## 🖨️ 3.5 KOT Print Flow (AUTO)

### Trigger:

 After KOT creation → auto print

### Failure UX:

 Show error popup
 Show digital KOT
 Retry button

---

# 💰 4. BILLING SYSTEM SCREENS

## 🧾 4.1 Bill Preview Screen

 Aggregated items from KOTs
 Subtotal
 Item list (filtered: no rejected)

---

## 💳 4.2 Billing & Checkout Screen

### Layout:

 Left: Items
 Right: Summary

### Features:

 Subtotal
 Discount input (%, flat)
 GST toggle
 Total calculation
 Payment modes:

  Cash
  UPI
  Others
 Confirm & Generate Bill

---

## 🖨️ 4.3 Bill Receipt Screen

 Final bill display
 Print button
 Reprint option (admin only)
 Digital fallback

---

# 👨🍳 5. WAITER ROLE UI

## Access:

 Table Screen
 Order Screen
 KOT Screen

## Restrictions:

 ❌ No billing
 ❌ No analytics
 ❌ No admin controls

---

# 💼 6. CASHIER ROLE UI

## 🏠 6.1 Dashboard Screen

### Sections:

#### 🔹 Real-Time Snapshot

 Total Sales (Today)
 Total Orders (Today)
 Active Tables
 Average Order Value

---

#### 🔹 Time-Based View

 Hourly Sales Graph
 Current Peak Hour Indicator

---

#### 🔹 Live Operations Panel

 Active Tables Count
 Orders in Progress
 KOT Pending

---

#### 🔹 Today Summary

 Orders placed
 KOTs printed
 Receipts printed

---

#### 🔹 Alerts Panel

 Pending prints
 Failed KOTs
 Tables stuck in billing

---

#### 🔹 Payment Overview

 Cash / UPI / Others distribution

---

## 🪑 6.2 Operational Screens

 Table Screen (shared)
 Order Screen (shared)
 KOT Screen (shared)
 Billing Screens (full access)

---

# 👑 7. ADMIN ROLE UI

## 🏠 7.1 Dashboard Screen

### Sections:

#### 💰 Revenue Intelligence

 Daily / Weekly / Monthly revenue
 Revenue growth %

---

#### 🍦 Product Performance

 Top selling items
 Least selling items
 Category-wise revenue

---

#### 💸 Discount & Leakage

 Total discount given
 Discount % of revenue

---

#### 🧾 Billing Behavior

 Reprint count
 Suspicious bills (printCount > 1)

---

#### ⚡ Live Operations Panel

 Same as cashier

---

## 🪑 7.2 Table Management

 Create table
 Edit table
 Delete table

---

## 🍦 7.3 Menu Management

### Categories

 Create / Edit / Delete

### Items

 Create item
 Update price
 Toggle availability

---

## 👤 7.4 User Management

 Create user
 Assign roles
 Edit user

---

## 📊 7.5 Reports

 Daily Report
 Monthly Report
 Yearly Report

---

## 📈 7.6 Advanced Analytics

 Peak hours
 Top items

---

## 📜 7.7 Audit Logs

 Bill reprints
 Suspicious activity

---

## 🧾 7.8 Bills / Receipts Management

 View bills
 Filter by date
 Reprint

---

## 🔄 7.9 Admin Control Screens (Override System)

 Table Screen (force control)
 Order Screen (manual order)
 KOT Screen

---

## 💰 7.10 Billing Screens

 Same as cashier
 With full permissions

---

# 🌐 8. OFFLINE MODE UI (IMPORTANT)

## Features:

 Offline indicator (top banner)
 Queue pending actions:

  KOT
  Bills
 Sync status screen

---

## UX Behavior:

 Allow order/KOT creation offline
 Auto-sync when online
 Show conflict warnings

---

# 🧠 9. FUTURE EXTENSIONS

 Kitchen Display Screen (KDS)
 Inventory Dashboard
 WhatsApp / QR Bill Sharing

---

# 🔥 FINAL SYSTEM STRUCTURE SUMMARY

## CORE FLOW (MVP)

 Table → Order → KOT → Billing

---

## SUPPORT SYSTEM

 Printing
 Alerts
 Reports

---

## CONTROL SYSTEM

 Admin management
 Audit
 Analytics

---

# ✅ STATUS

✔ All screens covered
✔ Role separation clear
✔ No duplication
✔ Production-ready structure

---

# END
