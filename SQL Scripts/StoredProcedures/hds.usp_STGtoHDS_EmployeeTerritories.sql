IF OBJECT_ID('hds.usp_STGtoHDS_EmployeeTerritories', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_EmployeeTerritories
GO
CREATE PROCEDURE hds.usp_STGtoHDS_EmployeeTerritories AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.EmployeeTerritories hds
        USING stg.EmployeeTerritories stage 
        ON hds.[EmployeeID] = stage.[EmployeeID] AND hds.[TerritoryID] = stage.[TerritoryID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([EmployeeID], [TerritoryID], [EtlInsertTime])
            VALUES (stage.[EmployeeID], stage.[TerritoryID], @CurrentDATE);

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