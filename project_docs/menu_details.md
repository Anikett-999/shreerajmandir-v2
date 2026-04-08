 
# 🧠 🍦 MASTER MENU MIND MAP

```
MENU
│
├── Cocktails
│   └── Kolhapuri Special
│       ├── Royal Fruit Cocktail
│       ├── Special Cocktail
│       ├── Dry Fruit Cocktail
│       ├── Choco Decor
│       ├── Mango Tower
│       ├── Strawberry Tower
│       └── Mini Cocktail
│
├── Sundaes
│   └── Rajmandir Sundaes
│       ├── Titanic
│       ├── Kulfi Villa Dessert
│       ├── Chocolaty Dessert
│       ├── Refresh Dessert
│       ├── Mix Fruit Jelly
│       ├── Brownie & Cookies
│       ├── Crunchy Munchy
│       ├── Afghani Crunch
│       ├── Vanilla with Caramel
│       └── Gems Masti
│
├── Mastani
│   └── Mastani Mania
│       ├── Mango Mastani
│       ├── Sitafal Mastani
│       ├── Brownie Chocolate Mastani
│       ├── Mango with Fruit Cream
│       └── Mango with Mango Slice
│
├── Milkshakes
│   └── Milkshake with Ice Cream
│       ├── Vanilla Milkshake
│       ├── Strawberry Milkshake
│       ├── Choco Chips Milkshake
│       ├── Keshar Pista Milkshake
│       └── Rose Petal Milkshake
│
├── Falooda
│   └── Falooda Specials
│       ├── Rajmandir Special Falooda
│       ├── Shahi Keshar Falooda
│       ├── Thandai Falooda
│       ├── Special Rose Falooda
│       ├── Mango Falooda
│       ├── Strawberry Falooda
│       ├── Blackcurrant Falooda
│       └── Rabdi Falooda
│
├── Coffee
│   └── Coffee Mania
│       ├── Coffee Tower Cocktail
│       ├── Coffee Walnut
│       ├── Coffee Caramel
│       ├── Coffee Vanilla
│       └── Cold Coffee
│
└── Scoops (🔥 CORE CATEGORY)
    │
    ├── Variants (MANDATORY FOR ALL ITEMS)
    │   ├── Cup
    │   └── Cone
    │
    ├── Regular
    │   ├── Vanilla
    │   ├── Strawberry
    │   ├── Butterscotch
    │   ├── Mango
    │   ├── Rajbhog
    │   ├── Dark Choco Chips
    │   ├── Pan Masala
    │   ├── Keshar Pista
    │   ├── Afghan Dryfruit
    │   ├── Red Peru
    │   └── Rose Petal (Sugar Free)
    │
    ├── Round the Year
    │   ├── Blackcurrant
    │   ├── Pine Strawberry
    │   ├── Santra Mantra
    │   ├── Jelly Queen
    │   ├── Crunchy Munch
    │   ├── Kaju Draksh
    │   ├── Roasted Almond
    │   ├── Mawa Anjeer
    │   ├── Caramel Cake
    │   ├── Panchratna
    │   ├── Cream & Cookies
    │   └── Royal Treat
    │
    └── Seasonal
        ├── Sitafal
        ├── Mango Special Variants (if seasonal)
        └── (Admin controlled items)
```

---

# 🔥 CRITICAL LOGIC (THIS IS WHAT MOST PEOPLE MISS)

## 1. Scoops = Backbone of Your Business

Everything else is:

* Cocktail → combination
* Sundae → combination
* Falooda → combination

👉 Scoops = raw product

---

## 2. Variants Apply ONLY to Scoops

```
Vanilla → Cup / Cone
NOT:
Falooda → Cup ❌
```

---

## 3. Groups ≠ Categories

| Type     | Example |
| -------- | ------- |
| Category | Scoops  |
| Group    | Regular |
| Item     | Vanilla |

👉 Don’t mix this or your DB will break

---

## 4. Same Flavor Appears Multiple Times (Correct)

Example:

| Item                   | Category   |
| ---------------------- | ---------- |
| Keshar Pista           | Scoops     |
| Keshar Pista Milkshake | Milkshakes |

👉 Different IDs, same name → GOOD

---

## 5. Naming Standard (FINAL LOCK)

* Use Title Case
* No spelling variations
* Always consistent

---

# 🧱 HOW SYSTEM WILL THINK

When waiter taps:

```
Scoops → Regular → Vanilla → Cone
```

System stores:

```json
{
  "name": "Vanilla",
  "category": "Scoops",
  "group": "Regular",
  "variant": "Cone"
}
```

---

# 🖨️ HOW IT SHOWS IN KOT

```
Vanilla (Cone)
Category: Scoops
Qty: 2
```

---

# 💰 HOW IT SHOWS IN BILL

```
2 x Vanilla (Cone) - ₹120
```

---

# ⚠️ EDGE CASES HANDLED

✔ Seasonal items
✔ Duplicate names
✔ Variant handling
✔ Category-based reports
✔ Future inventory

---
 
 