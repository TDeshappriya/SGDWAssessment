CREATE TABLE [hds].[Employees]
(
	[EmployeeID] INT NOT NULL,
	[LastName] VARCHAR(40) NULL,
	[FirstName] VARCHAR(40) NULL,
	[Title] VARCHAR(40) NULL,
	[TitleOfCourtesy] VARCHAR(40) NULL,
	[BirthDate] DATETIME NULL,
	[HireDate] DATETIME NULL,
	[Address] VARCHAR(40) NULL,
	[City] VARCHAR(40) NULL,
	[Region] VARCHAR(40) NULL,
	[PostalCode] VARCHAR(40) NULL,
	[Country] VARCHAR(40) NULL,
	[HomePhone] VARCHAR(40) NULL,
	[Extension] VARCHAR(40) NULL,
	[Photo] VARBINARY(MAX) NULL,
	[Notes] VARCHAR(4000) NULL,
	[ReportsTo] INT NULL,
	[PhotoPath] VARCHAR(4000) NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
)WITH (
    DISTRIBUTION = HASH ([EmployeeID]),
    HEAP
)