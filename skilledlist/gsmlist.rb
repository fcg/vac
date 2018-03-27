require 'Nokogiri'
require 'open-uri'
require 'sqlite3'
require 'csv'
require 'yaml'
require 'openssl'
require 'net/http'
require 'reverse_markdown'

MLTSSLURL = 'http://flyabroad.io/au/occupations-lists/mltssl'.freeze
STSOLURL = 'http://flyabroad.io/au/occupations-lists/stsol'.freeze
ROLURL = 'http://flyabroad.io/au/occupations-lists/rol'.freeze

TRSXPATH = '//*[@id="body"]/table/tbody/tr'.freeze

# OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def buildmltssl
    db = SQLite3::Database.open 'anzsco.db'
  
    bbsids = YAML.load(File.open('../_data/common/anz6tobbs.yml'))
    anznames = YAML.load(File.open('../_data/common/anznames.yml'))
    postdate = Time.now.strftime('%Y-%m-%d')
    mltsslfile = "ignore/#{postdate}-mltssl-list.md"
  
    trarr = []
    linkarr = []
  
    trarr.push "ANZSCO | 职业名称 - 飞出国 | 职业列表 | 适用签证 - fcgvisa | 评估机构"
    trarr.push '------ | ------ | ------ | ------ | ------'
  
    db.execute("select c.anzsco,c.nameen,c.list,c.visas,c.ass from
        gsmlist g,combined c where g.list = 'MLTSSL' AND g.anzsco=c.anzsco") do |row|
      td1anzsco = row[0]
      td2nameen = row[1]
      td3list  = row[2]
      td4visas = row[3]
      td5ass = row[4]
  
      bbsid = bbsids[td1anzsco.to_i]
      anzcn = anznames[td1anzsco]
  
      td4visalinks = td4visas.split(',')
      td4visalink = nil
  
      td4visalinks.each do |link|
        td4visalink = if td4visalink.to_s.empty? then "[#{link.strip}]"
                      else
                        "#{td4visalink},[#{link.strip}]"
                      end
      end
  
      td5asslinks = td5ass.split('/')
      td5asslink = nil
  
      td5asslinks.each do |link|
        td5asslink = if td5asslink.to_s.empty? then "[#{link.strip}]"
                     else
                       "#{td5asslink}/[#{link.strip}]"
                     end
      end
  
      mdrow = "[#{td1anzsco}] | #{anzcn}/#{td2nameen} | [#{td3list}] | #{td4visalink} | #{td5asslink}"
  
      trarr.push mdrow
      linkarr.push "[#{td1anzsco}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}?target=blank"
    end
  
    solhtml = trarr.join("\n")
    links = linkarr.join("\n")
  
    context = solhtml + "\n\n" + links
  
    File.open(mltsslfile, 'w') { |file| file.write(context) }
  end

  buildmltssl()

def buildstsol
    db = SQLite3::Database.open 'anzsco.db'
  
    bbsids = YAML.load(File.open('../_data/common/anz6tobbs.yml'))
    anznames = YAML.load(File.open('../_data/common/anznames.yml'))
    postdate = Time.now.strftime('%Y-%m-%d')
    stsolfile = "ignore/#{postdate}-stsol-list.md"
  
    trarr = []
    linkarr = []
  
    trarr.push "ANZSCO | 职业名称 - 飞出国 | 职业列表 | 适用签证 - fcgvisa | 评估机构"
    trarr.push '------ | ------ | ------ | ------ | ------'
  
    db.execute("select c.anzsco,c.nameen,c.list,c.visas,c.ass from
        gsmlist g,combined c where g.list = 'STSOL' AND g.anzsco=c.anzsco") do |row|
      td1anzsco = row[0]
      td2nameen = row[1]
      td3list  = row[2]
      td4visas = row[3]
      td5ass = row[4]
  
      bbsid = bbsids[td1anzsco.to_i]
      anzcn = anznames[td1anzsco]
  
      td4visalinks = td4visas.split(',')
      td4visalink = nil
  
      td4visalinks.each do |link|
        td4visalink = if td4visalink.to_s.empty? then "[#{link.strip}]"
                      else
                        "#{td4visalink},[#{link.strip}]"
                      end
      end
  
      td5asslinks = td5ass.split('/')
      td5asslink = nil
  
      td5asslinks.each do |link|
        td5asslink = if td5asslink.to_s.empty? then "[#{link.strip}]"
                     else
                       "#{td5asslink}/[#{link.strip}]"
                     end
      end
  
      mdrow = "[#{td1anzsco}] | #{anzcn}/#{td2nameen} | [#{td3list}] | #{td4visalink} | #{td5asslink}"
  
      trarr.push mdrow
      linkarr.push "[#{td1anzsco}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}?target=blank"
    end
  
    solhtml = trarr.join("\n")
    links = linkarr.join("\n")
  
    context = solhtml + "\n\n" + links
  
    File.open(stsolfile, 'w') { |file| file.write(context) }
  end

#   buildstsol

def buildrol
  db = SQLite3::Database.open 'anzsco.db'

  bbsids = YAML.load(File.open('../_data/common/anz6tobbs.yml'))
  anznames = YAML.load(File.open('../_data/common/anznames.yml'))
  postdate = Time.now.strftime('%Y-%m-%d')
  rolfile = "ignore/#{postdate}-rol-list.md"

  trarr = []
  linkarr = []

  trarr.push "ANZSCO | 职业名称 - 飞出国 | 职业列表 | 适用签证 - fcgvisa | 评估机构"
  trarr.push '------ | ------ | ------ | ------ | ------'

  db.execute("select c.anzsco,c.nameen,c.list,c.visas,c.ass from
      gsmlist g,combined c where g.list = 'ROL' AND g.anzsco=c.anzsco") do |row|
    td1anzsco = row[0]
    td2nameen = row[1]
    td3list  = row[2]
    td4visas = row[3]
    td5ass = row[4]

    bbsid = bbsids[td1anzsco.to_i]
    anzcn = anznames[td1anzsco]

    td4visalinks = td4visas.split(',')
    td4visalink = nil

    td4visalinks.each do |link|
      td4visalink = if td4visalink.to_s.empty? then "[#{link.strip}]"
                    else
                      "#{td4visalink},[#{link.strip}]"
                    end
    end

    td5asslinks = td5ass.split('/')
    td5asslink = nil

    td5asslinks.each do |link|
      td5asslink = if td5asslink.to_s.empty? then "[#{link.strip}]"
                   else
                     "#{td5asslink}/[#{link.strip}]"
                   end
    end

    mdrow = "[#{td1anzsco}] | #{anzcn}/#{td2nameen} | [#{td3list}] | #{td4visalink} | #{td5asslink}"

    trarr.push mdrow
    linkarr.push "[#{td1anzsco}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}?target=blank"
  end

  solhtml = trarr.join("\n")
  links = linkarr.join("\n")

  context = solhtml + "\n\n" + links

  File.open(rolfile, 'w') { |file| file.write(context) }
end

# buildrol

###################### download and parse ########################

def download_doc
  open(DFILE, 'wb') do |file|
    puts 'download combined html'
    file << open(TURL, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
  end
end

def get_doc(theurl)
  html = open(theurl)
  charset = 'utf-8'
  doc = Nokogiri::HTML.parse(html, nil, charset)
end

def parse_list
  db = SQLite3::Database.open 'anzsco.db'
  updated = DateTime.now.strftime('%Y-%m-%d')

  doc = get_doc(MLTSSLURL)

  trs = doc.xpath(TRSXPATH)

  trs.each do |tr|
    anzsco = tr.xpath('td[1]').inner_text.strip
    namecn = tr.xpath('td[2]').inner_text.strip
    nameen = tr.xpath('td[3]').inner_text.strip
    ass = tr.xpath('td[4]').inner_text.strip
    list = 'MLTSSL'

    db.execute("insert into gsmlist (anzsco, namecn, nameen, ass, list, updated)
        VALUES (?,?,?,?,?,?)", [anzsco, namecn, nameen, ass, list, updated])
  end

  doc = get_doc(STSOLURL)

  trs = doc.xpath(TRSXPATH)

  trs.each do |tr|
    anzsco = tr.xpath('td[1]').inner_text.strip
    namecn = tr.xpath('td[2]').inner_text.strip
    nameen = tr.xpath('td[3]').inner_text.strip
    ass = tr.xpath('td[4]').inner_text.strip
    list = 'STSOL'

    db.execute("insert into gsmlist (anzsco, namecn, nameen, ass, list, updated)
        VALUES (?,?,?,?,?,?)", [anzsco, namecn, nameen, ass, list, updated])
  end

  doc = get_doc(ROLURL)

  trs = doc.xpath(TRSXPATH)

  trs.each do |tr|
    p anzsco = tr.xpath('td[1]').inner_text.strip
    namecn = tr.xpath('td[2]').inner_text.strip
    nameen = tr.xpath('td[3]').inner_text.strip
    ass = tr.xpath('td[4]').inner_text.strip
    list = 'ROL'

    db.execute("insert into gsmlist (anzsco, namecn, nameen, ass, list, updated)
        VALUES (?,?,?,?,?,?)", [anzsco, namecn, nameen, ass, list, updated])
  end
end

def recreategsmlisttable
  db = SQLite3::Database.open 'anzsco.db'
  db.execute('DROP TABLE if exists gsmlist')

  rows = db.execute <<-SQL
      create table gsmlist (
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      anzsco TEXT DEFAULT NULL,
      namecn TEXT DEFAULT NULL,
      nameen TEXT DEFAULT NULL,
      ass TEXT DEFAULT NULL,
      list TEXT DEFAULT NULL,
      updated TEXT DEFAULT NULL
      );
    SQL

  db.close
  end

# recreategsmlisttable()
# parse_list()
