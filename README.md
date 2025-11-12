---
# 🍽️ SQL Project: Food Delivery Data Analysis
---

## 📘 Project Overview

This project simulates a real-world business scenario of a **food delivery company**, focusing on **analyzing customer behavior, delivery performance, and restaurant insights** using SQL.  

The goal is to showcase **data analytics capabilities using SQL queries**, from database setup to deriving actionable insights that can help optimize operations and customer experience.

> 📝 Note: All data is **synthetic** and created for learning purposes only.

---

## 🧩 Project Structure
- **Database Setup** – Created a PostgreSQL database `food_delivery` with schema and data tables.  
- **Data Import** – Inserted sample order, customer, restaurant, and delivery data.  
- **Data Cleaning** – Ensured data integrity and consistency across multiple tables.  
- **Analysis & Reporting** – Used SQL queries to answer business questions and measure performance KPIs.  

---

## 🛠️ Tech Stack
| Tool / Technology | Purpose |
|-------------------|----------|
| **PostgreSQL** | Data storage and SQL query execution |
| **pgAdmin 4** | GUI for database management |
| **Excel / Power BI** | Data visualization and reporting |
| **Git & GitHub** | Version control and project sharing |

---

## 🧱 Database Schema
The database contains the following main tables:

- `customers` – Customer profile and demographic information  
- `restaurants` – Partner restaurant details  
- `orders` – Order-level transaction data  
- `deliveries` – Delivery partner and order tracking details  
- `riders` – Delivery partner performance and activity  

> **Entity-Relationship Diagram (ERD):**  
  
 <p align="center">
   <img src="ER%20Diagram.jpg" alt="ER Diagram" width="80%">
 </p>

---

## 📊 Business Problems Solved
The following questions were addressed using SQL:

1. Identify the **top-performing restaurants** based on order count and ratings.  
2. Analyze **peak order times** to optimize delivery partner availability.  
3. Segment customers into **new, returning, and loyal** based on order frequency.  
4. Calculate **monthly revenue and growth trends**.  
5. Measure **average delivery time and partner performance efficiency**.  
6. Find **most ordered dishes and high-profit categories**.  
7. Evaluate **restaurant contribution to overall revenue**.  

---

## 💻 Sample SQL Queries

```sql
-- 🥇 Top Performing Restaurants
SELECT restaurant_id, COUNT(order_id) AS total_orders
FROM orders
GROUP BY restaurant_id
ORDER BY total_orders DESC
LIMIT 10;

-- 🕒 Peak Delivery Hours
SELECT EXTRACT(HOUR FROM order_time) AS hour, COUNT(*) AS orders
FROM orders
GROUP BY hour
ORDER BY orders DESC;

```

---

## 🧠 Key Learnings
Improved understanding of data relationships and normalization.

Gained experience in writing optimized SQL queries for business use cases.

Developed skills in translating business needs into data-driven insights.

Practiced database management, joins, and aggregate functions in real-world context.

---

## 📄 Documentation

Detailed explanations, SQL logic, and business insights are included in the following files:

| File | Description |
|------|--------------|
| [📊 Food-Delivery-Analytics-SQL-Case-Study.pptx](Food-Delivery-Analytics-SQL-Case-Study.pptx) | Presentation summarizing insights and visual analysis |
| [🧾 Report.docx](Report.docx) | Detailed document containing structured analysis, answers, and recommendations |

> These resources include a full walkthrough of the SQL problem-solving process, insights visualization, and business takeaways.

---

## 🧾 Conclusion
This project demonstrates how SQL can be effectively used to analyze data, solve business problems, and generate insights in the food delivery industry.
It reflects structured thinking, analytical capability, and data storytelling — key skills for any Data Analyst or Business Intelligence professional.

---

## ⚠️ Disclaimer
All customer, restaurant, and order data are fictitious and AI-generated for educational purposes.
This project does not represent real entities and is meant purely for learning and showcasing data analytics proficiency.

---

## 👨‍💻 Author
Mukesh Gopi Nandh
📧 mukeshudatha7@gmail.com
🌐 GitHub: ---

## 👨‍💻 Author

**Mukesh Gopi Nandh**  
📧 [mukeshudatha7@gmail.com](mailto:mukeshudatha7@gmail.com)  

🌐 **Connect with Me:**  
<p align="left">
  <a href="https://github.com/Mukeshgn" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-Mukeshgn-181717?style=for-the-badge&logo=github" alt="GitHub"/>
  </a>
  <a href="https://www.linkedin.com/in/mukesh-gopi-nandh" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-Mukesh%20Gopi%20Nandh-blue?style=for-the-badge&logo=linkedin" alt="LinkedIn"/>
  </a>
</p>

