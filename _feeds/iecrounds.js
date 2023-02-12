import * as cheerio from 'cheerio';
import moment from 'moment';
import * as fs from 'fs';
import got from 'got';
import fetch from 'node-fetch';

// https://www.cic.gc.ca/english/work/iec/selections.xml

import puppeteer from 'puppeteer';

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();

  await page.goto('https://www.cic.gc.ca/english/work/iec/selections.asp?country=kr&cat=wh');

  const pageData = await page.evaluate(() => {return {html: document.documentElement.innerHTML,};});

  const $ = cheerio.load(pageData.html);

  fs.writeFile("1.html", pageData.html, { flag: 'w+' }, (err) => {});

  console.log($("#stats").text());

  $(".col-md-8").find("p")
      .each(function (index, element) {
          console.log($(element).text());
        }
      )

  await browser.close();
})();

async function iecroundsupate() {
    const iecroundsurl = "https://www.cic.gc.ca/english/work/iec/selections.asp?country=kr&cat=wh";
    const pageurl = iecroundsurl;
    const mdbasedir = "./_feeds/_iecrounds/";

    const yesterday = moment(new Date()).subtract(1, "days");

    const shfilename = "iecroundsupate.sh";
    const shfilearray = [];
    let shcontent = "";

    const response = await fetch(pageurl);
    //   const response = await got(pageurl);
    const html = await response.text();

    let $ = cheerio.load(html);

    console.log($("#stats").text());

    $("section").find(".col-md-8")
        .each(function (index, element) {
            console.log($(element).text());
          }
        )

    // shcontent = shfilearray.join("\n");

    // fs.writeFile(`${mdbasedir}${shfilename}`, shcontent, { flag: 'w+' }, (err) => {
    //     if (err)
    //         console.log(err);
    //     else {
    //         console.log("File written successfully\n");


    //     }
    // });
}

// abnewsfeeds();
// iecroundsupate();

