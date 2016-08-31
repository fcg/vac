# http://www.immigratemanitoba.com/mpnp-for-skilled-workers/expression-of-interest/
# http://www.immigratemanitoba.com/eoi-draw-archive/

require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require "sqlite3"
require "csv"
require "yaml"
require 'date'
require 'openssl'

TURL = 'http://www.immigratemanitoba.com/mpnp-for-skilled-workers/expression-of-interest/'

def get_doc(url)

	ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
	charset = 'utf-8'
	error = nil;
  # html = open("vic-graduates.html")
	html = open(url, 'User-Agent' => ua)
	doc = Nokogiri::HTML::parse(html, nil, charset)
end

def post()

  db = SQLite3::Database.open "eedraws.db"

db.results_as_hash = false
  rows = db.execute("select num,updated,inmbnum,inmbrank,overseasnum,overseasrank from mbeoi order by num asc")

db.results_as_hash = true
  sums = db.execute("select max(num) nums,sum(inmbnum)+sum(overseasnum) ioall, sum(inmbnum) inall, sum(overseasnum) outall, min(inmbrank) minin, max(inmbrank) maxin,min(overseasrank) minoverseas,max(overseasrank)  maxoverseas from mbeoi")

 puts "Results = #{sums[0].inspect}"

  mbeoidir = 'D:\FCGGH\vac\_data\mb'
  csvname = 'eoi2016.csv'
  ymlname = 'sum2016.yml'

  # d = YAML::load_file("#{mbeoidir}/#{ymlname}") #Load
  # d['content'] = 2 #Modify
  File.open("#{mbeoidir}/#{2016/7/30}", 'w+') {|f| f.write sums[0].to_yaml }

  CSV.open("#{mbeoidir}/#{csvname}","w") do |csv|

    csv << "num,updated,inmbnum,inmbrank,overseasnum,overseasrank".split(",")

    rows.each do |row|
      csv << row
    end

    sum = sums[0]

    csv << ["总:","飞出国",sum[2],sum[4],sum[3],sum[6]]
  end

end

def parse_new()
  db = SQLite3::Database.open "eedraws.db"

  doc = get_doc(TURL)
  h2s = doc.css("h2")

  num,no = h2s.first.text.strip.split("#")[1].split("–")

  date = h2s[1].text.strip

  num = num.strip

  updated = Date.parse(date.strip).strftime("%Y-%m-%d")

  strongs = doc.css("p>strong")

  inmbnum = strongs[0].text.split(":").last.strip.gsub(" ","")
  inmbrank =   strongs[1].text.split(":").last.strip.gsub(" ","")
  overseasnum = strongs[2].text.split(":").last.strip.gsub(" ","")
  overseasrank =   strongs[3].text.split(":").last.strip.gsub(" ","")

  db.execute("insert into mbeoi (num,inmbnum,inmbrank,overseasnum,overseasrank,updated) values (?,?,?,?,?,?)",[no,inmbnum,inmbrank,overseasnum,overseasrank,updated])

end

parse_new()
post()

def parse_archive()

	db = SQLite3::Database.open "eedraws.db"

  # doc = get_doc(ATURL)

  html = open("mbeoi.htm")
  charset = 'utf-8'

  doc = Nokogiri::HTML::parse(html, nil, charset)

  h2s = doc.css("h2")
  # h3s = doc.css("h3")
  strongs = doc.css("p>strong")

  puts strongs.size

  h2s.each_with_index do |mh2,index|

    i = index + 1

# MPNP under the Expression of Interest System – Draw #1 – May 20, 2015
    no,date = mh2.text.strip.split("#")[1].split("–")

    no = no.strip

    updated = Date.parse(date.strip).strftime("%Y-%m-%d")

    # ionoff = i*2 Skilled Workers in Manitoba - Skilled Workers Overseas
    # puts h3s[ionoff].text + " " + h3s[ionoff+1].text
    # num, rank
begin
    istrong = i*5

    inmbnum = strongs[istrong-5].text.split(":").last.strip.gsub(" ","")
    inmbrank =   strongs[istrong-4].text.split(":").last.strip.gsub(" ","")
    overseasnum = strongs[istrong-3].text.split(":").last.strip.gsub(" ","")
    overseasrank =   strongs[istrong-2].text.split(":").last.strip.gsub(" ","")

    db.execute("insert into mbeoi (num,inmbnum,inmbrank,overseasnum,overseasrank,updated) values (?,?,?,?,?,?)",[no,inmbnum,inmbrank,overseasnum,overseasrank,updated])
  rescue Exception => ex
    puts ex.message
    puts strongs[istrong]
  end

  end

end

# parse_archive()

def creatembeoi()

	db = SQLite3::Database.open "eedraws.db"

	rows = db.execute <<-SQL
		create table mbeoi (
			Id INTEGER PRIMARY KEY AUTOINCREMENT,
			num INTEGER DEFAULT NULL,
			inmbnum INTEGER DEFAULT NULL,
			inmbrank INTEGER DEFAULT NULL,
			overseasnum INTEGER DEFAULT NULL,
			overseasrank INTEGER DEFAULT NULL,
			updated TEXT DEFAULT NULL
		);
	SQL

	db.close

end

# creatembeoi()
