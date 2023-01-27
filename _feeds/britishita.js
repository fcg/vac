import { parseFeed } from "https://deno.land/x/rss/mod.ts";
import moment from "https://deno.land/x/momentjs@2.29.1-deno/mod.ts";
import { basename, dirname } from "https://deno.land/std/path/mod.ts";
import { cheerio } from "https://deno.land/x/cheerio@1.0.7/mod.ts";
import puppeteer from "https://deno.land/x/puppeteer@16.2.0/mod.ts";
import { writeCSV } from "https://deno.land/x/csv/mod.ts";

async function savecsv(csvfile, rows) {
  const f = await Deno.open(csvfile, {
    write: true,
    create: true,
    truncate: true,
  });

  await writeCSV(f, rows);

  f.close();
}

function gettabledata(html, selector) {
  const $ = cheerio.default.load(html);

  var html_table = $(selector);

  var table_header = html_table.find("th").map(function () {
    return $(this).text().trim().replace(/[\r\n\t\x0B\x0C\u0085\u2028\u2029]+/g," ").replaceAll(" ","");
  }).toArray();

  var rowspans = html_table.find("tbody tr").map(function (tr_index) {
    // gets all rowspans for the current row; loops through all td cells of the current tr row
    var tr_rowspans = $(this).find("td").map(function (td_index) {
      // shotern the reference to the rowspan value of the current td cell since it's used more than once
      var rowspan_count = $(this).attr("rowspan");
      // build an object with the index of the current tr, td, the rowspan value, and the the td value
      return {
        "tr_index": tr_index,
        "td_index": rowspan_count ? td_index : 0,
        "count": Number(rowspan_count) || 0,
        "value": $(this).text().trim().replace(/[\r\n\t\x0B\x0C\u0085\u2028\u2029]+/g," ").replaceAll(" ",""),
      };
    }).toArray().filter(function (item) {
      return item.count;
    });
    // the filter above ^ removes undefined items form the array
    // returns the rowspans for the current row
    return tr_rowspans;
  }).toArray();
  // gets table cell values; loops through all tr rows
  var table_data = html_table.find("tbody tr").map(function (tr_index) {
    // gets the cells value for the row; loops through each cell and returns an array of values
    // note: nothing special happens to the cells at this point
    var cells = $(this).find("td").map(function (td_index) {
      return $(this).text().trim().replace(/[\r\n\t\x0B\x0C\u0085\u2028\u2029]+/g," ").replaceAll(" ","");
    }).toArray();
    // adds missing cells to each row of data; loops through each rowspan collected
    rowspans.forEach(function (rowspan) {
      // defines the min and max rows; uses tr index to get the first index, and tr index + rowspan value to get the last index
      var span = {
        "min": rowspan.tr_index,
        "max": rowspan.tr_index + rowspan.count,
      };
      // if the current row is within the min and max
      if (tr_index > span.min && tr_index < span.max) {
        // add an array element where the missing cell data should be and add the cell value at the same time
        cells.splice(rowspan.td_index, 0, rowspan.value);
      }
    });
    // returns an array of the cell data generated
    return [cells];
  }).toArray();

  console.log("table_header", table_header);

  return [table_header].concat(table_data);
}

async function bcupdate() {
  const bcupdateurl =
    "https://www.welcomebc.ca/Immigrate-to-B-C/Invitations-To-Apply";
  const mdbasedir = "./_feeds/_british/";

  const yesterday = moment(new Date()).subtract(1, "days");

  const shfilename = "britishita.sh";
  const shfilearray = [];
  let shcontent = "";

  const response = await fetch(bcupdateurl);
  const html = await response.text();

  // var html_table2 = $("div.page-content-main table:nth-of-type(2)");
  // gets table header titles; loops through all th data, and pulls an array of the values

  // var table_header2 = html_table2.find("th").map(function () {
  //   return $(this).text().trim();
  // }).toArray();
  // gets all rowspans inside the table; loops through all tr rows

  let table_data1 = gettabledata(
    html,
    "div.page-content-main table:first-of-type",
  );
  let table_data2 = gettabledata(
    html,
    "div.page-content-main table:nth-of-type(2)",
  );

  // output the table headers
  // console.log("table_data1", table_data1);
  // output the table data
  // console.log("table_data2", table_data2);

  await savecsv("_feeds/_british/Skills-Immigration-invitations-2023.csv",table_data1);

  await savecsv("_feeds/_british/Entrepreneur-Immigration-invitations-2023.csv",table_data2);

  return;

  for (const theupdate of updates) {
    let headerraw = theupdate.header.replaceAll(":", "-");
    let headstrings = headerraw.split(":");
    let dateraw = headstrings[0].trim();

    console.log(dateraw);

    let date = moment(dateraw);
    if (!date.isAfter(yesterday)) return;

    let dateymd = date.format("YYYY-MM-DD");
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
    ).replaceAll(
      "#",
      "",
    ).replaceAll(" ", "-").replaceAll("--", "-");

    let updatehtml = theupdate.content;

    let htmlfilename = `${dateymd}-${titlepath}.html`;
    const mdfilename = htmlfilename.replace(".html", "_britishita.md");
    const cnmdfilename = mdfilename.replace("_britishita", "_cn");
    const fcgmdfilename = mdfilename.replace(".md", "_fcg.md");
    const jekyllfrontmatterfilename = mdfilename.replace(".md", "_fm.md");

    let frontmatter = `---
    layout: post
    title:  ${title}
    description: '${headerraw}'
    date:   ${dateymd}
    categories: british
    ---
    
    `;

    // console.log(frontmatter);

    shfilearray.push(`# ${headerraw}\n`);
    shfilearray.push(`html2md -i "${htmlfilename}" | tee "tmp_${mdfilename}"`);
    shfilearray.push(
      `sed 's/\\[\\([^][]*\\)\\]([^()]*)/\\1/g' "tmp_${mdfilename}" | sed '/Tags:/,$d;/googletag/d;/On this page/d;/Sponsor Content/d;/Some parts of this/d;/british/d;/Schedule a Free/d;/Get a Free/d;/====/d;/Visit CanadaVisa.com/d;' | cat -s | tee "${mdfilename}"`,
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
      `echo "\\nFCGvisa translated, https://www.welcomebc.ca All Rights Reserved." >> "${fcgmdfilename}.txt"\n`,
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

      // console.log(`${mdbasedir}${shfilename} saved!`);
    } catch (error) {
      console.log(error);
    }
  }
}

bcupdate();
