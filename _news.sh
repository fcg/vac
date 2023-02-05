#!/bin/bash 

# https://www.alberta.ca/aaip-updates.aspx
# https://www.welcomebc.ca/Immigrate-to-B-C/Invitations-To-Apply
# https://www.immigratemanitoba.com/feed/
# https://www.ontario.ca/page/2023-ontario-immigrant-nominee-program-updates
# https://www.canadavisa.com/news/rss.html

rm -f ./_feeds/updates.txt

deno run -A --unstable ./_feeds/askmigration.js
deno run -A --unstable ./_feeds/canadaimmigrants.js
deno run -A --unstable ./_feeds/canadianimmigrant.js

deno run -A --unstable ./_feeds/alberta.js
deno run -A --unstable ./_feeds/britishita.js
deno run -A --unstable ./_feeds/canadavisa.js
deno run -A --unstable ./_feeds/cicnews.js
deno run -A --unstable ./_feeds/manitoba.js
deno run -A --unstable ./_feeds/ontario.js