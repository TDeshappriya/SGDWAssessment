CREATE TABLE [presentation].[DimCustomer]
(
	[CustomerSK] INT IDENTITY(1,1)	NOT NULL,
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
	[Fax] VARCHAR(40) NULL,
	[CustomerDesc] VARCHAR(4000) NULL,
	[IsActive] BIT NOT NULL,
	[EtlProcessdate]   DATETIME2 (7) NOT NULL,
    [EtlUpdatedate]   DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([CustomerID]),
    CLUSTERED COLUMNSTORE INDEX
)