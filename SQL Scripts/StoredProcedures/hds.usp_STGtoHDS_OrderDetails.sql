IF OBJECT_ID('hds.usp_STGtoHDS_OrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_OrderDetails
GO
CREATE PROCEDURE hds.usp_STGtoHDS_OrderDetails AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.OrderDetails hds
        USING stg.OrderDetails stage 
        ON hds.[OrderID] = stage.[OrderID] AND hds.[ProductID] = stage.[ProductID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[UnitPrice] = stage.[UnitPrice],
                hds.[Quantity] = stage.[Quantity],
                hds.[Discount] = stage.[Discount],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([OrderID], [ProductID], [UnitPrice], [Quantity], [Discount], [EtlInsertTime])
            VALUES (stage.[OrderID], stage.[ProductID], stage.[UnitPrice], stage.[Quantity], stage.[Discount], @CurrentDATE);

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