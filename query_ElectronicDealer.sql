

--Sales Performance Overview

--What are total sales and total quantity sold by month and year?

--Sales every month
select FORMAT_DATE('%y-%m', s.`Order Date`) as MonthYear,round(sum(p.`Unit Price USD` * s.Quantity),0) as Revenue
from `ElectronicDealer.Sales` as s
left join `ElectronicDealer.Products` as p 
on s.ProductKey = p.ProductKey
group by MonthYear 
order by MonthYear;

-- Quantity sold every month
select format_date('%y-%m' , `Order Date`) as MonthYear,sum(Quantity) as QuantitySold
from `ElectronicDealer.Sales`
group by MonthYear
order by MonthYear;


--How do sales compare by currency over time?

select format_date('%y-%m', s.`Order Date`) as MonthYear, er.`Currency`, round(sum(p.`Unit Price USD` * er.Exchange * s.Quantity),0) as Sales, 
from `ElectronicDealer.Sales` as s 
left join `ElectronicDealer.Products` as p 
on s.ProductKey = p.ProductKey 
left join `ElectronicDealer.Exchange_Rates` as er 
on s.`Order Date` = er.Date
group by MonthYear, er.`Currency`
order by MonthYear, er.`Currency`;

--What is the average order value (AOV) per month?



SELECT 
  MonthYear,
  ROUND(AVG(OrderValue), 2) AS AvgOrderValue
FROM (
  SELECT 
    s.`Order Number`,
    FORMAT_DATE('%Y-%m', s.`Order Date`) AS MonthYear,
    SUM(p.`Unit Price USD` * s.`Quantity`) AS OrderValue
  FROM `ElectronicDealer.Sales` AS s
  LEFT JOIN `ElectronicDealer.Products` AS p
    ON s.`ProductKey` = p.`ProductKey`
  GROUP BY s.`Order Number`, MonthYear
) AS OrderTotals
GROUP BY MonthYear
ORDER BY MonthYear;




--What is the total Revenue and  Profit per month?

select format_date('%y-%m', s.`Order Date`) as MonthYear,
 round(sum(p.`Unit Price USD` * s.Quantity),0) as Revenue,
 round(sum((p.`Unit Price USD`-p.`Unit Cost USD`)* s.Quantity),2) as Profit
 from `ElectronicDealer.Sales` as s 
 left join `ElectronicDealer.Products` as p
 on s.ProductKey = p.ProductKey
 group by MonthYear
 order by MonthYear;


-- What is the total revenue and profit per quarters?

select 
FORMAT('%d-Q%d', EXTRACT(YEAR FROM s.`Order Date`), EXTRACT(QUARTER FROM s.`Order Date`)) AS YearQuarter ,
round(sum(p.`Unit Price USD` * s.Quantity),0) as Revenue,
 round(sum((p.`Unit Price USD`-p.`Unit Cost USD`)* s.Quantity),2) as Profit
 from `ElectronicDealer.Sales` as s 
 left join `ElectronicDealer.Products` as p
 on s.ProductKey = p.ProductKey
 group by YearQuarter 
 order by YearQuarter ;

--Which stores generate the highest sales?

select s.StoreKey, st.Country,                                                                                      
round(sum(p.`Unit Price USD` * s.Quantity),0) as Revenue,                                                                                                                             
from `ElectronicDealer.Sales` as s 
left join `ElectronicDealer.Stores`as st
on s.StoreKey = st.StoreKey
left join `ElectronicDealer.Products` as p 
on s.ProductKey = p.ProductKey
group by s.StoreKey,st.Country
order by Revenue desc ;

--Which country generate the highest sales?

select st.Country, 
round(sum(p.`Unit Price USD` * s.Quantity),0) as Revenue,
from `ElectronicDealer.Sales` as s 
left join `ElectronicDealer.Stores`as st
on s.StoreKey = st.StoreKey
left join `ElectronicDealer.Products` as p 
on s.ProductKey = p.ProductKey
group by st.Country
order by Revenue desc ; 


--What is the month-over-month (MoM) and year-over-year (YoY) revenue growth?

