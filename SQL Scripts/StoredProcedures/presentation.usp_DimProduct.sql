IF OBJECT_ID('presentation.usp_DimProduct', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimProduct
GO
CREATE PROCEDURE presentation.usp_DimProduct AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        
		DROP TABLE #TEMP;

		SELECT c.[ProductID],
				c.[ProductName],
				c.[ReorderLevel],
				c.[Discontinued],
				c.EtlInsertTime
		INTO #TEMP
		FROM hds.Products c


		DROP TABLE #NewRecords

		SELECT  c.[ProductID],
				c.[ProductName],
				c.[ReorderLevel],
				c.[Discontinued],
				c.EtlInsertTime
        INTO #NewRecords
        FROM #Temp AS c
        LEFT JOIN [presentation].[DimProduct] AS pc
          ON c.[ProductID] = pc.[ProductID]
        WHERE pc.[ProductID] IS NULL

		DROP TABLE #UpdatedRecords

		SELECT c.[ProductID],
				c.[ProductName],
				c.[ReorderLevel],
				c.[Discontinued],
				c.EtlInsertTime
        INTO #UpdatedRecords
        FROM #Temp AS c
        INNER JOIN [presentation].[DimProduct] AS pc
          ON c.[ProductID] = pc.[ProductID]
        WHERE c.[ProductName] <> pc.[ProductName]
			OR c.[ReorderLevel] <> pc.[ReorderLevel]
			OR c.[Discontinued] <> 	c.[Discontinued]

		INSERT INTO [presentation].[DimProduct] ([ProductID],
				[ProductName],
				[ReorderLevel],
				[Discontinued],
				EtlProcessdate)
          (SELECT new.[ProductID],
				new.[ProductName],
				new.[ReorderLevel],
				new.[Discontinued],
				new.EtlInsertTime
          FROM #NewRecords AS new)	

		UPDATE  [presentation].[DimProduct] 
        SET [ProductName] = t.[ProductName],
			[ReorderLevel] = t.[ReorderLevel],
			[Discontinued]  = t.[Discontinued],
			EtlProcessdate = t.EtlInsertTime,
			EtlUpdatedate = GETDATE()     
        FROM #UpdatedRecords AS t
        WHERE [presentation].[DimProduct].[ProductID] = t.[ProductID]


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