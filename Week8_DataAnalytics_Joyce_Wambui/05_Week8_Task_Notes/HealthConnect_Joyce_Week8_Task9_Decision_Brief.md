# HealthConnect Rwanda | Week 8 Task 9

**Joyce · Data Analytics · Decision brief**

**Decision for HealthConnect:** Approve a consistent way to record appointment outcomes before choosing who should receive reminders or expanding any AI scheduling support. The current data can guide what to investigate and what to fix in reporting.

| Decision | What HealthConnect can do now | What would support a bigger decision |
| --- | --- | --- |
| **Scheduling: Where should we intervene?** | Use the **5,000 recorded bookings** to review workload in the extract. The appointment file has no attendance outcome, so it cannot identify who missed an appointment or where no-shows are most common. | Record attended, missed, cancelled and rescheduled outcomes. Check coverage by facility and period before targeting reminders or comparing no-show rates. |
| **Finance: Which facilities should we investigate?** | Review overall collections of **RWF 8.39 billion** and the difference between billed and collected amounts. Prioritize fixing attribution: only **8.28%** of payment value links to an appointment in the extract. | Reconcile facility assignments before ranking collections. Use due dates and payment dates to assess overdue balances, and expense data to assess profitability. |
| **Patient experience: What needs attention?** | Use **2.99/5 across 21,064 responses** as a reason to review patient support. Only **8.34%** of responses link to an appointment, so the overall score does not identify a poorly performing facility. | Capture feedback dates and reliable appointment links, then review response counts and coverage by facility before comparing sites. |
| **Staffing: Can department charts guide resource changes?** | Make count reconciliation a condition for using the charts. A controlled Week 7 test inflated **5,000 appointments to 50,000 rows** when joined to bed records through Department ID. | Confirm that joins preserve source totals and resolve conflicting facility and department assignments before using the results to reallocate staff. |

**When to test patient support changes.** Once attendance outcomes are consistently recorded, compare a small reminder or easier rescheduling pilot with the existing process. If the clinic includes an AI assistant, give it approved scheduling information and route unresolved requests to staff. Use no-show rates, completed reschedules and patient feedback to decide whether to expand. The current data does not establish that any of these changes will reduce missed appointments.

**Evidence:** Week 8 project guide, Data Analytics task 9 (p. 6); Joyce’s Week 7 Testing and Refinement Report and Week 8 appointment, finance and feedback checks. RWF follows the Week 7 reporting assumption.
