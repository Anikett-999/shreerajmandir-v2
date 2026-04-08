# 🧱 Ice Cream POS System – System Design Document (SDD v1)

---

# 1. 📌 Purpose

This document defines the **technical architecture and system design** for the Ice Cream POS system.

It translates the PRD into:
- Data structure
- System components
- Execution flow
- Technical boundaries

---

# 2. 🏗️ System Architecture

## 2.1 High-Level Architecture

```plaintext
Flutter UI
   ↓
State Management (Riverpod)
   ↓
Service Layer (Business Logic)
   ↓
Firebase (Firestore + Auth)
   ↓
Hardware Layer (Thermal Printer)
```

---

## 2.2 Responsibilities

### UI Layer
- Displays data
- Handles user input
- No business logic

### State Layer (Riverpod)
- Manages app state
- Subscribes to Firestore streams

### Service Layer
- Handles business rules
- Validates operations
- Coordinates DB + printing

### Firebase Layer
- Stores all data
- Handles real-time sync

### Hardware Layer
- Printer communication

---

# 3. 🗂️ Firestore Database Design

## 3.1 Root Structure

```plaintext
businesses/
  businessId/
    branches/
      branchId/
        tables/
        orders/
        kots/
        bills/
        menu/
        users/
        counters/
```

---

## 3.2 Collections

### tables/

```json
{
  tableId,
  name,
  capacity,
  status,
  activeOrderId,
  updatedAt
}
```

---

### orders/

```json
{
  orderId,
  tableId,
  status: "active | closed",
  kotIds: [],
  createdAt,
  closedAt
}
```

---

### kots/

```json
{
  kotId,
  kotNumber,
  orderId,
  tableId,
  items: [],
  isPrinted,
  createdBy,
  createdAt
}
```

---

### bills/

```json
{
  billId,
  orderId,
  tableId,
  items: [],
  subtotal,
  discount,
  extraCharges,
  total,
  paymentModes: [],
  printCount,
  isSuspicious,
  createdBy,
  createdAt
}
```

---

### menu/

```json
{
  categoryId,
  name,
  groups: [
    {
      name,
      items: []
    }
  ]
}
```

---

### users/

```json
{
  userId,
  name,
  email,
  roles: [
    { branchId, role }
  ]
}
```

---

### counters/

```json
{
  kotCounter
}
```

---

# 4. 🔄 State Management Design

## 4.1 Riverpod Usage

- Stream providers for Firestore collections
- State providers for UI state
- Notifiers for actions

---

## 4.2 Key Providers

- tableProvider
- orderProvider
- kotProvider
- billProvider
- menuProvider

---

# 5. ⚙️ Service Layer Design

## 5.1 Services

- TableService
- OrderService
- KOTService
- BillingService
- PrintService

---

## 5.2 Responsibilities

### OrderService
- Create order
- Attach KOT

### KOTService
- Generate KOT
- Assign number

### BillingService
- Aggregate KOTs
- Calculate totals
- Generate bill

### PrintService
- Handle printer connection
- Print KOT
- Print bill
- Retry logic

---

# 6. 🔢 KOT Number Generation

## Strategy

- Use Firestore transaction
- Increment counter atomically

---

# 7. ⚡ Real-Time System

## 7.1 Listeners

- tables → live updates
- orders → status changes
- kots → new orders

---

## 7.2 Behavior

- Table UI auto updates
- Order screen syncs instantly

---

# 8. 🖨️ Printing Architecture

## 8.1 Flow

```plaintext
Order Created → PrintService → Printer
```

---

## 8.2 Failure Handling

- Mark as not printed
- Show alert
- Retry option

---

## 8.3 Local Storage

- Save selected printer config

---

# 9. 🔐 Security Rules

## Enforced at Service Layer

- Role validation before action
- Billing restricted to admin/cashier

---

# 10. ⚠️ Concurrency Handling

## 10.1 Billing Lock

- Set table.status = "billing"
- Prevent parallel billing

---

## 10.2 KOT Creation

- Use transactions
- Prevent duplicate creation

---

# 11. ❗ Error Handling

- Printer failure
- Network delay
- Invalid actions

---

# 12. 🚀 Performance Considerations

- Minimize Firestore reads
- Use indexed queries
- Avoid deep nesting

---

# 13. 🔄 Extensibility

Designed to support:
- Inventory module
- Kitchen dashboard
- Multi-business SaaS

---

---

# 14. 🔁 STATE MACHINE DEFINITIONS (STRICT TRANSITIONS)

## 14.1 Table State

States:
- available
- occupied
- billing

Allowed Transitions:
- available → occupied (on first KOT)
- occupied → billing (on bill start)
- billing → available (on successful close)

Forbidden:
- billing → occupied
- available → billing

---

## 14.2 Order State

States:
- active
- closed

Allowed:
- active → closed

Forbidden:
- closed → active

---

## 14.3 Bill State

States:
- created
- printed
- reprinted (suspicious)

Rules:
- created → printed (first print)
- printed → reprinted (if printCount > 1)

---

# 15. 🔌 SERVICE & ACTION CONTRACTS (DETAILED)

## 15.1 TableService

createTable(data)
- Input: name, capacity
- Role: admin only
- Output: tableId

updateTable(tableId, data)
- Role: admin only

deleteTable(tableId)
- Condition: no active order

---

## 15.2 OrderService

createOrder(tableId)
- Creates new order if none exists
- Assigns to table

getActiveOrder(tableId)

closeOrder(orderId)

---

## 15.3 KOTService

createKOT(tableId, items[])
- Creates new KOT
- Assigns global kotNumber
- Links to order
- Triggers print

Rules:
- Items must not be empty
- Debounce duplicate calls

cancelItem(kotId, itemId)
- Only before served

---

## 15.4 BillingService

generateBill(orderId, discount, extraCharges, paymentModes[])
- Fetch all KOTs
- Filter rejected items
- Apply discount
- Apply extra charges
- Generate bill snapshot

reprintBill(billId)
- Increment printCount
- Mark suspicious if >1

clearTable(tableId)
- Only after bill
- Reset state

---

## 15.5 PrintService

printKOT(kotId)
printBill(billId)

retryPrint(jobId)

---

# 16. ⚠️ CONCURRENCY & DATA CONSISTENCY RULES

## 16.1 KOT Creation

- Use Firestore transaction
- Ensure only one kotNumber assigned

## 16.2 Billing Lock

- When billing starts:
  - table.status = billing
- Reject other billing attempts

## 16.3 Duplicate Actions

- Prevent double taps using debounce

---

# 17. 🔁 COMPLETE SYSTEM FLOWS

## 17.1 Order Flow

1. Select table
2. Add items
3. Create KOT
4. Print KOT

---

## 17.2 Billing Flow

1. Start billing
2. Lock table
3. Calculate totals (Subtotal - Discount + Extra Charges)
4. Generate bill
5. Print
6. Clear table

---

## 17.3 Print Failure Flow

1. Attempt print
2. If fail:
   - Show error
   - Show digital bill
   - Allow retry

---

# 18. 🧪 TEST SCENARIOS (CRITICAL)

- KOT creation success
- Printer failure handling
- Duplicate billing attempt blocked
- Reprint marked suspicious
- Table state transitions correct

---

# END OF DOCUMENT

