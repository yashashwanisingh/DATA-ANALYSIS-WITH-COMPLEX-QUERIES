
/*CREATE TABLE Sales (
    SaleID      INT PRIMARY KEY,
    EmpName     VARCHAR(50),
    Region      VARCHAR(50),
    Amount      DECIMAL(10,2),
    SaleDate    DATE
);

INSERT INTO Sales (SaleID, EmpName, Region, Amount, SaleDate) VALUES
(1,  'Aditi', 'North', 12000.00, '2025-01-05'),
(2,  'Aditi', 'North', 15000.00, '2025-01-20'),
(3,  'Aditi', 'North', 18000.00, '2025-02-10'),
(4,  'Aditi', 'North', 22000.00, '2025-03-02'),

(5,  'Rohan', 'South',  8000.00, '2025-01-08'),
(6,  'Rohan', 'South', 11000.00, '2025-01-25'),
(7,  'Rohan', 'South', 14000.00, '2025-02-14'),
(8,  'Rohan', 'South', 20000.00, '2025-03-05'),

(9,  'Meera', 'North',  9000.00, '2025-01-12'),
(10, 'Meera', 'North', 13000.00, '2025-02-18'),
(11, 'Meera', 'North', 16000.00, '2025-03-07');

SELECT * FROM sales;

*/


SELECT
    EmpName,
    SaleDate,
    Amount,
    SUM(Amount) OVER (
        PARTITION BY EmpName
        ORDER BY SaleDate
    ) AS RunningTotal
FROM Sales
ORDER BY EmpName, SaleDate;
SELECT
    EmpName,
    SUM(Amount) AS TotalSales,
    RANK() OVER (
        ORDER BY SUM(Amount) DESC
    ) AS SalesRank
FROM Sales
GROUP BY EmpName
ORDER BY SalesRank;

SELECT
    SaleID,
    EmpName,
    Amount,
    SaleDate
FROM Sales
WHERE Amount > (
    SELECT AVG(Amount) FROM Sales
)
ORDER BY Amount DESC;

SELECT
    EmpName,
    TotalSales
FROM (
    SELECT EmpName, SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY EmpName
) t
WHERE TotalSales > (
    SELECT AVG(TotalSales)
    FROM (
        SELECT SUM(Amount) AS TotalSales
        FROM Sales
        GROUP BY EmpName
    ) x
)
ORDER BY TotalSales DESC;
SELECT
    EmpName,
    TotalSales
FROM (
    SELECT EmpName, SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY EmpName
) t
WHERE TotalSales > (
    SELECT AVG(TotalSales)
    FROM (
        SELECT SUM(Amount) AS TotalSales
        FROM Sales
        GROUP BY EmpName
    ) x
)
ORDER BY TotalSales DESC;

WITH MonthlySales AS (
    SELECT
        EmpName,
        DATE_FORMAT(SaleDate, '%Y-%m') AS YearMonth,  -- MySQL
        SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY EmpName, DATE_FORMAT(SaleDate, '%Y-%m')
)
SELECT * FROM MonthlySales
ORDER BY EmpName, YearMonth;
WITH EmployeeTotals AS (
    SELECT
        EmpName,
        SUM(Amount) AS TotalSales
    FROM Sales
    GROUP BY EmpName
)
SELECT
    EmpName,
    TotalSales,
    CASE
        WHEN TotalSales >= 60000 THEN 'Top Performer'
        WHEN TotalSales >= 40000 THEN 'Average Performer'
        ELSE 'Needs Improvement'
    END AS PerformanceCategory
FROM EmployeeTotals
ORDER BY TotalSales DESC;
