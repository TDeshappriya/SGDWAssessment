IF OBJECT_ID('presentation.usp_DimShipper', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimShipper
GO
CREATE PROCEDURE presentation.usp_DimShipper AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        
		DROP TABLE #TEMP;

		SELECT c.[ShipperID],
				c.[CompanyName],
				c.[Phone],
				c.EtlInsertTime
		INTO #TEMP
		FROM hds.Shippers c


		DROP TABLE #NewRecords

		SELECT  c.[ShipperID],
				c.[CompanyName],
				c.[Phone],
				c.EtlInsertTime
        INTO #NewRecords
        FROM #Temp AS c
        LEFT JOIN [presentation].[DimShipper] AS pc
          ON c.[ShipperID] = pc.[ShipperID]
        WHERE pc.[ShipperID] IS NULL

		DROP TABLE #UpdatedRecords

		SELECT c.[ShipperID],
				c.[CompanyName],
				c.[Phone],
				c.EtlInsertTime
        INTO #UpdatedRecords
        FROM #Temp AS c
        INNER JOIN [presentation].[DimShipper] AS pc
          ON c.[ShipperID] = pc.[ShipperID]
        WHERE c.[CompanyName] <> pc.[CompanyName]
			OR c.[Phone] <> pc.[Phone]

		INSERT INTO [presentation].[DimShipper] ([ShipperID],
				[CompanyName],
				[Phone],
				EtlProcessdate)
          (SELECT new.[ShipperID],
				new.[CompanyName],
				new.[Phone],
				new.EtlInsertTime
          FROM #NewRecords AS new)	

		UPDATE  [presentation].[DimShipper] 
        SET [CompanyName] = t.[CompanyName],
			[Phone] = t.[Phone],
			EtlProcessdate = t.EtlInsertTime,
			EtlUpdatedate = GETDATE()     
        FROM #UpdatedRecords AS t
        WHERE [presentation].[DimShipper].[ShipperID] = t.[ShipperID]


        COMMIT TRANSACTION
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