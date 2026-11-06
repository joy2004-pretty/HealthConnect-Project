# HealthConnect Rwanda | Week 8 Task 10

**Joyce · Data Analytics · Findings for Data Science and Project Management**

The appointment extract contains **5,000 distinct bookings**. It supports a review of recorded workload, but it has no field that tells us whether patients attended. That gap affects both the model evaluation and what the project can claim in its final presentation.

| Intended recipient | Finding to share | How the track can use it |
| --- | --- | --- |
| **Data Science** | The appointment extract has no attendance outcome. Only **5,000 of 60,000 billing rows** match an appointment in that extract. An unmatched bill gives no evidence that the patient missed a visit. | Check whether an authoritative attendance source can be linked by Appointment ID. Agree on the definition of a no-show and which bookings are eligible before calculating a baseline or evaluating a model. Keep cancelled, rescheduled and unknown outcomes visible separately. |
| **Project Management** | Overall collections total **RWF 8,389,454,556**, but only **8.28%** of the payment value links to an appointment. Patient satisfaction is **2.99/5 across 21,064 responses**; only **8.34%** of responses link to an appointment. | Use the overall figures in the presentation and disclose limited coverage for facility comparisons. Assign someone to confirm the authoritative appointment register and resolve conflicting facility and department assignments. |
| **Both tracks** | In a controlled Week 7 test, joining appointments to bed records by Department ID produced **50,000 rows from 5,000 appointments**. A lookup with one row per department restored the expected row count in the test. | Check row counts and key uniqueness before using department summaries or joined data. Review any unmatched records separately so the model or presentation does not silently exclude them. |

**What to confirm before integration:** Data Science would need to confirm the outcome source, definition and coverage. Project Management would need to confirm who owns the export and which figures can be presented at facility level. Keep these as open dependencies until the receiving track confirms how it used the findings.

**Status:** Prepared for review. No exchange or joint validation has been recorded.

**Evidence:** Week 8 guide, Data Analytics Task 10 and sections 9–10; Joyce’s Week 7 Testing and Refinement Report and Week 8 KPI, appointment and decision checks. RWF follows the Week 7 reporting assumption.
