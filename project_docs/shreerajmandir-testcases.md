# 🧪 Ice Cream POS – Test Case Document (v2 – QA Grade)

---

# 1. 📌 Purpose

Provide **production-grade, execution-ready test cases** covering:

* Functional correctness
* Data integrity
* Concurrency & race conditions
* Failure handling (printer/network)
* Performance & usability

All cases follow a strict format to enable **manual + automated testing**.

---

# 2. 🧱 Test Case Format (Standard)

Each test case uses:

* **ID**
* **Module**
* **Priority** (P0 Critical / P1 High / P2 Medium / P3 Low)
* **Preconditions**
* **Test Data**
* **Steps**
* **Expected Result**
* **Postconditions**
* **Notes**

---

# 3. 👤 AUTH MODULE

## TC-AUTH-01 (P0)

**Valid Login**

* Preconditions: User exists with valid credentials
* Test Data: email, password
* Steps:

  1. Open login screen
  2. Enter valid credentials
  3. Tap Login
* Expected Result:

  * Login success
  * User roles loaded
  * Redirect to Table screen
* Postconditions: Auth session active

---

## TC-AUTH-02 (P0)

**Invalid Login**

* Preconditions: None
* Steps:

  1. Enter wrong credentials
  2. Tap Login
* Expected Result:

  * Error message shown
  * No navigation

---

# 4. 🪑 TABLE MODULE

## TC-TBL-01 (P0)

**Create Table**

* Preconditions: Admin logged in
* Steps:

  1. Create table (name, capacity)
* Expected Result:

  * Table appears in grid
  * Status = available

---

## TC-TBL-02 (P0)

**Delete Table With Active Order (Blocked)**

* Preconditions: Table has activeOrderId
* Steps:

  1. Attempt delete
* Expected Result:

  * Operation blocked
  * Error shown (CONFLICT)

---

## TC-TBL-03 (P1)

**Real-time Sync Across Devices**

* Preconditions: Two devices logged in same branch
* Steps:

  1. Device A changes table status via KOT
* Expected Result:

  * Device B UI updates instantly

---

# 5. 🍦 MENU MODULE

## TC-MENU-01 (P0)

**Load Categories & Items**

* Preconditions: Menu data exists
* Steps:

  1. Open order screen
* Expected Result:

  * Categories visible
  * Items load correctly

---

## TC-MENU-02 (P1)

**Search Item**

* Steps:

  1. Enter keyword in search
* Expected Result:

  * Filtered items shown

---

## TC-MENU-03 (P1)

**Out-of-Stock Item**

* Preconditions: item.isAvailable = false
* Expected Result:

  * Item hidden or disabled

---

# 6. 🛒 CART MODULE

## TC-CART-01 (P0)

**Add Item to Cart**

* Steps:

  1. Tap item
* Expected Result:

  * Item added
  * Quantity = 1

---

## TC-CART-02 (P0)

**Increase/Decrease Quantity**

* Steps:

  1. Tap + / -
* Expected Result:

  * Qty updates correctly

---

## TC-CART-03 (P1)

**Add Note Toggle**

* Steps:

  1. Enable note toggle
  2. Enter note
* Expected Result:

  * Note saved in cart item

---

## TC-CART-04 (P0)

**Duplicate Tap Protection**

* Steps:

  1. Rapidly tap add
* Expected Result:

  * No duplicate unintended entries

---

# 7. 🍳 KOT MODULE

## TC-KOT-01 (P0)

**Create KOT**

* Preconditions: Non-empty cart
* Steps:

  1. Place order
* Expected Result:

  * KOT created
  * kotNumber incremented atomically
  * Table status → occupied

---

## TC-KOT-02 (P0)

**KOT Immutability**

* Steps:

  1. Attempt edit existing KOT
* Expected Result:

  * Not allowed

---

## TC-KOT-03 (P1)

**Cancel Item Before Serve**

* Steps:

  1. Cancel item
* Expected Result:

  * status = rejected
  * Totals updated

---

## TC-KOT-04 (P0)

**Cancel After Serve (Blocked)**

* Preconditions: item.status = served
* Expected Result:

  * Operation blocked

