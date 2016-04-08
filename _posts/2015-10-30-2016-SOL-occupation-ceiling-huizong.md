---
layout: post
title:  "2015年澳大利亚技术移民SOL配额使用情况"
date:   2015-11-18 10:00:00 +0800
categories: gsm
---

## Occupation ceilings for the 2015-16 programme year


飞出国：下表基于为2015-2016年度澳大利亚技术移民SOL配额使用情况汇总表。

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>职业代码</th>
    <th>职业名称</th>
    <th>全年配额</th>
    <th>所剩配额</th>
    <th>已邀请比例</th>
    <th>7月邀请数量</th>
    <th>8月邀请数量</th>
    <th>9月邀请数量</th>
    <th>10月第一轮</th>
    <th>10月第二轮</th>
    <th>11月第一轮</th>
  </tr>
{% for sol in site.data.SOL2015 %}
<tr>
<td> <a href="http://www.flyabroadvisa.com/anzsco/{{ sol.occupation }}.html" target="_blank">{{ sol.occupation }}</a> </td>
<td> {{ sol.description }} </td>
<td> {{ sol.ceiling }} </td>
<td> {{ sol.left }} </td>
<td> {{ sol.used }} </td>
<td> {{ sol.7 }} </td>
<td> {{ sol.8 }} </td>
<td> {{ sol.9 }} </td>
<td> {{ sol.101 }} </td>
<td> {{ sol.102 }} </td>
<td> {{ sol.111 }} </td>
</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/eoi/6335/" target="blank">飞出国论坛</a> 。