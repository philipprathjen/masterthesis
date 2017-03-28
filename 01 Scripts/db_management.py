import pandas as pd
import numpy as np
import difflib
import os

database = pd.read_excel('Database.xlsx', 'database', index_col=0, header=0, na_values=['NA'])
id_consol = pd.read_excel('identifiers.xlsx', 'consol', index_col=0, header=0, na_values=['NA'])

def save_id_file(db):
    writer = pd.ExcelWriter('identifiers.xlsx', engine='xlsxwriter')
    db.to_excel(writer, sheet_name='consol')
    writer.save()

def save_database(db):
    writer = pd.ExcelWriter('database.xlsx', engine='xlsxwriter')
    db.to_excel(writer, sheet_name='database')
    writer.save()

def name_get_id(name, df):
    strname=str(name)
    key = df.get_value(strname,"identifier")
    return key
def name_get_gvkey(name, df):
    strname=str(name)
    key = df.get_value(strname,"gvkey")
    return key 
def name_get_cusip(name, df):
    strname=str(name)
    key = df.get_value(strname,"cusip")
    return key 
def name_get_isin(name, df):
    strname=str(name)
    key = df.get_value(strname,"isin")
    return key 
def name_get_poetzl(name, df):
    strname=str(name)
    key = df.get_value(strname,"poetzl")
    return key 
def name_get_pid(name, df):
    strname=str(name)
    key = df.get_value(strname,"PR_id")
    return key 
def find_comp(key, dbid):
    x = []
    tst = str(key)
    name=[]
    for row in dbid.iterrows():
        x.append(row)
    for i in range(0, len(x)):
        var1 = str(x[i][1][0])
        var2 = str(x[i][1][1])
        var3 = str(x[i][1][2])
        var4 = str(x[i][1][3])
        var5 = str(x[i][1][4])
        var6 = str(x[i][1][5])
        var7 = str(x[i][1][6])
        var8 = str(x[i][1][7])
        var9 = str(x[i][1][8])
        var10 = str(x[i][1][9])
        var11 = str(x[i][1][10])
        var12 = str(x[i][1][11])
        var13 = str(x[i][1][12])
        var14 = str(x[i][1][13])
        var15 = str(x[i][1][14])
        var16 = str(x[i][1][15])
        var17 = str(x[i][1][16])

        if tst == var1 or tst==var2 or tst ==var3 or tst == var4 or tst == var5 or tst == var6 or tst == var7 or tst == var8 or tst == var9 or tst == var10 or tst == var11 or tst == var12 or tst == var13 or tst == var14 or tst == var15 or tst == var16 or tst == var17:
            name.append(x[i][0])
    return name

def match_name_consol(givenname, iddb):
    namestr = str(givenname).upper()
    x = []
    namelist = []
    for row in iddb.iterrows():
        x.append(row)
    for i in range(0, len(x)):
        name = str(x[i][0])
        match_val = difflib.SequenceMatcher(None, namestr, name).ratio()
        if match_val > 0.5:
            namelist.append(name)
    i = 0
    current_max_val = 0
    current_max_len = 0
    current_max = 0
    element = 0
    for name in namelist:
        match = difflib.SequenceMatcher(None, namestr, name)
        match_val = difflib.SequenceMatcher(None, namestr, name).ratio()
        if match_val > current_max_val:
            current_max_val = match_val
            element_val = i
        try:
            match_len = match.find_longest_match(0,len(name),0,len(namestr))[2]
        except:
            match_len = match.find_longest_match(0,len(namestr),0,len(name))[2]
        try:
            mlen_ratio = match_len / len(namestr)
        except:
            mlen_ratio = 1
        if current_max_len < mlen_ratio:
            current_max_len = mlen_ratio
            element_len = i    
        match_mult = mlen_ratio * match_len
        if current_max < match_mult:
            current_max = match_mult
            selection = i    
        i += 1
    try:
        best = namelist[selection]
    except:
        best = "NA"
    return (best, current_max_val)

def create_db_id(companyName, year):
    name = str(companyName)
    ano = str(year)
    key = name + "[" + ano +"]"
    return key

def consol_entry(name, category, value):
    strname=str(name)
    column = str(category)
    current = ""
    try:
        current = id_consol.get_value(strname, column)
        current = str(current)
        if current != "nan" and current != value:
            response = ""
            while response != "y" and response != "n":
                q_text = "current: %s - new: %s. Are you sure you want to replace? [y/n]"%(current, value)
                response = input(q_text)
            if response == "y":
                id_consol.set_value(strname, column, value)
                print("Change made")
            else:
                response2 = ""
                q_text = "current: %s - new: %s. Add it to %s2 [y/n]"%(current, value, category)
                response2 = input(q_text)
                if response2 == "y":
                    category2 = "%s2" %category 
                    print(category2)
                    id_consol.set_value(strname, category2, value)
                    print("It was added to the second category")
                else:
                    print("No change was made")
        else:
            id_consol.set_value(strname, column, value)
            print("Category: ", column)
            print("The old value was: ", current)
            print("The new value is: ", value)
    except:
        print("Category: ", column)
        try:
            current = id_consol.get_value(strname, column)
            current = str(current)
            if current == value:
                print("This isin already exists in the database")
            else:
                print("The entry does not exist yet. Have you created it? create_company_consol()")
        except:
            print("The entry does not exist yet. Have you created it? create_company_consol()")

