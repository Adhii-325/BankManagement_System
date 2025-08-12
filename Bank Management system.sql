CREATE DATABASE BankManagementSystem;
USE BankManagementSystem;
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Address VARCHAR(255),
    Age INT CHECK (Age >= 18)
);
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY AUTO_INCREMENT,
    BranchName VARCHAR(100) NOT NULL,
    BranchAddress VARCHAR(255) NOT NULL,
    IFSCCode VARCHAR(11) UNIQUE NOT NULL
);
CREATE TABLE Account (
    AccountID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    AccountType ENUM('Savings', 'Current', 'Fixed Deposit') NOT NULL,
    Balance DECIMAL(15,2) CHECK (Balance >= 0),
    DateOpened DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
CREATE TABLE Transaction (
    TransactionID INT PRIMARY KEY AUTO_INCREMENT,
    AccountID INT NOT NULL,
    TransactionType ENUM('Deposit', 'Withdrawal', 'Transfer') NOT NULL,
    Amount DECIMAL(15,2) CHECK (Amount > 0),
    TransactionDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    LoanType ENUM('Home Loan', 'Car Loan', 'Personal Loan') NOT NULL,
    LoanAmount DECIMAL(15,2) CHECK (LoanAmount > 0),
    InterestRate DECIMAL(5,2) CHECK (InterestRate > 0),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    BranchID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role ENUM('Manager', 'Cashier', 'Clerk') NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID)
);
CREATE TABLE UserLogin (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Admin', 'Employee', 'Customer') NOT NULL,
    CustomerID INT NULL,
    EmployeeID INT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
INSERT INTO Customer (FirstName, LastName, DOB, Email, Phone, Address, Age)
VALUES
('John', 'Doe', '1990-05-14', 'john.doe@example.com', '9876543210', '123 Main St', 34),
('Jane', 'Smith', '1985-11-20', 'jane.smith@example.com', '9123456780', '456 Park Ave', 39);
INSERT INTO Branch (BranchName, BranchAddress, IFSCCode)
VALUES
('Central Branch', '789 Bank St', 'BANK0003'),
('North Branch', '101 North Ave', 'BANK0003');
INSERT INTO Account (CustomerID, BranchID, AccountType, Balance, DateOpened)
VALUES
(1, 1, 'Savings', 5000.00, '2023-01-15'),
(2, 2, 'Current', 10000.00, '2023-02-10');
INSERT INTO Transaction (AccountID, TransactionType, Amount)
VALUES
(1, 'Deposit', 2000.00),
(1, 'Withdrawal', 1000.00),
(2, 'Deposit', 5000.00);
INSERT INTO Loan (CustomerID, LoanType, LoanAmount, InterestRate, StartDate, EndDate)
VALUES
(1, 'Home Loan', 500000.00, 6.5, '2023-03-01', '2033-03-01'),
(2, 'Car Loan', 300000.00, 8.0, '2023-04-01', '2028-04-01');
INSERT INTO Employee (BranchID, FirstName, LastName, Role, Salary)
VALUES
(1, 'Mark', 'Taylor', 'Manager', 75000.00),
(2, 'Sara', 'Wilson', 'Cashier', 40000.00);
INSERT INTO UserLogin (Username, PasswordHash, Role, CustomerID, EmployeeID)
VALUES
('admin', 'hashed_admin_password', 'Admin', NULL, NULL),
('john_doe', 'hashed_password_1', 'Customer', 1, NULL),
('mark_taylor', 'hashed_password_2', 'Employee', NULL, 1);
CREATE INDEX idx_account_customer ON Account(CustomerID);
CREATE INDEX idx_transaction_account ON Transaction(AccountID);

