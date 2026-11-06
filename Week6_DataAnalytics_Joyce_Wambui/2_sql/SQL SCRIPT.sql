CREATE database HEALTHCARE_ANALYTICS;

-- SPECIFIES THE DATABASE IN USE
USE HEALTHCARE_ANALYTICS;

-- shows the existing tables in the healthcare analytics database
SHOW tables;

-- sql queries for week 6 project
-- PATIENT ANALYSIS
-- 1. TOTAL REGISTERED PATIENTS
select *  from  hc_patients;
select count(*) from hc_patients;

-- 2.PATIENTS BY GENDER
select Gender,count(*) as total_patients  
from  hc_patients
group by Gender ;

-- 3.PATIENTS BY province
select g.ProvinceName,count(*) as total_patients
from hc_patients p
inner join geographical_location g
 on p.VillageID= g.VillageID
 group by g.ProvinceName;
 
 -- 4.PATIENTS ABOVE 65 YEARS
 select * 
 from  hc_patients
 where Age> 65;
 
 -- 5.PATIENTS WITH CHRONIC DISEASES
 select * 
 from  hc_patients
 where ChronicCondition <> "None";
 
 -- 6.PATIENTS COVERED BY INSURANCE
 select *
 from hc_patients
 where InsuranceID is not null;
 
 -- 7.PATIENTS BY BLOOD GROUP
 alter table hc_patients
 rename column ï»¿PatientID to PatientID;
 select BloodGroup,count(*) as total_patients
 from hc_patients
 group by BloodGroup
 ORDER BY total_patients asc;
 
 -- 8. young vs old patients
 SELECT
    PatientID,
    FirstName,
    LastName,
    Age,
    CASE
        WHEN Age = (SELECT MIN(Age) FROM hc_patients)
            THEN 'Youngest'
        WHEN Age = (SELECT MAX(Age) FROM hc_patients)
            THEN 'Oldest'
    END AS age_rank
FROM hc_patients
WHERE Age = (SELECT MIN(Age) FROM hc_patients)
   OR Age = (SELECT MAX(Age) FROM hc_patients)
ORDER BY Age;

-- 9.duplicate phone numbers
select Phone, count(Phone) as count
from hc_patients
group by Phone
having count >1;

-- 10.Average patient age
select round(avg(Age),0) as average_age
from hc_patients;

-- APPOINTMENT ANALYSIS
-- 11.appointment by month
SELECT
    MONTHNAME(Date) AS Month,
    COUNT(AppointmentID) AS Total_Appointments
FROM hc_appointments
GROUP BY MONTH(Date), Month
ORDER BY MONTH(Date);

-- 12.Busiest Hospitals
select FacilityID ,count(*) as patients_treated
from hc_appointments
group by FacilityID
order by patients_treated desc
limit 10;

-- 13.Busiest department
select DepartmentID ,count(*) as patients_treated
from hc_appointments
group by DepartmentID
order by patients_treated desc
limit 10;

-- 14. doctors with the highest workload
select DoctorID ,count(*) as patients_treated
from hc_appointments
group by DoctorID
order by patients_treated desc
limit 10;

-- 15.Identify referrrals patterns
SELECT
     a.FacilityID AS origin_facility,
    r.ReferredFacilityID AS destination_facility,
    COUNT(*) AS referral_count
FROM hc_referrals r
LEFT JOIN hc_appointments a
    ON r.AppointmentID = a.AppointmentID
GROUP BY a.FacilityID, r.ReferredFacilityID
ORDER BY referral_count DESC;
 
-- 16.appointments by emergency
select VisitType , count(*) as total_appointments
from hc_appointments
where VisitType="Emergency";

-- 17. average appointments per doctor
SELECT ROUND( count(AppointmentID) / count(distinct Doctorid) ) AS avgapp_doctor
FROM hc_appointments;

-- 18.appointments by province
select g.ProvinceName, count(a.AppointmentID) as total_patients
from hc_patients p
left join geographical_location g
on p.VillageID=g.VillageID
left join hc_appointments a
on p.PatientID=a.PatientID
group by g.ProvinceName
order by total_patients desc ;

-- 19. facility with the highest patient volume
select FacilityID, count( distinct PatientID) as patient_volume
from hc_appointments
group by FacilityID
order by patient_volume desc
;

-- 20. peak consultation periods
select monthname(Date) as month ,count(AppointmentID) as total_appointments
from hc_appointments
group by month, VisitType
having VisitType="Consultation"
order by total_appointments desc
limit 6;

-- CLINICAL ANALYSIS
-- 21. Top Diagnoses
alter table hc_diagnoses
rename column ï»¿DiagnosisID to DiagnosisID;

select Diagnosis, count( DiagnosisID) as count
from hc_diagnoses
group by Diagnosis
order by count desc
limit 1;

-- 22.Most requested Lab tests
select Test ,count(AppointmentID) as test_count
from healthcare_analytics.`hc_ laboratory_tests`
group by Test
order by test_count desc;

-- 23.most prescribed medications
select Medication, count(AppointmentID) as prescription_count
from healthcare_analytics.`hc_ prescriptions`
group by Medication
order by prescription_count desc;

-- 24.Average admission duration
select avg(LengthOfStayDays) as  average_duration_rate
from hc_admissions;

-- 25.disease severity distribution
select Severity ,count(DiagnosisID) as diagnosed_count
from hc_diagnoses
group by Severity
order by diagnosed_count;

