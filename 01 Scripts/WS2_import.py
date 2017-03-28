import pandas as pd
import numpy as np
import difflib
import os
import db_management as dbm

## Import the database, the identifiers
database = pd.read_excel('Database.xlsx', 'database', index_col=0, header=0, na_values=['NA'])
id_consol = pd.read_excel('identifiers.xlsx', 'consol', index_col=0, header=0, na_values=['NA'])

worldscope_data = pd.read_excel('../Financials/Financial_TS_WS.xlsx', 'WS2', index_col=0, header=0, na_values=['NA'])

### Define categories to be imported

cat = {
	'WS.SICCode': "sic", 
	'WS.CapitalExpendituresCFStmt': "capex",
	'WS.CostOfGoodsSold': "cogs",
	'WS.EarningsBeforeInterestAndTaxes': "ebit"
}


### EUR
### Scaling: Millions
### Source: Thomson Financial
##### Split the data into list elements
x = []
for row in worldscope_data.iterrows():
	x.append(row)
ccca = 0
for i in range(0, len(x)):
	db_key = ""
	name = x[i][0]
	isin = x[i][1][1]
	y = {}
	category = x[i][1][3]
	try:
		dbname = dbm.find_comp(isin, id_consol)[0]
	except:
		category="breakup"
		#### this will help skip the database entry
	y[2015] = x [i][1][4]
	y[2014] = x [i][1][5]
	y[2013] = x [i][1][6]
	y[2012] = x [i][1][7]
	y[2011] = x [i][1][8]
	y[2010] = x [i][1][9]
	y[2009] = x [i][1][10]
	y[2008] = x [i][1][11]
	y[2007] = x [i][1][12]
	y[2006] = x [i][1][13]
	y[2005] = x [i][1][14]
	y[2004] = x [i][1][15]
	y[2003] = x [i][1][16]
	y[2002] = x [i][1][17]
	y[2001] = x [i][1][18]
	y[2000] = x [i][1][19]
	y[1999] = x [i][1][20]
	y[1998] = x [i][1][21]
	y[1997] = x [i][1][22]
	y[1996] = x [i][1][23]
	y[1995] = x [i][1][24]
	y[1994] = x [i][1][25]

	try:
		dbcat = cat[category]
		input_dummy = 1
	except:
		input_dummy = 0

	if input_dummy ==1:
		try:
			str_len = len(y[2015])
			sic_dummy = 1
		except:
			sic_dummy = 0 
		if dbcat == "sic" and sic_dummy == 1:
			#print(len(y[2015]), y[2015][:4], y[2015][5:10], y[2015][10:14], y[2015][15:20])
			str_len = len(y[2015])
			sic_str = y[2015]
			sic_list = []
			while str_len>0:
				item = sic_str[:4]
				sic_list.append(item)
				try:
					sic_str = sic_str[5:]
					str_len = str_len - 5
				except:
					str_len = 0
				print(str_len)
				print(sic_list)

		for year in range(1994,2016):
			db_key = dbm.create_db_id(dbname, year)
			cci = 0
			try:
				database.get_value(db_key, "company")
				cci = 1 #counter to check if entry exists
			except:
				cci = 0 # the entry does not exist yet
			if cci == 1:
				if cat[category] != "sic":
					value = y[year] / dbm.inflation_index[str(year)]
					#print("Not SIC: ", db_key, cat[category], value)
					dbm.simple_new_db_entry(db_key, cat[category], value, database)
				if cat[category] == "sic":
					siccount = 1
					for sic in sic_list:
						sic_c = "sic%s" %(siccount)
						siccount += 1
						#print("SIC: ", db_key, sic_c, sic)
						dbm.simple_new_db_entry(db_key, sic_c, sic, database)

			ccca +=1
			if ccca == 80:
				ccca = 0
				dbm.save_database(database)
			if ccca == 0:
				print(i, "printed")
			else:
				print(i)

dbm.save_database(database)				
os.system('say "Philipp. Your program has finished."')
