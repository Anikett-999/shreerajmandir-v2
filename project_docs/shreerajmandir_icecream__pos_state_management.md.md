# 🔄 Ice Cream POS – State Management Document (v2 – Production Grade)

---

# 1. 📌 PURPOSE

Defines **how data flows, updates, and synchronizes** across:

* UI (Flutter)
* State Layer (Riverpod)
* Service Layer
* Firestore

Goal:
👉 **Single source of truth = Firestore**
👉 UI is purely reactive

---

# 2. 🧱 FINAL ARCHITECTURE FLOW

```plaintext
UI (Widgets)
   ↓
ViewModel (StateNotifier / Notifier)
   ↓
Service Layer (from API doc)
   ↓
Repository Layer (Firestore access)
   ↓
Firestore (Source of Truth)
```

---

# 3. 🧠 CORE PRINCIPLES (STRICT RULES)

### RULE 1: UI NEVER CALLS FIRESTORE

Only ViewModel → Service → Repository

---

### RULE 2: NO BUSINESS LOGIC IN UI

All logic lives in Service layer

---

### RULE 3: FIRESTORE = TRUTH

Never trust local state for:

* totals
* table status
* billing

---

### RULE 4: WRITE → WAIT → REACT

* Trigger action
* Wait for Firestore update
* UI updates via stream

---

### RULE 5: NO OPTIMISTIC UI

POS must be **accurate > fast illusion**

---

# 4. 🧩 STATE CLASSIFICATION (STRICT)

---

## 4.1 GLOBAL STATE

| State          | Source          |
| -------------- | --------------- |
| Current User   | Auth            |
| Current Branch | Local selection |
| Printer Config | Local storage   |

---

## 4.2 DOMAIN STATE (SERVER DRIVEN)

| State  | Source    |
| ------ | --------- |
| Tables | Firestore |
| Orders | Firestore |
| KOTs   | Firestore |
| Bills  | Firestore |
| Menu   | Firestore |

---

## 4.3 UI STATE (LOCAL ONLY)

| State             | Scope        |
| ----------------- | ------------ |
| Cart              | Order screen |
| Selected category | Menu         |
| Discount input    | Billing      |
| Loading flags     | Per action   |
| Error messages    | Global       |

---

# 5. 📦 PROVIDER ARCHITECTURE (RIVERPOD)

---

## 5.1 CORE PROVIDERS

```plaintext
authProvider
branchProvider
printerProvider
```

---

## 5.2 DOMAIN STREAM PROVIDERS

```plaintext
tablesProvider(branchId)
ordersProvider(branchId)
kotsByOrderProvider(orderId)
billsProvider(branchId)
menuCategoriesProvider(branchId)
menuItemsProvider(categoryId)
```

---

## 5.3 DERIVED PROVIDERS (IMPORTANT)

👉 This is where real systems become efficient

```plaintext
activeOrderProvider(tableId)
tableSummaryProvider(tableId)
billPreviewProvider(orderId)
```

---

## 5.4 UI STATE PROVIDERS

```plaintext
cartProvider
selectedCategoryProvider
discountProvider
paymentProvider
loadingProvider(actionKey)
errorProvider
```

---

# 6. 🪑 TABLE STATE FLOW

---

## Source:

Firestore → tables collection

---

## UI Behavior:

* Table grid listens to tablesProvider
* Any update → instant UI change

---

## Derived Data:

From schema:

* totalAmount
* itemCount
* kotCount

👉 DO NOT recompute in UI

---

## Actions:

```plaintext
createTable()
updateTable()
deleteTable()
lockForBilling()
clearTable()
```

---

## Critical Rule:

👉 Table state must always match:

* Order state
* Billing state

---

# 7. 🛒 CART STATE (LOCAL, CRITICAL)

---

## Structure:

```json
{
  items: [
    { itemId, name, qty, price, note }
  ]
}
```

---

## Rules:

* Exists only in memory
* Cleared after KOT creation
* Not stored in DB

---

## Flow:

```plaintext
User adds item → cartProvider updates
User clicks order → createKOT()
→ cart reset
```

---

# 8. 🍳 KOT STATE FLOW

---

## Source:

Firestore (kots collection)

---

## Creation Flow:

```plaintext
UI → KOTService.createKOT()
→ Firestore write
→ tables updated
→ stream updates UI
```

---

## UI NEVER:

* stores KOT locally
* modifies KOT

---

## Important:

KOT is immutable
👉 state only changes via item.status

---

# 9. 💰 BILL STATE FLOW

---

## Preview (LOCAL DERIVED)

```plaintext
billPreviewProvider(orderId)
→ aggregates KOTs
→ filters rejected
```

---

## Final Bill:

```plaintext
generateBill()
→ Firestore write
→ billProvider updates
```

---

## UI State:

* discount %
* GST toggle
* payment selection

---

## Critical Rule:

👉 Bill once created = immutable

---

# 10. 🔁 REAL-TIME SYNCHRONIZATION

---

## Streams Used:

* tables
* orders
* kots
* bills

---

## Behavior:

* No manual refresh
* UI auto-syncs

---

## Filtering:

Always by:

```plaintext
branchId
```

---

# 11. ⚠️ ERROR STATE MANAGEMENT

---

## Global Error Provider:

```plaintext
errorProvider
```

---

## Behavior:

* Show snackbar/dialog
* Do NOT crash UI

---

## Example:

* Printer fail
* Network issue
* Invalid action

---

# 12. ⏳ LOADING STATE

---

## Pattern:

```plaintext
loadingProvider("createKOT")
loadingProvider("generateBill")
```

---

## Rules:

* Scoped loading
* Never global freeze

---

# 13. 🔐 CONCURRENCY HANDLING (CRITICAL)

---

## Case 1: Double Billing

* Table locked via Firestore
* UI reacts to status change

---

## Case 2: Duplicate Tap

* Debounce at UI
* Service-level guard

---

## Case 3: Multi-user updates

* Firestore wins
* UI reacts only

---

# 14. 📉 PERFORMANCE STRATEGY

---

## DO:

* Use small scoped providers
* Listen only required data
* Use `.select()` in Riverpod

---

## DON’T:

* Listen full collections unnecessarily
* Recompute totals in UI

---

# 15. 🚫 OFFLINE BEHAVIOR

---

## Decision:

❌ Offline NOT supported

---

## Implementation:

* Disable Firestore persistence
* Show error on network failure

---

# 16. 🔄 STATE RESET RULES

---

| Event          | Reset            |
| -------------- | ---------------- |
| KOT created    | cart cleared     |
| Bill generated | billing UI reset |
| Table cleared  | all UI resets    |

---

# 17. 🚀 EXTENSIBILITY

This design supports:

* Kitchen screen (future)
* Inventory module
* Multi-business SaaS

---

# 18. 🧠 FINAL SYSTEM BEHAVIOR

```plaintext
User Action
→ ViewModel
→ Service Layer
→ Firestore
→ Stream Update
→ UI Refresh
```

👉 No shortcuts
👉 No hidden logic
👉 Fully predictable system

---

# END OF DOCUMENT
