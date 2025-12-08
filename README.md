# 🍽️ Restaurant Data System (In Development) 
A relational database system for restaurant operations, designed for future integration with Python backend and analytics. 

## 📌 Overview
This project defines a structured dataset and relational database schema designed to support core restaurant operations such as ordering, inventory management, staff administration, bookings, suppliers, promotions, and payments.
It focuses on clean data modeling, normalization, and realistic operational workflows — serving as a foundation for future backend development, ETL pipelines, or a full-stack management application.

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
<img width="1080" height="890" alt="erd" src="https://github.com/user-attachments/assets/7741be95-edae-45b4-a942-55c03a0aad2c" />

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
