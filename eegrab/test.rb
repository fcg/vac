require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'
  
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  url = 'http://www.cic.gc.ca/english/department/mi/'
  charset = 'utf-8'
  html = open(url, 'User-Agent' => ua)

  # html = open("miee.html")
  doc = Nokogiri::HTML.parse(html, nil, charset)

  invitationsxpath = ".//*[@id='mi-pr-express']/p[5]/strong[4]/text()"
  rankxpath = ".//*[@id='mi-pr-express']/p[6]/strong[3]/text()"
  # datexpath = ".//*[@id='mi-pr-express']/p[5]/strong[2]/span/text()"
  datexpath = ".//*[@id='mi-pr-express']/h3/text()"
  mieexpath = ".//*[@id='mi-pr-express']"

  datecss = '.nowrap'

  miee = doc.xpath(mieexpath).to_html
  invitations = doc.xpath(invitationsxpath).to_s.delete(',').to_i
  rank = doc.xpath(rankxpath).to_s.delete(',').to_i
  head = doc.xpath(datexpath).to_s
  raw = head.strip.delete("\u00A0")
  text,eedate = head.split("\u2013")
  # eedate = doc.css(datecss).last.inner_text.to_s.delete("\u2013").strip.delete("\u00A0")

  puts text,eedate