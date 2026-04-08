# 🔌 Ice Cream POS – Service & API Contract Document (v1)

---

# 1. 📌 Purpose

Defines **all service-layer functions (APIs)** for the POS system.

Goals:
- Single source of truth for business logic
- Clear inputs/outputs
- Enforced rules & validations
- Safe concurrency with Firebase

---

# 2. 🧱 Conventions

- All writes go through **Service Layer** (never directly from UI)
- Use **Firestore transactions** for critical operations
- Return standardized response:

```json
{
  "success": true,
  "data": {},
  "error": null
}
```

Error format:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable"
  }
}
```

Common Error Codes:
- UNAUTHORIZED
- INVALID_INPUT
- NOT_FOUND
- CONFLICT
- PRINTER_ERROR

---

# 3. 👤 AuthService

## login(email, password)
- Input: email, password
- Output: user + roles
- Errors: INVALID_CREDENTIALS

## getUser(userId)
- Output: user object with roles[]

---

# 4. 🪑 TableService

## createTable({name, capacity})
- Role: admin
- Tx: no
- Output: tableId

## updateTable(tableId, {name?, capacity?})
- Role: admin

## deleteTable(tableId)
- Role: admin
- Rule: no activeOrderId
- Error: CONFLICT

## getTables(branchId)
- Stream: yes

## lockForBilling(tableId)
- Role: admin | cashier
- Tx: yes
- Rule: status must be "occupied"
- Action: set status = "billing"
- Error: CONFLICT if already billing

## clearTable(tableId)
- Role: admin | cashier
- Tx: yes
- Rule: active bill exists
- Action: set status="available", activeOrderId=null, totals reset

---

# 5. 🧾 OrderService

## getOrCreateActiveOrder(tableId)
- Tx: yes
- If active exists → return it
- Else create new order and attach to table

## getActiveOrder(tableId)
- Query by tableId + status=active

## closeOrder(orderId)
- Tx: yes
- Set status=closed, closedAt

---

# 6. 🍳 KOTService

## createKOT({tableId, items[], createdBy})
- Tx: yes
- Steps:
  1. Validate items (non-empty)
  2. getOrCreateActiveOrder(tableId)
  3. Increment counter (kotCounter)
  4. Create KOT document
  5. Update table denormalized fields (totals, counts)
- Output: {kotId, kotNumber}
- Errors: INVALID_INPUT, CONFLICT

## cancelItem({kotId, itemIndex})
- Tx: yes
- Rule: item.status != served
- Action: set status = rejected; update totals

## getKOTsByOrder(orderId)
- Query: kots where orderId == X

---

# 7. 💰 BillingService

## previewBill(orderId)
- Read-only
- Aggregates all KOTs
- Filters rejected items
- Returns: subtotal, items[]

## generateBill({orderId, discountPercent, extraCharges, payments[], createdBy})
- Tx: yes
- Steps:
  1. lockForBilling(tableId)
  2. Fetch KOTs
  3. Filter rejected
  4. Calculate subtotal
  5. Apply discount
  6. Apply extra charges
  7. Create bill snapshot
- Output: billId
- Errors: INVALID_INPUT, CONFLICT

## reprintBill(billId, userId)
- Role: admin
- Tx: yes
- Action:
  - increment printCount
  - set isSuspicious=true if printCount>1
  - set printedAt, lastPrintedBy

## finalizeAndClearTable(billId)
- Role: admin | cashier
- Tx: yes
- Steps:
  1. ensure bill exists
  2. closeOrder(orderId)
  3. clearTable(tableId)

---

# 8. 🖨️ PrintService

## printKOT(kotId)
- Side-effect service
- Reads KOT → formats ESC/POS
- Returns success/failure

## printBill(billId)
- Reads bill → formats receipt

## retryPrint({type, id})
- type: KOT | BILL

## onPrintFailure(context)
- UI should:
  - show alert
  - show digital view
  - allow retry

---

# 9. 🍦 MenuService

## getCategories(branchId)
- Stream: yes

## getItemsByCategory(categoryId)
- Query items collection

## createCategory({name, order})
- Role: admin

## createItem({name, categoryId, groupName, price, variants[]})
- Role: admin

## updateItem(itemId, data)
- Role: admin

## setItemAvailability(itemId, isAvailable)

---

# 10. 📊 ReportService

## getDailyReport(date)
## getMonthlyReport(month)
## getYearlyReport(year)

## getTopItems(range)
- Aggregate from bills

## getPeakHours(range)
- Aggregate by hour from bills.createdAt

---

# 11. 🧾 AuditService

## log({action, userId, tableId?, billId?})
- Write to audit_logs

---

# 12. 🔄 Concurrency Rules (Enforced)

- KOT creation → transaction + counter increment
- Billing → table lock (status=billing)
- Clear table only after bill

---

# 13. ⚠️ Edge Case Handling

- Empty cart → block createKOT
- Printer fail → do not rollback order/bill
- Double billing → blocked by lock
- Network retry → idempotent operations where possible

---

# 14. 🧪 Idempotency (Recommended)

- createKOT: include clientRequestId to avoid duplicates
- generateBill: guard if bill already exists for order

---

# END OF DOCUMENT

