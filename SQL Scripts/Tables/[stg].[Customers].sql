CREATE TABLE [stg].[Customers]
(
	[CustomerID] NCHAR(5) NOT NULL,
	[CompanyName] VARCHAR(40) NOT NULL,
	[ContactName] VARCHAR(40) NULL,
	[ContactTitle] VARCHAR(40) NULL,
	[Address] VARCHAR(100) NULL,
	[City] VARCHAR(40) NULL,
	[Region] VARCHAR(40) NULL,
	[PostalCode] VARCHAR(40) NULL,
	[Country] VARCHAR(40) NULL,
	[Phone] VARCHAR(40) NULL,
	[Fax] VARCHAR(40) NULL
)