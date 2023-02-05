#!/bin/bash 

# https://www.alberta.ca/aaip-updates.aspx
# https://www.welcomebc.ca/Immigrate-to-B-C/Invitations-To-Apply
# https://www.immigratemanitoba.com/feed/
# https://www.ontario.ca/page/2023-ontario-immigrant-nominee-program-updates
# https://www.canadavisa.com/news/rss.html

# https://mdccanada.ca/

# curl -s https://www.canadim.com/blog/top-ten-indemand-jobs-in-canada/ | pup ".o-container-col" | html2md - | tee ./_feeds/_canadim/top-ten-indemand-jobs-in-canada.md
# trans -b "en:zh" file://top-ten-indemand-jobs-in-canada.md | tee top-ten-indemand-jobs-in-canada-zh.md  
# sed 's/\[\([^][]*\)\]([^()]*)/\1/g' top-ten-indemand-jobs-in-canada-zh.md | tee top-ten-indemand-jobs-in-canada-zh-fcg.md
# sed 's/\[\([^][]*\)\]([^()]*)/\1/g' top-ten-indemand-jobs-in-canada.md | tee top-ten-indemand-jobs-in-canada-en-fcg.md

rm -f ./_feeds/updates.txt

deno run -A --unstable ./_feeds/askmigration.js
deno run -A --unstable ./_feeds/canadaimmigrants.js
deno run -A --unstable ./_feeds/canadianimmigrant.js
deno run -A --unstable ./_feeds/canadianvisa.js
deno run -A --unstable ./_feeds/canadim.js
deno run -A --unstable ./_feeds/canadamadesimple.js

deno run -A --unstable ./_feeds/alberta.js
deno run -A --unstable ./_feeds/britishita.js
deno run -A --unstable ./_feeds/canadavisa.js
deno run -A --unstable ./_feeds/cicnews.js
deno run -A --unstable ./_feeds/manitoba.js
deno run -A --unstable ./_feeds/ontario.js