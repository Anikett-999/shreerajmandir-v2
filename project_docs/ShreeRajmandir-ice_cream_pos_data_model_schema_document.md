# 🗂️ Ice Cream POS – Data Model & Schema Document (v1)

---

# 1. 📌 Purpose

This document defines the **complete Firestore data model and schema design** for the POS system.

Goals:
- Consistency
- Scalability
- Low read/write cost
- Conflict-free operations

---

# 2. 🧱 DESIGN PRINCIPLES

- Flat structure (avoid deep nesting)
- Denormalization where needed (for speed)
- Immutable transactional records
- Branch-level isolation
- Query-first design (optimize for UI queries)

---

# 3. 🗂️ ROOT STRUCTURE

```plaintext
businesses/
  {businessId}/
    branches/
      {branchId}/
        tables/
        orders/
        kots/
        bills/
        menu_categories/
        users/
        counters/
```

---

# 4. 🪑 TABLES COLLECTION

## Path
`branches/{branchId}/tables/{tableId}`

## Schema

```json
{
  "tableId": "string",
  "name": "Table 1",
  "capacity": 4,
  "status": "available | occupied | billing",
  "activeOrderId": "string | null",
  "totalAmount": 0,
  "itemCount": 0,
  "kotCount": 0,
  "updatedAt": "timestamp"
}
```

## Notes
- `totalAmount`, `itemCount`, `kotCount` are **denormalized for fast UI**

---

# 5. 🧾 ORDERS COLLECTION

## Path
`branches/{branchId}/orders/{orderId}`

## Schema

```json
{
  "orderId": "string",
  "tableId": "string",
  "status": "active | closed",
  "kotIds": ["kotId1", "kotId2"],
  "createdAt": "timestamp",
  "closedAt": "timestamp | null"
}
```

---

# 6. 🍳 KOTS COLLECTION

## Path
`branches/{branchId}/kots/{kotId}`

## Schema

```json
{
  "kotId": "string",
  "kotNumber": 1001,
  "orderId": "string",
  "tableId": "string",
  "items": [
    {
      "itemId": "string",
      "name": "Vanilla",
      "category": "Scoops",
      "qty": 2,
      "price": 60,
      "note": "Less sugar",
      "status": "placed | served | rejected"
    }
  ],
  "totalAmount": 120,
  "isPrinted": true,
  "createdBy": "userId",
  "createdAt": "timestamp"
}
```

## Notes
- `totalAmount` stored for faster billing aggregation

---

# 7. 💰 BILLS COLLECTION

## Path
`branches/{branchId}/bills/{billId}`

## Schema

```json
{
  "billId": "string",
  "orderId": "string",
  "tableId": "string",
  "items": [
    {
      "name": "Vanilla",
      "qty": 2,
      "price": 60,
      "note": "Less sugar"
    }
  ],
  "subtotal": 300,
  "discountPercent": 10,
  "discountAmount": 30,
  "extraCharges": 0,
  "total": 270,
  "paymentModes": ["cash"],
  "printCount": 1,
  "isSuspicious": false,
  "createdBy": "userId",
  "createdAt": "timestamp"
}
```

## Notes
- Snapshot data (immutable)

---

# 8. 🍦 MENU COLLECTION

## Path
`branches/{branchId}/menu_categories/{categoryId}`

## Schema

```json
{
  "categoryId": "string",
  "name": "Sundaes",
  "groups": [
    {
      "groupName": "Special Sundaes",
      "items": [
        {
          "itemId": "string",
          "name": "Titanic",
          "price": 180,
          "variants": [],
          "isAvailable": true
        }
      ]
    }
  ]
}
```

---

# 9. 👤 USERS COLLECTION

## Path
`branches/{branchId}/users/{userId}`

## Schema

```json
{
  "userId": "string",
  "name": "string",
  "email": "string",
  "roles": [
    {
      "branchId": "string",
      "role": "admin | cashier | waiter"
    }
  ]
}
```

---

# 10. 🔢 COUNTERS COLLECTION

## Path
`branches/{branchId}/counters/global`

## Schema

```json
{
  "kotCounter": 1001
}
```

## Usage
- Increment atomically for KOT numbers

---

# 11. ⚡ DERIVED DATA STRATEGY

To improve performance:

- Store totals in tables
- Store totals in KOT
- Store final totals in bills

Avoid heavy aggregation queries

---

# 12. 🔍 INDEXING STRATEGY

Create indexes for:

- orders by tableId + status
- kots by orderId
- bills by createdAt

---

# 13. ⚠️ DATA CONSISTENCY RULES

- Always use transactions for:
  - KOT creation
  - Counter increment

- Never update bill after creation

- Table status must reflect order state

---

# 14. 🚀 SCALABILITY NOTES

- Designed for multiple branches
- Can extend to multi-business
- Supports future inventory module

---

---

# 15. 🔧 FINAL SCHEMA CORRECTIONS (PRODUCTION READY)

## 15.1 MENU RESTRUCTURE (IMPORTANT)

### Replace nested structure with:

```plaintext
menu_categories/
menu_items/
```

### menu_categories

```json
{
  "categoryId": "string",
  "name": "Sundaes",
  "order": 1
}
```

### menu_items

```json
{
  "itemId": "string",
  "name": "Titanic",
  "categoryId": "string",
  "groupName": "Special Sundaes",
  "price": 180,
  "variants": [],
  "isAvailable": true
}
```

---

## 15.2 USERS RESTRUCTURE (GLOBAL)

### Move users outside branch:

```plaintext
users/{userId}
```

### Schema

```json
{
  "userId": "string",
  "name": "string",
  "email": "string",
  "roles": [
    { "branchId": "string", "role": "admin | cashier | waiter" }
  ]
}
```

---

## 15.3 REMOVE kotIds FROM ORDERS

### Reason:
- Avoid duplication
- Use query instead

### Query Pattern:
- kots where orderId == X

---

## 15.4 BILL PAYMENT STRUCTURE (IMPROVED)

Replace:

```json
"paymentModes": ["cash"]
```

With:

```json
"payments": [
  { "mode": "cash", "amount": 200 },
  { "mode": "upi", "amount": 70 }
]
```

---

## 15.5 PRINT TRACKING (ADD FIELDS)

Add to bills:

```json
"printedAt": "timestamp",
"lastPrintedBy": "userId"
```

---

## 15.6 AUDIT LOG COLLECTION (NEW)

### Path
`branches/{branchId}/audit_logs/{logId}`

### Schema

```json
{
  "action": "bill_generated | bill_reprint | table_cleared",
  "userId": "string",
  "tableId": "string",
  "billId": "string",
  "timestamp": "timestamp"
}
```

---

## 15.7 FINAL ROOT STRUCTURE (UPDATED)

```plaintext
businesses/
  {businessId}/
    branches/
      {branchId}/
        tables/
        orders/
        kots/
        bills/
        menu_categories/
        menu_items/
        counters/
        audit_logs/

users/
```

---

# 16. ✅ FINAL VALIDATION

✔ All core entities covered:
- Tables
- Orders
- KOTs
- Bills
- Menu
- Users
- Counters
- Audit logs

✔ All relationships defined
✔ All edge cases supported
✔ Ready for production implementation

---

# END OF DOCUMENT

