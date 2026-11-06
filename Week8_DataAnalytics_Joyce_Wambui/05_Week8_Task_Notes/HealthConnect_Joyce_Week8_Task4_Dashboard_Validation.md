# HealthConnect Rwanda | Week 8 Task 4

**Joyce · Data Analytics · Dashboard validation**

**Status:** Source values and saved report settings checked. On-screen values, slicer behaviour, and filter reset are **pending a Power BI Desktop check**. The PBIX was not changed.

## What the saved report shows

- The Executive Dashboard has a visible Facility slicer. The Financial Dashboard has a hidden slicer in the same sync group. Select the facility on the Executive page, then open the Financial page to test whether the selection carries over.
- The facility and department payment charts each exclude blank values in their respective appointment grouping field (FacilityID or DepartmentID). At source, named groups account for **RWF 694,551,320** of payments. A further **RWF 7,694,903,236** lacks an appointment link. If the charts match the named groups, they cover **8.28%** of full collections of **RWF 8,389,454,556**.
- The reported-revenue line uses a separate monthly table. That source has no facility or department field, so the line should not be described as facility revenue.

Suggested labels for the financial charts: **Appointment-linked payments by facility**, **Appointment-linked payments by department**, and **Reported revenue by month**. Add a note explaining that the payment charts exclude amounts without an appointment link.

## Desktop check record

Clear facility, department, province, and any other selections before establishing the baseline. Record the actual on-screen values against the source checks below.

| Check | What to do | Expected source result | Desktop result |
| --- | --- | --- | --- |
| D1. Executive baseline | Open the Executive Dashboard with selections cleared. | 20,000 registered patients; 5,000 recorded appointments; 20 facilities; 350 doctors represented in appointments; RWF 1,132,677,500 reported revenue; satisfaction 2.99/5. | Pending |
| D2. Finance baseline | With slicers cleared, hover over **HF011** on the facility payment chart and **DEP016** on the department payment chart. Use the department ID: the master contains 20 departments named Radiology. | **HF011: RWF 39,810,993**. **DEP016: RWF 5,290,208**. Each chart's named groups should reconcile to RWF 694,551,320 if it includes all appointment-linked groups and no other filters apply. | Pending |
| D3. Facility selection | Select **HF011** on Executive. Check Recorded Appointments, then go to Financial and inspect the facility payment bars. | **273 recorded appointments** and **RWF 39,810,993 in linked collections** if the filter reaches the appointment and payment tables. | Pending |
| D4. Reset | Return to Executive, clear HF011, then revisit Financial. | Recorded Appointments returns to **5,000** and the facility chart returns to its unfiltered view. | Pending |

If the appointment count changes but the finance chart does not, record that result and check whether the facility filter reaches Payments through Appointments and Billing. If values are shown in rounded units, use a tooltip or the chart's data view for the comparison. Save a screenshot of the selected and cleared states as evidence.

**Source method:** Appointments were counted by recorded FacilityID. Payments were matched to billing by BillingID and then to appointments by AppointmentID; collections were grouped by the recorded facility or department. This reproduces the intended groups from the source CSVs. It does not establish how the live Power BI relationships behave.

**Evidence:** Week 8 project guide, Data Analytics tasks 3–4 (p. 6); the Task 3 KPI check; Joyce's saved PBIX visual definitions; and the appointment, billing, payment, department, and revenue summary CSVs.
