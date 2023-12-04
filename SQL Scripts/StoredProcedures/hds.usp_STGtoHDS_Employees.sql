IF OBJECT_ID('hds.usp_STGtoHDS_Employees', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Employees
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Employees AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Employees hds
        USING stg.Employees stage 
        ON hds.[EmployeeID] = stage.[EmployeeID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[LastName] = stage.[LastName],
                hds.[FirstName] = stage.[FirstName],
                hds.[Title] = stage.[Title],
                hds.[TitleOfCourtesy] = stage.[TitleOfCourtesy],
                hds.[BirthDate] = stage.[BirthDate],
                hds.[HireDate] = stage.[HireDate],
                hds.[Address] = stage.[Address],
                hds.[City] = stage.[City],
                hds.[Region] = stage.[Region],
                hds.[PostalCode] = stage.[PostalCode],
                hds.[Country] = stage.[Country],
                hds.[HomePhone] = stage.[HomePhone],
                hds.[Extension] = stage.[Extension],
                hds.[Photo] = stage.[Photo],
                hds.[Notes] = stage.[Notes],
                hds.[ReportsTo] = stage.[ReportsTo],
                hds.[PhotoPath] = stage.[PhotoPath],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([EmployeeID], [LastName], [FirstName], [Title], [TitleOfCourtesy], [BirthDate], [HireDate], [Address], [City], [Region], [PostalCode], [Country], [HomePhone], [Extension], [Photo], [Notes], [ReportsTo], [PhotoPath], [EtlInsertTime])
            VALUES (stage.[EmployeeID], stage.[LastName], stage.[FirstName], stage.[Title], stage.[TitleOfCourtesy], stage.[BirthDate], stage.[HireDate], stage.[Address], stage.[City], stage.[Region], stage.[PostalCode], stage.[Country], stage.[HomePhone], stage.[Extension], stage.[Photo], stage.[Notes], stage.[ReportsTo], stage.[PhotoPath], @CurrentDATE);

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