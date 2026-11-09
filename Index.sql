CREATE INDEX idx_saletransaction_date
ON SaleTransaction (TransactionDate DESC);

CREATE INDEX idx_customer_phone
ON Customer (Phone);

CREATE INDEX idx_product_active
ON Product (Id, Name, CategoryId)
WHERE IsDeleted = FALSE;

CREATE INDEX idx_employee_active
ON Employee (Id, DepartmentId)
WHERE IsDeleted = FALSE;

CREATE UNIQUE INDEX idx_inventory_product_dept
ON Inventory (ProductId, DepartmentId);

CREATE INDEX idx_saleitem_transaction_product
ON SaleItem (SaleTransactionId, ProductId);