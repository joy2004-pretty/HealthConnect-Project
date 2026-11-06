# HealthConnect Rwanda: Healthcare Operations & Performance Analytics

**End-to-end healthcare analytics project | MySQL | Power BI**

An end-to-end healthcare analytics project using synthetic data for a fictional healthcare provider, HealthConnect Rwanda. I used **MySQL** for data analysis and **Power BI** to develop an interactive dashboard, validate findings and communicate business recommendations.

**Analytical scope:** The available data supports appointment workload and patient-service analysis but does not contain attendance outcomes. Therefore, this project identifies the data requirements and recommendations needed to support future no-show reduction initiatives rather than claiming to have measured or reduced no-shows.

**Project Question:**

> How can HealthConnect use data and AI to reduce missed appointments and improve the patient support experience?

---

## Key Takeaways

- **The data can describe workload but not attendance.** The appointment extract has 5,000 bookings but no attended / missed / cancelled field, so a no-show rate cannot be calculated. The first recommendation is to start recording appointment outcomes.
- **Collections reconcile overall, but facility comparisons cover only a small slice.** RWF 8.39 billion was collected against RWF 9.31 billion billed (90.12%), but only 8.28% of payment value links to a recorded appointment.
- **Testing caught a real analytical error.** A join through bed records inflated the appointment count from 5,000 to 50,000 in a controlled test. A one-row-per-department lookup restored the correct count.
- **Validated against the source.** Dashboard cards and filters were checked live in Power BI Desktop against figures recalculated from the raw data, and all checks matched.
- **Honest reporting of limits.** Every figure in this repository states what it covers and what it does not.

---

## Headline Figures

| Measure | Value | Note |
|---|---|---|
| Registered patients | 20,000 | Patient register |
| Recorded appointments | 5,000 | 4,443 distinct patients; dated 1 Jan to 28 Dec 2026 |
| Facilities / Doctors | 20 / 350 | |
| Total billed | RWF 9,309,401,961 | |
| Collected payments | RWF 8,389,454,556 | 90.12% of billed |
| Outstanding billing balance | RWF 919,947,405 | Billed less collected; not a measure of loss |
| Reported revenue (monthly summary) | RWF 1,132,677,500 | Separate source; not the same as collections |
| Payments linked to an appointment | RWF 694,551,320 | 8.28% of collections |
| Average patient satisfaction | 2.99 / 5 | 21,064 responses; only 8.34% link to an appointment |

*Currency is assumed to be RWF, following the project's reporting assumption.*

---

## Project Journey

| Week | Stage | What I did |
|---|---|---|
| **6** | Build | Wrote 40 SQL analyses and a KPI script, built a six-page Power BI dashboard, and produced a data quality assessment, business insights report and executive presentation. |
| **7** | Test and refine | Validated the SQL and KPIs against the source data, found a join error, wrote 13 refinement queries and retested them. |
| **8** | Finalize | Confirmed final KPI definitions, validated dashboard fields, identified the most important patterns, and wrote recommendations, a decision brief, hand-off notes, an analytics report and an executive summary. |

---

## Tools & Skills

- **MySQL** (database `healthcare_analytics`): joins, window functions (`LAG`, `RANK`, `DENSE_RANK`), CTEs, aggregation
- **Power BI**: KPI cards, slicers, drill-through, tooltips, six core analytics pages
- **Data validation**: reconciling totals, checking join grain and record coverage, documenting limitations
- **Business communication**: executive reports, decision briefs, presentation slides

---

## About the Data

- The datasets are **synthetic**. They contain no real patient information.
- The original CSV files cover patients, appointments, diagnoses, laboratory tests, prescriptions, admissions, referrals, billing, insurance claims, payments, patient feedback, staff, facilities and a revenue summary, plus geographic data.
- I merged the original files into fewer tables to make the analysis manageable. The originals are kept separately so the merge can be traced.
- Some ID columns in the SQL (for example `ï»¿StaffID`) carry a byte-order-mark artifact from the CSV import. The scripts are written to match the imported schema, so adjust the column names if your import differs.

---

## Repository Structure

```
HealthConnect-Project/
├── README.md
├── screenshots/              dashboard and SQL result screenshots
├── Week6_DataAnalytics_Joyce_Wambui/
│   ├── data/                 original and merged datasets
│   ├── sql/                  SQL_SCRIPT.sql (40 analyses), Key_Performance_Indicators.sql
│   ├── dashboard/            Power BI dashboard (.pbix)
│   └── reports/              data quality findings, business insights report, presentation
├── Week7_DataAnalytics_Joyce_Wambui/
│   ├── sql/                  HealthConnect_Week7_SQL_Refinements.sql
│   ├── evidence/             testing register, retest results, issues log, source verification
│   └── reports/              testing and refinement report, project summary
└── Week8_DataAnalytics_Joyce_Wambui/
    ├── task-notes/           Tasks 1 to 13 (KPI check, dashboard validation, insights, recommendations)
    └── reports/              analytics report, executive summary, presentation
```

---

## Week 6: Analysis & Dashboard

**SQL.** Forty analyses across four areas, plus a KPI script:

