CREATE TABLE [presentation].[FactProductStock]
(
	[ProductSK] INT	NOT NULL,
	[ProductCategorySK] INT NOT NULL,
	[QuantityPerUnit] VARCHAR(60) NULL,
	[UnitPrice] MONEY NULL,
	[UnitsInStock] SMALLINT NULL,
	[UnitsOnOrder] SMALLINT NULL,
	[EtlProcessdate]   DATETIME2 (7) NOT NULL
) WITH (
    DISTRIBUTION = HASH ([ProductSK]),
    CLUSTERED COLUMNSTORE INDEX
)