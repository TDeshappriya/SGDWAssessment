IF OBJECT_ID('hds.usp_STGtoHDS_Shippers', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Shippers
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Shippers AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Shippers hds
        USING stg.Shippers stage 
        ON hds.[ShipperID] = stage.[ShipperID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[CompanyName] = stage.[CompanyName],
                hds.[Phone] = stage.[Phone],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([ShipperID], [CompanyName], [Phone], [EtlInsertTime])
            VALUES (stage.[ShipperID], stage.[CompanyName], stage.[Phone], @CurrentDATE);

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