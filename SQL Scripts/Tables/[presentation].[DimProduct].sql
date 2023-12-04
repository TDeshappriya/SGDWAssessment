CREATE TABLE [presentation].[DimProduct]
(
	[ProductSK] INT	IDENTITY(1,1)	NOT NULL,
	[ProductID] INT NOT NULL,
	[ProductName] VARCHAR(60) NULL,
	[ReorderLevel] SMALLINT NULL,
	[Discontinued] BIT NULL,
	[EtlProcessdate]   DATETIME2 (7) NOT NULL,
    [EtlUpdatedate]   DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([ProductID]),
    CLUSTERED COLUMNSTORE INDEX
)
