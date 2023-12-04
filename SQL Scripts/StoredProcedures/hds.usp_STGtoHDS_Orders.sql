IF OBJECT_ID('hds.usp_STGtoHDS_Orders', 'P') IS NOT NULL
    DROP PROCEDURE hds.usp_STGtoHDS_Orders
GO
CREATE PROCEDURE hds.usp_STGtoHDS_Orders AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        DECLARE @CurrentDATE AS DATETIME2(7);
        SET @CurrentDATE = GETDATE();

        MERGE hds.Orders hds
        USING stg.Orders stage 
        ON hds.[OrderID] = stage.[OrderID]

        WHEN MATCHED THEN
            UPDATE SET 
                hds.[CustomerID] = stage.[CustomerID],
                hds.[EmployeeID] = stage.[EmployeeID],
                hds.[OrderDate] = stage.[OrderDate],
                hds.[RequiredDate] = stage.[RequiredDate],
                hds.[ShippedDate] = stage.[ShippedDate],
                hds.[ShipVia] = stage.[ShipVia],
                hds.[Freight] = stage.[Freight],
                hds.[ShipName] = stage.[ShipName],
                hds.[ShipAddress] = stage.[ShipAddress],
                hds.[ShipCity] = stage.[ShipCity],
                hds.[ShipRegion] = stage.[ShipRegion],
                hds.[ShipPostalCode] = stage.[ShipPostalCode],
                hds.[ShipCountry] = stage.[ShipCountry],
                hds.[EtlInsertTime] = @CurrentDATE

        WHEN NOT MATCHED BY TARGET THEN 
            INSERT ([OrderID], [CustomerID], [EmployeeID], [OrderDate], [RequiredDate], [ShippedDate], [ShipVia], [Freight], [ShipName], [ShipAddress], [ShipCity], [ShipRegion], [ShipPostalCode], [ShipCountry], [EtlInsertTime])
            VALUES (stage.[OrderID], stage.[CustomerID], stage.[EmployeeID], stage.[OrderDate], stage.[RequiredDate], stage.[ShippedDate], stage.[ShipVia], stage.[Freight], stage.[ShipName], stage.[ShipAddress], stage.[ShipCity], stage.[ShipRegion], stage.[ShipPostalCode], stage.[ShipCountry], @CurrentDATE);

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