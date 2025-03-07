-- Opportunity
-- 1.Expected amount
SELECT SUM(`Expected Amount`) AS total_expected_amount 
FROM oppertunity_table
WHERE `Expected Amount` <> '';

-- 2.Open active opportunities
SELECT 
    COUNT(`Opportunity ID`) AS total_opportunities,
    CONCAT(
        ROUND((
            (SELECT COUNT(`has open activity`) 
             FROM oppertunity_table 
             WHERE `has open activity` = "True") 
             / COUNT(`Opportunity ID`)) * 100, 2), '%'
    ) AS active_open_opportunities
FROM oppertunity_table;

-- 3.conversion Rate
SELECT concat(round(((SELECT COUNT(stage) FROM oppertunity_table 
WHERE stage = 'closed won') / COUNT(`Opportunity ID`))*100,2),"%") AS Conversion_rate
FROM oppertunity_table;

-- 4.won Rate
SELECT concat(round(((SELECT COUNT(stage) FROM oppertunity_table 
WHERE stage = 'closed won') / COUNT(`Opportunity ID`))*100,2),"%") AS won_rate
FROM oppertunity_table;

-- 5.Loss Rate
SELECT concat(round(((SELECT COUNT(stage) FROM oppertunity_table 
WHERE stage = 'closed lost') / COUNT(`Opportunity ID`))*100,2),"%") AS Loss_rate
FROM oppertunity_table;

-- 6.expected vs forecast
select `Fiscal Year`,sum(`Expected Amount`) from oppertunity_table group by  `Fiscal Year`;
SELECT 
   `created date` ,
    SUM(`Expected Amount`) OVER (ORDER BY `created date`) AS running_expected_revenue,
    SUM(CASE WHEN `Forecast Q Commit` = 'true' THEN amount ELSE 0 END) 
        OVER (ORDER BY `created date`) AS running_forecast_commit,
    (SUM(`Expected Amount`) OVER (ORDER BY `created date`) - 
     SUM(CASE WHEN `Forecast Q Commit` = 'true' THEN amount ELSE 0 END) 
        OVER (ORDER BY `created date`)) AS difference
FROM 
    oppertunity_table
ORDER BY 
    `created date`;
    
-- 7.Active vs total opportunities
select (select count(`has open activity`) as Total_Open_Activity  from oppertunity_table where `has open activity`= "True") as Active_Opportunities,
count(`Opportunity ID`) as Total_opportunities from oppertunity_table;

-- 8.closed won vs total opportunities
select(select count(stage) from oppertunity_table where stage = "closed won") as Closed_Won_Opportunities,
count(`Opportunity ID`) as Total_Opportunities from oppertunity_table;

-- 9.Closed won vs Total Closed
select(select count(stage) from oppertunity_table where stage = "closed won") as Closed_Won_Opportunities,
count(closed) as Closed_Opportunities from oppertunity_table where closed = "true";

-- 10.Expected amount by Opportunity type
select `Opportunity Type`,sum(`Expected Amount`) from oppertunity_table group by `Opportunity Type` order by `Opportunity Type`;

-- 11.opportunities by industry
select industry,count(`Opportunity ID`) as oppertunities from oppertunity_table group by industry order by oppertunities desc;

-- Lead
select * from oppertunity_table;
select * from lead_table ;
select * from account;
select * from opportunity_product;
select * from user_table;

-- 1.Total lead
select count(`Total Leads`) from lead_table;

-- 2.expected amount from converted leads
select l.`Total Leads`,l.converted,o.`Expected Amount` from oppertunity_table as o join lead_table as l on o.`Record Type ID`=l.`Record Type ID`
 where l.converted = "true";

-- 3.conversion rate
select concat(round((select count(converted) from lead_table where converted = "true")/count(`Lead ID`)*100,2),"%") as conversion_rate from lead_table;

-- 4.converted accounts
select count(`Converted Account ID`) as Converted_accounts from lead_table where `Converted Account ID`<>'' ;

-- 5.converted opportunity
select count(`Converted Opportunity ID`) as Converted_opportunities from lead_table where `Converted Opportunity ID`<>'' ;

-- 6.lead by source
select `Lead Source` as source,count(`Lead Source`) as lead_by_source from lead_table group by `Lead Source` order by lead_by_source desc;

-- 7.lead by industry
select industry,count(`Lead ID`) as industry_lead from lead_table group by industry order by industry_lead desc;

-- 8.lead by stage
select status,count(status) from lead_table group by status;

