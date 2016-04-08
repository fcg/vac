---
layout: post
title:  "2015年8月6日澳大利亚技术移民SOL配额使用情况"
date:   2015-08-06 14:00:00
categories: gsm
---

## Occupation ceilings for the 2015-16 programme year

飞出国：下表对邀请数进行了排序，从数据上看，软件，审计，护士，会计，位列前三，分别是447,299,284。而且审计类配额只有1000，一次就用去299，外审配额也会比较紧张。其他职业里计算机网络，ICT BA，工业工程师邀请数超100。

飞出国：下表基于2015年8月6日澳洲移民部发布数据。

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>编码</th>
    <th>职业描述-飞出国</th>
    <th>配额</th>
    <th>已用</th>
  </tr>
{% for sol in site.data.SOL20150806 %}
<tr>
<td> <a href="http://www.flyabroadvisa.com/anzsco/{{ sol.Occupation }}.html" target="_blank">{{ sol.Occupation }}</a> </td>
<td> {{ sol.Description }} </td>
<td> {{ sol.Ceiling }} </td>
<td> {{ sol.Used }} </td>
</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/eoi/6335/" target="blank">飞出国论坛</a> 。
