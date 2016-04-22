---
layout: post
title:  "2015年12月18日澳大利亚技术移民SOL配额使用情况"
date:  2016-01-04 09:50:00  +0800
categories: gsm
---

## Occupation ceilings for the 2015-16 programme year

飞出国：澳洲移民局官网于12.18更新。飞出国发布的表格为经过排序后的。从表中不难看出，前5名是软件，注册护士，审计，计算机网络，工业机械和生产工程师，数量分别为 2748，1235，1000，940，822。**其中审计职业已满额。**

飞出国：下表基于2015年12月18日澳洲移民部发布数据。

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>编码</th>
    <th>职业描述-飞出国</th>
    <th>配额</th>
    <th>已用</th>
  </tr>
{% for sol in site.data.SOL20151218 %}
<tr>
<td> <a href="http://ww2.flyabroadvisa.com/anzsco/{{ sol.Occupation }}.html" target="_blank">{{ sol.Occupation }}</a> </td>
<td> {{ sol.Description-flyabroad }} </td>
<td> {{ sol.Ceiling }} </td>
<td> {{ sol.Used }} </td>
</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/eoi/6335/" target="blank">飞出国论坛</a> 。