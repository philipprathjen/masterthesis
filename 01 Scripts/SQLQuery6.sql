/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
SELECT [BvD_ID_number]
      ,[NAME_INTERNAT]
      ,[NAME_NATIVE]
      ,[Postcode]
      ,[City]
      ,[City_native]
      ,[Country]
      ,[Country_ISO_code]
  FROM [Max-Planck].[dbo].[Contact_info]
  WHERE [Country] = 'Germany'