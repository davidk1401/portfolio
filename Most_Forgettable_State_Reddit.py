# A post in the r/polls subreddit asked about the most forgettable US state.
# This program counts how many times each state has been mentioned so far
# on the page, using that post's main link. It then uploads the results into a
# Pandas dataframe and sorts descending by the number of mentions.

from bs4 import BeautifulSoup
from urllib.request import Request, urlopen
import re
import pandas as pd
import sys

states = ['Alaska', 'Alabama', 'Arkansas', 'Arizona',
          'California', 'Colorado', 'Connecticut',
          'Delaware',
          'Florida',
          'Georgia',
          'Hawaii',
          'Iowa', 'Idaho', 'Illinois', 'Indiana',
          'Kansas', 'Kentucky',
          'Louisiana',
          'Massachusetts', 'Maryland', 'Maine', 'Michigan', 'Minnesota',
          'Missouri', 'Mississippi', 'Montana',
          'North Carolina', 'North Dakota', 'Nebraska', 'New Hampshire',
          'New Jersey', 'New Mexico', 'Nevada', 'New York',
          'Ohio', 'Oklahoma', 'Oregon',
          'Pennsylvania',
          'Rhode Island',
          'South Carolina', 'South Dakota', 'Tennessee', 'Texas',
          'Utah',
          'Virginia', 'Vermont',
          'Washington', 'Wisconsin', 'West Virginia', 'Wyoming']

df = pd.DataFrame(
    columns=['Mentions'],
    index=states)

req = Request("https://old.reddit.com/r/polls/comments/tj1gh0/what_is_the_most_forgettable_us_state/?limit=500")
html_page = urlopen(req)

soup = BeautifulSoup(html_page, "html.parser")

html_text = soup.get_text()
html_text = html_text.lower()

for i in states:
    df.loc[i,:] = html_text.count(i.lower())

print(df.sort_values(by=['Mentions'],ascending=False))
