require 'Nokogiri'
require 'open-uri'
require 'sqlite3'
require 'csv'
require "yaml"
require 'openssl'
require 'net/http'
require 'reverse_markdown'
require 'mdtable'

# puts MDTable.convert [['col1', 'col2', 'col3'], [1,2,3]]

TRXPATH   = '//*[@id="ctl00_PlaceHolderMain_PublishingPageContent__ControlWrapper_RichHtmlField"]/table[2]/tbody/tr'
NOMI1516 = ".//*[@id='sub-heading-3']/table[2]/tbody/tr"
DFILE = "ignore/combined.html"

TURL = "https://www.homeaffairs.gov.au/trav/work/work/skills-assessment-and-assessing-authorities/skilled-occupations-lists/combined-stsol-mltssl"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def download_doc()

	open(DFILE, 'wb') do |file|
	  puts "download combined html"
	  file << open(TURL, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
	end

end

ReverseMarkdown.config do |config|
  config.unknown_tags     = :pass_through
  config.github_flavored  = true
  config.tag_border  = ''
end

def save_combined_list()

  db = SQLite3::Database.open "anzsco.db"
  html = open(DFILE)
  charset = 'utf-8'
  doc = Nokogiri::HTML::parse(html, nil, charset)

  updated = DateTime.now.strftime("%Y-%m-%d")

  trs = doc.xpath(TRXPATH)

  trs.each do |tr|

      next if tr.xpath("td[1]").empty? 
      next if tr.xpath("td[1]") == "Occupation"
      occupation = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").gsub("\r\n","").gsub("  "," ").gsub("       "," ").gsub("           "," ").gsub("  "," ").strip
      td1nameen = occupation
      td2anzsco  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").strip
      td3list  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").strip
      td4visas = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").strip
      td5ass  = tr.xpath("td[5]").inner_text.gsub(/\u00A0/,"").strip

    db.execute("insert into combined (anzsco, nameen, list, visas, ass, updated) VALUES (?,?,?,?,?,?)",[td2anzsco,td1nameen,td3list,td4visas,td5ass,updated])

  end

end

def buildmdtable()

  db = SQLite3::Database.open "anzsco.db"

  bbsids = YAML.load(File.open("../_data/common/anz6tobbs.yml"))
  anznames = YAML.load(File.open("../_data/common/anznames.yml"))
  postdate = Time.now.strftime("%Y-%m-%d")
  savefile = "ignore/#{postdate}-combined-list.md"

  td1nameen = nil
  td2anzsco = nil
  td3ass = nil

  trarr = Array.new
  linkarr = Array.new

  trarr.push "ANZSCO | 职业名称 - 飞出国 | 职业列表 | 适用签证 - fcgvisa | 评估机构"
  trarr.push "------ | ------ | ------ | ------ | ------"

  db.execute("select anzsco, nameen, list, visas, ass from combined") do |row|

    td1anzsco  = row[0]
    td2nameen = row[1]
    td3list  = row[2]
    td4visas = row[3]
    td5ass  = row[4]
    
    bbsid = bbsids[td1anzsco.to_i]
    anzcn = anznames[td1anzsco]

    td4visalinks = td4visas.split(",")
    td4visalink=nil

    td4visalinks.each do |link|

        if td4visalink.to_s.empty? then td4visalink = "[#{link.strip}]"
        else
            td4visalink = "#{td4visalink},[#{link.strip}]"
        end
    end

    td5asslinks = td5ass.split("/")
    td5asslink=nil

    td5asslinks.each do |link|

        if td5asslink.to_s.empty? then td5asslink = "[#{link.strip}]"
        else
            td5asslink = "#{td5asslink}/[#{link.strip}]"
        end
    end

	mdrow = "[#{td1anzsco}] | #{anzcn}/#{td2nameen} | [#{td3list}] | #{td4visalink} | #{td5asslink}"

    trarr.push mdrow
    linkarr.push "[#{td1anzsco}]: http://bbs.fcgvisa.com/t/flyabroad/#{bbsid}?target=blank"
	
  end

  solhtml = trarr.join("\n")
  links = linkarr.join("\n")

  context = solhtml + "\n\n" + links

  File.open(savefile, 'w') { |file| file.write(context) }

end

def recreatecombinedtable()

  db = SQLite3::Database.open "anzsco.db"
  db.execute("DROP TABLE if exists combined")

  rows = db.execute <<-SQL
    create table combined (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    anzsco TEXT DEFAULT NULL,
    nameen TEXT DEFAULT NULL,
    list TEXT DEFAULT NULL,
    visas TEXT DEFAULT NULL,
    ass TEXT DEFAULT NULL,
    updated TEXT DEFAULT NULL
    );
  SQL

  db.close
end

# download_doc()
recreatecombinedtable()
save_combined_list()

buildmdtable()