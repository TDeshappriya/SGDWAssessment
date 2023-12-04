CREATE TABLE [hds].[Products]
(
	[ProductID] INT NOT NULL,
	[ProductName] VARCHAR(60) NULL,
	[SupplierID] INT NULL,
	[CategoryID] INT NULL,
	[QuantityPerUnit] VARCHAR(60) NULL,
	[UnitPrice] MONEY NULL,
	[UnitsInStock] SMALLINT NULL,
	[UnitsOnOrder] SMALLINT NULL,
	[ReorderLevel] SMALLINT NULL,
	[Discontinued] BIT NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([ProductID]),
    CLUSTERED COLUMNSTORE INDEX
)