- **Patients:** gender, province, age, blood group, chronic conditions, insurance coverage
- **Appointments:** monthly volume, busiest facilities and departments, doctor workload, referral patterns
- **Clinical:** top diagnoses, lab tests, medications, admission rates, length of stay
- **Financial:** revenue by facility and department, payments, outstanding balances, insurance claims

Some KPIs could not be calculated from the supplied data (for example new patients, bed utilization and service-level revenue). I documented each of these in the scripts instead of forcing a misleading answer.

**Power BI dashboard.** Six core pages: Executive, Patient Analytics, Clinical Analytics, Financial, Operational and Patient Experience. The file also has a landing page and six supporting detail pages.

---

## Week 7: Testing & Refinement

I tested the Week 6 outputs instead of rebuilding them.

| Test finding | Fix |
|---|---|
| Joining appointments to a bed-level lookup multiplied department counts from 5,000 to 50,000 | Join to one row per department |
| An appointment-matched lab query kept only 2,272 of 5,000 tests | Keep all 5,000 and show 2,728 as "Unknown" |
| Facility and department payment queries covered only a subset of collections | Start from payments and keep an "Unknown" group so totals reconcile |
| Rating "distribution" averaged ratings by comment | Count responses by numeric rating |
| Equipment counts were repeated across bed rows | Count distinct equipment IDs (200) |
| The staff-to-patient ratio direction was ambiguous | Report patients per staff member and staff per 1,000 patients |

**Result:** 41 analysis queries and 60 KPI queries executed, 13 refinement queries written, and **14 of 14 targeted retests passed**.

**Verification scope.** The initial SQL tests ran in a SQLite compatibility environment with documented MySQL mappings. The refined queries were then run in MySQL Workbench against the project database, and the dashboard was checked live in Power BI Desktop in Week 8.

---

## Week 8: Final Insights & Recommendations

**Dashboard validation (live in Power BI Desktop)**

I compared on-screen dashboard values with figures recalculated from the source CSVs. All four checks matched.

| Check | What I tested | Expected | Result |
|---|---|---|---|
| D1. Executive baseline | Cards with all filters cleared | 20,000 patients; 5,000 recorded appointments; 20 facilities; 350 doctors; RWF 1,132,677,500 reported revenue; 2.99 / 5 satisfaction | Matched |
| D2. Finance baseline | Payment charts, hovering over HF011 and DEP016 | HF011: RWF 39,810,993; DEP016: RWF 5,290,208 | Matched |
| D3. Facility selection | Selected HF011 on the Executive page, then viewed the Financial page | 273 recorded appointments; RWF 39,810,993 in linked payments | Matched |
| D4. Reset | Cleared the HF011 selection | 5,000 appointments; unfiltered charts restored | Matched |


**Priority insights**

1. **Bookings describe workload; attendance is unmeasured.** Quarterly records ranged from 1,235 to 1,271, and 510 patients appear more than once.
2. **Overall collections reconcile; facility rankings cover a small share.** Only 8.28% of payment value links to an appointment.
3. **The overall feedback score has much wider coverage than the facility breakdown.** The linked responses average 2.93 / 5 against 2.99 overall.
4. **The choice of join can overstate or understate workload.** Report the source total and the attributable portion separately.

**Recommendations**

1. Record a final outcome (attended, missed, cancelled, rescheduled) for every appointment.
2. Reconcile payments to the authoritative appointment register and keep unmatched payments in an "Unattributed" group.
3. Add join checks that catch duplicated or dropped records.
4. Capture feedback dates and valid appointment references.
5. Once outcomes are reliable, pilot reminders or easier rescheduling against the current process, with any AI assistant limited to approved scheduling information and staff escalation.

---

## Limitations

- No attendance outcome exists, so **no no-show rate can be calculated**.
- 55,000 billing records and most feedback and laboratory records reference appointment IDs that are missing from the appointment extract.
- Billing, payment, claim and feedback records have no transaction dates, so timing and trend analysis is limited.
- Some facility and department assignments conflict (4,744 appointments and 1,187 staff records).
- Bed records are a status snapshot; every bed is marked "Available", so utilization cannot be calculated.
- Reported revenue, collections, claims and outstanding balance are different measures and are never combined.

---

## How to Use This Repository

1. Install MySQL 8.0 or later and create the database: `CREATE DATABASE healthcare_analytics;`
2. Import the CSV files from the data folder into tables named as in the SQL scripts.
3. Run `SQL_SCRIPT.sql` and `Key_Performance_Indicators.sql` (Week 6), then `HealthConnect_Week7_SQL_Refinements.sql` (Week 7).
4. Open the `.pbix` file in Power BI Desktop to explore the dashboard.

---

## Dashboard Preview

### Executive Dashboard
![Executive Dashboard](screenshots/Executive%20dashboard.png)

### Patient Analytics
![Patient Analytics](screenshots/patient%20analytics.png)

### Financial Dashboard
![Financial Dashboard](screenshots/Financial%20dashboard%20.png)

## SQL Analysis Preview

### KPI Analysis
![SQL KPI Analysis](screenshots/SQL%20kpi%20analysis.png)

### Query Results
![SQL Query Results](screenshots/SQL%20query%20results.png)


---

## Author

**Joyce Wambui**
Data Analytics Intern, AnalystLab Africa Experience Lab
[LinkedIn](https://www.linkedin.com/in/joycekibandi/) | [GitHub](https://github.com/joy2004-pretty)

