CREATE TABLE [hds].[OrderDetails]
(
	[OrderID] INT NOT NULL,
	[ProductID] INT NOT NULL,
	[UnitPrice] MONEY NULL,
	[Quantity] INT NULL,
	[Discount] REAL NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([OrderID]),
    CLUSTERED COLUMNSTORE INDEX
)