CREATE TABLE [hds].[EmployeeTerritories]
(
	[EmployeeID] INT NOT NULL,
	[TerritoryID] VARCHAR(20) NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([EmployeeID]),
    CLUSTERED COLUMNSTORE INDEX
)