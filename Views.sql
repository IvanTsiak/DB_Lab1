CREATE OR REPLACE VIEW vw_ActiveProducts AS
SELECT
    p.Id AS ProductId,
    p.SKU,
    p.Name AS ProductName,
    p.CurrentPrice,
    c.Name AS CategoryName
FROM Product p
JOIN Category c ON p.CategoryId = c.Id
WHERE p.IsDeleted = FALSE;

CREATE OR REPLACE VIEW vw_ActiveEmployees AS
SELECT
    e.Id AS EmployeeId,
    e.FirstName || ' ' || e.LastName AS FullName,
    e.Email,
    r.Title AS RoleTitle,
    d.Name AS DepartmentName,
    e.HireDate
FROM Employee e
JOIN Role r ON e.RoleId = r.Id
JOIN Department d ON e.DepartmentId = d.Id
WHERE e.IsDeleted = FALSE;

CREATE OR REPLACE VIEW vw_ActiveCustomers AS
SELECT
    Id AS CustomerId,
    FirstName || ' ' || LastName AS FullName,
    Phone,
    LoyaltyPoints
FROM Customer
WHERE IsDeleted = FALSE;

CREATE OR REPLACE VIEW vw_DepartmentSalesSummary AS
SELECT
    d.Id AS DepartmentId,
    d.Name AS DepartmentName,
    COUNT(st.Id) AS TotalTransactions,
    COALESCE(SUM(st.TotalAmount), 0.00) AS TotalRevenue
FROM Department d
LEFT JOIN SaleTransaction st ON d.Id = st.DepartmentId
WHERE d.IsDeleted = FALSE
GROUP BY d.Id, d.Name;