CREATE TABLE [presentation].[DimDate]
(
    [DateSK] INT NOT NULL,
    Date DATE,
	Year INT,
	Quarter INT,
	Month INT,
	Day INT,
	DayOfWeek INT,
	Weekday BIT
) WITH (
    DISTRIBUTION = HASH ([DateSK]),
    CLUSTERED COLUMNSTORE INDEX
)