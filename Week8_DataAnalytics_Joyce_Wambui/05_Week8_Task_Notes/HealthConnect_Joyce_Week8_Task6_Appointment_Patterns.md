# HealthConnect Rwanda | Week 8 Task 6

**Joyce · Data Analytics · Recorded appointment patterns and attendance limits**

The extract contains **5,000 unique appointment IDs** and **4,443 distinct patients**. The dates recorded in the file run from **1 January to 28 December 2026**. The figures describe records in this extract; they do not measure how many patients turned up.

## Recorded activity by quarter and visit type

| Quarter | Consultation | Follow-up | Emergency | Total records |
| --- | ---: | ---: | ---: | ---: |
| Q1 | 411 | 447 | 413 | 1,271 |
| Q2 | 408 | 426 | 408 | 1,242 |
| Q3 | 427 | 418 | 407 | 1,252 |
| Q4 | 410 | 403 | 422 | 1,235 |
| **Total** | **1,656** | **1,694** | **1,650** | **5,000** |

Quarterly totals ranged from **1,235 to 1,271**, a difference of 36 records. Consultations, follow-ups and emergency appointments each account for roughly one third of the extract. This describes the mix and volume of the records; it does not establish a seasonal pattern in clinic demand.

Of the 4,443 patients represented, **3,933** appear once and **510** appear more than once (**11.5%**). The 510 patients account for **1,067** appointment records. This shows how often a patient ID appears, not whether a patient returned in person. The **Follow-up** visit type is also separate from counting multiple records for the same patient.

## Why the no-show rate is unavailable

The appointment extract has an ID, date, visit type, patient, doctor, facility and department. It has no attendance outcome that distinguishes an attended appointment from a no-show, cancellation or reschedule. The 55,000 billing records whose AppointmentID is absent from the extract show incomplete linkage. They do not tell us whether anyone missed an appointment. The 60,809 total in the Revenue Summary is a separate aggregate and cannot supply those missing outcomes.

For a future pilot, record a final outcome for every booking and agree on the eligible population. One candidate definition is **missed ÷ (attended + missed)** for eligible appointments with known outcomes, with cancellations and reschedules tracked separately. Report the share of eligible records with unknown outcomes alongside the rate.

## What to say in the presentation

> The extract contains 5,000 appointment records spread fairly evenly across the four quarters. It also shows 510 patients with more than one record. That gives us a view of recorded activity, but the file doesn't tell us who attended. We need to capture appointment outcomes before we can measure missed appointments or test whether reminders help.

**Sources and method:** Week 8 guide, Data Analytics task 6 (p. 6); supplied appointment extract, billing file and Revenue Summary. Quarter comes from the recorded Date field. The counts use one row per unique AppointmentID; repeat bookings use distinct PatientID and count each patient's appointment records.
