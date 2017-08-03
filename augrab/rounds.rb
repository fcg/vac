require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'reverse_markdown'

NOMI16   = ".//*[@id='sub-heading-3']/table[1]/tbody/tr"
NOMI1516 = ".//*[@id='sub-heading-3']/table[2]/tbody/tr"

TURL = "http://www.border.gov.au/Trav/Work/Skil"

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

  # updated = "2017-02-01"

  tbs = maindiv.css("table")

  n189 = tbs[0].css("td")[1].inner_text.gsub(",","").to_i
  n489 = tbs[0].css("td")[3].inner_text.gsub(",","").to_i

  t189 = tbs[1].css("tr")[1].css("td").last.text.strip
  t489 = tbs[1].css("tr")[2].css("td").last.text.strip
  tall = tbs[1].css("tr")[3].css("td").last.text.strip

  dtp189 = tbs[2].css("td")[1].text.strip
  dtp489 = tbs[2].css("td")[4].text.strip

p tbs[2].css("td")[2].text.strip 
p tbs[2].css("td")[5].text.strip

  dt189 = DateTime.strptime(tbs[2].css("td")[2].text.gsub("\u00A0","").strip, "%d/%m/%Y %l:%M %p").strftime("%Y-%m-%d %H:%M")
  dt489 = DateTime.strptime(tbs[2].css("td")[5].text.gsub("\u00A0","").strip, "%d/%m/%Y %l:%M %p").strftime("%Y-%m-%d %H:%M")

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

更多请参考飞出国论坛： [澳洲技术移民 Skillselect EOI 2017-2018 年度邀请记录 - fcgvisa](http://bbs.fcgvisa.com/t/skillselect-eoi-2017-2018/24327)。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（fcgvisabbs）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

ENDS

File.open("#{postdir}#{updated}-Skillselect-Round-Results.md", 'w') do |file|

  content = frontstr + intrstr + rawcontext + linkstr

  file.write content

end

end

parse_current("https://www.border.gov.au/WorkinginAustralia/Pages/12-july-2017-round-results.aspx")