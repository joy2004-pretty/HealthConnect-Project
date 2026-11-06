-- HealthConnect Rwanda Week 7 analytical refinements
-- Analyst: Joyce. Reviewed 2 November 2026.
-- MySQL 8.0+; run the SELECT blocks against the existing imported schema.
-- Original scripts are retained separately and are unchanged.
-- These statements use the table names and BOM-affected ID columns present in
-- the supplied SQL. Adapt identifiers consistently if your import normalized them.
USE healthcare_analytics;

-- R01 Department-name uniqueness control. Expected: no conflicting names.
SELECT `ï»¿DepartmentID` AS DepartmentID,
       COUNT(DISTINCT DepartmentName) AS Distinct_Names
FROM hc_hospital_facilities
GROUP BY `ï»¿DepartmentID`
HAVING COUNT(DISTINCT DepartmentName) > 1;

-- R02 Q26 laboratory volume. All source tests retained, including Unknown.
-- This measures test volume rather than time-based equipment utilization.
SELECT COALESCE(a.FacilityID, 'Unknown') AS Facility,
       COUNT(l.LabID) AS Total_Lab_Tests
FROM healthcare_analytics.`hc_ laboratory_tests` AS l
LEFT JOIN hc_appointments AS a ON l.AppointmentID = a.AppointmentID
GROUP BY a.FacilityID
ORDER BY Total_Lab_Tests DESC;

-- R03 Q30 appointment workload. One department-name row prevents bed fan-out.
-- Run R01 first. No conflicting names were found in the source department master.
SELECT a.DepartmentID AS DepartmentID,
       COALESCE(d.DepartmentName, 'Unknown') AS DepartmentName,
       COUNT(a.AppointmentID) AS Total_Appointments
FROM hc_appointments AS a
LEFT JOIN (
    SELECT `ï»¿DepartmentID` AS DepartmentID,
           MIN(DepartmentName) AS DepartmentName
    FROM hc_hospital_facilities
    GROUP BY `ï»¿DepartmentID`
) AS d ON a.DepartmentID = d.DepartmentID
GROUP BY a.DepartmentID, d.DepartmentName
ORDER BY Total_Appointments DESC;

-- R04 Companion clinical-event workload. Each source record remains an event.
-- Appointment workload in R03 and clinical-event workload have different grains.
SELECT COALESCE(a.DepartmentID, 'Unknown') AS DepartmentID,
       e.EventType,
       COUNT(*) AS Clinical_Events
FROM (
    SELECT AppointmentID, 'Diagnosis' AS EventType FROM hc_diagnoses
    UNION ALL
    SELECT AppointmentID, 'Laboratory test' FROM healthcare_analytics.`hc_ laboratory_tests`
    UNION ALL
    SELECT AppointmentID, 'Prescription' FROM healthcare_analytics.`hc_ prescriptions`
    UNION ALL
    SELECT AppointmentID, 'Admission' FROM hc_admissions
) AS e
LEFT JOIN hc_appointments AS a ON e.AppointmentID = a.AppointmentID
GROUP BY a.DepartmentID, e.EventType
ORDER BY DepartmentID, e.EventType;

-- R05 Q31 collected payments by recorded facility. Unknown remains in the total.
SELECT COALESCE(a.FacilityID, 'Unknown') AS Facility,
       SUM(p.AmountPaid) AS Collected_Payments
FROM hc_payments AS p
LEFT JOIN hc_billing AS b ON p.BillingID = b.`ï»¿BillingID`
LEFT JOIN hc_appointments AS a ON b.AppointmentID = a.AppointmentID
GROUP BY a.FacilityID
ORDER BY Collected_Payments DESC;

-- R06 Q32 collected payments by recorded department. Unknown retained.
SELECT COALESCE(a.DepartmentID, 'Unknown') AS DepartmentID,
       SUM(p.AmountPaid) AS Collected_Payments
FROM hc_payments AS p
LEFT JOIN hc_billing AS b ON p.BillingID = b.`ï»¿BillingID`
LEFT JOIN hc_appointments AS a ON b.AppointmentID = a.AppointmentID
GROUP BY a.DepartmentID
ORDER BY Collected_Payments DESC;

-- R07 Q37 collections by appointment cohort. This is not a payment-date trend.
-- No payment transaction date exists. Unknown cohort is shown explicitly.
SELECT
    COALESCE(DATE_FORMAT(a.Date, '%Y-%m'), 'Unknown') AS Appointment_Cohort,
    SUM(p.AmountPaid) AS Collected_Payments
