use healthcare_analytics;

-- PATIENT KPIS
-- Total Registered patients
select count(distinct PatientID) as total_registered_patients
from hc_patients;

-- Active patients
select count(distinct PatientID) as active_patients
from hc_appointments;

-- new patients
/* This kpi cannot be cannot since the registration date in the patients dataset has not been provided*/

-- returning patients
SELECT COUNT(*) AS returning_patients
FROM (
    SELECT PatientID
    FROM hc_appointments
    GROUP BY PatientID
    HAVING COUNT(AppointmentID) > 1
) AS returning;

-- Male vs Female Patients
Select Gender,count(PatientID) as no_of_patients
from hc_patients
group by Gender;

-- Age Group Distribution
SELECT
    CASE
        WHEN Age BETWEEN 0 AND 17 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 29 THEN '18-29'
        WHEN Age BETWEEN 30 AND 44 THEN '30-44'
        WHEN Age BETWEEN 45 AND 59 THEN '45-59'
        WHEN Age >= 60 THEN '60+'
    END AS Age_Group,
    COUNT(DISTINCT PatientID) AS Total_Patients
FROM hc_patients
WHERE Age IS NOT NULL
GROUP BY Age_Group
ORDER BY MIN(Age);

-- Blood Group Distribution
select BloodGroup,count(distinct PatientID) as count_distribution
from hc_patients
group by BloodGroup 
order by count_distribution desc;

-- Insurance coverage rate
SELECT
   round( COUNT(DISTINCT CASE
        WHEN InsuranceID IS NOT NULL THEN PatientID
    END) * 100.0
    / COUNT(DISTINCT PatientID) ,0) AS insurance_coverage_rate

FROM hc_patients;

-- Patients by Province
select g.ProvinceName,count(distinct p.PatientID) as Patients
from hc_patients p
left join geographical_location g
on p.VillageID=g.VillageID
group by g.ProvinceName
order by Patients;

-- Patients by District
select g.DistrictName,count(distinct p.PatientID) as Patients
from hc_patients p
left join geographical_location g
on p.VillageID=g.VillageID
group by g.DistrictName
order by Patients desc;

-- Patients by Chronic Disease
select ChronicCondition, count(distinct PatientID) as patients
from hc_patients
where ChronicCondition <>"None"
group by ChronicCondition;

-- Average Patient Age
select avg(Age)
from hc_patients;

-- Appointment KPIs
-- • Total Appointments
select count(AppointmentID) as total_appointments
from hc_appointments;
-- • Daily Appointments
SELECT
    DATE(Date) AS appointment_date,
    COUNT(AppointmentID) AS total_appointments
FROM hc_appointments
GROUP BY DATE(Date)
ORDER BY appointment_date;

-- • Monthly Appointments
SELECT
    month(Date) AS appointment_month,
 monthname(Date) AS month_name,
    COUNT(AppointmentID) AS total_appointments
FROM hc_appointments
GROUP BY appointment_month, month_name
ORDER BY appointment_month;

-- • Appointment Growth Rate
SELECT
    appointment_month,
    total_appointments,
    LAG(total_appointments) OVER (
        ORDER BY appointment_month
    ) AS previous_month_appointments,

    ROUND(
        (total_appointments - LAG(total_appointments) OVER (
            ORDER BY appointment_month
        )) * 100.0
        / NULLIF(LAG(total_appointments) OVER (
            ORDER BY appointment_month
        ), 0),
        2
    ) AS appointment_growth_rate
FROM (
    SELECT
        DATE_FORMAT(Date, '%Y-%m') AS appointment_month,
        COUNT(AppointmentID) AS total_appointments
    FROM hc_appointments
    GROUP BY DATE_FORMAT(Date, '%Y-%m')
) AS monthly_data
ORDER BY appointment_month;
-- • Emergency Appointments
select VisitType, count(AppointmentID) as total_appointments
from hc_appointments
where VisitType="Emergency";
-- • Follow-up Appointments
select VisitType, count(AppointmentID) as total_appointments
from hc_appointments
where VisitType="Follow-up";
-- • Consultation Appointments
select VisitType, count(AppointmentID) as total_appointments
from hc_appointments
where VisitType="Consultation";
-- • Referral Rate
SELECT
    ROUND(
        COUNT(DISTINCT r.AppointmentID) * 100.0
        / COUNT(DISTINCT a.AppointmentID),
        2
    ) AS referral_rate
FROM hc_appointments a
LEFT JOIN hc_referrals r
    ON a.AppointmentID = r.AppointmentID; 
-- • Appointment Cancellation Rate (if applicable)
/* not computable*/
-- • Average Appointments per Doctor
select round(count(AppointmentID)/count(distinct DoctorID),0) as average_appointments_per_doctor
from hc_appointments;


-- Clinical KPIs
-- • Top 20 Diagnoses
select Diagnosis, count(DiagnosisID) as diagnosis_count
from hc_diagnoses
group by Diagnosis
order by  diagnosis_count desc
limit 20;

