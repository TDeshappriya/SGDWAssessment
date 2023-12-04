CREATE TABLE [hds].[Suppliers]
(
	[SupplierID] INT NOT NULL,
	[CompanyName] VARCHAR(50) NULL,
	[ContactName] VARCHAR(50) NULL,
	[ContactTitle] VARCHAR(50) NULL,
	[Address] VARCHAR(50) NULL,
	[City] VARCHAR(50) NULL,
	[Region] VARCHAR(50) NULL,
	[PostalCode] VARCHAR(50) NULL,
	[Country] VARCHAR(50) NULL,
	[Phone] VARCHAR(50) NULL,
	[Fax] VARCHAR(50) NULL,
	[HomePage] VARCHAR(4000) NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([SupplierID]),
    CLUSTERED COLUMNSTORE INDEX
)