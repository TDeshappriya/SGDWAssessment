
IF OBJECT_ID('presentation.usp_DimDate', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimDate
GO
CREATE PROCEDURE presentation.usp_DimDate AS
BEGIN
    
    BEGIN TRY

	TRUNCATE TABLE [presentation].[DimDate]

	CREATE TABLE dbo.TempDateDimension
		(
			DateSK INT ,
			Date DATE,
			Year INT,
			Quarter INT,
			Month INT,
			Day INT,
			DayOfWeek INT,
			Weekday BIT
		);

		DECLARE @StartDate DATE = '1995-01-01';
		DECLARE @EndDate DATE = '2000-12-31';

		WITH Numbers AS
		(
			SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
				ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS N
			FROM sys.objects AS o1, sys.objects AS o2
		)

		INSERT INTO dbo.TempDateDimension
		(
			DateSK,
			Date,
			Year,
			Quarter,
			Month,
			Day,
			DayOfWeek,
			Weekday
		)
		SELECT
			--CONVERT(INT, FORMAT(DATEADD(DAY, N - 1, @StartDate), 'ddMMyyyy')),
			REPLACE(DATEADD(DAY, N - 1, @StartDate), '-', ''),
			DATEADD(DAY, N - 1, @StartDate),
			YEAR(DATEADD(DAY, N - 1, @StartDate)),
			DATEPART(QUARTER, DATEADD(DAY, N - 1, @StartDate)),
			MONTH(DATEADD(DAY, N - 1, @StartDate)),
			DAY(DATEADD(DAY, N - 1, @StartDate)),
			DATEPART(WEEKDAY, DATEADD(DAY, N - 1, @StartDate)),
			CASE WHEN DATEPART(WEEKDAY, DATEADD(DAY, N - 1, @StartDate)) IN (1, 7) THEN 0 ELSE 1 END
		FROM Numbers
		WHERE N <= DATEDIFF(DAY, @StartDate, @EndDate) + 1;

		
		INSERT INTO [presentation].[DimDate]
		(
			DateSK,
			Date,
			Year,
			Quarter,
			Month,
			Day,
			DayOfWeek,
			Weekday
		)
		SELECT
			DateSK,
			Date,
			Year,
			Quarter,
			Month,
			Day,
			DayOfWeek,
			Weekday
		FROM dbo.TempDateDimension;

		
		DROP TABLE dbo.TempDateDimension;

        
    END TRY  
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION 

        DECLARE @ErrorNumber INT = ERROR_NUMBER()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorProcedure NVARCHAR(128) = ERROR_PROCEDURE()
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorValue NVARCHAR(4000)
        DECLARE @ErrorState INT = ERROR_STATE()

        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorNumber);
    END CATCH
END
GO