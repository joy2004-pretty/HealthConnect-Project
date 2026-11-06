# HealthConnect Rwanda | Week 8 Task 3

**Joyce · Data Analytics · Final KPI definitions and dashboard field check**

The figures below were recalculated from the supplied CSVs using the same definitions as the KPI SQL. They are **unfiltered source checks** for the Executive Dashboard. The saved Power BI fields were inspected separately; the displayed values were not evaluated in Power BI Desktop.

| Executive card | Definition and expected value | Saved field and review |
| --- | --- | --- |
| Total Patients | Distinct IDs in the patient register: **20,000**. | `Dim_Patients[PatientID]` is the right source. Confirm a distinct count in Power BI. |
| Total Appointments | Count nonblank appointment IDs in the extract: **5,000**. All 5,000 are unique. | `Fact_Appointments[AppointmentID]` is the right source. Use the label **Recorded Appointments** and check that the card counts records. The separate Revenue Summary reports 60,809 appointments; that aggregate does not represent rows in this extract. |
| Total Facilities | Count distinct facility IDs: **20**. The department master and appointment extract contain the same 20 IDs. | `Dim_Hospital_Facilities[FacilityID]` is the saved field. Confirm it counts distinct IDs, since facilities repeat across department and bed rows. |
| Total Doctors | Count distinct staff IDs where Role is Doctor: **350**. Only one of the identical doctor CSVs was counted. | The executive card uses `Fact_Appointments[DoctorID]`, while the SQL uses the staff register. The same 350 IDs occur in both sources in this extract. Use the staff-based **Doctors** measure after verifying it, or label the current card **Doctors with a Recorded Appointment**. |
| Total Revenue | Sum `Revenue` in the 12-row revenue summary: **RWF 1,132,677,500**. | `Fact_Revenue_Summary[Revenue]` matches the SQL source. Rename the label **Reported Revenue** to distinguish it from collections. |
| Average Patient Satisfaction | Average the numeric rating across **21,064** feedback responses: **2.99 / 5**. | `Dim_Patient_Feedback[Rating]` is the right source. The saved aggregation expression is consistent with an average. Confirm the card shows **2.99** with filters cleared. |

The saved card query-reference names are not always consistent with their aggregation expressions. For example, the satisfaction card's reference starts with `Sum`, but its aggregation setting matches the report's other average visuals. Check the actual field aggregation in Power BI before treating those reference names as errors.

## Financial KPI reconciliation

The monthly line and executive card use **reported revenue**. The facility and department bars use `Fact_Payments[AmountPaid]` and group by appointment facility or department. Although the saved bars also carry the label **Total Revenue**, the values represent payments and should be labelled **Collected Payments**.

| Source check | Value | Calculation |
| --- | ---: | --- |
| Total billed | RWF 9,309,401,961 | Sum billing amounts |
| Collected payments | RWF 8,389,454,556 | Sum all payment amounts |
| Outstanding billing balance | RWF 919,947,405 | Total billed less total collected |
| Payments linked to a recorded appointment | RWF 694,551,320 | Payment joined to billing, then to an available appointment |
| Payments without an available appointment link | RWF 7,694,903,236 | All collections less appointment-linked collections |

The last two rows add to the full collection total. Check whether the named bars and any **Unknown** group reconcile to that total in the live report. The stored fields alone cannot show how model relationships, filters or blank categories affect the visuals.

**Evidence:** Week 8 project guide, Data Analytics tasks 2–4 (p. 6); Joyce's Week 7 Testing and Refinement Report (pp. 1–3); her KPI SQL; the supplied source CSVs; and the saved visual definitions in her PBIX. RWF follows the Week 7 reporting assumption.

**Next check:** Compare these figures with the unfiltered dashboard, then test the affected cards and financial bars with a facility selected.
