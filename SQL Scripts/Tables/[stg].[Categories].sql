CREATE TABLE [stg].[Categories]
(
	[CategoryID] INT NOT NULL,
	[CategoryName] VARCHAR(15) NULL,
	[Description] VARCHAR(4000) NULL,
	[Picture] VARBINARY(MAX) NULL
)WITH (HEAP)