-- 1. Executive Overview: Total Sales and Profit by Region
SELECT Region, SUM(sales) AS Total_Sales, SUM(profit) AS Total_profit 
FROM Superstore 
GROUP BY Region 
ORDER BY Total_sales DESC; 

-- 2. Performance Deep-Dive: High-Profit Categories in the West (WHERE vs HAVING)
SELECT Category, AVG(Profit) AS Avg_Profit 
FROM Superstore 
WHERE Region = 'West' 
GROUP BY Category 
HAVING Avg_Profit > 50;

-- 3. Strategic Intelligence: Create View for Customer Segmentation
CREATE VIEW Customer_Segments AS 
SELECT Customer_Name, SUM(Sales) AS Lifetime_Value, 
CASE 
    WHEN SUM(Sales) > 10000 THEN 'High Value' 
    WHEN SUM(Sales) BETWEEN 5000 AND 10000 THEN 'Medium Value' 
    ELSE 'Low Value' 
END AS Segment 
FROM Superstore 
GROUP BY Customer_Name;

-- 4. Complex Relationships: Joining Primary Data with Calculated Segments
SELECT s.Order_ID, s.Customer_Name, s.Sales, cs.Segment
FROM Superstore s
INNER JOIN Customer_Segments cs ON s.Customer_Name = cs.Customer_Name
LIMIT 10;

-- 5. Granular Ranking: Top 3 Products per Category (Subquery + Window Function)
SELECT * FROM (
    SELECT Category, Product_Name, Sales, 
    DENSE_RANK() OVER (PARTITION BY Category ORDER BY Sales DESC) AS Rank 
    FROM Superstore
) AS Ranked_Items 
WHERE Rank <= 3;

-- 6. Performance Optimization: Creating a Composite Index
CREATE INDEX idx_region_category ON Superstore (Region, Category)