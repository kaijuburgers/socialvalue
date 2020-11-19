
'''
Created 18th November 2020

This takes a CVS file containing the data provided in Data_Nov20.xls, cleans it, and converts it into CSV files for further analysis

This could be a lot more streamlined and neat looking, but I did not want to focus too much time on the cleaning part of this 

'''

import pandas as pd
import string

from postcodetodistricts import getarea


socialvaluedataframe = pd.read_csv('data.csv', keep_default_na=False, delimiter=';')

#this cleans currency values, returning them as a float
def convert_money_values(row):
	row = row.translate(None, string.punctuation)
	row = row.replace('\xc2\xa3', '')
	#split into two
	row1 = row[0:-2]
	row2 = row[-2:]
	#join and convert
	rowfinal = row1 + "." + row2
	#return
	try:
		rowfinal = float(rowfinal)
		return rowfinal
	except:
		pass


#this identifies data focused on NT1 only, cleans the number values and saves it to its own CSV
'nt1_df = socialvaluedataframe[~socialvaluedataframe.NationalTOMsRef.str.contains('NT19',case=False)]
nt1_df = nt1_df[~nt1_df.NationalTOMsRef.str.contains('NT18',case=False)]

appending_money_values = []
for row in nt1_df['Delivered_LEV']:
	row = convert_money_values(row)
	appending_money_values.append(row)
nt1_df['Delivered_LEV'] = appending_money_values

appending_money_values = []
for row in nt1_df['Target_LEV']:
	row = convert_money_values(row)
	appending_money_values.append(row)
nt1_df['Target_LEV'] = appending_money_values

appending_money_values = []
for row in nt1_df['Proxy_Value']:
	row = convert_money_values(row)
	appending_money_values.append(row)
nt1_df['Proxy_Value'] = appending_money_values

appending_money_values = []
for row in nt1_df['Contract_Value']:
	row = convert_money_values(row)
	appending_money_values.append(row)
nt1_df['Contract_Value'] = appending_money_values


appending_areas = []
for row in nt1_df['Postcode']:
	newarea = getarea(row)
	appending_areas.append(newarea)
nt1_df['PC_Area']= appending_areas

nt1_df.to_csv (r'employmentdata.csv', index = False, header=True)



#this identifies data focued on NT19, and saves it to its own CSV

#shorter code for nt19, as only wanted to use it for one question
#would be much more detailed if cleaning it in general
socialvaluedataframe = pd.read_csv('data.csv', keep_default_na=False, delimiter=';')
nt19_df = socialvaluedataframe[socialvaluedataframe.NationalTOMsRef.str.contains('NT19',case=False)]
appending_money_values = []
for row in nt19_df['Target_LEV']:
	row = convert_money_values(row)
	appending_money_values.append(row)
nt19_df['Target_LEV'] = appending_money_values

appending_money_values = []
for row in nt19_df['Delivered_LEV']:
	row = convert_money_values(row)
	appending_money_values.append(row)
nt19_df['Delivered_LEV'] = appending_money_values
nt19_df.to_csv (r'nt19.csv', index = False, header=True)



