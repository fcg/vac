require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'
require 'yaml'
require 'date'
require 'openssl'

# 下载 pdf ，通过下列网址转换为 html，调用 factsheet 脚本，创建数据库，发布。
# https://www.idrsolutions.com/online-pdf-to-html5-converter/

def parse_html(_dir)
  db = SQLite3::Database.open 'nzeoi.db'

  html1 = open("#{_dir}/1.html")

  charset = 'utf-8'

  doc = Nokogiri::HTML.parse(html1, nil, charset)

  p datedby = doc.css('#t7_1').text.delete('.').strip

  updated = DateTime.parse(datedby).strftime('%Y-%m-%d')

  highpointseois = doc.css('#t9_1').text.strip
  highpoints = doc.css('#tb_1').text.strip
  lowpointseois = doc.css('#te_1').text.strip
  lowpoints = doc.css('#tg_1').text.strip

  totaleois = doc.css('#tn_1').text.strip
  totalpeople = doc.css('#tp_1').text.strip

  eoisinpool = doc.css('#tt_1').text.gsub('There are ', '').gsub('EOIs in the pool after the selection.', '').delete(',').strip

  puts "#{datedby}-#{highpointseois}-#{highpoints}-#{lowpointseois}-#{lowpoints}-#{totaleois}-#{totalpeople}-#{eoisinpool}"

  # job, nojob, total 2-3-4
  points140off = doc.css('#t17_1').text.strip
  points140offnojob = doc.css('#t16_1').text.strip
  points140offjob = doc.css('#t15_1').text.strip

  points140on = doc.css('#t1b_1').text.strip
  points140onnojob = doc.css('#t1a_1').text.strip
  points140onjob = doc.css('#t19_1').text.strip

  p140subtotal = doc.css('#t1f_1').text.strip
  p140subtotalnojob = doc.css('#t1e_1').text.strip
  p140subtotaljob = doc.css('#t1d_1').text.strip

  p100_140joboff = doc.css('#t1l_1').text.strip
  p100_140joboffnojob = doc.css('#t1k_1').text.strip
  p100_140joboffjob = doc.css('#t1j_1').text.strip

  p100_140jobon = doc.css('#t1p_1').text.strip
  p100_140jobonnojob = doc.css('#t1o_1').text.strip
  p100_140jobonjob = doc.css('#t1n_1').text.strip

  p100subtotal = doc.css('#t1t_1').text.strip
  p100subtotalnojob = doc.css('#t1s_1').text.strip
  p100subtotaljob = doc.css('#t1r_1').text.strip

  total = doc.css('#t1x_1').text.strip
  totalnojob = doc.css('#t1w_1').text.strip
  totaljob = doc.css('#t1v_1').text.strip

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

  # db.execute(insert_sql, [points140offjob,
  #                         points140offnojob,
  #                         points140off,
  #                         points140onjob,
  #                         points140onnojob,
  #                         points140on,
  #                         p140subtotaljob,
  #                         p140subtotalnojob,
  #                         p140subtotal,
  #                         p100_140joboffjob,
  #                         p100_140joboffnojob,
  #                         p100_140joboff,
  #                         p100_140jobonjob,
  #                         p100_140jobonnojob,
  #                         p100_140jobon,
  #                         p100subtotaljob,
  #                         p100subtotalnojob,
  #                         p100subtotal,
  #                         totaljob,
  #                         totalnojob,
  #                         total,
  #                         updated])

  html2 = open("#{_dir}/2.html")

  charset = 'utf-8'

  doc2 = Nokogiri::HTML.parse(html2, nil, charset)

  trans = YAML.load(File.open('ctytrans.yml'))

  countrylist = ''

  toparr = [] # 中文名称
  topCountry = []
  topPercentage = []

  topCountry[0] = doc2.css('#t7_2').text.strip
  topPercentage[0] = doc2.css('#t8_2').text.strip

  topCountry[1] = doc2.css('#t9_2').text.strip
  topPercentage[1] = doc2.css('#ta_2').text.strip

  topCountry[2] = doc2.css('#tb_2').text.strip
  topPercentage[2] = doc2.css('#tc_2').text.strip

  topCountry[3] = doc2.css('#td_2').text.strip
  topPercentage[3] = doc2.css('#te_2').text.strip

  topCountry[4] = doc2.css('#tf_2').text.strip
  topPercentage[4] = doc2.css('#tg_2').text.strip

  topCountry[5] = doc2.css('#th_2').text.strip
  topPercentage[5] = doc2.css('#ti_2').text.strip

  topCountry[6] = doc2.css('#tj_2').text.strip
  topPercentage[6] = doc2.css('#tk_2').text.strip

  topCountry[7] = doc2.css('#tl_2').text.strip
  topPercentage[7] = doc2.css('#tm_2').text.strip

  topCountry[8] = doc2.css('#tn_2').text.strip
  topPercentage[8] = doc2.css('#to_2').text.strip

  topCountry[9] = doc2.css('#tp_2').text.strip
  topPercentage[9] = doc2.css('#tq_2').text.strip

  topCountry[10] = doc2.css('#tr_2').text.strip
  topPercentage[10] = doc2.css('#ts_2').text.strip

  (0...topCountry.size).each do |i|
    country = topCountry[i]

    country = trans[country] unless trans[country].nil? || trans[country].empty?
    percent = topPercentage[i]

    toparr.push country

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

申请人来源国，#{toparr[0]} 最多，#{toparr[1]} 和 #{toparr[2]} 其次，分别占#{topPercentage[0]}，#{topPercentage[1]} 和 #{topPercentage[2]}。

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

  postdir = '../_posts/'
  filename = "#{updated}-SMC-EOI-selection.md"

  File.open("#{postdir}#{filename}", 'w') do |file|
    content = template + countrytable

    file.write content
  end
end

def parseSheet(_dir)
  parse_html(_dir)
end

parseSheet('FactSheet20160106')
parseSheet('FactSheet20160203')
parseSheet('FactSheet20160330')
# parseSheet('FactSheet20160622')
# parseSheet('FactSheet20160706')
# parseSheet('FactSheet20160720')
