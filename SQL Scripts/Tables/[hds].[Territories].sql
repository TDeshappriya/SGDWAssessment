CREATE TABLE [hds].[Territories]
(
	[TerritoryID] VARCHAR(20) NOT NULL,
	[TerritoryDescription] VARCHAR(50) NOT NULL,
	[RegionID] INT NOT NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
)	 WITH (
    DISTRIBUTION = HASH ([TerritoryID]),
    CLUSTERED COLUMNSTORE INDEX
)