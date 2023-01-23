import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
import { basename, dirname } from "https://deno.land/std/path/mod.ts";
import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";
import puppeteer from "https://deno.land/x/puppeteer@16.2.0/mod.ts";

async function abnewsfeeds() {
  const browser = await puppeteer.launch();

  const response = await fetch("https://www.alberta.ca/NewsRoom/newsroom.cfm");
  const xml = await response.text();
  const { entries } = await parseFeed(xml);

  const mdbasedir = "./_feeds/_alberta/";
  const shfilename = "alberta.sh";
  const shfilearray = [];
  let shcontent = "";

  entries.forEach(async (element) => {
    // console.log(element);

    const id = element.id;
    const pageurl = element.links[0].href;
    const title = element.title.value;
    const publishedraw = element.publishedRaw;
    const description = element.description.value;

    const url = new URL(pageurl);
    const path = title.replaceAll(" ", "-").replaceAll(":", "").replaceAll(
      "’",
      "-",
    ).replaceAll("|", "").replaceAll("--", "-");

    const yesterday = moment(new Date()).subtract(1, "days");
    const pubdate = moment(publishedraw);
    const pubdateyyyymmdd = pubdate.format("YYYY-MM-DD");

    if (!pubdate.isAfter(yesterday)) return;

    const htmlfilename = `${pubdateyyyymmdd}-${path}.html`;
    // console.log(htmlfilename);
    const mdfilename = htmlfilename.replace(".html", "_alberta.md");
    const cnmdfilename = mdfilename.replace("_alberta", "_cn");
    const fcgmdfilename = mdfilename.replace(".md", "_fcg.md");
    const jekyllfrontmatterfilename = mdfilename.replace(".md", "_fm.md");

    shfilearray.push(`# ${pageurl}\n`);
    shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
    shfilearray.push(
      `sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' "tmp_${mdfilename}" | sed '/Tags:/,$d;/googletag/d;/On this page/d;/Sponsor Content/d;/Some parts of this/d;/alberta/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;' | cat -s | tee ${mdfilename}`,
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
      `echo "\\nFCGvisa translated, alberta.ca All Rights Reserved." >> "${fcgmdfilename}.txt"\n`,
    );
    shfilearray.push(
      `cat -s "${fcgmdfilename}.txt" > "../../_posts/${fcgmdfilename}"\n`,
    );

    const $ = cheerio.default.load(description);
    const desc = $("p").first().text();

    let frontmatter = `---
layout: post
title:  "${title}"
description: ${desc}
date:   ${publishedraw}
categories: alberta
---

`;

    try {
      const page = await browser.newPage();

      await page.goto(url, {
        waitUntil: "networkidle2",
      });

      const html = await page.content();

      const $ = cheerio.default.load(html);
      // console.log(html);

      const article = $("main").html();

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
  });

  // shfilearray.push("cp -f *_fcg.md ../_posts/");
  shfilearray.push("# rm -f *.html");
  shfilearray.push("# rm -f *_alberta.md");
  shfilearray.push("# rm -f *_fcg.md");
  shfilearray.push("# rm -f *_cn.md");

  shcontent = shfilearray.join("\n");

  await Deno.writeTextFile(`${mdbasedir}${shfilename}`, shcontent);

  await browser.close();
}

async function abupdate() {
  const abupdateurl = "https://www.alberta.ca/aaip-updates.aspx";
  const mdbasedir = "./_feeds/_alberta/";

  const shfilename = "albertaupdate.sh";
  const shfilearray = [];
  let shcontent = "";

  // const browser = await puppeteer.launch();
  // const page = await browser.newPage();

  // await page.goto(abupdateurl, {
  //   waitUntil: "networkidle2",
  // });

  // const html = await page.content();

  // await page.$eval("#goa-accordion54082 > div > button", (el) => el.click());

  const response = await fetch(abupdateurl);
  const html = await response.text();

  // console.log(html);

  const $ = cheerio.default.load(html);

  // const h3list = [];
  // const lilist = [];

  // $(".goa-accordion.goa-accordion--toolbar-active").find("li").each(function (index, element) {
  //   console.log($(element).attr("id"));
  //   if($(element).attr("id")){
  //     h3list.push($(element).find("h3").text().trim());
  // }
  // });

  // console.log(h3list);

  const updates = $(".goa-accordion.goa-accordion--toolbar-active").find("li")
    .map(function () {
      if ($(this).attr("id")) {
        return {
          header: $(this).find("h3").text().trim(),
          content: $(this).html().trim(),
        };
      }
    }).toArray();

  for (const theupdate of updates) {
    let headerraw = theupdate.header;
    let headstrings = headerraw.split(":");
    let date = headstrings[0].trim();
    let dateymd = moment(date).format("YYYY-MM-DD");
    let title = headstrings[1].trim();
    let titlepath = title.replaceAll(",", "-").replaceAll("'", "-").replaceAll(
      "|",
      "",
    ).replaceAll(
      "(",
      "",
    ).replaceAll(
      ")",
      "",
    ).replaceAll(" ", "-").replaceAll("--", "-");
    let updatehtml = theupdate.content;

    let htmlfilename = `${dateymd}-${titlepath}.html`;
    const mdfilename = htmlfilename.replace(".html", "_aipp.md");
    const cnmdfilename = mdfilename.replace("_aipp", "_cn");
    const fcgmdfilename = mdfilename.replace(".md", "_fcg.md");
    const jekyllfrontmatterfilename = mdfilename.replace(".md", "_fm.md");

    let frontmatter = `---
    layout: post
    title:  "${title}"
    description: ${headerraw}
    date:   ${dateymd}
    categories: alberta
    ---
    
    `;
    // let jekyllfrontmatterfilename = htmlfile.replace(".html", "_fm.md");

    shfilearray.push(`# ${headerraw}\n`);
    shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
    shfilearray.push(
      `sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' "tmp_${mdfilename}" | sed '/Tags:/,$d;/googletag/d;/On this page/d;/Sponsor Content/d;/Some parts of this/d;/alberta/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;' | cat -s | tee "${mdfilename}"`,
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
      `echo "\\nFCGvisa translated, alberta.ca All Rights Reserved." >> "${fcgmdfilename}.txt"\n`,
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

      await Deno.writeTextFile(`${mdbasedir}${shfilename}`, shcontent);
    } catch (error) {
      console.log(error);
    }
  }

  // console.log(updates);

  // var expandedlist = [];
  // var collapsedlist = [];
  // $(".expanded-item").each(function (index, element) {
  //   expandedlist.push($(element).html());
  // });
  // $(".collapsed-item").each(function (index, element) {
  //   // console.log(element);
  //   collapsedlist.push($(element).find(".goa-text").html());
  // });

  // console.log(expandedlist);
  // console.log(collapsedlist);

  // console.log(updatelist);
}

// abnewsfeeds();
abupdate();

// await browser.close();

//   - name: Fetch data for ALBERTA_CA_NEWSROOM
//     uses: githubocto/flat@v3
//     with:
//       http_url: https://www.alberta.ca/NewsRoom/newsroom.cfm
//       downloaded_filename: alberta_ca_newsroom.rss