-- 26.Laboratory test utilization
select a.FacilityID  as Facility, count(l.LabID) as total_lab_tests
from hc_appointments a
left join healthcare_analytics.`hc_ laboratory_tests`l
on a.AppointmentID=l.AppointmentID
group by Facility
order by total_lab_tests desc;

-- 27. Prescription trends
select Medication , count(PrescriptionID) as prescription_count
from healthcare_analytics.`hc_ prescriptions`
group by Medication
order by prescription_count desc;

-- 28.Referral destinations
select count( distinct ReferredFacilityID)
from hc_referrals;

select ReferredFacilityID
from hc_referrals;

-- 29.Admission rate by diagnosis

SELECT
    d.Diagnosis,
    COUNT(DISTINCT d.AppointmentID) AS Total_Cases,
    COUNT(DISTINCT ad.AppointmentID) AS Admitted_Cases,
    ROUND(
        COUNT(DISTINCT ad.AppointmentID) * 100.0 /
        NULLIF(COUNT(DISTINCT d.AppointmentID), 0),
        2
    ) AS Admission_Rate
FROM hc_diagnoses  d
LEFT JOIN hc_admissions  ad
    ON d.AppointmentID = ad.AppointmentID
GROUP BY d.Diagnosis
ORDER BY Admission_Rate DESC;

-- 30.Clinical workload by department
SELECT
   distinct a.DepartmentID as dept_ID,h.DepartmentName as dept_name,
    COUNT(a.AppointmentID) AS Total_Appointments
FROM hc_appointments a
left join hc_hospital_facilities h
on a.DepartmentID=h.ï»¿DepartmentID
GROUP BY dept_ID, dept_name
ORDER BY Total_Appointments DESC;

-- 31.Revenue by facility
select a.FacilityID as Facility, sum(p.AmountPaid) as revenue
from hc_appointments a
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by Facility 
order by revenue desc;

-- 32. Revenue by department.
select a.DepartmentID as department, sum(p.AmountPaid) as revenue
from hc_appointments a
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by department 
order by revenue desc;

-- 33.Revenue by service.
/*  Limitation: Revenue by Healthcare Service

The healthcare services dataset contains ServiceID, ServiceName, and DepartmentID, while the appointments dataset contains DepartmentID and AppointmentID. Billing and payment records can be linked to appointments through AppointmentID and BillingID, respectively.

However, the available datasets do not contain a direct relationship between individual services and specific appointments or billing records. Joining the services dataset to appointments using DepartmentID would associate all services within a department with the same department-level payment records, potentially duplicating revenue across services.

Impact: Accurate revenue attribution to individual healthcare services could not be established.

Action taken: Revenue analysis was restricted to the department level using recorded payment amounts. Service-level revenue was excluded to avoid misleading results.

Recommendation: Capture ServiceID against each appointment or billing record, or maintain a service-usage table linking ServiceID to AppointmentID or BillingID. This would enable accurate service-level revenue analysis in future reporting.
*/

-- 34.Insurance claims by provider
select Provider, count(ï»¿ClaimID) as claim_count
from hc_insurance_claims
group by Provider
order by claim_count desc;

-- 35.outstanding payments
SELECT
    b.ï»¿BillingID,
    b.Amount AS Total_Billed,
    b.Amount -
        COALESCE(SUM(p.AmountPaid), 0) AS Outstanding_Amount
FROM hc_billing AS b
LEFT JOIN hc_payments AS p
    ON b.ï»¿BillingID = p.BillingID
GROUP BY
    b.ï»¿BillingID,
    b.Amount
ORDER BY Outstanding_Amount DESC;

-- 36. Average billing amount
select sum(Amount)/count(ï»¿BillingID) as avg_billing_amount
from hc_billing;

-- 37.Monthly revenue trend
SELECT
    MONTH(a.Date) AS Revenue_Month,
    MONTHNAME(a.Date) AS Month_Name,
    SUM(p.AmountPaid) AS Total_Payments
FROM hc_appointments AS a
INNER JOIN hc_billing AS b
    ON a.AppointmentID = b.AppointmentID
INNER JOIN hc_payments AS p
    ON b.ï»¿BillingID = p.BillingID
GROUP BY
    MONTH(a.Date),
    MONTHNAME(a.Date)
ORDER By Revenue_Month;

-- 38.Payment methods
select distinct Method
from hc_payments;

-- 39. Top revenue-generating hospitals.
select a.FacilityID as Facility, sum(p.AmountPaid) as revenue
from hc_appointments a
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by Facility 
order by revenue desc
limit 1;

-- 40. Financial performance ranking.
SELECT
    a.DepartmentID AS Department,
    COALESCE(SUM(p.AmountPaid), 0) AS Total_Revenue,
    RANK() OVER (
        ORDER BY COALESCE(SUM(p.AmountPaid), 0) DESC
    ) AS Financial_Rank
FROM hc_appointments AS a
LEFT JOIN hc_billing AS b
    ON a.AppointmentID = b.AppointmentID
LEFT JOIN hc_payments AS p
    ON b.ï»¿BillingID = p.BillingID
GROUP BY a.DepartmentID
ORDER BY Financial_Rank;

SELECT
    d.Diagnosis,
    COUNT(*) AS Diagnosis_Count
FROM hc_diagnoses d
INNER JOIN hc_appointments a
    ON d.AppointmentID = a.AppointmentID
GROUP BY d.Diagnosis
ORDER BY Diagnosis_Count DESC;














 
 



