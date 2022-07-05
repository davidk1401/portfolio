import csv
import pandas as pd

#This script pulls Wide data from one CSV, converts it to Long using the Pandas melt function, then saves it as a new CSV
filename = 'C:\\Users\katil\\Downloads\\SouthDataLong.csv'
csv_file = 'C:\\Users\katil\\Downloads\\SouthCleaned.csv'
df = pd.read_csv(csv_file)
print(df)

csv_reader = csv.reader(csv_file, delimiter=',')
df = df.melt(id_vars =['RespondentID','Southern Identity','Zip Code','Resident State','Gender',
                       'Age','Income','Education','Region'])
df = df.dropna(subset='value')
df.rename(columns = {'variable':'Southern State'}, inplace = True)
df = df.drop(['value'], axis = 1)
df = df.sort_values('RespondentID',ascending=True)

df.to_csv(filename, mode='w',index=False)
