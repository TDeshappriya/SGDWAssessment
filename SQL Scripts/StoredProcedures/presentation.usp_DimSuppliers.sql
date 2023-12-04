IF OBJECT_ID('presentation.usp_DimSuppliers', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimSuppliers
GO
CREATE PROCEDURE presentation.usp_DimSuppliers AS
BEGIN
    BEGIN TRANSACTION
    BEGIN TRY
        
		DROP TABLE #TEMP;

		SELECT c.[SupplierID],
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
				c.[HomePage],
				c.EtlInsertTime
		INTO #TEMP
		FROM hds.Suppliers c
	


		DROP TABLE #NewRecords

		SELECT c.[SupplierID],
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
				c.[HomePage],
				c.EtlInsertTime
        INTO #NewRecords
        FROM #Temp AS c
        LEFT JOIN [presentation].[DimSuppliers] AS pc
          ON c.[SupplierID] = pc.[SupplierID]
        WHERE pc.[SupplierID] IS NULL

		DROP TABLE #UpdatedRecords

		SELECT c.[SupplierID],
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
				c.[HomePage],
				c.EtlInsertTime
        INTO #UpdatedRecords
        FROM #Temp AS c
        INNER JOIN [presentation].[DimSuppliers] AS pc
          ON c.[SupplierID] = pc.[SupplierID]
        WHERE c.[CompanyName] <> pc.[CompanyName]
				OR c.[ContactName] <> pc.[CompanyName]
				OR c.[ContactTitle] <> pc.[ContactTitle]
				OR c.[Address] <> pc.[Address]
				OR c.[City] <> pc.[City]
				OR c.[Region] <> pc.[Region]
				OR c.[PostalCode] <> pc.[PostalCode]
				OR c.[Country] <> pc.[Country]
				OR c.[Phone] <> pc.[Phone]
				OR c.[Fax] <> pc.[Fax]
				OR c.[HomePage] <> pc.[HomePage]

		INSERT INTO [presentation].[DimSuppliers] (
				[SupplierID],
				[CompanyName],
				[ContactName],
				[ContactTitle],
				[Address],
				[City],
				[Region],
				[PostalCode],
				[Country],
				[Phone],
				[Fax],
				[HomePage],
				[EtlProcessdate])
          (SELECT new.[SupplierID],
				new.[CompanyName],
				new.[ContactName],
				new.[ContactTitle],
				new.[Address],
				new.[City],
				new.[Region],
				new.[PostalCode],
				new.[Country],
				new.[Phone],
				new.[Fax],
				new.[HomePage],
				new.EtlInsertTime
          FROM #NewRecords AS new)	

		UPDATE  [presentation].[DimSuppliers] 
        SET [SupplierID] = t.[SupplierID],
			[CompanyName] = t.[CompanyName],
			[ContactName] = t.[ContactName],
			[ContactTitle] = t.[ContactTitle],
			[Address] = t.[Address],
			[City] = t.[City],
			[Region] = t.[Region],
			[PostalCode] = t.[PostalCode],
			[Country] = t.[Country],
			[Phone] = t.[Phone],
			[Fax] = t.[Fax],
			[HomePage] = t.[HomePage],
			EtlProcessdate = t.EtlInsertTime,
			EtlUpdatedate = GETDATE()     
        FROM #UpdatedRecords AS t
        WHERE [presentation].[DimSuppliers].[SupplierID] = t.[SupplierID]


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