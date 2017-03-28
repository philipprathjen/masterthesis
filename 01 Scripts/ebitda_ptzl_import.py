import pandas as pd
import numpy as np
import difflib
import os
import db_management as dbm

## Import the database, the identifiers
database = pd.read_excel('Database.xlsx', 'database', index_col=0, header=0, na_values=['NA'])
id_consol = pd.read_excel('identifiers.xlsx', 'consol', index_col=0, header=0, na_values=['NA'])

poetzl_comp_data = pd.read_excel('../Poetzl/masterdata_Prod_130522.xls', 'Sheet1', index_col=0, header=0, na_values=['NA'])

x = []

for row in poetzl_comp_data.iterrows():
    x.append(row)
ccca = 0
for i in range(0, len(x)):
    name = x[i][0]
    gvkey = x[i][1][0]
    year = x[i][1][1]
    ebitda = x[i][1][25]
    
    try:
        dbname = dbm.find_comp(gvkey, id_consol)[0]
    except:
        pass
    try:    
        dbname = dbm.match_name_consol(name, id_consol)[0]
    except:
        pass

    db_key = dbm.create_db_id(dbname, year) #create the db_key
    cci = 0 # counter to check if the entry exists
    try:
        database.get_value(db_key, "company")
        cci = 1 ### the entry already exists
    except: 
        cci = 0 # the entry does not exist yet
    if cci == 0: # this means that the entry does not exist yet
        database = dbm.create_company_year(db_key, database)

    #print(db_key, "ebitda", ebitda)
    database = dbm.simple_new_db_entry(db_key, "ebitda", ebitda, database)
    ccca +=1
    if ccca == 30:
        ccca = 0
        dbm.save_database(database)

dbm.save_database(database)
os.system('say "Philipp. Your program has finished."')
