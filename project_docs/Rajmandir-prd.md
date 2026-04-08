# 🍦 Ice Cream POS System – Product Requirements Document (PRD v4 – Expanded)

---

# 1. 📌 Product Overview

## 1.1 Objective
Design and build a **high-speed, fault-tolerant POS system** for an ice cream parlour that supports:

- Table-based ordering
- KOT-based kitchen workflow (print-driven)
- Real-time operations
- Multi-branch isolation
- Secure billing with audit trail

---

## 1.2 Core Philosophy

- 1–2 tap operations
- No dependency on hardware (printer-safe)
- Immutable transactional data
- Role-based strict permissions
- Minimal cognitive load for staff

---

# 2. 👥 User Roles & Detailed Permissions

## 2.1 Admin

### Capabilities
- Manage tables (create/edit/delete)
- Manage menu (categories, groups, items)
- Manage users (assign roles per branch)
- View analytics & reports
- Place orders & manage KOTs
- Generate, reprint, revise bills
- Access all branches

---

## 2.2 Cashier

### Capabilities
- Place orders
- Add new KOTs to existing table
- Modify cart before order placement
- Apply discount during billing
- Generate and print bills
- Clear tables

### Restrictions
- Cannot manage tables
- Cannot manage users
- Cannot access analytics
- Cannot reprint bills

---

## 2.3 Waiter

### Capabilities
- View all tables
- Place orders (create KOT)
- Add additional KOTs
- Mark order as served

### Restrictions
- Cannot generate bill
- Cannot clear table
- Cannot apply discount

---

## 2.4 Kitchen

- No application UI
- Works via printed KOT only

---

# 3. 🏢 Multi-Branch Design

## 3.1 Rules
- Strict data isolation per branch
- Shared app instance
- Admin can switch branches
- Users can have different roles per branch

---

# 4. 🪑 Table Module (Detailed)

## 4.1 Table Fields

- tableId
- name
- capacity
- status: available | occupied | billing
- activeOrderId
- lastUpdatedAt

---

## 4.2 Table State Machine

Available → Occupied → Billing → Available

---

## 4.3 Actions

### Admin
- Create table
- Edit table
- Delete table

### Admin + Cashier
- Generate bill
- Clear table

---

## 4.4 Edge Cases

- Cannot delete table if active order exists
- Cannot clear table without billing
- Prevent multiple billing sessions

---

# 5. 🍦 Menu Module (Detailed)

## 5.1 Structure

Category → Group → Items

---

## 5.2 Item Schema

- itemId
- name
- category
- group
- price
- variants[] (optional)
- isAvailable

---

## 5.3 Behavior

- Variant selection does NOT change price
- Admin can update prices anytime
- Out-of-stock items hidden or disabled

---

## 5.4 Edge Cases

- Same item name across categories must be disambiguated using category label

---

# 6. 🛒 Order & KOT Module (Deep Detail)

## 6.1 Core Concepts

- One table = one active order
- One order = multiple KOTs
- KOT = immutable

---

## 6.2 KOT Creation Flow

1. User selects items
2. Optional notes added per item
3. KOT created with global number
4. KOT saved in DB
5. Print triggered

---

## 6.3 KOT Schema

- kotId
- kotNumber (global per branch)
- orderId
- tableId
- items[]
- createdBy
- createdAt
- isPrinted

---

## 6.4 Item Schema (Inside KOT)

- itemId
- name
- category
- qty
- note
- status: placed | served | rejected

---

## 6.5 Rules

- Cannot edit KOT after creation
- Adding items = new KOT
- Cancel allowed only before serve

---

## 6.6 Duplicate Tap Prevention

- Implement debounce (300ms)
- Prevent duplicate KOT creation

---

# 7. 🖨️ Printing System (Robust Design)

## 7.1 Printers

- Kitchen printer
- Billing printer

---

## 7.2 Print Strategy

- Auto print on KOT creation
- Auto print on bill generation

---

## 7.3 Failure Handling

If printing fails:

- Show error popup
- Show digital KOT/Bill
- Mark as not printed
- Allow retry

---

## 7.4 Print Queue

- Maintain pending print jobs
- Retry mechanism

---

# 8. 💰 Billing Module (Deep Detail)

## 8.1 Billing Flow

1. Lock table (status = billing)
2. Fetch all KOTs
3. Filter rejected items
4. Calculate subtotal
5. Apply discount
6. Apply GST toggle
7. Generate bill snapshot
8. Attempt print
9. Close table

---

## 8.2 Bill Schema

- billId
- orderId
- tableId
- items[]
- subtotal
- discount
- gst
- total
- paymentModes[]
- createdBy
- createdAt
- printCount
- isSuspicious

---

## 8.3 Bill State Machine

Created → Printed → Reprinted (Suspicious)

---

## 8.4 Rules

- Cannot bill empty order
- Cannot modify bill after creation
- Reprint increments count
- printCount > 1 → suspicious

---

## 8.5 Bill Revision System

- Original bill immutable
- New bill created for correction

---

# 9. 📲 Digital Bill Fallback

## 9.1 When Printer Fails

- Show bill on screen
- Allow manual communication

---

## 9.2 Future

- WhatsApp share
- QR-based sharing

---

# 10. 📊 Reports & Analytics

## 10.1 Reports

- Daily
- Monthly
- Yearly

---

## 10.2 Metrics

- Top 10 items
- Peak hours

---

# 11. ⚡ Real-Time Behavior

- Table updates live
- Orders update live

---

# 12. 🔐 Security & Audit

## 12.1 Audit Logs

Track:
- Billing actions
- Reprints
- Table clearing

---

## 12.2 Validation

- Backend role enforcement mandatory

---

# 13. ⚠️ Edge Cases (Expanded)

- Printer offline
- Duplicate billing
- Multiple users same table
- App crash during billing
- Network delay

---

# 14. 🚫 Non-Functional Requirements

- UI response <300ms
- High reliability
- Simple onboarding

---

# 15. 🎯 MVP Scope

- Table
- Menu
- Order + KOT
- Billing
- Printing

---

# 16. 🔄 Future Scope

- Inventory
- Kitchen screen
- SaaS expansion

---

# END OF DOCUMENT

