
import pandas as pd
import string

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

#shorter for nt19, as only wanted to use it for one question
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