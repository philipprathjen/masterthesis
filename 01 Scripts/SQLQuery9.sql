/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
SELECT  [AutoIncrementId]
      ,[Patents062016].[dbo].[Patents].[PatPublnNr]
      ,[ApplnNr]
	  ,[publn_date]
	  ,[publn_first_grant]
	  ,[person_name]
      ,[person_ctry_code]
      ,[BvDID]
      ,[Patents062016].[dbo].[Patents].[appln_id]
  FROM [Patents062016].[dbo].[Owners]
  INNER JOIN [Patents062016].[dbo].[Patents]
  ON [Patents062016].[dbo].[Patents].[appln_id] = [Patents062016].[dbo].[Owners].[appln_id]
  WHERE [person_ctry_code] = 'DE' AND [publn_date] < '2006-03-22'