Use classicmodels;

select * from employees;

-- Q1 [A]

SELECT  employeeNumber, firstName, lastName
FROM employees
WHERE jobTitle = 'Sales Rep'
AND reportsTo = 1102;

-- Q1[B]

SELECT DISTINCT productLine
FROM products
WHERE productLine LIKE '%cars';

-- Q2 [A]

select * from customers;

Select customerNumber,customerName,
case
when country="USA"or country="canada" then "North America"
when country ="Uk" or country="France" or country ="Germany" then "Europe"
else "Others"
end as Customersegment
from customers;

-- Q.3 [A]
use classicmodels;
select productcode,sum(quantityOrdered) as Total_Ordered
from orderdetails
group by productcode 
order by Total_ordered desc limit 10;

-- Q.3 [B]
use classicmodels;
select * from payments;

select monthname(paymentdate)as Month_Name,
count(*) as Total_Payment
from payments
group by monthname(paymentdate)
having count(*)>20
order by Total_payment desc;

-- Q.4 [A]

Create database Customer_Orders;
Use Customer_Orders;
create table Customers(Customers_id int primary key auto_increment,
First_Name varchar(50),
Last_name varchar(50),
Email varchar(255)unique,
phone_no Varchar(20));
alter table Customers Modify First_Name varchar(50)not null;
alter table Customers Modify Last_name varchar(50)not null;

-- Q.4 [B]
use customer_orders;
create table Orders(order_id int primary key auto_increment,
				    Customers_id int,
                    Order_date date,
                    Total_amount decimal(10,2),
                    foreign key (Customers_id)references Customers (Customers_id )
                    on update cascade on delete set null
                    );
                    
alter table orders modify total_amount decimal (10,2)check(total_amount>0);
select * from orders;

                   
-- Q.5
use classicmodels;
SELECT c.country, COUNT(o.orderNumber) AS orderCount
FROM Customers c
JOIN Orders o ON c.customerNumber = o.customerNumber
GROUP BY c.country
ORDER BY orderCount DESC
LIMIT 5;

-- Q 6                       
drop table project;
	CREATE TABLE project (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    ManagerID INT
);
insert into project (EmployeeID,FullName,Gender,ManagerID) values
                    (1,'Pranaya','Male',3),
                    (2,'Priyanka','Female',1),
                    (3,'Preety','Female',null),
                    (4,'Anurag','Male',1),
                    (5,'Sambit','Male',1),
                    (6,'Rajesh','Male',3),
                    (7,'Hina','Female',3)
                    ;
select * from project;
SELECT 
    m.FullName AS ManagerName,
    e.FullName AS EmployeeName
    FROM 
    project e
 JOIN 
    project m ON e.ManagerID = m.EmployeeID;


-- Q 7  
use classicmodels;
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

ALTER TABLE facility
MODIFY Facility_ID INT PRIMARY KEY AUTO_INCREMENT;

ALTER TABLE facility
ADD City VARCHAR(100) NOT NULL AFTER Name;
 
 desc facility;
 
-- Q.8 
use classicmodels;
CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT o.orderNumber) AS number_of_orders
FROM 
    productlines pl
JOIN 
    products p ON pl.productLine = p.productLine
JOIN 
    orderdetails od ON p.productCode = od.productCode
JOIN 
    orders o ON od.orderNumber = o.orderNumber
GROUP BY 
    pl.productLine;
    
select * from product_category_sales;

-- Q 9 
     
use classicmodels;
CALL Get_country_payments(2003, 'France');

-- Q 10 [A]

Use classicmodels;
SELECT 
    c.CustomerNumber,
    c.CustomerName,
    COUNT(o.OrderNumber) AS Order_count,
    RANK() OVER (ORDER BY COUNT(o.OrderNumber) DESC) AS Order_Frequency_mk,
    DENSE_RANK() OVER (ORDER BY COUNT(o.OrderNumber) DESC) AS DenseOrderRank,
    LEAD(COUNT(o.OrderNumber), 1) OVER (ORDER BY COUNT(o.OrderNumber) DESC) AS NextOrderFrequency,
    LAG(COUNT(o.OrderNumber), 1) OVER (ORDER BY COUNT(o.OrderNumber) DESC) AS PreviousOrderFrequency
FROM 
    customers c
LEFT JOIN 
    orders o ON c.CustomerNumber = o.CustomerNumber
GROUP BY 
    c.CustomerNumber, c.CustomerName
ORDER BY 
    Order_count DESC;

-- Q.10 [B]

select year (orderDate) AS year,
monthname(orderDate) as Month,
COUNT(orderNumber) AS Total_Orders,
CONCAT (ROUND ((count(orderNumber)-LAG (count(orderNumber)) OVER (Order by year (orderDate)))/
LAG(COUNT(orderNumber)) OVER (Order by year(orderDate)) * 100 , 0), ' % ' ) AS' % YOY Change '
from Orders Group by year (orderDate),monthname(orderDate);

-- Q 11   
    SELECT 
    productLine,
    COUNT(*) AS count
FROM 
    products
WHERE 
    buyPrice > (SELECT AVG(buyPrice) FROM products)
GROUP BY 
    productLine;

    -- Q 12 
    use classicmodels;
    CREATE TABLE Emp_EH (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(100),
    EmailAddress VARCHAR(100)
);

CALL Emp_EH(1,'Apeksha','apeksha172001@gmail');
CALL Emp_EH(1,'Yash','yash2001@gmail');

select * from Emp_EH;

-- Q 13    
use classicmodels;
CREATE TABLE Emp_BIT (
    Name VARCHAR(50),
    Occupation VARCHAR(50),
    Working_date DATE,
    Working_hours INT
);

INSERT INTO Emp_BIT (Name, Occupation, Working_date, Working_hours) VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

select * from Emp_BIT;