with monthly_sales as (
select 
extract(Year FROM s.`Order Date`) as Year ,
extract(Month from s.`Order Date`) as Month,
round(sum(p.`Unit Cost USD`*s.Quantity)) as Revenue 
from `ElectronicDealer.Sales` as s 
join `ElectronicDealer.Products` as p 
on s.ProductKey = p.ProductKey
group by Year,Month 
)

select 
Year, Month , Revenue , 

lag(Revenue) over (order by Year, Month) as prev_month_sales,
lag(Revenue, 12 ) over (order by Year, Month) as prev_year_sales,

round( ( Revenue - lag(Revenue) over (order by Year, Month))/nullif(lag(Revenue) over (order by Year, Month),0)*100) as mom_growth_pct,

round(( Revenue -lag(Revenue, 12 ) over (order by Year, Month) )/ nullif(lag(Revenue, 12 ) over (order by Year, Month),0)*100) as yoy_growth_pct

from monthly_sales
order by Year,Month;


--Which day of the week has the highest average sales?


with day_sales as ( 
select 
Extract(day from s.`Order Date`) as order_day,
format_date('%A', s.`Order Date`) as day_name,
sum(p.`Unit Price USD`*s.Quantity) as total_sales
 from `ElectronicDealer.Sales` as s
  join `ElectronicDealer.Products` as  p
  on s.ProductKey = p.ProductKey
  group by order_day, day_name 
)

select 
day_name, 
round(avg(total_sales)) as avg_day_sales
from day_sales 
group by day_name
order by avg_day_sales desc;


--Which month has the highest average sales?


WITH monthly_sales AS (
  SELECT
    EXTRACT(YEAR FROM s.`Order Date`) AS order_year,
    EXTRACT(MONTH FROM s.`Order Date`) AS order_month,
    FORMAT_DATE('%B', s.`Order Date`) AS month_name,
    SUM(p.`Unit Price USD` * s.Quantity) AS total_sales
  FROM `ElectronicDealer.Sales` AS s
  JOIN `ElectronicDealer.Products` AS p
    ON s.ProductKey = p.ProductKey
  GROUP BY order_year, order_month, month_name
)
SELECT
  month_name,
  ROUND(AVG(total_sales), 2) AS avg_monthly_sales
FROM monthly_sales
GROUP BY month_name
ORDER BY avg_monthly_sales DESC;


--What is the contribution of each store to total sales revenue (store share %)?



select st.StoreKey ,
round(sum(p.`Unit Price USD`*s.Quantity)) as total_sales,
round(sum(p.`Unit Price USD`*s.Quantity)/
(
select sum(p.`Unit Price USD`*s.Quantity)
from `ElectronicDealer.Sales` as s 
join `ElectronicDealer.Products` as p
on s.ProductKey = p.ProductKey
join `ElectronicDealer.Stores`as st 
on s.StoreKey = st.StoreKey 
)  * 100,2) as pct

from `ElectronicDealer.Sales` as s 
join `ElectronicDealer.Products` as p
on s.ProductKey = p.ProductKey
join `ElectronicDealer.Stores`as st 
on s.StoreKey = st.StoreKey 
group by st.StoreKey
order by total_sales desc;

--Which regions or countries show the fastest sales growth rate?

with yearly_sales as (
select 
st.Country,
extract(year from s.`Order Date`) as Order_Year,
round(sum(p.`Unit Price USD`*s.Quantity)) as Revenue
from `ElectronicDealer.Sales` as s 
join `ElectronicDealer.Products` as p
on s.ProductKey = p.ProductKey
join `ElectronicDealer.Stores`as st 
on s.StoreKey = st.StoreKey 
group by order_year, st.Country
order by  st.Country,order_year
    )

select 
Country , 
Order_Year,
Revenue,
round(
100 * (Revenue - lag(Revenue) over (partition by Country order by Order_Year))/  lag(Revenue) over (partition by Country order by Order_Year)
) as pct_growth_rate
from yearly_sales     
order by Country, Order_Year




-----------------------------------------------------

 