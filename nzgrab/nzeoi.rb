# http://formshelp.immigration.govt.nz/SkilledMigrant/ExpressionOfInterest/historyofselectionpoints/eoi2016.htm
# http://formshelp.immigration.govt.nz/SkilledMigrant/ExpressionOfInterest/historyofselectionpoints/eoi2015.htm
# http://www.immigration.govt.nz/migrant/general/generalinformation/news/eoiselection.htm
# http://www.htmlpublish.com/
require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'
require 'yaml'
require 'date'
require 'openssl'
# require 'kristin'

# https://www.idrsolutions.com/online-pdf-to-html5-converter/

TURL = 'http://formshelp.immigration.govt.nz/SkilledMigrant/ExpressionOfInterest/historyofselectionpoints/eoi2016.htm'.freeze

# 413 316 已经完成，下载最新的，通过在线方式转为htm，放到 2016 目录下，parse
# http://www.pdfonline.com/convert-pdf-to-html/

def get_doc(url)
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  charset = 'utf-8'
  error = nil
  # html = open("vic-graduates.html")
  html = open(url, 'User-Agent' => ua)
  doc = Nokogiri::HTML.parse(html, nil, charset)
end

def download_doc(url, name)
  open("2016/#{name}", 'wb') do |file|
    puts "download #{name}"
    file << open(url, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE).read
  end
end

