CREATE TABLE [presentation].[DimShipper]
(
	[ShipperSK] INT	IDENTITY(1,1)	NOT NULL,
	[ShipperID] INT NOT NULL,
	[CompanyName] VARCHAR(40) NULL,
	[Phone] VARCHAR(30) NULL,
	[EtlProcessdate]   DATETIME2 (7) NOT NULL,
    [EtlUpdatedate]   DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([ShipperID]),
    CLUSTERED COLUMNSTORE INDEX
)