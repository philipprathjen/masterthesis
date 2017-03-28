/****** Skript für SelectTopNRows-Befehl aus SSMS ******/
SELECT TOP (10)
	   [BvD_ID_number]
      ,[Ticker_symbol]
      ,[ISIN_number]
	  ,[Country]
	  ,[ROE_using_P_L_before_tax_percentage]
  FROM [Max-Planck].[dbo].[Identifiers]
  INNER JOIN [Max-Planck].[dbo].[Contact_info]
	ON [Max-Planck].[dbo].[Identifiers].[BvD_ID_number] = [Max-Planck].[dbo].[Contact_info].[BvD_ID_number]
  INNER JOIN [Max-Planck].[dbo].[Key_financials_EUR]
	ON [Max-Planck].[dbo].[Contact_info].[BvD_ID_number] = [Max-Planck].[dbo].[Key_financials_EUR].[BvD_ID_number]