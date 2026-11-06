# HealthConnect Rwanda | Week 8 Task 2

**Joyce · Data Analytics · Final Integration Readiness**

1. **What is my final component?** My Data Analytics contribution is a Power BI report, backed by MySQL analysis, KPI queries, and a record of the Week 7 tests and refinements. The supplied report has 13 pages, including six core analytics pages.

2. **What problem does it address?** It helps the clinic review recorded appointment workload, payments, and feedback without mistaking missing records for missed visits. It also shows when the available links are too incomplete to compare facilities fairly.

3. **What is its current status?** The source results and SQL refinements are ready for review. The dashboard structure has been inspected, and the Week 7 report records reviewer acceptance of the visuals. The refined queries still need to be checked in the project MySQL database, and the affected dashboard figures need to be checked in Power BI. No cross-track integration is recorded.

4. **What did I improve during Week 7?** I used a lookup with one row per department to prevent bed records from multiplying appointment counts. I also kept all 5,000 lab tests, including 2,728 with no matching appointment, and kept unattributed payments in an **Unknown** group so they still count in the overall total.

5. **Which other tracks does my work depend on?** The source analysis can be reviewed on its own. For team integration, Project Management would help confirm the approved appointment extract and data dictionary, and Data Science would help agree on how to define a no-show once attendance outcomes are available.

6. **Which tracks depend on my output?** Data Science could use the coverage checks to decide whether the data can support a no-show model. Project Management could use the same checks to prioritise recovery of missing appointment records and resolve conflicting facility and department assignments. These are proposed uses.

7. **What output will I provide?** I would share the KPI definitions, the tested join rules, and a short coverage note: 5,000 of 60,000 billing records link to an available appointment. I would also share the payment reconciliation so the team can distinguish the overall collection total from the portion attributable to facilities.

8. **What output do I need from another track?** From Project Management, I would need confirmation of the authoritative appointment export, the data dictionary, and who can resolve the missing or conflicting records. From Data Science, I would need agreement on which outcomes count as a no-show and which appointments belong in the denominator. Neither input is recorded as received.

9. **What evidence demonstrates readiness?** Fourteen targeted Week 7 retests passed in a Python/SQLite compatibility run. The controlled department join returned the expected 5,000 appointments after the lookup was corrected. The payment checks reconciled RWF 694,551,320 linked to appointments plus RWF 7,694,903,236 unattributed to the full RWF 8,389,454,556 collected. These are source and compatibility checks; the report inspection was separate.

10. **What limitations remain?** The appointment extract has no attendance outcome, so it cannot support a no-show rate. Missing appointment records limit facility and department attribution. Transaction and feedback dates are unavailable, and the bed file is a snapshot. Reported revenue, payments received, claims, and outstanding balances must retain separate definitions.

**Evidence:** Week 8 project guide, section 7 (pp. 4–5); Joyce's Week 7 Testing and Refinement Report (pp. 1–5); Joyce's Week 7 Project Summary; and the supplied Power BI report structure. Financial amounts follow the Week 7 RWF assumption.
