require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'
require 'yaml'
require 'date'
require 'openssl'
require 'net/http'

FLYTASURL = 'http://vac.fcgvisa.com/gsm/2017/09/17/tas-489-190-3A-list/'.freeze
XPATHTABLETRS = '/html/body/div[2]/div[2]/div[1]/table/tbody/tr'.freeze

def get_doc(url)
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'
  html = open(url, 'User-Agent' => ua)
  doc = Nokogiri::HTML.parse(html, nil, charset)
end

def get_save_list
  db = SQLite3::Database.open 'anzsco.db'
  updated = DateTime.now.strftime('%Y-%m-%d')
  charset = 'utf-8'

  doc = get_doc(FLYTASURL)

  trs = doc.xpath(XPATHTABLETRS)

  trs.each do |tr|
    td1anzsco = tr.xpath('td[1]').inner_text.delete(' ').strip
    td2nameen = tr.xpath('td[2]').inner_text.delete(' ').strip
    td3ass = tr.xpath('td[3]').inner_text.delete(' ').strip
    # td4ielts = tr.xpath('td[4]').inner_text.delete(' ').strip
    # td5ass = tr.xpath('td[5]').inner_text.delete(' ').strip

    db.execute('insert into tas (anzsco, nameen, ass, updated) VALUES (?,?,?,?)', [td1anzsco, td2nameen, td3ass, updated])
  end
end

# def datafromcsv
#   db = SQLite3::Database.open 'anzsco.db'

#   CSV.foreach('TAS/SMP-20160824.csv', headers: true) do |row|
#     db.execute 'insert into tas (anzsco,nameen,ass) values ( ?, ?, ? )', row.fields
#   end

#   db.close
# end

def buildtashtml
  trans = YAML.load(File.open('../_data/common/trans.yml'))
  bbsids = YAML.load(File.open('../_data/common/anz6tobbs.yml'))
  anznames = YAML.load(File.open('../_data/common/anznames.yml'))
  postdate = Time.now.strftime('%Y-%m-%d')
  thefile = "ignore/#{postdate}-tas-state-nominated-occupation-lists.md"

  db = SQLite3::Database.open 'anzsco.db'

  trarr = []
  linkarr = []

  trarr.push "ANZSCO | 职业名称 - 飞出国 | 职业列表 | 评估机构"
  trarr.push '------ | ------ | ------ | ------'

  db.execute('select c.anzsco, c.nameen, c.list, c.ass
    from tas t,combined c where t.anzsco = c.anzsco') do |row|
    anzsco = row[0]
    nameen = row[1]
    list = row[2]
    ass = row[3]

    bbsid = bbsids[anzsco.to_i]
    anzcn = anznames[anzsco]

    asslinks = ass.split('/')
    asslink = nil

    asslinks.each do |link|
      asslink = if asslink.to_s.empty? then "[#{link.strip}]"
                else
                  "#{asslink}/[#{link.strip}]"
                   end
    end

    mdrow = "[#{anzsco}] | #{anzcn}/#{nameen} | [#{list}] | #{asslink}"

    trarr.push mdrow
    linkarr.push "[#{anzsco}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}?target=blank"
  end

  footnote = <<-NOTE

  
更多参考飞出国论坛：[TAS 塔州担保申请要求，流程及注意事项](http://bbs.fcgvisa.com/t/topic/10884)。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（fcgvisabbs）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。
NOTE

  frontstr = <<-FRONTS
---
layout: post
title:  "#{postdate} TAS 塔州州最新州担保职业及担保状态"
date:   #{postdate} 17:56:00  +0800
categories: gsm
---

### 2017-2018 年度塔州最新州担保职业清单 TSOL - 飞出国

下表是 2017年9月18日 TAS 塔州最新州担保清单（TSOL）。

该清单主要适用于境外 489 申请人（ ‘Overseas Applicant Category (3A)’ for the Skilled Regional
(Provisional) visa (subclass 489)）

FRONTS

  solhtml = trarr.join("\n")
  links = linkarr.join("\n")

  thehtml = "#{frontstr}#{solhtml}#{links}#{footnote}"

  File.open(thefile, 'w') { |file| file.write(thehtml) }
end

def recreatetastable
  db = SQLite3::Database.open 'anzsco.db'
  db.execute('DROP TABLE if exists tas')

  rows = db.execute <<-SQL
CREATE TABLE `tas` (
    `Id`	INTEGER PRIMARY KEY AUTOINCREMENT,
    `anzsco`	TEXT DEFAULT NULL,
    `nameen`	TEXT DEFAULT NULL,
    `namecn`	TEXT DEFAULT NULL,
    `ielts`	TEXT DEFAULT NULL,
    `ass`	TEXT DEFAULT NULL,
    `updated` TEXT DEFAULT NULL
)
SQL

  db.close
end

# recreatetastable
# get_save_list
buildtashtml
