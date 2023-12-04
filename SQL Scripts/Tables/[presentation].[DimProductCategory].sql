CREATE TABLE [presentation].[DimProductCategory]
(
	[ProductCategorySK] INT IDENTITY(1,1)	NOT NULL,
	[CategoryID] INT NOT NULL,
	[CategoryName] VARCHAR(15) NULL,
	[Description] VARCHAR(4000) NULL,
	[EtlProcessdate]   DATETIME2 (7) NOT NULL,
    [EtlUpdatedate]   DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH (CategoryID),
    CLUSTERED COLUMNSTORE INDEX
)