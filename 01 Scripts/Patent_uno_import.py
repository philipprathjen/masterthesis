import pandas as pd
import numpy as np
import difflib
import os
import db_management as dbm

## Import the database, the identifiers
database = pd.read_excel('Database.xlsx', 'database', index_col=0, header=0, na_values=['NA'])
id_consol = pd.read_excel('identifiers.xlsx', 'consol', index_col=0, header=0, na_values=['NA'])

poetzl_patents_PL = pd.read_excel('../Poetzl/WPC.xlsx', 'PL', index_col=0, header=0, na_values=['NA'])
poetzl_patents_NPL =  pd.read_excel('../Poetzl/WPC.xlsx', 'NPL', index_col=0, header=0, na_values=['NA'])

#print(poetzl_patents_NPL)
#xxx = poetzl_patents_NPL.get_value("babw-c.dta", 2011)
#print(xxx)
x = []
exemptions = []
for row in poetzl_patents_PL.iterrows():
    x.append(row)
ccca=0
for i in range(0, len(x)):
    poetzl_id = x[i][0]
    data = x[i][1]
    annual_data = {}
    ### Get the company from the database
    try:
        dbname = dbm.find_comp(poetzl_id, id_consol)[0]
        found = 1
    except:
        category="breakup"
        found = 0

    if found ==1:
        for elem in data.iteritems():
            annual_data[elem[0]] = elem[1]
        for item in annual_data:
            year = item
            db_key = dbm.create_db_id(dbname, year)
            if found == 0:
                database = dbm.create_company_year(db_key, database)
            value = annual_data[item]        
            print(db_key, "WPC_PL", value)
            database = dbm.simple_new_db_entry(db_key, "WPC_PL", value, database)
        ccca +=1
        if ccca == 15:
            ccca = 0
            dbm.save_database(database)


xx = []
exemptions = []
for row in poetzl_patents_NPL.iterrows():
    xx.append(row)
ccca=0
for i in range(0, len(xx)):
    poetzl_id = xx[i][0]
    data = xx[i][1]
    annual_data = {}
    ### Get the company from the database
    try:
        dbname = dbm.find_comp(poetzl_id, id_consol)[0]
        found = 1
    except:
        category="breakup"
        found = 0


    if found ==1:
        for elem in data.iteritems():
            annual_data[elem[0]] = elem[1]
        for item in annual_data:
            year = item
            db_key = dbm.create_db_id(dbname, year)
            if found == 0:
                database = dbm.create_company_year(db_key, database)
            value = annual_data[item]        
            print(db_key, "WPC_NPL", value)
            database = dbm.simple_new_db_entry(db_key, "WPC_NPL", value, database)
        ccca +=1
        if ccca == 15:
            ccca = 0
            dbm.save_database(database)


dbm.save_database(database)
os.system('say "Philipp. Your program has finished."')