-- • Disease Severity Distribution
select Severity, count(DiagnosisID) as total_cases
from hc_diagnoses
group by Severity
order by total_cases desc;

-- • Laboratory Test Volume
select count(LabID) as tota_lab_tests
from healthcare_analytics.`hc_ laboratory_tests`;

-- • Prescription Volume
select count(*) as presc_volume
from healthcare_analytics.`hc_ prescriptions`;

-- • Admission Rate
select 
round(count(distinct ad.AppointmentID )*100 / count(distinct a.AppointmentID)
      ,2) as admission_rate
from hc_appointments a
left join hc_admissions ad
on a.AppointmentID=ad.AppointmentID;

-- • Average Length of Stay
select round(avg(LengthOfStayDays),2) as avg_length_of_stay
from hc_admissions;

-- • Referral Distribution
select ReferredFacilityID,count(ReferralID) as total_referrals
from hc_referrals
group by ReferredFacilityID
order by  total_referrals desc;

-- • Readmission Indicator
SELECT
    a.PatientID,
    COUNT(DISTINCT ad.AppointmentID) AS admission_count,
    CASE
        WHEN COUNT(DISTINCT ad.AppointmentID) > 1
        THEN 'Readmitted'
        ELSE 'Not Readmitted'
    END AS readmission_indicator
FROM hc_admissions ad
JOIN hc_appointments a
    ON ad.AppointmentID = a.AppointmentID
GROUP BY a.PatientID;

-- • Most Common Medications
select Medication , count(PrescriptionID) as presc_count
from healthcare_analytics.`hc_ prescriptions`
group by Medication
order by presc_count desc
limit 1;

-- Healthcare Staff KPIs
-- • Number of Doctors
select count(distinct ï»¿StaffID) as number_of_doctors
from hc_medical_staffs
where Role="Doctor";

-- • Number of Nurses
select count(distinct ï»¿StaffID) as number_of_nurses
from hc_medical_staffs
where Role="Nurse";

--  Number of Pharmacists
select count(distinct ï»¿StaffID) as number_of_pharmacists
from hc_medical_staffs
where Role="Pharmacist";

-- Number of Laboratory Scientists
select count(distinct ï»¿StaffID) as number_of_lab_scientists
from hc_medical_staffs
where Role="Laboratory Scientist";

--  Number of Radiographers
select count(distinct ï»¿StaffID) as number_of_radiographers
from hc_medical_staffs
where Role="Radiographer";

-- • Staff Distribution by Facility
select FacilityID,count(distinct ï»¿StaffID) as total_staffs
from hc_medical_staffs
group by FacilityID;

-- Staff Distribution by Department
select Department,count(distinct ï»¿StaffID) as total_staffs
from hc_medical_staffs
group by Department;

-- Average Years of Experience
select round(avg(YearsExperience),0)as avg_yrs_of_experience
from hc_medical_staffs;

-- Staff-to-Patient Ratio

SELECT
    (SELECT COUNT(DISTINCT PatientID)
     FROM hc_patients) AS total_patients,

    (SELECT COUNT(DISTINCT ï»¿StaffID)
     FROM hc_medical_staffs) AS total_staff,

    ROUND(
        (SELECT COUNT(DISTINCT PatientID)
         FROM hc_patients) /
        (SELECT COUNT(DISTINCT ï»¿StaffID)
         FROM hc_medical_staffs),
        2
    ) AS staff_patient_ratio;

-- Operational KPIs
-- Number of Health Facilities
select count(distinct FacilityID) as tota_facilities
from hc_hospital_facilities;

-- Facility Type Distribution
/*not calculable*/

-- Bed Capacity
select count(distinct BedID) as bed_capacity
from hc_hospital_facilities;

-- Available Beds
select count(distinct BedID) as bed_capacity
from hc_hospital_facilities
where Status="Available" ;
-- Bed Utilization Rate
/* inclaculable because the bed status information provided is only available, so the 
information of whether its occupied/vacant is not provided*/

-- Room Utilization
/* incalculable since the only information given about rooms is roomid and how they are distributed across the facilities,
since no information of whether the room is vacant/occupied ,the measure becomes ambigous to compute*/

-- Equipment Distribution
select EquipmentName, count(EquipmentID) as total_equipments
from hc_hospital_facilities
group by EquipmentName;

-- Equipment Availability
/* incalculable since the information about availablity is not provided besides the distribution*/

-- Department Capacity
select DepartmentName, count(distinct RoomID) as total_rooms,
count(distinct BedID) as total_Beds, count(distinct EquipmentID) as total_equipments
from hc_hospital_facilities
group by DepartmentName;

-- Facility Performance Ranking
select a.DepartmentID as dept_id,
coalesce(sum(p.AmountPaid),0) as Total_revenue,
rank()  over(
order by coalesce(sum(p.AmountPaid),0) desc) as financial_rank
from hc_appointments a
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by dept_id;

