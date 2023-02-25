import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
import { basename, dirname } from "https://deno.land/std/path/mod.ts";
import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";

const response = await fetch("https://immigrationnewscanada.ca/feed/");
const xml = await response.text();
const { entries } = await parseFeed(xml);

const mdbasedir = "./_feeds/_immigrationnewscanada/";
const shfilename = "immigrationnewscanada.sh";
const shfilearray = [];
let shcontent = "";

const fetch_retry = async (url, options, n=10) => {
	let error;
	for (let i = 0; i < n; i++)
	{
		try
		{
			console.log(`Try ${i+1}`);
			return await fetch(url, options);
		}
		catch (err)
		{
			error = err;
		}
	}
  throw error;
};

entries.forEach(async (element) => {
    
  const id = element.id;
  const pageurl = element.links[0].href;
  const title = element.title.value;
  const publishedraw = element.published;
  const description = element.description.value;

  console.log(publishedraw);

  const url = new URL(pageurl);
  const path = url.pathname;
  
  const yesterday = moment(new Date()).subtract(1, 'days');
  const pubdate = moment(publishedraw)
  const pubdateyyyymmdd = pubdate.format("YYYY-MM-DD");
  const dateymd = pubdate.format("YYYY-MM-DD");

  if (!pubdate.isAfter(yesterday)) return;
  // if (!pubdate.isAfter("2023-01-01")) return;

  const htmlfilename = `${pubdateyyyymmdd}-${basename(path)}.html`;
  const mdfilename = htmlfilename.replace(".html","_immigrationnewscanada.md");
  const cnmdfilename = mdfilename.replace("_immigrationnewscanada","_cn");
  const fcgmdfilename = mdfilename.replace(".md","_fcg.md");
  const jekyllfrontmatterfilename = mdfilename.replace(".md","_fm.md");

  shfilearray.push(`# ${pageurl}\n`);
  shfilearray.push(`curl -k -L -s --compressed ${pageurl} | pup "article" | tee ${htmlfilename}\n`);
  shfilearray.push(`turndown -t atx -r - "${htmlfilename}" "tmp_${mdfilename}"`);
  shfilearray.push(`sed '/===/d;/----/d;/\\[!/d;/Something went wrong/d;/Load More Posts/d;/Loading/d;/data-lazy-fallback/d' "tmp_${mdfilename}" | sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' | sed '/FIND OUT IF YOU/,$d;/googletag/d;/Free Immigration Assessment/d;/immigrationnewscanada/d;/adsbygoogle/d;/！	!/d;/SHARE THIS ARTICLE/d;/Free Assessment/d;' | cat -s | tee ${mdfilename}`);
  shfilearray.push(`trans -b en:zh "file://${mdfilename}" | tee "${cnmdfilename}"`); 
  shfilearray.push(`sed -i 's/##* //g;s/^\\* //g;' ${mdfilename}`);
  shfilearray.push(`sed -i 's/＃/#/g;' ${cnmdfilename}`);
  shfilearray.push(`paste "${cnmdfilename}" "${mdfilename}" | tee "${fcgmdfilename}"\n`);
  shfilearray.push(`cat "${jekyllfrontmatterfilename}" "${fcgmdfilename}" > "../../_posts/${fcgmdfilename}"\n`);
  shfilearray.push(`echo "\\nFCGvisa translated, © immigrationnewscanada All Rights Reserved." >> "../../_posts/${fcgmdfilename}"\n`);

  const $ = cheerio.default.load(description);
  const desc = $("p").first().text().replaceAll(":","-"); 

  let frontmatter = 
`---
layout: post
title: '${title}'
description: '${desc}'
date: ${publishedraw}
categories: immigrationnewscanada
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

await Deno.writeTextFile(`${mdbasedir}${jekyllfrontmatterfilename}`, frontmatter, { append: false, create: true});

const options = {};

  // try {
    
  //   const res = await fetch_retry(url, options);
  //   console.log(res.status);
  //   const html = await res.text();
  //   const $ = cheerio.default.load(html);

  //   const article = $("article").html();    

  //   await Deno.writeTextFile(`${mdbasedir}${htmlfilename}`, article, { append: false, create: true});

  //   await Deno.writeTextFile(`${mdbasedir}${jekyllfrontmatterfilename}`, frontmatter, { append: false, create: true});
    
  // } catch (error) {
  //   console.log(error);
  // }
});

// shfilearray.push("cp -f *_fcg.md ../_posts/");
shfilearray.push("# rm -f *.html");
shfilearray.push("# rm -f *_immigrationnewscanada.md");
shfilearray.push("# rm -f *_fcg.md");
shfilearray.push("# rm -f *_cn.md");

shcontent = shfilearray.join('\n');

await Deno.writeTextFile(`${mdbasedir}${shfilename}`, shcontent,);

// sed -i '2,21d' *_immigrationnewscanada.md
// sed -i 's/\[\([^][]*\)\]([^()]*)/\1/g' *_immigrationnewscanada.md
// sed -i '/Tags:/,$d' *_immigrationnewscanada.md
// sed -i '/googletag/d' *_immigrationnewscanada.md
// sed -i '/immigrationnewscanada/d' *_immigrationnewscanada.md
// sed -i '/Discover if You Are Eligible for Canadian Immigration/d' *_immigrationnewscanada.md
// sed -i '/Visit CanadaVisa.com/d' *_immigrationnewscanada.md
// sed -i '/Schedule a Free/d;/Get a Free/d;' *.md

// sed '/Tags:/,$d;/googletag/d;/immigrationnewscanada/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;;'

// sed -i '2,22d;/googletag/d;/immigrationnewscanada/d' *_immigrationnewscanada.md
// sed -i 's/##* +//g;s/^\* +//g;' *_immigrationnewscanada.md

// sed -i 's/##* //g;' *_immigrationnewscanada.md
// sed -i 's/^\* //g;' *_immigrationnewscanada.md

// sed -i 's/^#(+) //g;' *_immigrationnewscanada.md

// sed -i 'Schedule a Free Legal/,$d'
// sed -n '/The second line/q;p' 
// This says "when you reach the line that matches the pattern quit, otherwise print each line". The -n option prevents implicit printing and the p command is required to explicitly print lines.
