IF OBJECT_ID('hds.usp_STGtoHDS_Region', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Region
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Region AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Region hds
        USING stg.Region stage 
        ON hds.[RegionID] = stage.[RegionID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[RegionDescription] = stage.[RegionDescription],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([RegionID], [RegionDescription], [EtlInsertTime])
            VALUES (stage.[RegionID], stage.[RegionDescription], @CurrentDATE);

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