CREATE TABLE [stg].[Products]
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
	[Discontinued] BIT NULL
)