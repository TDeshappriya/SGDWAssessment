
IF OBJECT_ID('presentation.usp_DimCustomer', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimCustomer
GO
CREATE PROCEDURE presentation.usp_DimCustomer AS
BEGIN
    
    BEGIN TRY
        
		

		SELECT c.[CustomerID],
				c.[CompanyName],
				c.[ContactName],
				c.[ContactTitle],
				c.[Address],
				c.[City],
				c.[Region],
				c.[PostalCode],
				c.[Country],
				c.[Phone],
				c.[Fax],
				cd.[CustomerDesc],
				c.EtlInsertTime
		INTO #TEMP
		FROM hds.Customers c
		LEFT JOIN hds.CustomerCustomerDemo ccd
		ON c.CustomerID = ccd.CustomerID
		LEFT JOIN hds.CustomerDemographics cd
		ON cd.CustomerTypeID = ccd.CustomerTypeID


		INSERT INTO presentation.DimCustomer
		(
			CustomerID,
			CompanyName,
			ContactName,
			ContactTitle,
			Address,
			City,
			Region,
			PostalCode,
			Country,
			Phone,
			Fax,
			CustomerDesc,
			IsActive,
			EtlProcessdate,
			EtlUpdatedate
		)
		SELECT
			h.CustomerID,
			h.CompanyName,
			h.ContactName,
			h.ContactTitle,
			h.Address,
			h.City,
			h.Region,
			h.PostalCode,
			h.Country,
			h.Phone,
			h.Fax,
			h.CustomerDesc,
			1 AS IsActive, 
			h.EtlInsertTime AS EtlProcessdate,
			NULL AS EtlUpdatedate
		FROM
			#TEMP h
		WHERE
			NOT EXISTS (
				SELECT 1
				FROM presentation.DimCustomer d
				WHERE h.CustomerID = d.CustomerID
				AND d.IsActive = 1
			);

		UPDATE d
		SET
			d.IsActive = 0, 
			d.EtlUpdatedate = GETDATE()
		FROM
			presentation.DimCustomer d
		INNER JOIN
			#TEMP h ON d.CustomerID = h.CustomerID
		WHERE
			d.IsActive = 1
			AND (
				d.CompanyName <> h.CompanyName
				OR d.ContactName <> h.ContactName
				OR d.ContactTitle <> h.ContactTitle
				OR d.Address <> h.Address
				OR d.City <> h.City
				OR d.Region <> h.Region
				OR d.PostalCode <> h.PostalCode
				OR d.Country <> h.Country
				OR d.Phone <> h.Phone
				OR d.Fax <> h.Fax
				OR d.CustomerDesc <> h.CustomerDesc
			);

		INSERT INTO presentation.DimCustomer
		(
			CustomerID,
			CompanyName,
			ContactName,
			ContactTitle,
			Address,
			City,
			Region,
			PostalCode,
			Country,
			Phone,
			Fax,
			CustomerDesc,
			IsActive,
			EtlProcessdate,
			EtlUpdatedate
		)
		SELECT
			h.CustomerID,
			h.CompanyName,
			h.ContactName,
			h.ContactTitle,
			h.Address,
			h.City,
			h.Region,
			h.PostalCode,
			h.Country,
			h.Phone,
			h.Fax,
			h.CustomerDesc,
			1 AS IsActive,
			h.EtlInsertTime AS EtlProcessdate,
			NULL AS EtlUpdatedate
		FROM
			#TEMP h
		INNER JOIN
			presentation.DimCustomer d ON h.CustomerID = d.CustomerID
		WHERE
			d.IsActive = 0;

		DROP TABLE #TEMP;
        
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