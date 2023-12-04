IF OBJECT_ID('presentation.usp_DimProductCategory', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimProductCategory
GO
CREATE PROCEDURE presentation.usp_DimProductCategory AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        
		DROP TABLE #TEMP;

		SELECT c.CategoryID,
				c.CategoryName,
				c.Description,
				c.EtlInsertTime
		INTO #TEMP
		FROM hds.Categories c


		DROP TABLE #NewRecords

		SELECT c.CategoryID,
				c.CategoryName,
				c.Description,
				c.EtlInsertTime
        INTO #NewRecords
        FROM #Temp AS c
        LEFT JOIN [presentation].[DimProductCategory] AS pc
          ON c.CategoryID = pc.CategoryID
        WHERE pc.CategoryID IS NULL

		DROP TABLE #UpdatedRecords

		SELECT c.CategoryID,
				c.CategoryName,
				c.Description,
				c.EtlInsertTime
        INTO #UpdatedRecords
        FROM #Temp AS c
        INNER JOIN [presentation].[DimProductCategory] AS pc
          ON c.CategoryID = pc.CategoryID
        WHERE c.CategoryName <> pc.CategoryName
			OR c.Description <> pc.Description

		INSERT INTO [presentation].[DimProductCategory] (CategoryID,
				CategoryName,
				Description,
				EtlProcessdate)
          (SELECT new.CategoryID,
				new.CategoryName,
				new.Description,
				new.EtlInsertTime
          FROM #NewRecords AS new)	

		UPDATE  [presentation].[DimProductCategory] 
        SET CategoryName = t.CategoryName,
			Description = t.Description,
			EtlProcessdate = t.EtlInsertTime,
			EtlUpdatedate = GETDATE()     
        FROM #UpdatedRecords AS t
        WHERE [presentation].[DimProductCategory].CategoryID = t.CategoryID


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