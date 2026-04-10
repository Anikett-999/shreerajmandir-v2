# 🏗️ Shree Rajmandir POS - Complete Software Blueprint & Step-by-Step Build Plan

This plan is written from a high-level **Software Engineering View**, outlining exactly how to build this full-fledged Ice Cream POS application **from scratch**. Following this step-by-step sequence is the safest way to avoid confusion, prevent code overlap, and ensure the app is deeply stable before adding complexity.

---

## 🏛️ Phase 1: Foundation & Architecture Setup
**Goal:** Establish the bones of the project before writing a single feature.
*   **Step 1.1:** Initialize the Flutter Project & define folder structure (MVVM: `core/`, `domain/models/`, `presentation/screens/`, `services/`).
*   **Step 1.2:** Configure `pubspec.yaml` (Add Riverpod, Firebase, ESC/POS Utils, Freezed).
*   **Step 1.3:** Setup Global Styling in `AppTheme` (Define standard colors, thumb-friendly button sizes, dark/light modes).
*   **Step 1.4:** Define domain entities. Create strictly immutable Data Models (`UserModel`, `TableModel`, `ItemModel`, `KOTModel`, `BillModel`).

---

## 🔒 Phase 2: Database & Authentication Layer
**Goal:** Connect to the remote backend safely.
*   **Step 2.1:** Execute Firebase CLI Handshake to generate `firebase_options.dart` and bind Android/Web builds.
*   **Step 2.2:** Set up Firebase Authentication (Email/Password) to protect app entry.
*   **Step 2.3:** Create `AuthService` logic and Riverpod `authProvider` to handle routing (Pushing unauthenticated users to the Login Screen).
*   **Step 2.4:** Build the `LoginScreen` Interface.

---

## 💾 Phase 3: Core Infrastructure & Master Data
**Goal:** Populate the app with the business assets (Tables & Menu).
*   **Step 3.1:** Create `MenuService` and `TableService` to manage read/write operations with Cloud Firestore.
*   **Step 3.2:** Execute a one-time "Data Seed" to push JSON menus (Ice Creams, Cocktails) and static Table configurations up to Firestore.
*   **Step 3.3:** Build the primary UI shell: The `HomeScreen` with an AppBar, navigation hooks, and Logout functionality.
*   **Step 3.4:** Display the live Tables in a Grid on the `HomeScreen` with color-coding (Available [Green], Occupied [Orange], Billing [Blue]).

---

## 🛒 Phase 4: The Ordering Engine (KOT Module)
**Goal:** Implement the complex, real-time waiter ordering system without crashing constraints.
*   **Step 4.1:** Build the 3-Panel `OrderScreen` UI (Left: Categories, Center: Items, Right: Cart/Current KOT).
*   **Step 4.2:** Create local state management for the `Cart` (Adding, removing, and adjusting quantities without lag).
*   **Step 4.3:** Create `KOTService.createKOT()`. When the waiter hits "Submit":
    *   Upload KOT to Firestore with **Denormalized Table Name** and **Waiter Information** (User Name).
    *   Find the selected Table and update its status from `Available` to `Occupied`.
    *   Wipe the local cart clean.
*   **Step 4.4: KOT Data Specification**
    *   `tableName`: Required string for kitchen identification.
    *   `userName`: First 5 characters of waiter's name stored for accountability.
    *   `items`: Must include category for compartmentalized kitchen prep.

---

## 💰 Phase 5: Billing & Math Engine
**Goal:** Handle money, discounts, and finalization perfectly.
*   **Step 5.1:** Create the `BillingScreen` that fetches all KOTs for a specific Occupied table.
*   **Step 5.2:** Implement precise Math Logic. Formula: `(Subtotal - Discount Amount) + Extra Charges`. (Ensure no GST artifacts remain).
*   **Step 5.3:** Create `BillingService.generateBill()`. When hitting "Checkout":
    *   Save final transaction array to Firestore under a daily ledger.
    *   Reset Table status from `Occupied/Billing` back to `Available`.

---

## 🖨️ Phase 6: Hardware Integration (Thermal Printing)
**Goal:** Connect the digital app to physical thermal printers across Android and Desktop.
*   **Step 6.1: Hardware Foundation & Persistence**
    *   Add `flutter_pos_printer_platform` to `pubspec.yaml` for native USB/BT/TCP support.
    *   Create `PrinterConfig` model (ConnectionType: BT, USB, IP, RawBT; Width: 58mm/80mm; Address/Port).
    *   Implement persistent storage for printer settings using `SharedPreferences`.
*   **Step 6.2: Universal Print Engine (`PrintService`)**
    *   Refactor `PrintService` to handle multi-platform routing.
    *   Logic: If Android + RawBT enabled -> use Intent; Else -> Use Direct Native Connection (USB/IP/BT).
    *   Implement ESC/POS templating for both KOT (Internal) and Bills (Customer-facing).
*   **Step 6.3: Advanced Printer Settings Screen**
    *   Build a premium UI for device discovery (scan for Bluetooth/USB devices).
    *   Add manual IP configuration for network-based thermal printers.
    *   Implement a "Test Print" tool with real-time connectivity status.
*   **Step 6.4: KOT Professional Layout Specification**
    *   **Header**: Bold Itemized KOT # (Left) | HH:mm Time (Top Right).
    *   **Metadata**: Table Name (Left) | Waiter "by:xxxxx" (Right).
    *   **3-Column Grid**: Items (6 units) | Category (4 units) | Qty (2 units).
    *   **Inline Notes**: Instruction text immediately below the affected item.
    *   **Separation**: Logical `hr()` line breaks for maximum clarity in heat.
*   **Step 6.5: Workflow Integration**
    *   Connect `KOTService` -> `PrintService` for automatic KOT printing on submission.
    *   Connect `BillingService` -> `PrintService` for automatic Bill printing on checkout.
    *   Implement "Reprint" logic in KOT and History screens.


---

## 📈 Phase 7: Audits, Analytics, & Final Polish
**Goal:** Make the app enterprise-ready for management.
*   **Step 7.1:** Implement `AuditService` to globally log destructive commands (e.g., "Cashier Voided KOT #15", "Admin deleted Table").
*   **Step 7.2:** Build a simple generic reporting dashboard (Daily Revenue, Peak Items).
*   **Step 7.3:** Conduct UAT (User Acceptance Testing) to ensure multi-device synchronization (e.g., Waiters don't overwrite each other's Tables).

---

## 🛑 Golden Rules for Developing This Sequence
1. **Never Skip Ahead:** You cannot build Phase 4 UI without Phase 3 Database Services working.
2. **Separation of Concerns:** UI files handle buttons/clicks. Service files handle logic/Firebase. Never mix them.
3. **Continuous Testing:** After every Phase completes, test the entire flow up to that point.
