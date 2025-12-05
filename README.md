# 🍽️ Restaurant Data System (In Development)

A relational database system for restaurant operations, designed for future integration with Python backend and analytics.

## 📌 Overview
This project defines a structured dataset and relational database schema designed to support core restaurant operations such as ordering, inventory management, staff administration, bookings, suppliers, promotions, and payments. It focuses on clean data modeling, normalization, and realistic operational workflows — serving as a foundation for future backend development, ETL pipelines, or a full-stack management application.

## 🧩 Features
- Fully normalized relational schema
- Entities for:
  - Menu, Ingredients, Suppliers
  - Orders, Payments, Delivery Partners
  - Bookings & Table Management
  - Staff & Roles
  - Promotions & discount logic
- Designed for future:
  - Python CRUD operations
  - ETL pipeline
  - BI dashboard (Power BI)
    
## ⚙️ Database Diagram (ERD)
<img width="1087" height="910" alt="Screenshot 2025-11-06 000702" src="https://github.com/user-attachments/assets/413204db-6bb3-4e0c-8439-a9fa77281c61" />

## 🚀 Roadmap
- [x] Design database schema (ERD)
- [x] Add SQL scripts for schema creation
- [ ] Add Python backend (psycopg2 connection + basic CRUD)
- [ ] Add data seeding script using Faker
- [ ] Add sample analytical SQL queries
- [ ] Add Power BI dashboard (future)
- [ ] Build Streamlit admin UI (optional)

## 🛠️ Tech Stack
- PostgreSQL  
- Python
- Faker (data generation)
- Power BI (future analytics)
- Streamlit (optional UI)

## 📂 Folder Structure
```
My_Restaurant/
├── schema/
│ ├── create_tables.sql
│ └── sample_queries.sql
├── backend/
│ ├── db_connection.py
│ ├── seed_data.py
│ └── queries.py
├── docs/
│ └── erd.png
├── README.md
└── requirements.txt
```

## ▶️ How to Run (Schema Only)

### 1. Create the PostgreSQL database
```sql
CREATE DATABASE my_restaurant;
