# Released under MIT license
# This script downloads from the atom feed of google trends and extracts today's search terms and volumes
# No external dependencies needed
# Output will be saved in file with today's date. Format is YYYYMMDD
# Sample output file in 20130622
#
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
#clean up
cp temp2 $var
rm -rf ./temp2
rm -rf ./temp1