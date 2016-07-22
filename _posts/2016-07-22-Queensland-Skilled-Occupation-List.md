---
layout: post
title: 昆士兰州 2016-07-25 190 & 489 州担保职业清单
date:  2016-07-22 16:00:00
categories: gsm
---

## 2016-07-25 昆州 190&489 州担保职业清单

2016-07-22 昆士兰州更新了州担保清单，该清单将在 2016-07-25 周一，生效。

<table border = "1" cellpadding="1" cellspacing="0">
<tr>
<th>职业代码</th>
<th>职业名称</th>
<th>489</th>
<th>190</th>
</tr>
{% for c in site.data.zdb.QLD20160725 %}
<tr>
<td> <a href="http://anzsco.cgvisa.com/{{ c.anz }}" target="_blank">{{ c.anz }}</a> </td>
<td> {{ c.cn }} / {{ c.en }} </td>
<td> {{ c.489 }} </td>
<td> {{ c.190 }} </td>

</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/eoi/2845/" target="blank">飞出国论坛 昆州担保指南</a> 。
