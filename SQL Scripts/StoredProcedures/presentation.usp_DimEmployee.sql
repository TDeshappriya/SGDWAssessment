IF OBJECT_ID('presentation.usp_DimEmployee', 'P') IS NOT NULL
    DROP PROCEDURE presentation.usp_DimEmployee
GO
CREATE PROCEDURE presentation.usp_DimEmployee AS
BEGIN
    
    BEGIN TRY
        
		

		SELECT c.[EmployeeID],
				c.[LastName],
				c.[FirstName],
				c.[Title],
				c.[TitleOfCourtesy],
				c.[BirthDate],
				c.[HireDate],
				c.[Address],
				c.[City],
				c.[Region],
				c.[PostalCode],
				c.[Country],
				c.[HomePhone],
				c.[Extension],
				c.[Notes],
				c.[ReportsTo],
				c.[PhotoPath],
				STRING_AGG(t.[TerritoryDescription], ', ') AS [TerritoryDescription],
				STRING_AGG(r.[RegionDescription], ', ') AS [RegionDescription],
				c.EtlInsertTime
		INTO #TEMP
		FROM hds.Employees c
		LEFT JOIN hds.EmployeeTerritories et
		ON c.EmployeeID = et.EmployeeID
		LEFT JOIN hds.Territories t
		ON et.TerritoryID = t.TerritoryID
		LEFT JOIN hds.Region r
		ON t.RegionID = r.RegionID
		GROUP BY c.[EmployeeID],
				c.[LastName],
				c.[FirstName],
				c.[Title],
				c.[TitleOfCourtesy],
				c.[BirthDate],
				c.[HireDate],
				c.[Address],
				c.[City],
				c.[Region],
				c.[PostalCode],
				c.[Country],
				c.[HomePhone],
				c.[Extension],
				c.[Notes],
				c.[ReportsTo],
				c.[PhotoPath],
				c.EtlInsertTime



		

		SELECT c.[EmployeeID],
				c.[LastName],
				c.[FirstName],
				c.[Title],
				c.[TitleOfCourtesy],
				c.[BirthDate],
				c.[HireDate],
				c.[Address],
				c.[City],
				c.[Region],
				c.[PostalCode],
				c.[Country],
				c.[HomePhone],
				c.[Extension],
				c.[Notes],
				c.[ReportsTo],
				c.[PhotoPath],
				c.[TerritoryDescription],
				c.[RegionDescription],
				c.EtlInsertTime
        INTO #NewRecords
        FROM #Temp AS c
        LEFT JOIN [presentation].[DimEmployee] AS pc
          ON c.[EmployeeID] = pc.[EmployeeID]
        WHERE pc.[EmployeeID] IS NULL

		

		SELECT c.[EmployeeID],
				c.[LastName],
				c.[FirstName],
				c.[Title],
				c.[TitleOfCourtesy],
				c.[BirthDate],
				c.[HireDate],
				c.[Address],
				c.[City],
				c.[Region],
				c.[PostalCode],
				c.[Country],
				c.[HomePhone],
				c.[Extension],
				c.[Notes],
				c.[ReportsTo],
				c.[PhotoPath],
				c.[TerritoryDescription],
				c.[RegionDescription],
				c.EtlInsertTime
        INTO #UpdatedRecords
        FROM #Temp AS c
        INNER JOIN [presentation].[DimEmployee] AS pc
          ON c.[EmployeeID] = pc.[EmployeeID]
        WHERE c.[LastName] <> pc.[LastName]
				OR c.[FirstName] <> pc.[LastName]
				OR c.[Title] <> pc.[Title]
				OR c.[TitleOfCourtesy] <> pc.[TitleOfCourtesy]
				OR c.[BirthDate] <> pc.[BirthDate]
				OR c.[HireDate] <> pc.[HireDate]
				OR c.[Address] <> pc.[Address]
				OR c.[City] <> pc.[City]
				OR c.[Region] <> pc.[Region]
				OR c.[PostalCode] <> pc.[PostalCode]
				OR c.[Country] <> pc.[Country]
				OR c.[HomePhone] <> pc.[HomePhone]
				OR c.[Extension] <> pc.[Extension]
				OR c.[Notes] <> pc.[Notes]
				OR c.[ReportsTo] <> pc.[ReportsTo]
				OR c.[PhotoPath] <> pc.[PhotoPath]
				OR c.[TerritoryDescription] <> pc.[TerritoryDescription]
				OR c.[RegionDescription] <> pc.[RegionDescription]

		INSERT INTO [presentation].[DimEmployee] (
				[EmployeeID],
				[LastName],
				[FirstName],
				[Title],
				[TitleOfCourtesy],
				[BirthDate],
				[HireDate],
				[Address],
				[City],
				[Region],
				[PostalCode],
				[Country],
				[HomePhone],
				[Extension],
				[Notes],
				[ReportsTo],
				[PhotoPath],
				[TerritoryDescription],
				[RegionDescription],
				[EtlProcessdate])
          (SELECT new.[EmployeeID],
				new.[LastName],
				new.[FirstName],
				new.[Title],
				new.[TitleOfCourtesy],
				new.[BirthDate],
				new.[HireDate],
				new.[Address],
				new.[City],
				new.[Region],
				new.[PostalCode],
				new.[Country],
				new.[HomePhone],
				new.[Extension],
				new.[Notes],
				new.[ReportsTo],
				new.[PhotoPath],
				new.[TerritoryDescription],
				new.[RegionDescription],
				new.EtlInsertTime
          FROM #NewRecords AS new)	

		UPDATE  [presentation].[DimEmployee] 
        SET [EmployeeID] = t.[EmployeeID],
			[LastName] = t.[LastName],
			[FirstName] = t.[FirstName],
			[Title] = t.[Title],
			[TitleOfCourtesy] = t.[TitleOfCourtesy],
			[BirthDate] = t.[BirthDate],
			[HireDate] = t.[HireDate],
			[Address] = t.[Address],
			[City] = t.[City],
			[Region] = t.[Region],
			[PostalCode] = t.[PostalCode],
			[Country] = t.[Country],
			[HomePhone] = t.[HomePhone],
			[Extension] = t.[Extension],
			[Notes] = t.[Notes],
			[ReportsTo] = t.[ReportsTo],
			[PhotoPath] = t.[PhotoPath],
			[TerritoryDescription] = t.[TerritoryDescription],
			[RegionDescription] = t.[RegionDescription],
			EtlProcessdate = t.EtlInsertTime,
			EtlUpdatedate = GETDATE()     
        FROM #UpdatedRecords AS t
        WHERE [presentation].[DimEmployee].[EmployeeID] = t.[EmployeeID]

		DROP TABLE #TEMP;
		DROP TABLE #NewRecords;
		DROP TABLE #UpdatedRecords;
        
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