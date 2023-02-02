import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
import { basename, dirname } from "https://deno.land/std/path/mod.ts";
import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";
import { GTR } from "https://deno.land/x/gtr/mod.ts";

async function canadavisafeeds() {
  const response = await fetch("https://www.canadavisa.com/news/rss.html");
  const xml = await response.text();
  const { entries } = await parseFeed(xml);

  const mdbasedir = "./_feeds/_canadavisa/";
  const shfilename = "canadavisa.sh";
  const shfilearray = [];
  let shcontent = "";

  // entries.forEach(async (element) => {
    for (const element of entries){
    // console.log(element);

    const id = element.id;
    const pageurl = element.links[0].href;
    const title = element.title.value;
    const publishedraw = element.publishedRaw;
    const description = element.description.value;

    const url = new URL(pageurl);
    const path = url.pathname;

    const yesterday = moment(new Date()).subtract(1, "days");
    const pubdate = moment(publishedraw);
    const pubdateyyyymmdd = pubdate.format("YYYY-MM-DD");
    const dateymd = pubdateyyyymmdd;

    if (!pubdate.isAfter(yesterday)) break;
    // if (!pubdate.isAfter("2023-01-01")) return;

    const htmlfilename = `${pubdateyyyymmdd}-${basename(path)}`;
    const mdfilename = htmlfilename.replace(".html", "_canadavisa.md");
    const cnmdfilename = mdfilename.replace("_canadavisa", "_cn");
    const fcgmdfilename = mdfilename.replace(".md", "_fcg.md");
    const jekyllfrontmatterfilename = mdfilename.replace(".md", "_fm.md");

    shfilearray.push(`# ${pageurl}\n`);
    shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
    shfilearray.push(
      `sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' "tmp_${mdfilename}" | sed '/Tags:/,$d;/Cec Fswp Fstp	Immigrate Work/d;/Felonycanada/g;/	Immigrate Work Study Sponsor Inadmissibility/d;/Canadavisaheadstartexpressentry/d;/Complete our FREE assessment form/d;/googletag/d;/Sponsor Content/d;/Sivakumar/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/CanadaVisa.com/d;' | cat -s | tee ${mdfilename}`,
    );
    shfilearray.push(
      `trans -b en:zh "file://${mdfilename}" | tee "${cnmdfilename}"`,
    );
    shfilearray.push(`sed -i 's/##* //g;s/^\\* //g;' ${mdfilename}`);
    shfilearray.push(`sed -i 's/＃/#/g;' ${cnmdfilename}`);
    shfilearray.push(
      `paste "${cnmdfilename}" "${mdfilename}" | tee "${fcgmdfilename}"\n`,
    );
    shfilearray.push(
      `cat "${jekyllfrontmatterfilename}" "${fcgmdfilename}" > "../../_posts/${fcgmdfilename}"\n`,
    );
    shfilearray.push(
      `echo "\\nFCGvisa translated, © Canadavisa.com All Rights Reserved." >> "../../_posts/${fcgmdfilename}"\n`,
    );

    const $ = cheerio.default.load(description);
    const desc = $("p").first().text().replaceAll(":","-");

    let frontmatter = `---
layout: post
title: '${title}'
description: '${desc}'
date: ${publishedraw}
categories: canadavisa
---

`;
const gtr = new GTR();

const { titlecn } = await gtr.translate(
  title,
  { targetLang: "zh" },
);

const { desccn } = await gtr.translate(
  desc,
  { targetLang: "zh" },
);

let newupdates = `# ${dateymd} - ${pageurl}
title: ${titlecn} / ${title}
description: ${desccn} / ${desc}

`;

await Deno.writeTextFile("_feeds/updates.txt",newupdates,{
append: true,
create: true,
});

    try {
      const res = await fetch(url);
      const html = await res.text();
      const $ = cheerio.default.load(html);

      const article = $("body > div.container.content.mt-3").html();

      console.log(article);

      await Deno.writeTextFile(`${mdbasedir}${htmlfilename}`, article, {
        append: false,
        create: true,
      });

      await Deno.writeTextFile(
        `${mdbasedir}${jekyllfrontmatterfilename}`,
        frontmatter,
        { append: false, create: true },
      );
    } catch (error) {
      console.log(error);
    }
  }

  // shfilearray.push("cp -f *_fcg.md ../_posts/");
  shfilearray.push("# rm -f *.html");
  shfilearray.push("# rm -f *_canadavisa.md");
  shfilearray.push("# rm -f *_fcg.md");
  shfilearray.push("# rm -f *_cn.md");

  shcontent = shfilearray.join("\n");

  await Deno.writeTextFile(`${mdbasedir}${shfilename}`, shcontent);
}

canadavisafeeds();
