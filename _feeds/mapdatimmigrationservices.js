// https://mapdatimmigrationservices.com/blogs-for-immigration-services

// import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
// import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";

import * as cheerio from 'cheerio';
import moment from 'moment';
import * as fs from 'fs';
import got from 'got';
import fetch from 'node-fetch';

async function mapdatimmigrationservicesupdate() {
    const mapdatimmigrationservicesurl = "https://mapdatimmigrationservices.com/blogs-for-immigration-services";
    const pageurl = mapdatimmigrationservicesurl;
    const mdbasedir = "./_feeds/_mapdatimmigrationservices/";

    const yesterday = moment(new Date()).subtract(1, "days");

    const shfilename = "mapdatimmigrationservicesupdate.sh";
    const shfilearray = [];
    let shcontent = "";

    const response = await fetch(pageurl);
    //   const response = await got(pageurl);
    const html = await response.text();

    let $ = cheerio.load(html);

    const updates = $(".portfolio-item")
        .map(function () {
            let dateraw = $(this).find(".portfolio-category").text();
            let date = moment(dateraw);

            if (date.isAfter(yesterday))
            // if (date.isAfter("2023-02-01"))
             {
                return {
                    url: $(this).find(".entry-overlay").attr("href"),
                    date: dateraw,
                    title: $(this).find("h3 a").attr("title"),
                };
            }
        }).get();

    for (const theupdate of updates) {

        // let headstrings = headerraw.split(":");
        let dateraw = theupdate.date;
        let date = moment(dateraw);
        let dateymd = date.format("YYYY-MM-DD");
        let title = theupdate.title;

        console.log(title);

        let titlepath = title.replaceAll(",", "-").replaceAll(">", "").replaceAll("'", "-").replaceAll(
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

        let newsresponse = await fetch(theupdate.url);
        let newshtml = await newsresponse.text();

        $ = cheerio.default.load(newshtml);

        let updatehtml = $("article").html();

        let htmlfilename = `${dateymd}-${titlepath}.html`;
        const mdfilename = htmlfilename.replace(".html", "_mapdatimmigrationservices.md");
        const cnmdfilename = mdfilename.replace("_mapdatimmigrationservices", "_cn");
        const fcgmdfilename = mdfilename.replace(".md", "_fcg.md");
        const jekyllfrontmatterfilename = mdfilename.replace(".md", "_fm.md");

        let frontmatter = `---
layout: post
title:  ${title}
description: '${title}'
date:   ${dateymd}
categories: mapdatimmigrationservices
---

`;

        let newupdates = `# ${dateymd} - ${pageurl}
title: ${title}
description: ${title}

`;

        // console.log(newupdates);

        fs.appendFileSync("_feeds/updates.txt", newupdates, { flag: 'w+' }, (err) => {
            if (err)
                console.log(err);
            else {
                console.log("File written successfully\n");


            }
        });

        // console.log(frontmatter);

        shfilearray.push(`# ${pageurl}\n`);
        //   shfilearray.push(`curl -k -L -s --compressed ${pageurl} | pup ".m2c-post__content" | tee ${htmlfilename}\n`);
        shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
        shfilearray.push(`sed '1,2d;/===/d;/----/d;/\\[!/d;/Something went wrong/d;/Load More Posts/d;/Loading/d;/data-lazy-fallback/d' "tmp_${mdfilename}" | sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' | sed '/Related articles/,$d;/googletag/d;/View all post/d;/mapdatimmigrationservices/d;/For more information/d;/！	!/d;/SHARE THIS ARTICLE/d;/Free Assessment/d;' | cat -s | tee ${mdfilename}`);
        shfilearray.push(`trans -b en:zh "file://${mdfilename}" | tee "${cnmdfilename}"`);
        shfilearray.push(`sed -i 's/##* //g;s/^\\* //g;' ${mdfilename}`);
        shfilearray.push(`sed -i 's/＃/#/g;' ${cnmdfilename}`);
        shfilearray.push(`paste "${cnmdfilename}" "${mdfilename}" | tee "${fcgmdfilename}"\n`);
        shfilearray.push(`cat "${jekyllfrontmatterfilename}" "${fcgmdfilename}" > "../../_posts/${fcgmdfilename}"\n`);
        shfilearray.push(`echo "\\nFCGvisa translated, © mapdatimmigrationservices All Rights Reserved." >> "../../_posts/${fcgmdfilename}"\n`);

        try {
            fs.writeFile(
                `${mdbasedir}${jekyllfrontmatterfilename}`,
                frontmatter, { flag: 'w+' }, (err) => {
                    if (err)
                        console.log(err);
                    else {
                        console.log("File written successfully\n");


                    }
                }
            );

            fs.writeFile(`${mdbasedir}${htmlfilename}`, updatehtml, { flag: 'w+' }, (err) => {
                if (err)
                    console.log(err);
                else {
                    console.log("File written successfully\n");


                }
            });

            // console.log(`${mdbasedir}${shfilename} saved!`);
        } catch (error) {
            console.log(error);
        }
    }

    shcontent = shfilearray.join("\n");

    fs.writeFile(`${mdbasedir}${shfilename}`, shcontent, { flag: 'w+' }, (err) => {
        if (err)
            console.log(err);
        else {
            console.log("File written successfully\n");


        }
    });
}

// abnewsfeeds();
mapdatimmigrationservicesupdate();