def create_company_consol(name, df):
    strname = str(name)
    try:
        x = df.get_value(strname, "isin")
        i = 0
    except:
        i = 1
    if i == 1:  
        df2 = pd.DataFrame({}, index=[strname]) 
        frames = [df, df2]
        result = pd.concat(frames)
    else:
        print('No change was made')
        result = df
    return result

def new_db_entry(db_key, category, value, db):
    strname=str(db_key)
    column = str(category)
    try:
        current = db.get_value(strname, column)
        current = str(current)
        if current != "nan" and current != "NaN" and current != "." and current != str(value):
            year = int(db_key[-5:-1])
            company = db_key[:-6]
            nid = create_db_id(company,year+1)
            fid = create_db_id(company,year-1)
            nidstr=str(nid)
            fidstr = str(fid)
            try:
                next_val = db.get_value(nid, column)
            except:
                next_val = "NaN"
            try:
                former_val = db.get_value(fid, column)
            except:
                former_val = "NaN"

            ask = 0
            try: 
                current_high = float(current) * 1.2
                current_mhigh = float(current) *1.1
                current_low = float(current) * 0.9
                current_mlow = float(current) * 0.8
                if current_high > value and value > current_mhigh:
                    ask = 1
                if current_low < value and value < current_mlow:
                    ask = 1
            except:
                pass
            if ask == 1: 
                print("Category: ", column)
                print("the former value is: ", former_val)
                print("the current value is: ", current, "replace??: ", value)
                print("the next value is: ", next_val)
                response = ""
                while response != "y" and response != "n":
                    response = input("Are you sure you want to replace? [y/n]: ")
                if response == "y":
                    db.set_value(strname, column, value)
                    print("Change made")
                else:
                    print("No change was made")
            else: 
                print("current value is: ", current, "- No change was made")
        else:
            db.set_value(strname, column, value)
            print("Category: ", column)
            print("The old value was: ", current)
            print("The new value is: ", value)
    except:
        print("Could not retrieve combination: ", strname, column)
        print("Does it exist? create_company_year" )

def simple_new_db_entry(db_key, category, value, db):
    strname=str(db_key)
    column = str(category)
    change_made = 0
    try:
        current = db.get_value(strname, column)
        current = str(current)
        if current != "nan" and current != "NaN" and current != "." and current != str(value):
            print("current value is: ", current, "- No change was made")
        else:
            db.set_value(strname, column, value)
            print("Category: ", column)
            print("The old value was: ", current)
            print("The new value is: ", value)
            change_made = 1
    except:
        print("Could not retrieve combination: ", strname, column)
        print("Does it exist?")
    return db

def create_company_year(db_key, df):
    strname = str(db_key)
    name = strname[:-6]
    year = strname[-5:-1]
    print(name, year)
    try:
        x = df.get_value(strname, "company") #the idea is that if this entry exists, then the row exists
        i = 0
    except:
        i = 1
    if i == 1:  
        df2 = pd.DataFrame({}, index=[strname]) 
        frames = [df, df2]
        result = pd.concat(frames)
        simple_new_db_entry(db_key, "company", name, result)
        simple_new_db_entry(db_key, "year", year, result)
    else:
        print('This entry already exists: ', strname)
        result = df
    return result

inflation_index = {
    '1991': 0.8717377530776487,
    '1992': 0.9161963784846087,
    '1993': 0.957425215516416,
    '1994': 0.9823182711198428,
    '1995': 1.0,
    '1996': 1.0141987815705333,
    '1997': 1.0341261553114101,
    '1998': 1.0438413316194199,
    '1999': 1.0504201440323881,
    '2000': 1.0649627143465095,
    '2001': 1.085776325650502,
    '2002': 1.1025358259999551,
    '2003': 1.1135857435748135,
    '2004': 1.1325028106194126,
    '2005': 1.1507479627084687,
    '2006': 1.1695906171431332,
    '2007': 1.1961722126574055,
    '2008': 1.2285012127560129,
    '2009': 1.2330456385839779,
    '2010': 1.2468828144373163,
    '2011': 1.2755102375069256,
    '2012': 1.3010204422570641,
    '2013': 1.32053574889092,
    '2014': 1.332420570630938,
    '2015': 1.4563356836996151
}