def parse_html(file)
  puts file

  db = SQLite3::Database.open 'nzeoi.db'

  html = open(file)
  charset = 'utf-8'

  doc = Nokogiri::HTML.parse(html, nil, charset)

  begin

    datedby = doc.css('.ft3')[0].text.delete('.').strip

    updated = DateTime.parse(datedby).strftime('%Y-%m-%d')

    highpointseois = doc.css('.ft6').text.strip
    # highpoints = doc.css(".ft2")[1].text.strip
    lowpointseois = doc.css('.ft8').text.strip
    lowpoints = doc.css('.ft3')[1].text.strip
    highpoints = doc.css('.ft3')[2].text.strip

    totaleois = doc.css('.ft3')[3].text.strip
    totalpeople = doc.css('.ft3')[4].text.strip

    eoisinpool = pools = doc.css('.p7.ft3').text.gsub('There are ', '').gsub('EOIs in the pool after the selection.', '').delete(',').strip

    eoisinpool = doc.css('.p7.ft7').text.gsub('There are ', '').gsub('EOIs in the pool after the selection.', '').delete(',').strip if pools.empty?

    puts "#{datedby}-#{highpointseois}-#{highpoints}-#{lowpointseois}-#{lowpoints}-#{totaleois}-#{totalpeople}-#{eoisinpool}"

  rescue Exception => e

    p e

    datedby = doc.css('.ft2')[1].text.delete('.').strip

    updated = DateTime.parse(datedby).strftime('%Y-%m-%d')

    highpointseois = doc.css('.ft5').text.strip
    # highpoints = doc.css(".ft2")[1].text.strip
    lowpointseois = doc.css('.ft6').text.strip
    lowpoints = doc.css('.ft7')[0].text.strip
    highpoints = doc.css('.ft7')[1].text.strip

    totaleois = doc.css('.ft7')[2].text.strip
    totalpeople = doc.css('.ft7')[3].text.strip

    eoisinpool = pools = doc.css('.p7.ft3').text.gsub('There are ', '').gsub('EOIs in the pool after the selection.', '').delete(',').strip

    eoisinpool = doc.css('.p7.ft7').text.gsub('There are ', '').gsub('EOIs in the pool after the selection.', '').delete(',').strip if pools.empty?

    puts "#{datedby}-#{highpointseois}-#{highpoints}-#{lowpointseois}-#{lowpoints}-#{totaleois}-#{totalpeople}-#{eoisinpool}"

  end

  p doc.inner_text

  table1 = doc.css('tr')

  trs = table1

  p   trs

  # job, nojob, total 2-3-4
  points140off = trs[4].css('p')[4].inner_text.strip
  points140offnojob = trs[4].css('p')[3].inner_text.strip
  points140offjob = trs[4].css('p')[2].inner_text.strip
  points140on = trs[6].css('p')[4].inner_text.strip
  points140onnojob = trs[6].css('p')[3].inner_text.strip
  points140onjob = trs[6].css('p')[2].inner_text.strip
  p140subtotal = trs[8].css('p')[4].inner_text.strip
  begin
     p140subtotal = trs[8].css('p')[5].inner_text.strip
   rescue
     puts "p140subtotal is #{p140subtotal}"
   end

  p140subtotalnojob = trs[8].css('p')[3].inner_text.strip
  p140subtotaljob = trs[8].css('p')[2].inner_text.strip
  p100_140joboff = trs[9].css('p')[4].inner_text.strip
  p100_140joboffnojob = trs[9].css('p')[3].inner_text.strip
  p100_140joboffjob = trs[9].css('p')[2].inner_text.strip

  begin
    p100_140jobon = trs[12].css('p')[4].inner_text.strip
    p100_140jobonnojob = trs[12].css('p')[3].inner_text.strip
    p100_140jobonjob = trs[12].css('p')[2].inner_text.strip
    p100subtotal = trs[14].css('p')[4].inner_text.strip
    p100subtotalnojob = trs[14].css('p')[3].inner_text.strip
    p100subtotaljob = trs[14].css('p')[2].inner_text.strip
    ##
    puts points140off + points140offjob + points140offnojob
    puts p100subtotal

    puts trs.size

    total = trs[15].css('p')[4].inner_text.strip ##
    totalnojob = trs[15].css('p')[3].inner_text.strip
    totaljob = trs[15].css('p')[2].inner_text.strip

  rescue Exception => e
    puts e

    p100_140jobon = trs[11].css('p')[4].inner_text.strip
    p100_140jobonnojob = trs[11].css('p')[3].inner_text.strip
    p100_140jobonjob = trs[11].css('p')[2].inner_text.strip
    p100subtotal = trs[13].css('p')[4].inner_text.strip
    p100subtotalnojob = trs[13].css('p')[3].inner_text.strip
    p100subtotaljob = trs[13].css('p')[2].inner_text.strip
    ##
    puts points140off + points140offjob + points140offnojob
    puts p100subtotal

    puts trs.size

    total = trs[14].css('p')[4].inner_text.strip ##
    totalnojob = trs[14].css('p')[3].inner_text.strip
    totaljob = trs[14].css('p')[2].inner_text.strip
  end

  # http://bbs.fcgvisa.com/t/2016-eoi/8622

  insert_sql = <<-INSERT
	insert into nzeoi (
		points140offjob,
		points140offnojob,
		points140offall,
		points140onjob,
		points140onnojob,
		points140onall,
		p140subtotaljob,
		p140subtotalnojob,
		p140subtotalall,
		p100_140joboffjob,
		p100_140joboffnojob,
		p100_140joboffall,
		p100_140jobonjob,
		p100_140jobonnojob,
		p100_140jobonall,
		p100subtotaljob,
		p100subtotalnojob,
		p100subtotalall,
		totaljob,
		totalnojob,
		totalall,
		updated
	) values
	(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)

	INSERT

  # db.execute(insert_sql,[points140offjob,
  # 		points140offnojob,
  # 		points140off,
  # 		points140onjob,
  # 		points140onnojob,
  # 		points140on,
  # 		p140subtotaljob,
  # 		p140subtotalnojob,
  # 		p140subtotal,
  # 		p100_140joboffjob,
  # 		p100_140joboffnojob,
  # 		p100_140joboff,
  # 		p100_140jobonjob,
  # 		p100_140jobonnojob,
  # 		p100_140jobon,
  # 		p100subtotaljob,
  # 		p100subtotalnojob,
  # 		p100subtotal,
  # 		totaljob,
  # 		totalnojob,
  # 		total,
  # 		updated])

  td1s = doc.css('.p10.ft5')

  td2s = doc.css('.p25.ft5')

  trans = YAML.load(File.open('ctytrans.yml'))

  countrylist = ''

  toparr = []
  topparr = []

  (0...td1s.size).each do |i|
    country = td1s[i].text.strip # + td2s[i].text

    country = trans[country] unless trans[country].nil? || trans[country].empty?
    percent = td2s[i].text

    toparr.push country
    topparr.push percent

    countrylist += "<tr><td>#{country}</td><td>#{percent}</td></tr>"
  end

  template = <<-TMP
---
layout: post
title:  "#{updated} 新西兰技术移民 SMC EOI 捞取结果"
date:   #{updated} 14:00:00
categories: smc
---

## 新西兰EOI捞取结果 #{datedby} － 飞出国

### New Zealand Residence Programme － 飞出国

### Fortnightly Selection Statistics - #{datedby}

#{updated} 新西兰EOI邀请 #{total} 份申请，总申请人 #{totalpeople} 人。

境外申请有 #{points140offnojob} 份没有 job offer 但超过140分的被自动邀请。

新西兰境外申请里低于140分的有 #{p100_140joboff} 份获得邀请，都有 job offer。

申请人来源国，#{toparr[0]} 最多，#{toparr[1]} 和 #{toparr[2]} 其次，分别占#{topparr[0]}，#{topparr[1]} 和 #{topparr[2]}。

### 1. SMC 邀请情况概况 - 飞出国

<table>
<tr>
<th>筛选标准</th>
<th>EOI 邀请数</th></tr>
<tr>
<td>超过140分</td>
<td><b>#{p140subtotal}</b></td></tr>
<tr>
<td>
<p>低于140分但有雇主offer的</p></td>
<td><b>#{p100subtotal}</b></td></tr>
<tr>
<th>
<p>总邀请数</p></th>
<th>
<p><b>#{total}</b></p></th></tr></table>

