\# Data Analysis using SQL



\*\*Author:\*\* Mukesh Gopi Nandh  

\*\*Email:\*\* mukeshudatha7@gmail.com  

\*\*GitHub:\*\* \[Mukeshgn](https://github.com/Mukeshgn)  

\*\*LinkedIn:\*\* \[Mukesh Gopi Nandh](https://www.linkedin.com/in/mukesh-gopi-nandh)



---



\## 📊 Project Overview

This project showcases a \*\*SQL-based data analytics case study\*\* that explores a food delivery business dataset.  

The analysis focuses on identifying \*\*customer behavior\*\*, \*\*delivery performance\*\*, and \*\*business insights\*\* using SQL queries.



The project demonstrates how to clean, transform, and analyze structured data to support \*\*data-driven decision-making\*\*.



---



\## 🧠 Key Objectives

\- Analyze \*\*order trends\*\* and \*\*peak delivery times\*\*  

\- Identify \*\*top customers and best-selling dishes\*\*  

\- Measure \*\*delivery performance metrics\*\*  

\- Derive \*\*restaurant-level insights\*\* using SQL queries  



---



\## 🗂️ Repository Structure

| Folder / File | Description |

|----------------|-------------|

| \*\*`sql/`\*\* | Contains schema creation and analytical SQL queries |

| \*\*`data/`\*\* | Includes sample or demo data (if available) |

| \*\*`docs/`\*\* | Case study PDF report and related documentation |

| \*\*`scripts/`\*\* | Any helper scripts for automation or loading data |

| \*\*`images/`\*\* | ER diagrams, dashboards, and result screenshots |

| \*\*`README.md`\*\* | Project overview and execution guide |



---



\## 🛠️ Tools \& Technologies Used

\- \*\*SQL (PostgreSQL / MySQL)\*\* – for data querying and analytics  

\- \*\*Excel / Power BI\*\* – for visualization and data summaries  

\- \*\*Git \& GitHub\*\* – for version control and collaboration  

\- \*\*VS Code / pgAdmin\*\* – for SQL query execution and testing  



---



\## ⚙️ How to Run Locally

Follow these steps to execute the SQL project on your local system:



1\. \*\*Create a new database\*\* (example in PostgreSQL):

&nbsp;  ```bash

&nbsp;  createdb food\_delivery

Load schema and data:



bash

Copy code

psql -d food\_delivery -f sql/schema.sql

psql -d food\_delivery -f sql/seed\_data.sql

Run the analytical queries one by one:



bash

Copy code

psql -d food\_delivery -f sql/queries/01\_top\_customers.sql

Review results and use them in Excel/Power BI dashboards if needed.



🔍 Sample Analyses

Analysis	Description

Customer Segmentation	Identify new, returning, and loyal customers

Revenue Analysis	Track sales and profit trends

Top Performing Restaurants	Find outlets with highest order counts

Peak Delivery Times	Discover most active ordering hours

Delivery Partner Efficiency	Compare delivery speeds and accuracy



📄 Documentation

A detailed explanation of the case study, including SQL logic, business context, and insights, is available in:

📘 docs/Food-Delivery-Analytics-SQL-Case-Study.pdf



📸 Visuals

ER Diagram

Below is the Entity Relationship (ER) Diagram used in this project:



<p align="center"> <img src="ER%20Diagram.jpg" alt="ER Diagram" width="80%"> </p>

Other Visuals

SQL Query Outputs



Power BI Dashboard



If available, you can include dashboard or query output screenshots here for a complete visual overview.



Example:



md

Copy code

!\[Dashboard Preview](images/dashboard\_preview.png)

🚀 Future Improvements

Add interactive dashboards (Power BI or Tableau)



Integrate Python (pandas, SQLAlchemy) for automation



Extend with advanced analytics (customer churn prediction)



🧾 License

This project is licensed under the MIT License — free to use and modify with attribution.



✉️ Contact

For collaboration or feedback:

📧 mukeshudatha7@gmail.com

🌐 LinkedIn

