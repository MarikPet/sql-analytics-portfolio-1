# sql-analytics-portfolio-1
# 📊 SQL Analytics Portfolio: Phase 1 (Foundations)

Welcome! This repository documents my journey into Data Analytics using **PostgreSQL**. It covers everything from database design and normalization to performance optimization and deep-dives into built-in SQL functions.

<div align="center">

![PostgreSQL](https://img.shields.io)
![pgAdmin4](https://img.shields.io)

</div>

---

## 📂 Project Structure

### 🏗️ Database Design & Normalization
*Located in `/queries/normalization/`*

This section focuses on the structural side of databases—organizing data to reduce redundancy and improve integrity.
*   **`normalization_task` (.pgerd):** The primary ER Diagram file showing the normalized database structure.
*   **`normalization_task.png`:** A visual export of the database schema for quick reference.

### 🔍 Analytical Queries & Optimization
*Located in `/queries/`*


| File Name | Description | Key Skills |
| :--- | :--- | :--- |
| `sales_db_structure` | ER Diagram of the initial sales database. | `Database Design`, `ERD` |
| `new_rules.sql` | Modifying existing structures and indexing. | `ALTER`, `UPDATE`, `INDEXING` |
| `sorting_cost_evaluation.sql` | Analyzing query execution and sorting. | `EXPLAIN`, `Performance` |
| `explain_index.sql` | Proving how indexes reduce query cost. | `Optimization`, `Indexing` |
| `filters.sql` | Implementing conditional logic in results. | `CASE WHEN`, `GROUP BY` |
| `numeric_functions.sql` | Revenue distribution and data anomalies. | `Math Functions`, `Data Quality` |
| `string_functions.sql` | Text manipulation and table generation. | `String Ops`, `Formatting` |
| `coalesce.sql` | Handling null values for cleaner reports. | `COALESCE`, `Cleaning` |
| `date_functions_in_class.sql` | Introduction to temporal data handling. | `DATES`, `INTERVALS` |
| `dates_homework.sql` | Advanced date analysis and time trends. | `Date Extraction` |

---

## 🛠️ Tech Stack & Skills
*   **Tools:** PostgreSQL, pgAdmin 4 (ERD Tool)
*   **Database Architecture:** Database Normalization and Schema Design.
*   **Performance Tuning:** Using `EXPLAIN` to understand query costs and the impact of indexes.
*   **Data Cleaning:** Handling missing data with `COALESCE` and conditional logic with `CASE`.

## 💡 Learning Highlights
*   **Normalization:** Successfully redesigned a flat/unorganized data structure into a normalized relational model to ensure data consistency.
*   **Efficiency:** Learned to use `EXPLAIN` to visualize the database engine's path and used `INDEX` to optimize slow-running queries.
*   **Problem Solving:** Used numeric and string functions not just to format data, but to uncover "hidden" problems in the datasets.

---
*Next Steps: Moving toward Subqueries, Common Table Expressions (CTEs), and Window Functions.*
