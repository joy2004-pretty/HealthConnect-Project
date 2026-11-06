# HealthConnect Rwanda | Week 8 Task 1

**Joyce · Data Analytics · Week 7 to Week 8 transition**

1. **What was my main Week 7 output?** A testing and refinement record for the MySQL analysis, KPI queries, and Power BI report. Week 7 checked 41 analysis SELECTs and 60 KPI SELECTs in a compatibility run, documented 13 refinement queries, and recorded 14 passing targeted retests.
2. **What was the most important test result?** In the controlled department join test, replacing the bed-level lookup with one row per department brought the appointment count from 50,000 back to the source count of 5,000.
3. **What major issue did testing uncover?** A department can appear once for each bed. Joining appointments directly to those repeated department rows counted the same appointments more than once in the test. The 50,000 figure came from the controlled test, not the live dashboard.
4. **What did I refine?** The revised queries used a unique department lookup, kept all 5,000 lab tests, and preserved payments without a matching appointment under **Unknown**. The analysis also distinguished reported revenue from cash collected.
5. **Which component is ready?** The source checks and documented SQL refinements are ready to carry into Week 8. The supplied Power BI file contains 13 pages. The compatibility retests and dashboard inspection do not establish that the refinements have run in the live MySQL or Power BI environment.
6. **What still needs integration?** Apply the refined queries to the actual MySQL schema and verify the affected figures in Power BI. A complete appointment export and a reliable attendance outcome are still needed for stronger facility attribution and no-show analysis.
7. **Which tracks would be involved?** Data Science could use the assessment of the missing attendance outcome. Project Management could coordinate access to the complete appointment export and document the outstanding dependencies. No exchange or joint validation is recorded.
8. **What will I demonstrate?** I plan to show why the department lookup changes the appointment count, then explain why the executive **reported revenue** card (RWF 1,132,677,500) and **collected payments** (RWF 8,389,454,556) answer different questions.

**Evidence:** Week 8 project guide, section 3 (p. 3); Joyce's Week 7 Testing and Refinement Report (pp. 1–3 and 5); Joyce's Week 7 Project Summary; and inspection of the supplied Power BI report structure. Financial amounts follow the Week 7 assumption that values are in RWF.
