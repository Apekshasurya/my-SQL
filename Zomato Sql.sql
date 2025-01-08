
create database z_analysis;
use z_analysis;
show tables;

UPDATE sheet1 SET Datekey_Opening = REPLACE(Datekey_Opening, '_', '/') WHERE Datekey_Opening LIKE '%_%';
alter table sheet1 modify column Datekey_Opening date;
select * from sheet1;


#1.Build a country Map Table
SELECT 
    s1.Countryid,
    s2.country
    FROM 
    Sheet1 s1
JOIN 
    Sheet2 s2
ON 
    s1.Countryid = s2.CountryCode;

#2.Calendar Table
select year(Datekey_Opening) years,
month(Datekey_Opening)  months,day(datekey_opening) day ,
monthname(Datekey_Opening) monthname,Quarter(Datekey_Opening)as quarter,
concat(year(Datekey_Opening),'-',monthname(Datekey_Opening)) yearmonth, 
weekday(Datekey_Opening) weekday,dayname(datekey_opening)dayname, 
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q1'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q2'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q3'
else  'Q4' end as quarters,
case when monthname(datekey_opening)='January' then 'FM10' 
when monthname(datekey_opening)='January' then 'FM11'
when monthname(datekey_opening)='February' then 'FM12'
when monthname(datekey_opening)='March' then 'FM1'
when monthname(datekey_opening)='April'then'FM2'
when monthname(datekey_opening)='May' then 'FM3'
when monthname(datekey_opening)='June' then 'FM4'
when monthname(datekey_opening)='July' then 'FM5'
when monthname(datekey_opening)='August' then 'FM6'
when monthname(datekey_opening)='September' then 'FM7'
when monthname(datekey_opening)='October' then 'FM8'
when monthname(datekey_opening)='November' then 'FM9'
when monthname(datekey_opening)='December'then 'FM10'
end Financial_months,
case when monthname(datekey_opening) in ('January' ,'February' ,'March' )then 'Q4'
when monthname(datekey_opening) in ('April' ,'May' ,'June' )then 'Q1'
when monthname(datekey_opening) in ('July' ,'August' ,'September' )then 'Q2'
else  'Q3' end as financial_quarters
from sheet1;

#3.Find the Numbers of Resturants based on City and Country.
select sheet2.country,sheet1.city,count(restaurantid)no_of_restaurants
from sheet1 inner join sheet2 
on sheet1.countryid=sheet2.CountryCode
group by sheet2.country,sheet1.city;

#4.Numbers of Resturants opening based on Year , Quarter , Month.
select year(datekey_opening)year,quarter(datekey_opening)quarter,monthname(datekey_opening)monthname,count(restaurantid)as no_of_restaurants 
from sheet1 group by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) 
order by year(datekey_opening),quarter(datekey_opening),monthname(datekey_opening) ; 

select count(RestaurantID) from sheet1;

#5. Count of Resturants based on Average Ratings.
SELECT 
case when rating between 0 and 1 then "0-1"
when rating between 1.1 and 2 then "1.1-2"
when rating between 2.1 and 3 then "2.1-3"
when rating between 3.1 and 4 then "3.1-4"
 when rating between 4.1 and 5 then "4.1-5" 
 end
 rating_range,count(RestaurantID)
 from sheet1
 group by rating_range
 order by rating_range;


#6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

SELECT Average_Cost_for_two, 
CASE WHEN (Average_Cost_for_two ) BETWEEN 0 AND 500 THEN "0 - 500"
WHEN (Average_Cost_for_two ) BETWEEN 501 AND 1000 THEN "501 - 1000"
WHEN (Average_Cost_for_two ) BETWEEN 1001 AND 5000 THEN "1001 - 5000"
WHEN (Average_Cost_for_two ) BETWEEN 5001 AND 10000 THEN "5001- 10000"
WHEN (Average_Cost_for_two ) BETWEEN 10001 AND 50000 THEN "10001 - 50000"
WHEN (Average_Cost_for_two ) BETWEEN 50001 AND 100000 THEN "50001 - 50000"
WHEN (Average_Cost_for_two ) BETWEEN 100001 AND 500000 THEN "100001 - 500000"
ELSE "ABOVE 500001"
END AS COST_BUCKET
FROM sheet1; 

#7.Percentage of Resturants based on "Has_Table_booking"
select has_online_delivery,concat(round(count(Has_Online_delivery)/100,1),"%") percentage 
from sheet1 
group by has_online_delivery;

#8.Percentage of Resturants based on "Has_Online_delivery"
select has_table_booking,concat(round(count(has_table_booking)/100,1),"%") percentage from sheet1
 group by has_table_booking; 

#9-- Count of Resturants based on Cuisines
select Cuisines,count(RESTAURANTID) as No_of_Restuarant from sheet1
group by Cuisines
order by No_of_Restuarant desc ;



