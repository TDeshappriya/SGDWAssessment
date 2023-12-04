CREATE TABLE [stg].[OrderDetails]
(
	[OrderID] INT NOT NULL,
	[ProductID] INT NOT NULL,
	[UnitPrice] MONEY NULL,
	[Quantity] INT NULL,
	[Discount] REAL NULL
)