#!/bin/bash

# https://www.cic.gc.ca/english/work/iec/selections.asp
# https://www.cic.gc.ca/english/work/iec/selections.asp?country=kr&cat=wh

curl -s https://www.cic.gc.ca/english/work/iec/selections.asp | pup "#country-name option text{}" | tee countrynames.txt
curl -s https://www.cic.gc.ca/english/work/iec/selections.asp | pup "#country-name option attr{value}" | tee countries.txt
curl -s https://www.cic.gc.ca/english/work/iec/selections.asp | pup "#country-name option attr{class}" | tee classes.txt

//*[@id="stats"]

curl -s https://www.cic.gc.ca/english/work/iec/selections.xml -o iecrounds2023.xml

npx convert-xml-to-json iecrounds2023.xml iecrounds2023.json

cat iecrounds2023.json | jq '.temp.country' > countries.json

in2csv countries.json | sed 's/\$\///g;s/\/0//g;s/\//_/g;s/To be announced/N\A/g;s/Not accepting applicants/Not/g;s/Not applicable/N\A/g;' | tee countries.csv

csvcut -c 1-10 countries.csv > mainiec_base.csv
csvcut -c 3,11-18 countries.csv | sed '/,,,,,,,,/d' > subiec_base.csv

csvjoin -c code _base_flags.csv subiec_base.csv | csvcut -C 1,4 |  tee subiec_all.csv  | csv2md - | sed 's/category/类别/g;s/quota/配额/g;s/first/最新邀请/g;s/second/最后一次邀请/g;s/invitations/邀请数/g;s/candidates/候选人数/g;s/spots/剩余名额/g;s/chances/机会/g;' | tee _subiec.md
csvjoin -c code _base_flags.csv mainiec_base.csv | csvcut -C 1,4,5 | csvsort -c 3 | tee mainiec_all.csv | csv2md - | sed 's/sub_txt/类别/g;s/quota/配额/g;s/sub_first/最新邀请/g;s/sub_second/最后一次邀请/g;s/sub_invitations/邀请数/g;s/sub_candidates/候选人数/g;s/sub_spots/剩余名额/g;s/sub_chances/机会/g;' | tee _mainiec.md

# sed 's/category/类别/g;s/quota/配额/g;s/first/最新邀请/g;s/second/最后一次邀请/g;s/invitations/邀请数/g;s/candidates/候选人数/g;s/spots/剩余名额/g;s/chances/机会/g;' _mainiec.md | head -n 2

# Volontariat international en entreprise (VIE)

# csvcut -n countries.csv
#   1: location
#   2: category
#   3: code
#   4: quota
#   5: first
#   6: second
#   7: invitations
#   8: candidates
#   9: spots
#  10: chances
#  11: sub_txt
#  12: sub_quota
#  13: sub_first
#  14: sub_second
#  15: sub_invitations
#  16: sub_candidates
#  17: sub_spots
#  18: sub_chances