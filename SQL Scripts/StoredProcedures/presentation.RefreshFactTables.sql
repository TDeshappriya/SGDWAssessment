IF OBJECT_ID('presentation.RefreshFactTables', 'P') IS NOT NULL
    DROP PROCEDURE presentation.RefreshFactTables
GO
CREATE PROCEDURE presentation.RefreshFactTables AS
BEGIN
    
    BEGIN TRY


		EXEC hds.usp_FactOrders;
		EXEC hds.usp_FactProductStock;

        
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