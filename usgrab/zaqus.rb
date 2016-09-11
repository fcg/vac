require 'Nokogiri'
require 'open-uri'
require 'haml'
require 'reverse_markdown'
require 'sqlite3'
require 'csv'

def csvandpost
  paiqi = Date.today.next_month
  paiqiyear = paiqi.year
  paiqimonth = paiqi.month
  paiqimonthb = paiqi.strftime('%b')
  paiqidate = "#{paiqiyear}#{paiqimonth}"
  postdate = Time.now.strftime('%Y-%m-%d') # 每次修改
  csvdir = '../_data/us/'
  postdir = '../_posts/'
  ebpost = "#{postdate}-Visa-Bulletin-#{paiqimonthb}-EB-Visa"
  fapost = "#{postdate}-Visa-Bulletin-#{paiqimonthb}-Family-Visa"
  trcss = '.article-content>table>tbody>tr'

  ua = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0.1) Gecko/20100101 Firefox/9.0.1'
  url = 'https://zaq.us/visa-bulletin/'
  charset = 'utf-8'
  html = open(url, 'User-Agent' => ua)
  doc = Nokogiri::HTML.parse(html, nil, charset)

  trs = doc.css(trcss)

  # FA
  CSV.open("#{csvdir}/#{paiqidate}-FA.csv", 'w') do |csv|
    csv << %w(pizhun quanqiu zhongguo bianhua beizhu)

    (0..4).each do |i|
      arr = []
      trs[i].css('td').each do |td|
        arr.push td.text.strip.delete("\u00A0").delete("\n")
      end
      csv << arr
    end
  end

  # FB
  CSV.open("#{csvdir}/#{paiqidate}-FB.csv", 'w') do |csv|
    csv << %w(pizhun quanqiu zhongguo bianhua beizhu)

    (5..9).each do |i|
      arr = []
      trs[i].css('td').each do |td|
        arr.push td.text.strip.delete("\u00A0").delete("\n")
      end
      csv << arr
    end
  end

  # EA
  CSV.open("#{csvdir}/#{paiqidate}-EA.csv", 'w') do |csv|
    csv << %w(pizhun quanqiu zhongguo bianhua beizhu)

    (10..17).each do |i|
      arr = []
      trs[i].css('td').each do |td|
        p arr.push td.text.strip.delete("\u00A0").delete("\n")
      end
      csv << arr
    end
  end

  # EB
  CSV.open("#{csvdir}/#{paiqidate}-EB.csv", 'w') do |csv|
    csv << %w(pizhun quanqiu zhongguo bianhua beizhu)

    (18..25).each do |i|
      arr = []
      trs[i].css('td').each do |td|
        arr.push td.text.strip.delete("\u00A0").delete("\n")
      end
      csv << arr
    end
  end

  famcontext = <<-FAM
---
layout: post
title: #{paiqiyear}年#{paiqimonth}月美国家庭移民排期
date:  #{postdate} 09:00:00
categories: usvisa
---

## #{paiqiyear}年#{paiqimonth}月美国家庭移民排期 - 批准排期 - 飞出国

| 职业移民批准排期 | 全球 | 中国出生 | 中国变化 | 飞出国说明 |
| --- | --- | --- | --- | --- |
{% for pq in site.data.us.#{paiqiyear}#{paiqimonth}-FA %}
| {{ pq.pizhun }} | {{ pq.quanqiu }} | {{ pq.zhongguo }} | {{ pq.bianhua }} | {{ pq.beizhu }} |
{% endfor %}

## #{paiqiyear}年#{paiqimonth}月美国家庭移民排期 - 递件排期 - 飞出国

| 职业移民递件排期 | 全球 | 中国出生 | 中国变化 | 飞出国说明 |
| --- | --- | --- | --- | --- |
{% for pq in site.data.us.#{paiqiyear}#{paiqimonth}-FB %}
| {{ pq.pizhun }} | {{ pq.quanqiu }} | {{ pq.zhongguo }} | {{ pq.bianhua }} | {{ pq.beizhu }} |
{% endfor %}

更多说明请参考飞出国论坛：<a href="http://bbs.fcgvisa.com/c/usavisa" target="blank">美国签证申请论坛</a> 。
FAM

  File.open("#{postdir}#{fapost}.md", 'w') do |file|
    file.write famcontext
  end

  ebcontext = <<-EB
---
layout: post
title: #{paiqiyear}年#{paiqimonth}月美国职业移民排期
date:  #{postdate} 09:00:00
categories: usvisa
---

## #{paiqiyear}年#{paiqimonth}月美国职业移民排期（Employment-Based）

美国职业移民，包括 EB-1 排期，EB-2 排期，EB-3 排期，EB-4 排期，EB-5 排期。

#{paiqiyear}年#{paiqimonth}月职业移民排期依然停滞不前，基本无变化。

批准排期表，中国大陆，只有早于下列日期的移民签证申请可能被批准：

- EB-1 排期截止日依然为2010年1月1日；
- EB-2 排期截止日依然为2010年1月1日；
- EB-3 排期截止日依然为2010年1月1日；EB-3 非技术劳工是2004-01-01；
- EB-5 排期截止日依然为2014年2月15日。

递件排期表，中国大陆,优先日期早于这些日期的申请人可按这些日期递交身份调整申请：

- EB-1 无排期；
- EB-2 排期截止日依然为2013年6月1日；
- EB-3 排期截止日依然为2015年5月1日；
- EB-5 排期截止日依然为2015年5月1日。

## #{paiqiyear}年#{paiqimonth}月美国职业移民排期 - 批准排期 - 飞出国

| 职业移民批准排期 | 全球 | 中国出生 | 中国变化 | 飞出国说明 |
| --- | --- | --- | --- | --- |
{% for pq in site.data.us.#{paiqiyear}#{paiqimonth}-EA %}
| {{ pq.pizhun }} | {{ pq.quanqiu }} | {{ pq.zhongguo }} | {{ pq.bianhua }} | {{ pq.beizhu }} |
{% endfor %}

## #{paiqiyear}年#{paiqimonth}月美国职业移民排期 - 递件排期 - 飞出国

| 职业移民递件排期 | 全球 | 中国出生 | 中国变化 | 飞出国说明 |
| --- | --- | --- | --- | --- |
{% for pq in site.data.us.#{paiqiyear}#{paiqimonth}-EB %}
| {{ pq.pizhun }} | {{ pq.quanqiu }} | {{ pq.zhongguo }} | {{ pq.bianhua }} | {{ pq.beizhu }} |
{% endfor %}

更多说明请参考飞出国论坛：<a href="http://bbs.fcgvisa.com/c/usavisa" target="blank">美国签证申请论坛</a> 。
EB

  File.open("#{postdir}#{ebpost}.md", 'w') do |file|
    file.write ebcontext
  end
end

csvandpost
