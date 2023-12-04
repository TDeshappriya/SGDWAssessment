
IF OBJECT_ID('hds.usp_STGtoHDS_CustomerDemographics', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_CustomerDemographics
GO
CREATE PROCEDURE hds.usp_STGtoHDS_CustomerDemographics AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.CustomerDemographics hds
        USING stg.CustomerDemographics stage 
        ON hds.[CustomerTypeID] = stage.[CustomerTypeID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[CustomerDesc] = stage.[CustomerDesc],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([CustomerTypeID], [CustomerDesc], [EtlInsertTime])
            VALUES (stage.[CustomerTypeID], stage.[CustomerDesc], @CurrentDATE);

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