---

## TC-KOT-05 (P0)

**Concurrent KOT Creation**

* Preconditions: Two users same table
* Steps:

  1. Both place KOT
* Expected Result:

  * Unique kotNumbers
  * No duplication

---

# 8. 🖨️ PRINTING MODULE

## TC-PRINT-01 (P0)

**KOT Print Success**

* Steps:

  1. Create KOT
* Expected Result:

  * Printed successfully

---

## TC-PRINT-02 (P0)

**Printer Failure Handling**

* Preconditions: Printer offline
* Steps:

  1. Create KOT
* Expected Result:

  * Error popup
  * Digital KOT shown
  * Retry option available

---

## TC-PRINT-03 (P1)

**Retry Print**

* Steps:

  1. Retry after failure
* Expected Result:

  * Print succeeds

---

# 9. 💰 BILLING MODULE

## TC-BILL-01 (P0)

**Generate Bill**

* Preconditions: Active order with KOTs
* Steps:

  1. Open billing
  2. Generate bill
* Expected Result:

  * Correct subtotal
  * Bill stored

---

## TC-BILL-02 (P0)

**Discount Calculation**

* Steps:

  1. Apply % discount
* Expected Result:

  * Correct deduction

---

## TC-BILL-03 (P0)

**GST Toggle**

* Steps:

  1. Toggle GST
* Expected Result:

  * Correct total update

---

## TC-BILL-04 (P0)

**Empty Bill Blocked**

* Preconditions: No items
* Expected Result:

  * Billing blocked

---

## TC-BILL-05 (P0)

**Double Billing Prevention**

* Preconditions: Table in billing state
* Expected Result:

  * Second attempt blocked

---

## TC-BILL-06 (P0)

**Reprint Bill → Suspicious**

* Steps:

  1. Reprint bill
* Expected Result:

  * printCount++
  * isSuspicious = true

---

## TC-BILL-07 (P1)

**Split Payment Structure**

* Steps:

  1. Select multiple modes
* Expected Result:

  * Stored correctly in payments[]

---

# 10. 🔄 TABLE CLEAR FLOW

## TC-TBLCLR-01 (P0)

**Clear Table After Billing**

* Expected Result:

  * Table → available
  * activeOrderId = null

---

## TC-TBLCLR-02 (P0)

**Clear Without Bill Blocked**

* Expected Result:

  * Operation blocked

---

# 11. ⚠️ CONCURRENCY TESTS

## TC-CON-01 (P0)

**Parallel Billing Attempt**

* Expected Result:

  * Only one succeeds

---

## TC-CON-02 (P0)

**Simultaneous KOT + Billing Conflict**

* Expected Result:

  * Consistent state
  * No partial writes

---

# 12. 🌐 NETWORK FAILURE TESTS

## TC-NET-01 (P0)

**Failure During KOT Creation**

* Expected Result:

  * No partial KOT
  * Retry safe

---

## TC-NET-02 (P0)

**Failure During Billing**

* Expected Result:

  * No duplicate bills
  * Safe retry

---

# 13. 📊 REPORTS MODULE

## TC-REP-01 (P1)

**Daily Report Accuracy**

* Expected Result:

  * Matches bills data

---

## TC-REP-02 (P1)

**Top Items Ranking**

* Expected Result:

  * Correct ordering

---

# 14. 📉 PERFORMANCE TESTS

## TC-PERF-01 (P0)

**30 Orders Load Test**

* Expected Result:

  * No UI lag
  * <300ms interactions

---

## TC-PERF-02 (P1)

**Realtime Update Latency**

* Expected Result:

  * <1s sync delay

---

# 15. 🧠 REAL-WORLD SIMULATION

## TC-REAL-01 (P0)

**Rush Hour Simulation**

* Multiple users
* Continuous KOT + billing
* Expected: System stable

---

# 16. 🔐 DATA INTEGRITY TESTS

## TC-DATA-01 (P0)

**No Partial Writes**

* Expected:

  * Either full success or no write

---

## TC-DATA-02 (P0)

**Immutable Bill**

* Expected:

  * No modification after creation

---

# END OF DOCUMENT
