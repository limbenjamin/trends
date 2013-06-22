# Released under MIT license
# This script downloads from the atom feed of google trends and extracts today's search terms and volumes, importing the results into mysql db
# No external dependencies needed
# Output will be saved mysql db name trends and table name trends
# db should consist of 3 columns:
#	name : varchar(50)
#	volume : varchar(20)
#	date : date(YYYY-MM-DD)
#Please create db and change user and password as necessary before using
#!/bin/bash
var=$(date +'%Y%m%d') #filename will be created in YYYYMMDD format
wget -O $var http://www.google.com.sg/trends/hottrends/atom/feed?pn=p5 #wget from google trends. replace with url of atom feed
awk '{ sub(/^[ \t]+/, ""); print }' $var > temp1
awk '/<title>|<ht:approx_traffic>|<pubDate>/' temp1 > temp2 #filter all lines except these
sed -i 's/<[^>]*>//g' temp2
sed -i -e "1d" temp2 #delete hot trends
# remove all but today's listings
day=$(date +'%a' --date="1 day ago")
day2=$(date +'%a')
sed -ni "/$day/q;p" temp2
sed -i '$d' temp2
sed -i "/${day2}/d" temp2
paste - -< temp2 > $var
var2=$(date +'%Y-%m-%d') #filename will be created in YYYYMMDD format
sed -i "s/$/\t${var2}/" $var
mv $var trends.*
mysqlimport --local --fields-terminated-by='\t' --lines-terminated-by="\n" -u user -ppassword trends /root/temp/trends.*
#clean up
rm -rf ./temp2
rm -rf ./temp1