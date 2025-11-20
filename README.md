# Global Electronics Retailer - Sales & Customer Analytics

![SQL](https://img.shields.io/badge/Language-SQL%20(BigQuery)-orange)
![Visualization](https://img.shields.io/badge/Visualization-Dashboard-blueviolet)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

## Project Overview
This project involves a comprehensive analysis of a global electronics retailer's transaction data. The goal was to dissect sales performance, understand customer demographics, and evaluate store contributions across different regions. 

The project is divided into two main components:
1.  **SQL Data Analysis:** Writing complex queries to extract financial metrics, handle currency exchange rates, and analyze store performance.
2.  **Customer Insight Dashboard:** Visualizing high-level KPIs related to customer retention, lifetime value, and demographic distribution.

---

## Table of Contents
- [Project Overview](#-project-overview)
- [Business Questions](#-business-questions)
- [Data Dictionary](#-data-dictionary)
- [SQL Analysis & Logic](#-sql-analysis--logic)
- [Dashboard Insights](#-dashboard-insights)
- [Key Findings](#-key-findings)
- [Technologies Used](#-technologies-used)

---

## Business Questions
* **Sales Trends:** How is revenue trending month-over-month and year-over-year?
* **Currency Impact:** How do sales figures look when adjusted for fluctuating exchange rates across different countries?
* **Store Performance:** Which stores contribute the most to the total revenue share?
* **Customer Profile:** Who is the typical customer? (Age, Gender, Region).
* **Retention:** Are we retaining customers effectively? What is the ratio of new vs. repeat customers?

---

## Data Dictionary
The analysis uses a relational database with the following key tables:
* `ElectronicDealer.Sales`: Transactional data including `Order Date`, `Quantity`, `StoreKey`, `ProductKey`.
* `ElectronicDealer.Products`: Product details including `Unit Price USD`.
* `ElectronicDealer.Stores`: Store location and country information.
* `ElectronicDealer.Exchange_Rates`: Daily currency exchange rates for normalizing revenue.

---

## SQL Analysis & Logic
The SQL scripts (`query_ElectronicDealer.sql`) handle the heavy lifting of data processing:

1.  **Revenue Calculation:**
    * Aggregated `Unit Price USD * Quantity` to calculate total revenue by month.
    * Implemented **Exchange Rate Normalization** to convert local currency sales into a standardized USD view for accurate global comparison.

2.  **Store Contribution Analysis:**
    * Calculated the **% Share of Total Sales** for each store to identify top-performing locations vs. underperformers.

3.  **Growth Rate Analysis:**
    * Used CTEs (Common Table Expressions) to calculate the sales growth rate for different regions to spot emerging markets.

---

## Dashboard Insights
The visual analysis (`Dashboard.pdf`) focuses on Customer Insights (2016-2021):

### **Customer KPIs**
* **Total Customers:** 15,266
* **Retention Rate:** **61%** of the base are Repeat Customers, indicating strong brand loyalty.
* **Avg Revenue Per Customer:** **$4,690**, suggesting a high-value product mix.
* **Avg Orders Per Customer:** 5 orders.

### **Demographics**
* **Gender Balance:** The customer base is nearly evenly split (Male: ~51%, Female: ~49%).
* **Age Distribution:** The majority of customers fall into the **26-55 age range**, with a peak in the 36-45 segment.
* **Geographic Spread:** The **USA** is the dominant market, followed by significant presence in **Germany** and the **UK**.

---

## Key Findings & Recommendations

1.  **High Retention:** With 61% repeat customers, the business has a solid loyal base.
    * *Recommendation:* Implement a loyalty program to further increase the Average Order Value (AOV) of these repeat buyers.
2.  **Market Dominance:** The USA and Europe (Germany/UK) are the strongholds.
    * *Recommendation:* Investigate the lower performance in other regions (e.g., Italy, France) to see if it's a supply chain issue or lack of marketing.
3.  **Currency Fluctuations:**
    * *Observation:* Sales figures can be misleading without exchange rate adjustment. The SQL model ensures reporting accuracy by dynamically applying daily rates.

---

## 💻 Technologies Used
* **SQL (BigQuery/Standard SQL):** For data extraction, joining multiple tables, and aggregations.
* **Data Visualization:** For building the customer insight dashboard (PDF report).
