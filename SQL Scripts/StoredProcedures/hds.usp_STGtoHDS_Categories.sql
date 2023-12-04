IF OBJECT_ID('hds.usp_STGtoHDS_Categories', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Categories
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Categories AS

BEGIN


	BEGIN TRANSACTION
	BEGIN TRY

	DECLARE @CurrentDATE AS DATETIME2 (7);
	SET @CurrentDATE = GETDATE();


	MERGE hds.Categories hds
	USING stg.Categories stage ON hds.[CategoryID] = stage.[CategoryID]
 
	WHEN MATCHED THEN
	UPDATE SET 
 		hds.[CategoryName] = stage.[CategoryName],
		hds.[Description] = stage.[Description],
		hds.[Picture] = stage.[Picture],
		hds.[EtlInsertTime] = @CurrentDATE
 	WHEN NOT MATCHED BY TARGET 
	THEN 
	INSERT (CategoryID, CategoryName,Description,Picture,EtlInsertTime)
	VALUES (stage.CategoryID,stage.CategoryName, stage.Description,stage.Picture, @CurrentDATE );

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