require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require "sqlite3"
require "csv"
require "yaml"
require 'date'
require 'openssl'

TURL = 'http://www.immigratemanitoba.com/news-and-notices/'

def get_doc(url)

	ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
	charset = 'utf-8'
	error = nil;
	html = open(url, 'User-Agent' => ua)
	doc = Nokogiri::HTML::parse(html, nil, charset)
end

def parse_eoi(url)

  db = SQLite3::Database.open "eedraws.db"

puts 'parse new mbeoi and insert into db'

  doc = get_doc(url)

  puts h2s = doc.css(".entry-content>p>strong")[1].text

  num,date = h2s.strip.split("#")[1].split("–")
  
  p num = num.strip
  p updated = Date.parse(date.gsub("\u00A0","").strip).strftime("%Y-%m-%d")

  strongs = doc.css(".entry-content>ul>li>strong")

  p inmbnum = strongs[0].text.split(":").last.strip.gsub(" ","")
  p inmbrank =   strongs[1].text.split(":").last.strip.gsub(" ","")
  p overseasnum = strongs[2].text.split(":").last.strip.gsub(" ","").split(" ")[0]
  p overseasrank =   strongs[3].text.split(":").last.strip.gsub(" ","")

  db.execute("insert into mbeoi (num,inmbnum,inmbrank,overseasnum,overseasrank,updated) values (?,?,?,?,?,?)",[num,inmbnum,inmbrank,overseasnum,overseasrank,updated])
 
puts '从数据库重新生成 csv'

  db.results_as_hash = false

  rows = db.execute("select num,updated,inmbnum,inmbrank,overseasnum,overseasrank from mbeoi order by num desc")

  db.results_as_hash = true
  sums = db.execute("select max(num) nums,sum(inmbnum)+sum(overseasnum) ioall, sum(inmbnum) inall, sum(overseasnum) outall, min(inmbrank) minin, max(inmbrank) maxin,min(overseasrank) minoverseas,max(overseasrank)  maxoverseas from mbeoi")

  puts "Results = #{sums[0].inspect}"

  mbeoidir = '../_data/mb'
  postdir = '../_posts/'
  csvname = 'eoi2016.csv'
  ymlname = 'sum2016.yml'    

  CSV.open("#{mbeoidir}/#{csvname}","w") do |csv|

    csv << "num,updated,inmbnum,inmbrank,overseasnum,overseasrank".split(",")

    rows.each do |row|
      csv << row
    end

    sum = sums[0]

    csv << ["总:","飞出国",sum[2],sum[4],sum[3],sum[6]]
  end

puts '生成 post'

frontstr = <<-YAML
---
layout: post
title:  "曼省技术移民 EOI #{updated} 总第 #{num} 捞：境外 #{overseasnum} 人，#{overseasrank} 分；曼省内 #{inmbnum} 人，#{inmbrank} 分"
date:   #{updated} 23:56:00  +0800
categories: MB
---
YAML


intrstr = <<-INTR

飞出国：加拿大时间 #{updated} 曼省省提名技术移民 EOI 第 #{num} 捞：境外 #{overseasnum} 人，#{overseasrank} 分，曼省境内 #{inmbnum} 人，#{inmbrank} 分。

- 曼省境内 [SKILLED WORKERS IN MANITOBA]：
  - Number of Letters of Advice to Apply issued: #{inmbnum}
  - Ranking score of lowest-ranked candidate invited: #{inmbrank}
- 境外 [SKILLED WORKERS OVERSEAS]：
  - Number of Letters of Advice to Apply issued: #{overseasnum} 
  - Ranking score of lowest-ranked candidate invited: #{overseasrank} 分

详细的请参考飞出国论坛：[曼省EOI邀请记录]。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（fcgvisabbs）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

------

[曼省EOI邀请记录]: http://bbs.fcgvisa.com/t/eoi-mpnp-under-the-expression-of-interest-system-draws/3723
[SKILLED WORKERS IN MANITOBA]: http://bbs.fcgvisa.com/t/swm-eligibility-mpnp-skilled-workers-in-manitoba/3684
[SKILLED WORKERS OVERSEAS]: http://bbs.fcgvisa.com/t/swo-eligibility-mpnp-skilled-workers-overseas/3698

INTR

    mbpostfile = "#{updated}-MPNP-EOI-Draw-#{num}"

    File.open("#{postdir}#{mbpostfile}.md", 'w') do |file|

      content = frontstr + intrstr

      file.write content

    end


end
parse_eoi("http://www.immigratemanitoba.com/2017/03/16/eoi-draw-no-28/")
#parse_eoi("http://www.immigratemanitoba.com/2017/02/27/eoi-draw-no-27/")
#parse_eoi("http://www.immigratemanitoba.com/2016/12/21/eoi-draw-no-24/")
#parse_eoi("http://www.immigratemanitoba.com/2016/12/30/eoi-draw-no-25/")
#parse_eoi("http://www.immigratemanitoba.com/2017/01/30/eoi-draw-no-26/")
