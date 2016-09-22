require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'reverse_markdown'

NOMI16   = ".//*[@id='sub-heading-3']/table[1]/tbody/tr"
NOMI1516 = ".//*[@id='sub-heading-3']/table[2]/tbody/tr"
TURL = "https://www.border.gov.au/Busi/Empl/skillselect"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def download_skillselect()

	open('skillselect.html', 'wb') do |file|
	  puts "download skillselect html"
	  file << open(TURL, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

def download_doc(url,name)

	open("2016/#{name}", 'wb') do |file|
	  puts "download #{name}"
	  file << open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

ReverseMarkdown.config do |config|
  config.unknown_tags     = :pass_through
  config.github_flavored  = true
  config.tag_border  = ''
end

# 解析最新澳洲 skillselect round 邀请情况并生成对应的 csv 文件和 post 文件
def parse_current(filename)

  csvdir = '..\\_data\\ee\\'
  postdir = '..\\_posts\\'

  html = open(filename)
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

  maindiv = doc.css(".ym-gbox-left").last

  body = ReverseMarkdown.convert maindiv.inner_html

  rawcontext = body.gsub("[](/","[](https://www.border.gov.au/").gsub(/\| \n/,"\| ").gsub(/\n \|/," \|").lines.join("> ")

  datestring = maindiv.css("div")[1].css("strong")[0].text.gsub("Invitations issued\u00A0on\u00A0","").gsub("\u00A0"," ").strip
  updated = DateTime.parse(datestring).strftime("%Y-%m-%d")

  tbs = maindiv.css("table")

  n189 = tbs[0].css("td")[1].inner_text.gsub(",","").to_i
  n489 = tbs[0].css("td")[3].inner_text.gsub(",","").to_i

  t189 = tbs[1].css("tr")[1].css("td").last.text.strip
  t489 = tbs[1].css("tr")[2].css("td").last.text.strip
  tall = tbs[1].css("tr")[3].css("td").last.text.strip

  dtp189 = tbs[2].css("td")[1].text.strip
  dtp489 = tbs[2].css("td")[4].text.strip

  # DateTime.strptime("1 April 2016 12.19 pm​", "%d %b %Y %I.%M %p").strftime("%Y-%m-%d %H:%M")
  dt189 = DateTime.strptime(tbs[2].css("td")[2].text.strip, "%d %b %Y %I.%M %p").strftime("%Y-%m-%d %H:%M")
  dt489 = DateTime.strptime(tbs[2].css("td")[5].text.strip, "%d %b %Y %I.%M %p").strftime("%Y-%m-%d %H:%M")

  # accountants2211p = tbs[3].css("td")[2].text.strip
  # accountants2211d = DateTime.strptime(tbs[3].css("td")[3].text.strip, "%d %b %Y %I.%M %p").strftime("%Y-%m-%d %H:%M")
  # ict2611p = tbs[3].css("td")[6].text.strip
  # ict2611d = DateTime.strptime(tbs[3].css("td")[7].text.strip, "%d %b %Y %I.%M %p").strftime("%Y-%m-%d %H:%M")
  # soft2613p = tbs[3].css("td")[10].text.strip
  # soft2613d = DateTime.strptime(tbs[3].css("td")[11].text.strip, "%d %b %Y %I.%M %p").strftime("%Y-%m-%d %H:%M")

  frontstr = <<-FRON
---
layout: post
title:  "澳洲技术移民 Skillselect EOI  #{updated} 邀请结果，189 签证邀请 #{n189} 份，489 亲属担保 #{n489} 份"
date:   #{updated} 13:56:00  +0800
categories: gsm
---

FRON

  intrstr = <<-INTR
## 澳洲技术移民 Skillselect EOI  #{updated} 邀请结果

飞出国：#{updated} 澳洲技术移民 EOI 发出 189 签证邀请 #{n189} 份，489 亲属担保 #{n489} 份，
截止到 #{updated}，澳洲技术移民 EOI 2016-2017 年度共发出 189 邀请 #{t189} 份，489 邀请 #{t489} 份，总计 #{tall} 份。

本次邀请中，189 邀请分数 #{dtp189} 分（截止到 #{dt189}），489 邀请分数 #{dtp489}（截止到 #{dt489}）。

INTR

  linkstr = <<-ENDS

更多请参考飞出国论坛： [澳洲技术移民 Skillselect EOI 2016-2017 年度邀请记录 - fcgvisa](http://bbs.fcgvisa.com/t/skillselect-eoi-2016-2017/17031)。
ENDS

File.open("#{postdir}#{updated}-Skillselect-Round-Results.md", 'w') do |file|

  content = frontstr + intrstr + rawcontext

  file.write content

end

end

# http://www.border.gov.au/Trav/Work/Skil/6-july-2016-round-results
# parse_current("http://www.border.gov.au/WorkinginAustralia/Pages/8-june-2016-round-results.aspx")
# parse_current("http://www.border.gov.au/Trav/Work/Skil/6-july-2016-round-results")
# parse_current("https://www.border.gov.au/Trav/Work/Skil/3-august-2016-round-results")
# parse_current("http://www.border.gov.au/WorkinginAustralia/pages/17-august-2016-round-results.aspx")
parse_current("http://www.border.gov.au/WorkinginAustralia/pages/14-september-2016-round-results.aspx")

def parse2016()
# 解析文档，下载每次的数据，解析并post
download_skillselect()
html = open("skillselect.html")
charset = 'utf-8'

doc = Nokogiri::HTML::parse(html, nil, charset)

div3 = doc.css('.tabbody')[2]

lis = div3.css("ul li a")

uri = URI(TURL)

(3...6).each do |i|

	currenturlpath = lis[i].attr("href").gsub(".aspx","")

	currenturl = "#{uri.scheme}://#{uri.host}#{currenturlpath}"

	fname = "#{currenturlpath.split('/').last}.html"

	# download_doc(currenturl,fname)

	parse_current(fname)

end

end

# parse2016()

def invitation_round_tabbody2()
  # div[aria-labelledby="ui-id-3"]
  # div[aria-labeledby="next-invitation-rounds"]

  html = open("skillselect.html")
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

  div3 = doc.css('.tabbody')[2]

  current = div3.css('p a')

  currentdate = current.inner_text
  currenturlpath = current.attr('href').to_s

  # 当前邀请部分及下次邀请时间和邀请人数

  uri = URI(TURL)

  currenturl = "#{uri.scheme}://#{uri.host}#{currenturlpath}"

  fname = "#{currenturlpath.split('/').last}.html"

  # next
  next1 = div3.css('h4')[0].inner_text.strip
  next2 = div3.css('h4')[1].inner_text.strip

  next1tb = doc.css('.table-100')[0]

  next1date = DateTime.parse(next1).strftime("%Y-%m-%d")
  next1189 = next1tb.css("td")[1].inner_text.strip
  next1489 = next1tb.css("td")[3].inner_text.strip

  next2tb = doc.css('.table-100')[1]

  next2date = DateTime.parse(next2).strftime("%Y-%m-%d")
  next2189 = next2tb.css("td")[1].inner_text.strip
  next2489 = next2tb.css("td")[3].inner_text.strip

end

# invitation_round_tabbody2()

def update_nominations()
  # ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  #
  # charset = 'utf-8'
  #
  # html = open(TURL, 'User-Agent' => ua)
  #
  html = open("skillselect.html")
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

  db = SQLite3::Database.open "csol.db"

  updated = "2016-03-30"
  type = "16"

  # t1 = './/*[@id="ctl00_PlaceHolderMain_PublishingPageContent__ControlWrapper_RichHtmlField"]/div/div[3]/div[5]/table[1]/tbody/tr'

  nomicss = ".table-100.small"

  tables = doc.css(nomicss)

  tables[0].css("tbody>tr").each do |tr|
    visa = tr.xpath("td[1]").inner_text.strip
    act = tr.xpath("td[2]").inner_text.strip.to_i
    nsw  = tr.xpath("td[3]").inner_text.strip.to_i
    nt  = tr.xpath("td[4]").inner_text.strip.to_i
    qld = tr.xpath("td[5]").inner_text.strip.to_i
    sa  = tr.xpath("td[6]").inner_text.strip.to_i
    tas  = tr.xpath("td[7]").inner_text.strip.to_i
    vic = tr.xpath("td[8]").inner_text.strip.to_i
    wa  = tr.xpath("td[9]").inner_text.strip.to_i

puts "#{visa} - #{tr.xpath("td[10]").inner_text.strip}"

if visa.empty?

  puts "#{tr.to_s}"

end
    next if visa == "Total"
    next if visa == "​Visa subclass"
    next if visa.empty?

    db.execute("insert into nominations (visa,act,nsw,nt,qld,sa,tas,vic,wa,type,updated) values (?,?,?,?,?,?,?,?,?,?,?)",
    [visa,act,nsw,nt,qld,sa,tas,vic,wa,type,updated])

  end

    type = "1516"
    # t2 = './/*[@id="ctl00_PlaceHolderMain_PublishingPageContent__ControlWrapper_RichHtmlField"]/div/div[3]/div[5]/table[2]/tbody/tr'

    tables[1].css("tbody>tr").each do |tr|
      visa = tr.xpath("td[1]").inner_text.strip
      act = tr.xpath("td[2]").inner_text.strip.to_i
      nsw  = tr.xpath("td[3]").inner_text.strip.to_i
      nt  = tr.xpath("td[4]").inner_text.strip.to_i
      qld = tr.xpath("td[5]").inner_text.strip.to_i
      sa  = tr.xpath("td[6]").inner_text.strip.to_i
      tas  = tr.xpath("td[7]").inner_text.strip.to_i
      vic = tr.xpath("td[8]").inner_text.strip.to_i
      wa  = tr.xpath("td[9]").inner_text.strip.to_i


      next if visa == "Total"
      next if visa == "​Visa subclass"
      next if visa.empty?

puts "#{visa} - #{tr.xpath("td[10]").inner_text.strip}"

      if visa == "​Visa subclass"

        puts "#{tr.to_s}"

      end

      db.execute("insert into nominations (visa,act,nsw,nt,qld,sa,tas,vic,wa,type,updated) values (?,?,?,?,?,?,?,?,?,?,?)",
      [visa,act,nsw,nt,qld,sa,tas,vic,wa,type,updated])

  end

  db.close

end

# 签证类型, 州（7个）, 邀请人数, type(15还是1516), 当前时间
# nominations  任何一个州的改变都重新插入，total 自动汇总
#
# curent-nominations-2016
# curent-nominations-1516
# Visa subclass	ACT	NSW	NT	Qld	SA	Tas.	Vic.	WA	Total
def createnominations()

  db = SQLite3::Database.open "csol.db"

  rows = db.execute <<-SQL
    create table nominations (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      visa TEXT DEFAULT NULL,
      act INTEGER DEFAULT NULL,
      nsw INTEGER DEFAULT NULL,
      nt INTEGER DEFAULT NULL,
      qld INTEGER DEFAULT NULL,
      sa INTEGER DEFAULT NULL,
      tas INTEGER DEFAULT NULL,
      vic INTEGER DEFAULT NULL,
      wa INTEGER DEFAULT NULL,
      type TEXT DEFAULT NULL,
      updated TEXT DEFAULT NULL
    );
  SQL

  db.close

end

# createnominations()
# update_nominations()
