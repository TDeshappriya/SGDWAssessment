IF OBJECT_ID('presentation.usp_FactProductStock', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_FactProductStock
GO
CREATE PROCEDURE presentation.usp_FactProductStock AS
BEGIN
    
    BEGIN TRY

	TRUNCATE TABLE presentation.FactProductStock

	INSERT INTO presentation.FactProductStock(
			ProductSK,
			ProductCategorySK,
			QuantityPerUnit,
			UnitPrice,
			UnitsInStock,
			UnitsOnOrder,
			EtlProcessdate)
	SELECT dp.ProductSK,
			dpc.ProductCategorySK,
			p.QuantityPerUnit,
			p.UnitPrice,
			p.UnitsInStock,
			p.UnitsOnOrder,
			GETDATE()
	FROM hds.Products p
	INNER JOIN presentation.DimProductCategory dpc
	ON dpc.CategoryID = p.CategoryID
	INNER JOIN presentation.DimProduct dp
	ON p.ProductId = dp.ProductID


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
