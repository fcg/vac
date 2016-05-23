require 'Nokogiri'
require 'open-uri'
require 'openssl'
require 'sqlite3'
require 'csv'
require 'net/http'

CEILINGS   = "//*[@id='tab-content-3']/table"
CEILINGTRS = "//*[@id='tab-content-3']/table/tbody/tr"
TURL = "https://www.border.gov.au/Busi/Empl/skillselect"
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def updatecsv()



end

def postceiling()

end

def upateceilling()

  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'

  html = open(TURL, 'User-Agent' => ua)

  doc = Nokogiri::HTML::parse(html, nil, charset)

  table = doc.css(".table-100").last

  trs = table.css("tbody>tr")

  db = SQLite3::Database.open "csol.db"

  trs.each do |tr|

    td1anzsco4 = tr.xpath("td[1]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
    td2nameen  = tr.xpath("td[2]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip
    td3ceiling  = tr.xpath("td[3]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i
    td4result   = tr.xpath("td[4]").inner_text.gsub(/\u00A0/,"").gsub(/\u200B/,"").strip.to_i

    # if td1anzsco4 == "3241" then
    #   p "#{td4result} : #{td1anzsco4}"
    #
    #   rows = db.execute("update ceilings set result = ? where anzsco4 = ?", [td4result, td1anzsco4])
    # end

  end

end

def initcsv()

  db = SQLite3::Database.open "csol.db"

  currentfn = "20160427.csv"

  f1516 = "ceilling-15-16.csv"

  dir = "../_data/sol/"

  rows = db.execute("select anzsco4, bbsid, nameen, namecn, ceiling, result, change, ceiling - result as remain from ceilings order by  remain")

  CSV.open("#{dir}#{f1516}", "w") do |csv|
    csv << %w(anzsco4 bbsid nameen namecn ceiling result change remain)
    rows.each do |row|
      csv << row
    end
  end

end

initcsv

# upateceilling()
