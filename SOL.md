---
layout: page
title: 澳洲 2016-2017 SOL 配额
---

## 澳大利亚技术移民2016-2017年度 SOL 职业(189+489亲属)配额完成情况汇总

>Occupation ceilings for the 2015-16 programme year

飞出国：下表基于为2016-2017年度澳大利亚技术移民SOL配额使用情况汇总表。

飞出国下表排序是按照剩余职业配额由少到多排序的。

<table border = "1" cellpadding="1" cellspacing="0">
<tr>
<th>职业代码</th>
<th>职业名称</th>
<th>全年配额</th>
<th>已邀请</th>
<th>所剩配额</th>
</tr>
{% for c in site.data.sol.ceilling-16-17 %}
<tr>
<td> <a href="http://bbs.fcgvisa.com/t/topic/{{ c.bbsid }}" target="_blank">{{ c.anzsco4 }}</a> </td>
<td> {{ c.namecn }} </td>
<td> {{ c.ceiling }} </td>
<td> {{ c.result }} </td>
<td> {{ c.remain }} </td>
</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/17031/" target="blank">飞出国论坛</a> 。
