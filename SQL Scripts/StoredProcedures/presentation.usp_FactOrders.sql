IF OBJECT_ID('presentation.usp_FactOrders', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_FactOrders
GO
CREATE PROCEDURE presentation.usp_FactOrders AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY


		DECLARE @MaxDateSK INT;

		SET @MaxDateSK = COALESCE((SELECT MAX(OrderDateSK) AS MaxDateSK FROM presentation.FactOrders), '19900101');

		INSERT INTO presentation.FactOrders(
				CustomerSK, 
				EmployeeSK, 
				OrderDateSK,
				RequiredDateSK,
				ShippedDateSK,
				ShipperSK,
				ProductSK,
				ProductCategorySK,
				SupplierSK,
				OrderID,
				TotalOrderFreight,
				UnitPrice,
				Quantity,
				Discount,
				EtlProcessdate)
		SELECT COALESCE(dc.CustomerSK, -999999999),
			COALESCE(de.EmployeeSK, -999999999),
			COALESCE(dd1.DateSK, -999999999),
			COALESCE(dd2.DateSK, -999999999),
			COALESCE(dd3.DateSK, -999999999),
			COALESCE(ds.ShipperSK, -999999999),
			COALESCE(dp.ProductSK, -999999999),
			COALESCE(dpc.ProductCategorySK, -999999999),
			COALESCE(dss.SupplierSK, -999999999),
			o.OrderID AS OrderID,
			o.Freight AS TotalOrderFreight,
			od.UnitPrice,
			od.Quantity,
			od.Discount,
			GETDATE()
		FROM hds.Orders o 
		INNER JOIN presentation.DimEmployee de 
		ON o.EmployeeID = de.EmployeeiD
		INNER JOIN presentation.DimCustomer dc 
		ON dc.CustomerID = o.CustomerID
		AND IsActive = 1
		INNER JOIN presentation.DimDate dd1
		ON dd1.Date = o.OrderDate
		LEFT JOIN presentation.DimDate dd2
		ON dd2.Date = o.RequiredDate
		LEFT JOIN presentation.DimDate dd3
		ON dd3.Date = o.ShippedDate
		INNER JOIN presentation.DimShipper ds
		ON ds.ShipperID = o.ShipVia
		INNER JOIN hds.OrderDetails od
		ON od.OrderID = o.OrderID
		INNER JOIN hds.Products p
		ON p.ProductID = od.ProductID
		INNER JOIN presentation.DimProduct dp
		ON dp.ProductID = p.ProductID
		INNER JOIN presentation.DimSuppliers dss
		ON dss.SupplierID = p.SupplierID
		INNER JOIN presentation.DimProductCategory dpc
		ON dpc.CategoryID = p.CategoryID
		WHERE dd1.DateSK > @MaxDateSK


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
