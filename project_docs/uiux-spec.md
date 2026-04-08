
# 🎨 Ice Cream POS – UI/UX Specification (v1)

---

# 1. 📌 Purpose

Define **complete UI/UX behavior, layouts, interactions, and rules** for the POS system.

Goals:

* Ultra-fast operations (1–2 taps)
* Zero confusion under rush
* Large touch targets
* Consistent patterns across screens
* Error-proof workflows

---

# 2. 🧭 DESIGN PRINCIPLES

* Speed > aesthetics
* Visibility > hidden actions
* Consistency across all screens
* Minimal cognitive load
* Immediate feedback on every action

---

# 3. 📱 GLOBAL UI RULES

## 3.1 Touch Targets

* Minimum size: 48px
* Spacing between buttons

## 3.2 Typography

* Large readable text
* Important values (TOTAL, Table) bold

## 3.3 Colors

* Green → Available / Success
* Red → Occupied / Alert
* Orange → Billing / Attention
* Blue → Actions

## 3.4 Feedback

* Tap animation (quick highlight)
* Snackbar for success/error

---

# 4. 🪑 TABLE SCREEN (HOME)

## 4.1 Layout

Grid of table cards

## 4.2 Table Card

Fields:

* Table name
* Total amount
* Item count
* Status badge

## 4.3 Colors

* Available → Green
* Occupied → Red
* Billing → Orange

## 4.4 Actions

Tap:

* Open order screen

Long press / ⚙:

* Generate Bill (admin + cashier)
* Clear Table (admin + cashier)

## 4.5 Filters

* All
* Available
* Occupied
* Billing

---

# 5. 🛒 ORDER SCREEN

## 5.1 Layout

Left → Categories
Center → Items Grid
Right → Cart

## 5.2 Category Panel

* Scrollable list
* Large buttons

## 5.3 Items Grid

* Card layout
* Tap = add item

## 5.4 Variant Selection

* Popup with options

## 5.5 Notes

* Toggle “Add Note”
* Input field appears only if enabled

## 5.6 Cart Panel

Displays:

* Items
* Qty controls
* Notes
* Total

## 5.7 Actions

* Increase qty
* Decrease qty
* Remove item

## 5.8 Place Order

* Single button
* Creates KOT
* Clears cart

---

# 6. 🧾 KOT EXPERIENCE (NO SCREEN)

## 6.1 Print Layout

* KOT number
* Table number
* Time
* Category grouping
* Items + qty
* Notes highlighted

## 6.2 Error Handling

* Popup on print fail
* Show digital KOT

---

# 7. 💰 BILLING SCREEN

## 7.1 Layout

Top: Table info
Middle: Item list
Bottom: totals + actions

## 7.2 Fields

* Subtotal
* Discount (%)
* Extra Charges
* Total

## 7.3 Payment

* Cash
* UPI
* Card
* Split

## 7.4 Actions

* PRINT & CLOSE

---

# 8. 📲 DIGITAL BILL VIEW

* Same as printed bill
* Full-screen readable
* Used when printer fails

---

# 9. 🔐 ROLE-BASED UI

## Admin

* Full access

## Cashier

* No table edit
* Can bill/clear

## Waiter

* No billing
* No table actions

---

# 10. ⚠️ ERROR UX

## Types

* Printer error
* Network error
* Validation error

## Behavior

* Show message
* Provide retry

---

# 11. 🔁 LOADING UX

* Button-level loading
* Disable repeated taps

---

# 12. 📊 REPORTS SCREEN

* Date filters
* Summary cards
* Top items list
* Peak hours chart

---

# 13. 🚀 PERFORMANCE UX

* Instant navigation
* No heavy animations
* Lazy loading lists

---

# 14. 🔄 USER FLOWS

## Order Flow

Table → Order → KOT → Serve → Bill → Close

## Billing Flow

Open → Review → Discount → Extra Charges → Payment → Print → Close

---

# END OF DOCUMENT
