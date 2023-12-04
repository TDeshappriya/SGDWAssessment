CREATE TABLE [presentation].[FactOrders]
(
	[CustomerSK] INT NOT NULL,
	[EmployeeSK] INT NOT NULL,
	[OrderDateSK] INT  NULL,
	[RequiredDateSK] INT  NULL,
	[ShippedDateSK] INT  NULL,
	[ShipperSK] INT	NOT NULL,
	[ProductSK] INT	NOT NULL,
	[ProductCategorySK] INT NOT NULL,
	[SupplierSK]  INT NOT NULL,
	[OrderID] INT NOT NULL,
	[TotalOrderFreight] VARCHAR(60) NULL,
	[UnitPrice] MONEY NULL,
	[Quantity] INT NULL,
	[Discount] REAL NULL,
	[EtlProcessdate]   DATETIME2 (7) NOT NULL
) WITH (
    DISTRIBUTION = HASH ([CustomerSK]),
    CLUSTERED COLUMNSTORE INDEX
)