CREATE TABLE Role (
    Id SERIAL PRIMARY KEY,
    Title VARCHAR(50) NOT NULL,
    AccessLevel INT DEFAULT 1
);

CREATE TABLE Department (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(200),
    IsDeleted BOOLEAN DEFAULT FALSE,
    UpdatedAt TIMESTAMP,
    UpdatedBy INT
);

CREATE TABLE Employee (
    Id SERIAL PRIMARY KEY,
    DepartmentId INT REFERENCES Department(Id),
    RoleId INT REFERENCES Role(Id),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE,
    IsDeleted BOOLEAN DEFAULT FALSE,
    UpdatedAt TIMESTAMP,
    UpdatedBy INT REFERENCES Employee(Id)
);

ALTER TABLE Department
ADD CONSTRAINT fk_department_updatedby FOREIGN KEY (UpdatedBy) REFERENCES Employee(Id);


CREATE TABLE Category (
    Id SERIAL PRIMARY KEY,
    ParentCategoryId INT REFERENCES Category(Id),
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Product (
    Id SERIAL PRIMARY KEY,
    CategoryId INT REFERENCES Category(Id),
    SKU VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(200) NOT NULL,
    CurrentPrice NUMERIC(18,2) NOT NULL,
    IsDeleted BOOLEAN DEFAULT FALSE,
    UpdatedAt TIMESTAMP,
    UpdatedBy INT REFERENCES Employee(Id)
);

CREATE TABLE PriceHistory (
    Id SERIAL PRIMARY KEY,
    ProductId INT REFERENCES Product(Id),
    OldPrice NUMERIC(18,2),
    NewPrice NUMERIC(18,2) NOT NULL,
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ChangedBy INT REFERENCES Employee(Id)
);

CREATE TABLE Supplier (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    ContactPhone VARCHAR(20),
    Email VARCHAR(100),
    IsDeleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE Inventory (
    Id SERIAL PRIMARY KEY,
    ProductId INT REFERENCES Product(Id),
    DepartmentId INT REFERENCES Department(Id),
    Quantity INT DEFAULT 0,
    LastRestockDate TIMESTAMP
);

CREATE TABLE SupplyOrder (
    Id SERIAL PRIMARY KEY,
    SupplierId INT REFERENCES Supplier(Id),
    OrderedBy INT REFERENCES Employee(Id),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20)
);

CREATE TABLE SupplyOrderItem (
    Id SERIAL PRIMARY KEY,
    SupplyOrderId INT REFERENCES SupplyOrder(Id),
    ProductId INT REFERENCES Product(Id),
    Quantity INT NOT NULL,
    PurchasePrice NUMERIC(18,2)
);

CREATE TABLE Customer (
    Id SERIAL PRIMARY KEY,
    Phone VARCHAR(20) UNIQUE,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    LoyaltyPoints INT DEFAULT 0,
    IsDeleted BOOLEAN DEFAULT FALSE,
    UpdatedAt TIMESTAMP,
    UpdatedBy INT REFERENCES Employee(Id)
);

CREATE TABLE PaymentMethod (
    Id SERIAL PRIMARY KEY,
    MethodName VARCHAR(50)
);

CREATE TABLE Discount (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Percentage NUMERIC(5,2),
    ValidFrom TIMESTAMP,
    ValidTo TIMESTAMP,
    IsActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE SaleTransaction (
    Id SERIAL PRIMARY KEY,
    CustomerId INT REFERENCES Customer(Id),
    EmployeeId INT REFERENCES Employee(Id),
    DepartmentId INT REFERENCES Department(Id),
    PaymentMethodId INT REFERENCES PaymentMethod(Id),
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount NUMERIC(18,2) NOT NULL
);

CREATE TABLE SaleItem (
    Id SERIAL PRIMARY KEY,
    SaleTransactionId INT REFERENCES SaleTransaction(Id),
    ProductId INT REFERENCES Product(Id),
    Quantity INT NOT NULL,
    UnitPrice NUMERIC(18,2) NOT NULL
);

CREATE TABLE AppliedDiscount (
    Id SERIAL PRIMARY KEY,
    SaleTransactionId INT REFERENCES SaleTransaction(Id),
    DiscountId INT REFERENCES Discount(Id),
    DiscountAmount NUMERIC(18,2)
);