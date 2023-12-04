CREATE TABLE [stg].[Orders]
(
	[OrderID] INT NOT NULL,
	[CustomerID] NCHAR(5) NOT NULL,
	[EmployeeID] INT NOT NULL,
	[OrderDate] DATETIME NULL,
	[RequiredDate] DATETIME NULL,
	[ShippedDate] DATETIME NULL,
	[ShipVia] INT NULL,
	[Freight] VARCHAR(60) NULL,
	[ShipName] VARCHAR(60) NULL,
	[ShipAddress] VARCHAR(60) NULL,
	[ShipCity] VARCHAR(60) NULL,
	[ShipRegion] VARCHAR(60) NULL,
	[ShipPostalCode] VARCHAR(60) NULL,
	[ShipCountry] VARCHAR(60) NULL
)