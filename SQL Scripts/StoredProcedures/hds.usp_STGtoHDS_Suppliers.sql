IF OBJECT_ID('hds.usp_STGtoHDS_Suppliers', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Suppliers
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Suppliers AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Suppliers hds
        USING stg.Suppliers stage 
        ON hds.[SupplierID] = stage.[SupplierID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[CompanyName] = stage.[CompanyName],
                hds.[ContactName] = stage.[ContactName],
                hds.[ContactTitle] = stage.[ContactTitle],
                hds.[Address] = stage.[Address],
                hds.[City] = stage.[City],
                hds.[Region] = stage.[Region],
                hds.[PostalCode] = stage.[PostalCode],
                hds.[Country] = stage.[Country],
                hds.[Phone] = stage.[Phone],
                hds.[Fax] = stage.[Fax],
                hds.[HomePage] = stage.[HomePage],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([SupplierID], [CompanyName], [ContactName], [Address], [City], [Region], [PostalCode], [Country], [Phone], [Fax], [HomePage], [EtlInsertTime])
            VALUES (stage.[SupplierID], stage.[CompanyName], stage.[ContactName], stage.[Address], stage.[City], stage.[Region], stage.[PostalCode], stage.[Country], stage.[Phone], stage.[Fax], stage.[HomePage], @CurrentDATE);

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