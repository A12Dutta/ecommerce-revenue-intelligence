# E-Commerce Customer & Revenue Decision Intelligence System

An end-to-end analytics project analyzing **$14.98M** in tracked revenue across **93K orders** (2016–2018 Olist dataset) to drive revenue optimization, customer retention, and logistics performance.

---

## 📌 Executive Summary & Key Highlights
* **Revenue Architecture:** Integrated 9 relational tables into a unified star schema for enterprise KPI reporting.
* **Logistics Bottlenecks:** Identified an average delivery time of **12.8 days vs. an internal 10-day target**, representing a 28% operational buffer lag that a 28% operational buffer lag strongly correlated with lower review score trends (requires causal statistical testing).
* **Customer Retention:** Cohort analysis established customer acquisition as the primary growth engine, highlighting a key opportunity for post-purchase re-engagement.
* **Seller Concentration:** The top 5% of sellers account for **53.3% of total platform GMV**, signaling key account management risks.

---

## 📊 Dashboard Overview

![Power BI Executive Dashboard](outputs/dashboard_overview.png)

---

## 🛠️ Tech Stack & Architecture
* **Database Management:** MySQL (Schema design, table indexing, multi-table aggregation queries)
* **Data Engineering & Analysis:** Python (`pandas`, `numpy`, `matplotlib`, `seaborn`)
* **Business Intelligence:** Power BI (Star Schema modeling, DAX measure engineering, dynamic drill-throughs)
* **Documentation:** Executive Report (PDF located in `documentation/`)

---

## 📁 Repository Structure
```text
├── sql/                   # MySQL DDL scripts, data verification, & KPI engine queries
├── python/                # Data cleaning, EDA scripts, & anomaly detection
├── powerbi/               # Interactive Power BI Dashboard (.pbix)
├── documentation/         # Executive Report (PDF)
└── outputs/               # Dashboard preview images & visualizations

---

## Strategic Business Recommendations

Based on the core SQL and Power BI analytics engine, three primary operational levers have been identified:

1. **Protect VIP Seller Cohort:** The top 5% of sellers generate 53.3% of total GMV. Establish dedicated account management and SLA monitoring to prevent seller churn in this high-concentration segment.
2. **Optimize Logistics Buffer:** Adjust delivery estimates by calibrating warehouse dispatch buffers to reduce customer expectation gaps without increasing late delivery penalties.
3. **Targeted Re-Engagement:** Implement automated lifecycle campaigns targeting high-LTV repeat buyer personas based on cohort retention windows.