### 2. SMC 邀请情况细节 － 飞出国

<table>
<tr>
<td/>
<td/>
<td>有 job offer</td>
<td>无 job offer</td>
<td>总计：</td></tr>
<tr>
<td/>
<td>类型</td>
<td/>
<td/>
<td/>
</tr>
<tr>
<td>140 分及以上</td>
<td>新西兰境外</td>
<td>#{points140offjob}</td>
<td>#{points140offnojob}</td>
<td>#{points140off}</td>
</tr>
<tr>
<td/>
<td>新西兰境内</td>
<td>#{points140onjob}</td>
<td>#{points140onnojob}</td>
<td>#{points140on}</td>
</tr>
<tr>
<td>小计：</td>
<td/>
<td><b>#{p140subtotaljob}</b></td>
<td><b>#{p140subtotalnojob}</b></td>
<td><b>#{p140subtotal}</b></td>
</tr>
<tr>
<td>有job offer分数低于140的</td>
<td>新西兰境外</td>
<td>#{p100_140joboffjob}</td>
<td>-</td>
<td>#{p100_140joboff}</td>
</tr>
<tr>
<td/><td>新西兰境内</td>
<td>#{p100_140jobonjob}</td>
<td>-</td>
<td>#{p100_140jobon}</td>
</tr>
<tr>
<td>小计：</td>
<td/>
<td><b>#{p100subtotaljob}</b></td>
<td>-</td>
<td><b>#{p100subtotaljob}</b></td>
</tr>
<tr>
<td>总计：</td>
<td/>
<td><b>#{totaljob}</b></td>
<td><b>#{totalnojob}</b></td>
<td><b>#{total}</b></td>
</tr>
</table>

### 3. 来源国 Nationality Composition of EOIs

TMP

  countrytable = <<-CTB
<table>
<tr>
<td>Nationality</td>
<td>Percentage</td>
</tr>
#{countrylist}
<tr>
<td/>
<td>100%</td>
</tr>
</table>

您也可以去飞出国论坛讨论：[新西兰技术移民2016年eoi邀请记录](http://bbs.fcgvisa.com/t/2016-eoi/8622) 。

CTB

  filename = "#{updated}-SMC-EOI-selection.md"

  File.open(filename, 'w') do |file|
    # {postdir}

    content = template + countrytable

    file.write content
  end
end

def p2016tohtml
  Dir['*.htm'].each do |f|
    # of = f.gsub('.pdf', '.htm')
    #
    # Kristin.convert(f, of)
    # 不成功，用 http://www.htmlpublish.com/ 处理

    parse_html(f)
  end
end

# parse_html("2016/FactSheet20160316.htm")

def download_last
  doc = get_doc(TURL)
  uri = URI(TURL)
  allhref = doc.css('a')

  allhref.each do |ahref|
    h = ahref.attr('href').to_s
    next if h.start_with?('#')
    next if h.start_with?('javascript')
    next if h.empty?

    currenturlpath = h.delete("\u00A0").strip

    currenturl = "#{uri.scheme}://#{uri.host}#{currenturlpath}"

    fname = currenturlpath.split('/').last.to_s

    p currenturl

    download_doc(currenturl, fname)

    break
  end
end

def createnzeoi
  db = SQLite3::Database.open 'nzeoi.db'

  rows = db.execute <<-SQL
		create table nzeoi (
			Id INTEGER PRIMARY KEY AUTOINCREMENT,
			points140offjob INTEGER DEFAULT NULL,
			points140offnojob INTEGER DEFAULT NULL,
			points140offall INTEGER DEFAULT NULL,
			points140onjob INTEGER DEFAULT NULL,
			points140onnojob INTEGER DEFAULT NULL,
			points140onall INTEGER DEFAULT NULL,
			p140subtotaljob INTEGER DEFAULT NULL,
			p140subtotalnojob INTEGER DEFAULT NULL,
			p140subtotalall INTEGER DEFAULT NULL,
			p100_140joboffjob INTEGER DEFAULT NULL,
			p100_140joboffnojob INTEGER DEFAULT NULL,
			p100_140joboffall INTEGER DEFAULT NULL,
			p100_140jobonjob INTEGER DEFAULT NULL,
			p100_140jobonnojob INTEGER DEFAULT NULL,
			p100_140jobonall INTEGER DEFAULT NULL,
			p100subtotaljob INTEGER DEFAULT NULL,
			p100subtotalnojob INTEGER DEFAULT NULL,
			p100subtotalall INTEGER DEFAULT NULL,
			totaljob INTEGER DEFAULT NULL,
			totalnojob INTEGER DEFAULT NULL,
			totalall INTEGER DEFAULT NULL,
			-- type TEXT DEFAULT NULL,
			updated TEXT DEFAULT NULL
		);
	SQL

  db.close
end

# createnzeoi()
# 330 203 106

download_last
# p2016tohtml
