---
layout: post
title:  "2017-08 澳洲州担保邀请数据"
date:   2017-08-31 23:56:00  +0800
categories: gsm
---

飞出国澳洲 SkillSelect 2017-2018 年度州担保邀请数据统计。

## 2017-08 澳洲州担保邀请数据

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>类别</th>
    <th>堪培拉</th>
    <th>新州</th>
    <th>北领地</th>
    <th>昆州</th>
    <th>南澳</th>
    <th>塔州</th>
    <th>维州</th>
    <th>西澳</th>
    <th>总计</th>
  </tr>
{% for zdb in site.data.zdb.2017-08-31 %}
<tr>
<td> {{ zdb.Class }} </td>
<td> {{ zdb.ACT }} </td>
<td> {{ zdb.NSW }} </td>
<td> {{ zdb.NT }} </td>
<td> {{ zdb.Qld }} </td>
<td> {{ zdb.SA }} </td>
<td> {{ zdb.Tas }} </td>
<td> {{ zdb.Vic }} </td>
<td> {{ zdb.WA }} </td>
<td> {{ zdb.Total }} </td>
</tr>
{% endfor %}
</table>

### 飞出国 2017-2018 年度各州 190 州担保数据记录

下面数据只针对 2017-2018 年度澳洲 190 州担保各州担保数据。

<table border = "1" cellpadding="1" cellspacing="0">
<tr>
<th>月份</th>
<th>堪培拉</th>
<th>新州</th>
<th>北领地</th>
<th>昆州</th>
<th>南澳</th>
<th>塔州</th>
<th>维州</th>
<th>西澳</th>
<th>总计</th>
</tr>
{% for zdb in site.data.zdb.190-1718 %}
<tr>
<td> {{ zdb.updated }} </td>
<td> {{ zdb.ACT }} </td>
<td> {{ zdb.NSW }} </td>
<td> {{ zdb.NT }} </td>
<td> {{ zdb.Qld }} </td>
<td> {{ zdb.SA }} </td>
<td> {{ zdb.Tas }} </td>
<td> {{ zdb.Vic }} </td>
<td> {{ zdb.WA }} </td>
<td> {{ zdb.Total }} </td>
</tr>
{% endfor %}
</table>

更多请参考飞出国论坛： [2017-2018 年度澳洲州担保邀请记录](http://bbs.fcgvisa.com/t/2017-2018/24722/) 。

需要获得相关移民及出国签证申请帮助可以联系飞出国微信（flyabroad）： <a href="http://flyabroad.me/contact" target="_blank">http://flyabroad.me</a>。

> 以上内容由`飞出国香港`（<a href="http://flyabroad.hk/" target="_blank">flyabroad.hk</a>）整理完成，转载请保留并注明出处。

