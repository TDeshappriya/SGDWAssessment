IF OBJECT_ID('presentation.RefreshDimensions', 'P') IS NOT NULL
    DROP PROCEDURE presentation.RefreshDimensions
GO
CREATE PROCEDURE presentation.RefreshDimensions AS
BEGIN
    
    BEGIN TRY


		EXEC presentation.usp_DimProductCategory;
		EXEC presentation.usp_DimCustomer;
		EXEC presentation.usp_DimEmployee;
		EXEC presentation.usp_DimProduct;
		EXEC presentation.usp_DimShipper;
		EXEC presentation.usp_DimSuppliers;
		EXEC presentation.usp_DimDate;

        
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