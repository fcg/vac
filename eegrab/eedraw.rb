require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'

def parsenewee
  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  url = 'http://www.cic.gc.ca/english/department/mi/'
  charset = 'utf-8'
  html = open(url, 'User-Agent' => ua)

  # html = open("miee.html")
  doc = Nokogiri::HTML.parse(html, nil, charset)

  # invitationsxpath = ".//*[@id='mi-pr-express']/p[5]/strong[4]/text()"
  # rankxpath = ".//*[@id='mi-pr-express']/p[6]/strong[3]/text()"
  # invitationsxpath = ".//*[@id='mi-pr-express']/p[5]/strong[2]/text()"
  # invitationsxpath = ".//*[@id='mi-pr-express']/p[5]/strong[4]/text()"
  invitationsxpath = "/html/body/div/div/main/section[1]/details[2]/p[5]/strong[4]/text()"
  # rankxpath = ".//*[@id='mi-pr-express']/p[6]/strong/text()"
  # rankxpath = ".//*[@id='mi-pr-express']/p[6]/strong[3]/text()"
  rankxpath = "/html/body/div/div/main/section[1]/details[2]/p[6]/strong[3]/text()"
  # datexpath = ".//*[@id='mi-pr-express']/p[5]/strong[2]/span/text()"
  # datexpath = ".//*[@id='mi-pr-express']/h3/text()"
  # datexpath = ".//*[@id='mi-pr-express']/h3/time/text()"
  # datexpath = ".//*[@id='mi-pr-express']/p[6]/strong[1]/text()"
  datexpath = "html/body/div/div/main/section[1]/details[2]/p[6]/strong[1]/text()"
  # mieexpath = ".//*[@id='mi-pr-express']"
  mieexpath = "html/body/div/div/main/section[1]/details[2]"

  datecss = '.nowrap'

  miee = doc.xpath(mieexpath).to_html
  invitations = doc.xpath(invitationsxpath).to_s.delete(',').to_i
  rank = doc.xpath(rankxpath).to_s.delete(',').to_i

  ##eedate = doc.xpath(datexpath).to_s.strip.delete("\u00A0").split("\u2013")[1].strip
  p eedate = doc.xpath(datexpath).to_s.gsub("\u00A0"," ")
  # eedate = doc.css(datecss).last.inner_text.to_s.delete("\u2013").strip.delete("\u00A0")

  # d = Date.parse(date).strftime('%F')

  ReverseMarkdown.config do |config|
    config.unknown_tags     = :bypass
    config.github_flavored  = true
    config.tag_border = ''
  end

  miBody = ReverseMarkdown.convert miee

  db = SQLite3::Database.open 'eedraws.db'

  maxnum = db.execute('select MAX(TotalNum) from eedraws').first[0]
  inyear = db.execute("select NumInYear from eedraws where TotalNum='#{maxnum}'").first[0] + 1
  totalnum = maxnum + 1

  # ymdDate = Date.parse(eedate[0]).strftime('%F')

  ymdDate = Date.strptime(eedate, '%b %d, %Y').strftime('%Y-%m-%d')

  row = [ymdDate, invitations, rank, totalnum, inyear, miBody]

  db.execute("INSERT INTO eedraws (EEDate, EEinvitations,EErank,TotalNum,NumInYear,MIBody)
          VALUES (?, ?,?,?,?,?)", row)

  db.close
end

def posttovac
  bbslink = 'http://bbs.fcgvisa.com/t/2017-express-entry-ita-ee/20819'
  csvdir = '../_data/ee/'
  postdir = '../_posts/'

  db = SQLite3::Database.open 'eedraws.db'

  unposted = 'select TotalNum,date(EEDate), EEinvitations,EErank,NumInYear,MIBody from eedraws where posted is null'
  updateposted = 'update eedraws set posted = 1 where TotalNum = ?'
  selectposted = 'select TotalNum,date(EEDate), EEinvitations,EErank,NumInYear from eedraws where TotalNum <= ? order by TotalNum desc' # 修改为按倒叙排列

  arr = []

  db.execute(unposted) do |row|
    totalnum = row[0],
               eedate = row[1],
               eeinvitations = row[2],
               eerank = row[3],
               numinyear = row[4],
               mibody = row[5]

    currentNum = totalnum[0]

    maxrank = db.execute('select MAX(EErank) from eedraws where TotalNum <= ?', [currentNum]).first[0]
    minrank = db.execute('select MIN(EErank) from eedraws where TotalNum <= ?', [currentNum]).first[0]
    sumnum  = db.execute('select SUM(EEinvitations) from eedraws where TotalNum <= ?', [currentNum]).first[0]

    #  p currentNum
    #  p currentNum[0]

    eecsvfile = "EE#{eedate}"
    eepostfile = "#{eedate}-Express-Entry-Draw-#{currentNum}-#{eerank}-points-#{eeinvitations}"

    CSV.open("#{csvdir}EE#{eedate}.csv", 'w') do |csv|
      csv << %w(no date people points numinyear)
      db.execute(selectposted, currentNum) do |draw|
        csv << draw
      end
      csv << [minrank, "飞出国", "累计人数:", sumnum, "最低分数:"]
      # 飞出国	累计人数：	71081	最低分数：	450
    end

    frontstr = <<-YAML
---
layout: post
title:  "Express Entry #{eedate} 2017 年第 #{numinyear} 捞：#{eeinvitations}人，#{eerank}分"
date:   #{eedate} 23:56:00  +0800
categories: EE
---
YAML

    intrstr = <<-INTR

飞出国：加拿大时间 #{eedate}，CIC 发布 Express Entry 2017 年第 #{numinyear} 捞（总第 #{currentNum} 捞），#{eeinvitations}人，#{eerank}分。

2017年6月6日，加拿大联邦技术移民

2016年11月19日，加拿大联邦技术移民快速通道类别更改评分标准，[降低job offer加分，增加加拿大学历加分](http://bbs.fcgvisa.com/t/significant-changes-to-comprehensive-ranking-system-crs-for-express-entry-immigration-system/19886)，2017年6月6日，EE CRS 进一步调整评分标准，增加[加拿大亲属分数及法语额外加分](http://www.flyabroadnews.com/express-entry-comprehensive-ranking-system-crs-2017-flyabroad/)。

加拿大联邦技术移民 [Express Entry] 不要求申请人有雇主offer，也没有职业和专业限制，对加拿大受管制职业也不要求获得省政府的认证，只需要满足加拿大联邦技术移民 [FSW]，加拿大经验类移民 [CEC] 或 加拿大技工类移民 [FST] 任何一种加拿大联邦技术移民签证类别要求就可以创建 Express Entry profile 到池子排队（EE pool），然后加拿大联邦移民部会不定期根据分数高低发出 EE 邀请，获得邀请后90天内提交移民签证申请，提交移民签证申请后有半年左右时间就可以获得签证了。

2016年11月19日，加拿大 Express Entry CRS 评分标准调整，加拿大雇主 offer 大部分只能加 50 分，600 分以上申请人明显减少，同时随着加拿大联邦 EE 邀请人数增加，EE 邀请分数已经大大低于 450 分，当前最低是 #{minrank} 分就可以获得邀请，这给学历高，语言好，有加拿大学历或加拿大工作经验的申请人提供了方便快捷的申请方式，随着 #{minrank} 分上申请人被联邦捞取，加拿大安大略省省提名项目 400 分类别申请人里大部分获得邀请的应该是 400 - #{minrank} 之间申请人，对安省省提名 [HCP] 类别也是利好消息。

**2017年6月6日后，加拿大 Express Entry 又遇重大调整：**

继2016年11月19日降低 job offer分，提高加拿大学历分后，2017年6月6日起，加拿大 Express Entry CRS 将增加法语和加拿大兄弟姐妹申请人的额外加分，法语CLB7，英语CLB5的可以额外加30分，有兄弟姐妹的可以额外加15分。

<table class="table table-bordered table-hover table-condensed">
<tbody><tr>
<td>法语加分</td>
<td>法语CLB7同时英语CLB4，15分额外加分；法语CLB7同时英语CLB5，30分额外加分。</td>
</tr>
<tr>
<td>兄弟姐妹加分</td>
<td>有18周以上加拿大公民或永久居民且居住在加拿大的兄弟姐妹，可以额外加15分。</td>
</tr>
<tr>
<td>Job Bank 可选注册</td>
<td>注册Job Bank成为自愿的选项，不再强制，简化申请。</td>
</tr>
</tbody></table>

飞出国：CLB 级别与考试成绩对应关系

- CLB 4：IELTS 听4.5，读3.5，写4，说4
- CLB 5：IELTS 听5，读4，写5，说5
- NLC 7：TEF 读207-232，写310-348，听249-279，说 310-348

如果不能符合加拿大联邦 EE 最低分数，也不满足安省 400 分项目类别，申请人还可以考虑 Express Entry 下的省提名项目，具体请见飞出国论坛或飞出国技术移民网站。

截止到现在加拿大 EE 累计捞取 #{sumnum} 人，历次最低分 #{minrank} 分，历次最高分 #{maxrank}分。飞出国加拿大 EE 历次邀请情况记录：

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>EE 邀请日期</th>
    <th>EE 邀请人数</th>
    <th>EE 邀请分数</th>
    <th>年度邀请次数</th>
    <th>EE 总邀请次数</th>
  </tr>
{% for ee in site.data.ee.#{eecsvfile} %}
<tr>
<td> {{ ee.date }} </td>
<td> {{ ee.people }} </td>
<td> {{ ee.points }} </td>
<td> {{ ee.numinyear }} </td>
<td> {{ ee.no }} </td>
</tr>
{% endfor %}
</table>

------

INTR

    bbsstr = <<-BBSS
	
2017年EE邀请情况请参考<a href=\"#{bbslink}\" target=\"_blank\">飞出国论坛 Express Entry 邀请情况记录</a>。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（flyabroad）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

[Express Entry]: http://flyabroad.io/ca/ee
[FSW]: http://flyabroad.io/ca/ee/fsw
[CEC]: http://flyabroad.io/ca/ee/cec
[FST]: http://flyabroad.io/ca/ee/fst
[Human Capital Category]: http://bbs.fcgvisa.com/t/oinp-human-capital/12184
[HCP]: http://bbs.fcgvisa.com/t/oinp-human-capital/12184

BBSS

    File.open("#{postdir}#{eepostfile}.md", 'w') do |file|
      content = frontstr + intrstr + mibody + bbsstr

      file.write content
    end

    db.execute(updateposted, currentNum)
  end

  db.close
end

parsenewee
posttovac
