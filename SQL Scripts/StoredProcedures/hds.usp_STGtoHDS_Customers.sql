IF OBJECT_ID('hds.usp_STGtoHDS_Customers', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Customers
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Customers AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Customers hds
        USING stg.Customers stage 
        ON hds.[CustomerID] = stage.[CustomerID]

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
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([CustomerID], [CompanyName], [ContactName], [ContactTitle], [Address], [City], [Region], [PostalCode], [Country], [Phone], [Fax], [EtlInsertTime])
            VALUES (stage.[CustomerID], stage.[CompanyName], stage.[ContactName], stage.[ContactTitle], stage.[Address], stage.[City], stage.[Region], stage.[PostalCode], stage.[Country], stage.[Phone], stage.[Fax], @CurrentDATE);

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