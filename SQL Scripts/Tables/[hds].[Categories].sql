CREATE TABLE [hds].[Categories]
(
	[CategoryID] INT NOT NULL,
	[CategoryName] VARCHAR(15) NULL,
	[Description] VARCHAR(4000) NULL,
	[Picture] VARBINARY(MAX) NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH (CategoryID),
    HEAP
)