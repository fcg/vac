import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
import { basename, dirname } from "https://deno.land/std/path/mod.ts";
import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";
import puppeteer from "https://deno.land/x/puppeteer@16.2.0/mod.ts";

async function onupdate() {
  const onupdateurl =
    "https://www.ontario.ca/page/2023-ontario-immigrant-nominee-program-updates";
  const mdbasedir = "./_feeds/_ontario/";

  const yesterday = moment(new Date()).subtract(1, "days");

  const shfilename = "ontarioupdate.sh";
  const shfilearray = [];
  let shcontent = "";

  const response = await fetch(onupdateurl);
  const html = await response.text();

  const $ = cheerio.default.load(html);

  let updates = $("h3").map((i, el) => {
    el = $(el);
    let text = $.html(el) + "\n";
    let date = $(el).text();
    let title = "";
    let desc = "";

    while (el = el.next()) {
      if (el.length === 0 || el.prop("tagName") === "H3") break;
      if (el.prop("tagName") === "H4") title = $(el).text();
      text += $.html(el) + "\n";
    }
    // console.log(text);
    return { date: `${date}`, title: `${title}`, html: `${text}` };
  }).get();

  for (const theupdate of updates) {

    let dateraw = theupdate.date;
    let title = theupdate.title;
    let desc = theupdate.title;
    let updatehtml = theupdate.html;
    let date = moment(dateraw);

    if (!date.isAfter(yesterday)) return;

    let dateymd = date.format("YYYY-MM-DD");
    
    let titlepath = title.replaceAll(",", "-").replaceAll("'", "-").replaceAll(
      "|",
      "",
    ).replaceAll(
      "(",
      "",
    ).replaceAll(
      ")",
      "",
    ).replaceAll(
      "#",
      "",
    ).replaceAll(" ", "-").replaceAll("--", "-");    

    let htmlfilename = `${dateymd}-${titlepath}.html`;
    const mdfilename = htmlfilename.replace(".html", "_aipp.md");
    const cnmdfilename = mdfilename.replace("_aipp", "_cn");
    const fcgmdfilename = mdfilename.replace(".md", "_fcg.md");
    const jekyllfrontmatterfilename = mdfilename.replace(".md", "_fm.md");

    let frontmatter = `
---
layout: post
title: '${title}'
description: '${desc}'
date: ${dateymd}
categories: ontario
---

      `;

    // console.log(frontmatter);

    shfilearray.push(`# ${dateymd} - ${title}\n`);
    shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
    shfilearray.push(
      `sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' "tmp_${mdfilename}" | sed '/Tags:/,$d;/googletag/d;/On this page/d;/Sponsor Content/d;/Some parts of this/d;/ontario/d;/Schedule a Free/d;/Get a Free/d;/====/d;/Visit CanadaVisa.com/d;' | cat -s | tee "${mdfilename}"`,
    );
    shfilearray.push(
      `trans -b :zh "file://${mdfilename}" | tee "${cnmdfilename}"`,
    );
    shfilearray.push(
      `sed -i 's/##* //g;s/^\\* //g;s/------*//g;s/> //g' ${mdfilename}`,
    );
    shfilearray.push(`sed -i 's/＃/#/g;s/------*//g;' ${cnmdfilename}`);
    shfilearray.push(
      `paste "${cnmdfilename}" "${mdfilename}" | tee "${fcgmdfilename}"\n`,
    );
    shfilearray.push(
      `cat "${jekyllfrontmatterfilename}" "${fcgmdfilename}" | sed -E 's/[[:space:]]+$//g;s/  //g' > "${fcgmdfilename}.txt"\n`,
    );
    shfilearray.push(
      `echo "\\nFCGvisa translated, ontario.ca All Rights Reserved." >> "${fcgmdfilename}.txt"\n`,
    );
    shfilearray.push(
      `cat -s "${fcgmdfilename}.txt" > "../../_posts/${fcgmdfilename}"\n`,
    );

    shcontent = shfilearray.join("\n");

    try {
      await Deno.writeTextFile(
        `${mdbasedir}${jekyllfrontmatterfilename}`,
        frontmatter,
        { append: false, create: true },
      );

      await Deno.writeTextFile(`${mdbasedir}${htmlfilename}`, updatehtml, {
        append: false,
        create: true,
      });

      await Deno.writeTextFile(`${mdbasedir}${shfilename}`, shcontent, {
        append: false,
        create: true,
      });

    //   console.log(`${mdbasedir}${shfilename} saved!`);
    } catch (error) {
      console.log(error);
    }
  }
}

onupdate();
