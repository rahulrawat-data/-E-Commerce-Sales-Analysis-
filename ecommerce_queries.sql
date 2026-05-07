create DATABASE `E-Commerce`;

use `E-Commerce`;

SELECT 
    count(*)
FROM
    ecommerce_data;
    
-- Which product category generates highest total revenue?
SELECT 
    product_category, SUM(sales) AS Total_Revenue
FROM
    ecommerce_data
GROUP BY product_category;

-- What are the top 5 best-selling products by sales value?
SELECT 
    product, SUM(sales) AS total_sales
FROM
    ecommerce_data
GROUP BY product
ORDER BY total_sales DESC
LIMIT 5;

-- Which payment method generates highest revenue and profit?
SELECT 
    payment_method,
    ROUND(SUM(profit), 2) AS total_profit,
    SUM(sales) AS total_sales
FROM
    ecommerce_data
GROUP BY payment_method;

-- How does revenue differ between Male and Female customers?
SELECT 
    gender, SUM(sales) AS total_sales
FROM
    ecommerce_data
GROUP BY gender;

-- Which month had the highest total sales?
SELECT 
    month_name, SUM(sales) AS total_sales
FROM
    ecommerce_data
GROUP BY month_name
ORDER BY total_sales DESC;

-- Do higher discounts lead to lower profit? (correlation check)
SELECT 
    Product,
    round(AVG(Discount),2) AS Average_Discount,
    round(avg(Profit),2) AS Average_Profit
FROM 
    ecommerce_data
GROUP BY 
    Product
ORDER BY 
    Average_Discount desc;

-- Which product category has the highest average shipping cost?
SELECT 
    *
FROM
    (SELECT 
        product, ROUND(AVG(shipping_cost), 2) AS avg_shipcost
    FROM
        ecommerce_data
    GROUP BY product) AS avg_shiping
ORDER BY avg_shipcost DESC
LIMIT 5;

-- Which login type (Member vs Guest) generates more revenue?
SELECT 
    customer_login_type, SUM(sales) AS total_rev
FROM
    ecommerce_data
GROUP BY customer_login_type;

-- What is the most preferred payment method per product category?
SELECT product_category, payment_method, total_count
FROM (
    SELECT product_category,
           payment_method,
           COUNT(*) AS total_count,
           RANK() OVER (PARTITION BY product_category 
                        ORDER BY COUNT(*) DESC) AS rnk
    FROM ecommerce_data
    GROUP BY product_category, payment_method
) ranked
WHERE rnk = 1;
WHERE rnk = 1;
-- Which Device Type (Web/Mobile) drives more sales?
SELECT 
    device_type, SUM(sales) AS total_sales
FROM
    ecommerce_data
GROUP BY device_type;

-- Rank top 5 customers by total spending within each product category using RANK()
SELECT Product_Category, Customer_Id, Total_Sales, rnk
FROM (
    SELECT Product_Category, 
           Customer_Id,
           ROUND(SUM(Sales), 2) AS Total_Sales,
           RANK() OVER (PARTITION BY Product_Category 
                        ORDER BY SUM(Sales) DESC) AS rnk
    FROM ecommerce_data
    GROUP BY Product_Category, Customer_Id
) ranked
WHERE rnk <= 5;