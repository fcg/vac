---
layout: post
title:  "2016-2017 年度南澳新增担保职业列表"
date:   2016-07-04 09:56:00  +0800
categories: SOL
---

飞出国：2016年7月4日南澳发布了 2016-2017 年度州担保职业列表。

下面是2016年7月4日南澳州担保职业新增的担保职业和具体担保要求。其中 312512 机械工程技术员 \ Mechanical Engineering Technician 7.4 当天满额。

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>ANZSCO 代码</th>
    <th>职业名称-飞出国</th>
    <th>需求</th>
    <th>担保要求 - Flyabroad</th>
  </tr>
{% for sol in site.data.zdb.sa-1617 %}
<tr>
<td> <a href="http://anzsco.cgvisa.com/{{ sol.anz }}" target="_blank">{{ sol.anz }}</a> </td>
<td> {{ sol.name}} </td>
<td> {{ sol.availability }} </td>
<td> {{ sol.require }} </td>
</tr>
{% endfor %}
</table>

更多南澳州担保要求参考： [南澳州担保申请要求，流程及注意事项 Immigration SA State Nominated Occupation Lists](http://bbs.fcgvisa.com/t/immigration-sa-state-nominated-occupation-lists/3009) 。