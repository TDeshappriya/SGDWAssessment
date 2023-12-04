IF OBJECT_ID('hds.usp_STGtoHDS_Products', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Products
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Products AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Products hds
        USING stg.Products stage 
        ON hds.[ProductID] = stage.[ProductID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[ProductName] = stage.[ProductName],
                hds.[SupplierID] = stage.[SupplierID],
                hds.[CategoryID] = stage.[CategoryID],
                hds.[QuantityPerUnit] = stage.[QuantityPerUnit],
                hds.[UnitPrice] = stage.[UnitPrice],
                hds.[UnitsInStock] = stage.[UnitsInStock],
                hds.[UnitsOnOrder] = stage.[UnitsOnOrder],
                hds.[ReorderLevel] = stage.[ReorderLevel],
                hds.[Discontinued] = stage.[Discontinued],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([ProductID], [ProductName], [SupplierID], [CategoryID], [QuantityPerUnit], [UnitPrice], [UnitsInStock], [UnitsOnOrder], [ReorderLevel], [Discontinued], [EtlInsertTime])
            VALUES (stage.[ProductID], stage.[ProductName], stage.[SupplierID], stage.[CategoryID], stage.[QuantityPerUnit], stage.[UnitPrice], stage.[UnitsInStock], stage.[UnitsOnOrder], stage.[ReorderLevel], stage.[Discontinued], @CurrentDATE);

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