FROM hc_payments AS p
LEFT JOIN hc_billing AS b
    ON p.BillingID = b.`ï»¿BillingID`
LEFT JOIN hc_appointments AS a
    ON b.AppointmentID = a.AppointmentID
GROUP BY
    COALESCE(DATE_FORMAT(a.Date, '%Y-%m'), 'Unknown')
ORDER BY
    Appointment_Cohort = 'Unknown',
    Appointment_Cohort;       

-- R08 Q39 top known facility by attributed collections.
-- Interpret with R05, which accounts for payments without facility attribution.
SELECT a.FacilityID AS Facility,
       SUM(p.AmountPaid) AS Attributed_Collections
FROM hc_payments AS p
JOIN hc_billing AS b ON p.BillingID = b.`ï»¿BillingID`
JOIN hc_appointments AS a ON b.AppointmentID = a.AppointmentID
GROUP BY a.FacilityID
ORDER BY Attributed_Collections DESC
LIMIT 1;

-- R09 Q40 known department ranking with an unranked Unknown row.
WITH Department_Collections AS (
    SELECT a.DepartmentID,
           SUM(p.AmountPaid) AS Collected_Payments
    FROM hc_payments AS p
    LEFT JOIN hc_billing AS b ON p.BillingID = b.`ï»¿BillingID`
    LEFT JOIN hc_appointments AS a ON b.AppointmentID = a.AppointmentID
    GROUP BY a.DepartmentID
)
SELECT COALESCE(DepartmentID, 'Unknown') AS DepartmentID,
       Collected_Payments,
       CASE WHEN DepartmentID IS NULL THEN NULL
            ELSE DENSE_RANK() OVER (
                ORDER BY CASE WHEN DepartmentID IS NULL THEN NULL
                              ELSE Collected_Payments END DESC
            )
       END AS Known_Department_Rank
FROM Department_Collections
ORDER BY CASE WHEN DepartmentID IS NULL THEN 1 ELSE 0 END,
         Collected_Payments DESC;

-- R10 KPI numeric rating distribution. The original query averages by Comment.
SELECT Rating,
       COUNT(*) AS Feedback_Count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hc_patient_feedback), 2)
           AS Feedback_Percent
FROM hc_patient_feedback
GROUP BY Rating
ORDER BY Rating;

-- R11 KPI equipment distribution at inventory grain within prepared details.
SELECT EquipmentName,
       COUNT(DISTINCT EquipmentID) AS Equipment_Count
FROM hc_hospital_facilities
WHERE EquipmentID IS NOT NULL
GROUP BY EquipmentName
ORDER BY Equipment_Count DESC;

-- R12 KPI workforce ratios with an explicit direction and denominator.
SELECT (SELECT COUNT(DISTINCT PatientID) FROM hc_patients) AS Registered_Patients,
       (SELECT COUNT(DISTINCT `ï»¿StaffID`) FROM hc_medical_staffs) AS Total_Staff,
       ROUND((SELECT COUNT(DISTINCT PatientID) FROM hc_patients) * 1.0 /
             NULLIF((SELECT COUNT(DISTINCT `ï»¿StaffID`) FROM hc_medical_staffs), 0), 2)
           AS Registered_Patients_Per_Staff_Member,
       ROUND((SELECT COUNT(DISTINCT `ï»¿StaffID`) FROM hc_medical_staffs) * 1000.0 /
             NULLIF((SELECT COUNT(DISTINCT PatientID) FROM hc_patients), 0), 2)
           AS Staff_Per_1000_Registered_Patients;

-- R13 Payments on claim-linked bills by provider.
-- This association does not establish an insurer's actual remittance.
SELECT ic.Provider,
       SUM(p.AmountPaid) AS Payments_On_Claim_Linked_Bills,
       SUM(CASE WHEN p.Method = 'Insurance' THEN p.AmountPaid ELSE 0 END)
           AS Insurance_Method_Payments_On_Claim_Linked_Bills
FROM (SELECT DISTINCT BillingID, Provider FROM hc_insurance_claims) AS ic
JOIN hc_payments AS p ON ic.BillingID = p.BillingID
GROUP BY ic.Provider
ORDER BY Payments_On_Claim_Linked_Bills DESC;
