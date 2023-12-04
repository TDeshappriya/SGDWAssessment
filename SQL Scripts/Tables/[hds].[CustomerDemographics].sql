CREATE TABLE [hds].[CustomerDemographics]
(
	[CustomerTypeID] NCHAR(5) NOT NULL,
	[CustomerDesc] VARCHAR(4000) NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
)WITH (
    DISTRIBUTION = HASH ([CustomerTypeID]),
    CLUSTERED COLUMNSTORE INDEX
)