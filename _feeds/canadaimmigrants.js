import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
import { basename, dirname } from "https://deno.land/std/path/mod.ts";
import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";

const response = await fetch("https://canadaimmigrants.com/feed/");
const xml = await response.text();
const { entries } = await parseFeed(xml);

const mdbasedir = "./_feeds/_canadaimmigrants/";
const shfilename = "canadaimmigrants.sh";
const shfilearray = [];
let shcontent = "";

entries.forEach(async (element) => {
    
  const id = element.id;
  const pageurl = element.links[0].href;
  const title = element.title.value;
  const publishedraw = element.publishedRaw;
  const description = element.description.value;

  const url = new URL(pageurl);
  const path = url.pathname;
  
  const yesterday = moment(new Date()).subtract(1, 'days');
  const pubdate = moment(publishedraw)
  const pubdateyyyymmdd = pubdate.format("YYYY-MM-DD");
  const dateymd = pubdate.format("YYYY-MM-DD");

  if (!pubdate.isAfter(yesterday)) return;
//   if (!pubdate.isAfter("2023-01-01")) return;

  const htmlfilename = `${pubdateyyyymmdd}-${basename(path)}.html`;
  const mdfilename = htmlfilename.replace(".html","_canadaimmigrants.md");
  const cnmdfilename = mdfilename.replace("_canadaimmigrants","_cn");
  const fcgmdfilename = mdfilename.replace(".md","_fcg.md");
  const jekyllfrontmatterfilename = mdfilename.replace(".md","_fm.md");

  shfilearray.push(`# ${pageurl}\n`);
  shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
  shfilearray.push(`sed '/===/d;/----/d' "tmp_${mdfilename}" | sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' | sed '/Tags:/,$d;/googletag/d;/Sponsor Content/d;/canadaimmigrants/d;/adsbygoogle/d;/！	!/d;/by The Canadian Magazine/d;/Visit CanadaVisa.com/d;' | cat -s | tee ${mdfilename}`);
  shfilearray.push(`trans -b en:zh "file://${mdfilename}" | tee "${cnmdfilename}"`); 
  shfilearray.push(`sed -i 's/##* //g;s/^\\* //g;' ${mdfilename}`);
  shfilearray.push(`sed -i 's/＃/#/g;' ${cnmdfilename}`);
  shfilearray.push(`paste "${cnmdfilename}" "${mdfilename}" | tee "${fcgmdfilename}"\n`);
  shfilearray.push(`cat "${jekyllfrontmatterfilename}" "${fcgmdfilename}" > "../../_posts/${fcgmdfilename}"\n`);
  shfilearray.push(`echo "\\nFCGvisa translated, © canadaimmigrants All Rights Reserved." >> "../../_posts/${fcgmdfilename}"\n`);

  const $ = cheerio.default.load(description);
  const desc = $("p").first().text().replaceAll(":","-"); 

  let frontmatter = 
`---
layout: post
title: '${title}'
description: '${desc}'
date: ${publishedraw}
categories: canadaimmigrants
---

`

let newupdates = `# ${dateymd} - ${pageurl}
title: ${title}
description: ${desc}

`;

await Deno.writeTextFile("_feeds/updates.txt",newupdates,{
append: true,
create: true,
});

  try {
    const res = await fetch(url);
    const html = await res.text();
    const $ = cheerio.default.load(html);

    const article = $(".post-inner.group").html();    

    await Deno.writeTextFile(`${mdbasedir}${htmlfilename}`, article, { append: false, create: true});

    await Deno.writeTextFile(`${mdbasedir}${jekyllfrontmatterfilename}`, frontmatter, { append: false, create: true});
    
  } catch (error) {
    console.log(error);
  }
});

// shfilearray.push("cp -f *_fcg.md ../_posts/");
shfilearray.push("# rm -f *.html");
shfilearray.push("# rm -f *_canadaimmigrants.md");
shfilearray.push("# rm -f *_fcg.md");
shfilearray.push("# rm -f *_cn.md");

shcontent = shfilearray.join('\n');

await Deno.writeTextFile(`${mdbasedir}${shfilename}`, shcontent,);

// sed -i '2,21d' *_canadaimmigrants.md
// sed -i 's/\[\([^][]*\)\]([^()]*)/\1/g' *_canadaimmigrants.md
// sed -i '/Tags:/,$d' *_canadaimmigrants.md
// sed -i '/googletag/d' *_canadaimmigrants.md
// sed -i '/canadaimmigrants/d' *_canadaimmigrants.md
// sed -i '/Discover if You Are Eligible for Canadian Immigration/d' *_canadaimmigrants.md
// sed -i '/Visit CanadaVisa.com/d' *_canadaimmigrants.md
// sed -i '/Schedule a Free/d;/Get a Free/d;' *.md

// sed '/Tags:/,$d;/googletag/d;/canadaimmigrants/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;;'

// sed -i '2,22d;/googletag/d;/canadaimmigrants/d' *_canadaimmigrants.md
// sed -i 's/##* +//g;s/^\* +//g;' *_canadaimmigrants.md

// sed -i 's/##* //g;' *_canadaimmigrants.md
// sed -i 's/^\* //g;' *_canadaimmigrants.md

// sed -i 's/^#(+) //g;' *_canadaimmigrants.md

// sed -i 'Schedule a Free Legal/,$d'
// sed -n '/The second line/q;p' 
// This says "when you reach the line that matches the pattern quit, otherwise print each line". The -n option prevents implicit printing and the p command is required to explicitly print lines.
