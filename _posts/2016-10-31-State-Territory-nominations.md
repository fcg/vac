---
layout: post
title:  "2016-10 澳洲州担保邀请数据"
date:   2016-10-31 23:56:00  +0800
categories: gsm
---

飞出国澳洲 SkillSelect 2016-2017 年度州担保邀请数据统计。

## 2016-10 澳洲州担保邀请数据

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
{% for zdb in site.data.zdb.2016-10-31 %}
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

### 飞出国 2016-2017 年度各州 190 州担保数据记录

下面数据只针对 2016-2017 年度澳洲 190 州担保各州担保数据。

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
{% for zdb in site.data.zdb.190-1617 %}
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

更多请参考飞出国论坛： [2016-2017 年度澳洲州担保邀请记录](http://bbs.fcgvisa.com/t/2016-2017/18110/) 。

