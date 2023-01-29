#!/bin/bash 

rm -f ./_feeds/updates.txt

deno run -A --unstable ./_feeds/alberta.js
deno run -A --unstable ./_feeds/britishita.js
deno run -A --unstable ./_feeds/canadavisa.js
deno run -A --unstable ./_feeds/cicnews.js
deno run -A --unstable ./_feeds/manitoba.js
deno run -A --unstable ./_feeds/ontario.js