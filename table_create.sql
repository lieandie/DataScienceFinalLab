create table lardb1_filtered as
(
    select * from lardb1
    where Occupancy = 1 and
    Property_Type = 1 and
    Action_Type <= 4
);
create table lardb2_filtered as
(
    select * from lardb2
    where Occupancy = 1 and
    Property_Type = 1 and
    Action_Type <= 4
);
create table lardb3_filtered as
(
    select * from lardb3
    where Occupancy = 1 and
    Property_Type = 1 and
    Action_Type <= 4
);

create table selected_state as
(
    select * from lardb1_filtered
    where State_Code in ('02','03','04')
);

create table dataset as 
(
select lt.value as loan_type, lp.value as loan_purpose, fil.Loan_Amount_inK as loan_amount_ink, ppvl.value as preapproval, act.value as action_type, cnt.county_name as county_name, eth.value as applicant_ethnicity, fil.Co_Applicant_Ethnicity as co_applicant_ethnicity, rc.value as applicant_race_1, sx.value as applicant_sex, fil.Applicant_Income_inK as applicant_income_ink, fil.Rate_Spread as rate_spread, fil.HOEPA_Status as hoepa_status, ls.value as lien_status, fil.Minority_Population_pct as minority_population_pct, fil.HUD_Median_Family_Income as hud_median_family_income, fil.Tract_To_MSAMD_Income_pct as tract_to_msamd_income_pct, fil.Number_of_Owner_occupied_units as number_of_owner_occupied_units, cnt.state_name as state_name
from selected_state as fil
join fips as fps on fil.State_Code = fps.state_code
join action as act on fil.Action_Type = act.code 
join counties as cnt on fil.County_Code = cnt.county_code and fps.state_code = cnt.state_code and fil.State_Code = cnt.state_code
join ethnicity as eth on fil.Applicant_Ethnicity = eth.code
join lienstatus as ls on fil.Lien_Status = ls.code
join loanpurpose as lp on fil.Loan_Purpose = lp.code
join loantype as lt on fil.Loan_Type = lt.code
join preapproval as ppvl on fil.Preapproval = ppvl.code
join race as rc on fil.Applicant_Race_1 = rc.code
join sex as sx on fil.Applicant_Sex = sx.code
);

copy (select * from dataset) to '/home/gpadmin/FINAL_LAB/dataset.csv' with csv header delimiter ',';
