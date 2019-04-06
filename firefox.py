import os
import sqlite3
import operator
from collections import OrderedDict
import matplotlib.pyplot as plt
from urlparse import urlparse

def parse(url):
    try:
        parse_url = urlparse(url)
        domain = parse_url.netloc
        return domain
    except IndexError:
        print("URL format error")

data_path = os.path.expanduser('~')+"/.mozilla/firefox/fzx0aeum.default"
files = os.listdir(data_path)
history_db = os.path.join(data_path, 'places.sqlite')
c = sqlite3.connect(history_db)
cursor = c.cursor()
select = "select count(*),max(id) from moz_places;"
cursor.execute(select)
count = cursor.fetchall()
count1 = count[0][0]
count2 = count[0][1]
#print count1
#print count2
select_statement = "select id,url from moz_places where id between 3547 and 'count2';"
cursor.execute(select_statement)
results = cursor.fetchall()
#date(last_visit_date/1000000,'unixepoch')
result1 = 10
for i in results:
	print i[0],i[1]


#date(last_visit_date/1000000,'unixepoch')
#os.system("ns pg4.tcl ")
