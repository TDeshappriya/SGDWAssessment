IF OBJECT_ID('hds.RefreshHDSTables', 'P') IS NOT NULL
    DROP PROCEDURE hds.RefreshHDSTables
GO
CREATE PROCEDURE hds.RefreshHDSTables AS
BEGIN
    
    BEGIN TRY


		EXEC hds.usp_STGtoHDS_Categories;
		EXEC hds.usp_STGtoHDS_CustomerDemographics;
		EXEC hds.usp_STGtoHDS_CustomerCustomerDemo;
		EXEC hds.usp_STGtoHDS_Customers;
		EXEC hds.usp_STGtoHDS_Employees;
		EXEC hds.usp_STGtoHDS_EmployeeTerritories;
		EXEC hds.usp_STGtoHDS_OrderDetails;
		EXEC hds.usp_STGtoHDS_Orders;
		EXEC hds.usp_STGtoHDS_Products;
		EXEC hds.usp_STGtoHDS_Region;
		EXEC hds.usp_STGtoHDS_Shippers;
		EXEC hds.usp_STGtoHDS_Suppliers;
		EXEC hds.usp_STGtoHDS_Territories;

        
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