-- Financial KPIs
-- Total Revenue
select sum(Revenue) as Total_revenue
from hc_revenue_summary;

-- Monthly Revenue
SELECT
    `ï»¿Month` AS Month,
    SUM(Revenue) AS Total_Revenue
FROM hc_revenue_summary
GROUP BY `ï»¿Month`;

-- Revenue by Hospital
select a.FacilityID as Facility,
coalesce(sum(p.AmountPaid),0) as Total_revenue
from hc_appointments a
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by Facility
order by Total_revenue desc;

-- Revenue by Department
select a.DepartmentID as Department,
coalesce(sum(p.AmountPaid),0) as Total_revenue
from hc_appointments a
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by Department
order by Total_revenue desc;

-- Revenue by Service
/*Revenue by Service: Not reliably calculable because the appointment records do not identify which service was performed*/

--  Revenue by Province
select g.ProvinceName as Province,
coalesce(sum(p.AmountPaid),0) as Total_revenue
from geographical_location g
left join  hc_patients pa
on g.VillageID=pa.VillageID
left join hc_appointments a
on pa.PatientID=a.PatientID
left join hc_billing b
on a.AppointmentID=b.AppointmentID
left join hc_payments p
on b.ï»¿BillingID=p.BillingID
group by Province
order by Total_revenue desc;

-- Revenue by Insurance Provider
SELECT
    ic.Provider,
    ROUND(SUM(p.AmountPaid), 2) AS Revenue_Received
FROM hc_insurance_claims ic
INNER JOIN hc_payments p
    ON ic.BillingID = p.BillingID
GROUP BY ic.Provider
ORDER BY Revenue_Received DESC;

 -- Outstanding Bills
 select
 ( select sum(Amount) 
 from hc_billing)as total_billed_amount,
 
( select sum(AmountPaid) 
 from hc_payments)as total_amount_recieved,
 
 ( select sum(Amount) 
 from hc_billing)- (select sum(AmountPaid) 
 from hc_payments
 ) as outstanding_bills;
 
-- Insurance Claim Approval Rate
select 
(select count(ï»¿ClaimID)
from `hc_insurance_claims`
where Status="Approved") as approved_claims,

(select count(ï»¿ClaimID)
from `hc_insurance_claims`) as total_claims,

round((select count(ï»¿ClaimID)
from `hc_insurance_claims`
where Status="Approved") * 100 /(select count(ï»¿ClaimID)
from `hc_insurance_claims`),2) as insurance_approval_rate;

-- Payment Method Distribution
select Method,count(ï»¿PaymentID) as payment_count
from hc_payments
group by Method
order by payment_count desc;

-- Average Billing Amount
 select round(avg(Amount),2)
 from hc_billing as avg_billed_amount;
 
-- Revenue Growth Rate

select
    *,
    case
        WHEN revenue_growth_rate > 0 THEN 'Positive'
        WHEN revenue_growth_rate < 0 THEN 'Negative'
        WHEN revenue_growth_rate = 0 THEN 'Zero'
        ELSE 'No Previous Month'
end as growth_status
from(
select ï»¿Month ,
Revenue as current_month_revenue,
lag(Revenue) over(order by ï»¿Month) as previous_month_revenue,

round(
(Revenue-lag(Revenue) over(order by ï»¿Month))* 100/nullif(lag(Revenue) over(order by ï»¿Month),0)
,2)as revenue_growth_rate

from hc_revenue_summary
) as monthly_growth
order by ï»¿Month;

-- Patient Experience KPIs
-- Average Satisfaction Rating
select round( avg(Rating),2) as Average_Satisfaction_Rating
from hc_patient_feedback;

-- Rating Distribution
select  Comment,round(avg(Rating),2) as overall_rating
from hc_patient_feedback
group by Comment
order by overall_rating desc;

-- Satisfaction by Hospital
select a.FacilityID as Facility,round(avg(Rating),2) as satisfaction_rating
from hc_appointments a
inner join hc_patient_feedback f
on a.AppointmentID=f.AppointmentID
group by Facility
order by satisfaction_rating desc; 

-- Satisfaction by Department
select a.DepartmentID as Department,round(avg(Rating),2) as satisfaction_rating
from hc_appointments a
inner join hc_patient_feedback f
on a.AppointmentID=f.AppointmentID
group by Department
order by satisfaction_rating desc; 

-- Most Common Feedback
select  Comment,count(ï»¿FeedbackID) as feedback_repetition
from hc_patient_feedback
group by Comment
order by feedback_repetition desc
limit 1;

-- Poor Rating Trend
/*Project documentation:Poor Rating Trend as Not Calculable – Date/timestamp field unavailable in the patient feedback dataset.*/
-- Excellent Rating Trend
/*Project documentation: Excellent  Rating Trend as Not Calculable – Date/timestamp field unavailable in the patient feedback dataset.*/

SELECT
    Diagnosis,
    COUNT(*) AS Total_Cases
FROM hc_diagnoses
GROUP BY Diagnosis
ORDER BY Total_Cases DESC;




