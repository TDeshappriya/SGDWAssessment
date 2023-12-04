CREATE TABLE [hds].[CustomerCustomerDemo]
(
	[CustomerID] NCHAR(5) NOT NULL,
	[CustomerTypeID] NCHAR(10) NOT NULL,
	[EtlInsertTime] DATETIME2 (7) NULL
) WITH (
    DISTRIBUTION = HASH ([CustomerID]),
    CLUSTERED COLUMNSTORE INDEX
)