import pandas as pd
import numpy as np
import difflib
import os
import db_management as dbm


## Import the database, the identifiers
database = pd.read_excel('Database.xlsx', 'database', index_col=0, header=0, na_values=['NA'])
id_consol = pd.read_excel('identifiers.xlsx', 'consol', index_col=0, header=0, na_values=['NA'])

bvd_data = pd.read_excel('../160831_Amadeus/CompanyInfo.xlsx', 'Results', index_col=0, header=0, na_values=['NA'])

x = []
for row in bvd_data.iterrows():
	x.append(row)

##### Naics Codes are based on 2012 classification
secondary_list = []
for i in range(0, len(x)):
	name = x[i][1][0]
	isin = x[i][1][2]  
	nic = x[i][1][6]
	nace_prim = x[i][1][7]
	#nace_sec = x[i][1][8] ### Multiple will be in line here
	naics_core = x[i][1][9]
	naics_prim = x[i][1][10] ### Multiple will be in line here
	#naics_sec = x[i][1][11] ### Multiple will be in line here
	sic_core = x[i][1][12]
	sic_prim = x[i][1][13]
	#sic_sec = x[i][1][14] ### Multiple will be in line here
	print(x[i][1][14])
	#os.system('say "Hello Teo Zamorano! What are you doing?"')
	# get the name
	if name != "nan" and name != "NaN":
		compname = name
		compisin = isin
		counter = 0

		# get the company name
		try:
			dbname = dbm.find_comp(compisin, id_consol)[0]
		except:
			dbname = ""
	counter += 1
	

	if counter == 1 and dbname!= "":
		### input the data from first row
		for year in range(1994, 2016):
			## get the element and write it to the database
			db_key = dbm.create_db_id(dbname, year)
			database = dbm.simple_new_db_entry(db_key, "nic", nic, database)
			database = dbm.simple_new_db_entry(db_key, "nace1", nace_prim, database)
			# if nace_prim != nace_sec:
			# 	dbm.new_db_entry(db_key, "nace2", nace_sec, database)
			# 	nace_dummy = 3
			# else:
			# 	nace_dummy = 2
			database = dbm.simple_new_db_entry(db_key, "naics1", naics_core, database)
			database = dbm.simple_new_db_entry(db_key, "naics2", naics_prim, database)
			# if naics_prim != naics_sec:
			# 	dbm.new_db_entry(db_key, "naics3", naics_sec, database)
			naics_dummy = 3
			# else:
			# 	naics_dummy = 3
			database = dbm.simple_new_db_entry(db_key, "sic1", sic_core, database)
			database = dbm.simple_new_db_entry(db_key, "sic2", sic_prim, database)
			# if sic_prim != sic_sec: 
			# 	dbm.new_db_entry(db_key, "sic3", sic_sec, database)
			# 	sic_dummy = 4
			# else:
			# 	sic_dummy = 3
			print(db_key)
	
	if counter > 1 and dbname!= "":
		### input the data from second row
		for year in range(1994, 2016):
			## get the element and write it to the database
			db_key = dbm.create_db_id(dbname, year)
			#nace_entry = "nace%s" %(nace_dummy)
			naics_entry = "naics%s" %(naics_dummy)
			#sic_entry = "sic%s" %(sic_dummy) 

			#nace_dummy += 1
			naics_dummy += 1
			#sic_dummy += 1

			database = dbm.simple_new_db_entry(db_key, naics_entry, naics_prim, database)
			print(db_key)


dbm.save_database(database)				
os.system('say "Philipp. Your program has finished."')
	## if nace_sec == nace_prim - drop nace_sec