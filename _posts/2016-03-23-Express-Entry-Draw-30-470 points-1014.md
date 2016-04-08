---
layout: post
title:  "Express Entry 2016-03-23 2016 年第 7 捞：1014人，470分"
date:   2016-03-23 23:56:00  +0800
categories: EE
---

飞出国：加拿大时间 2016-03-23，CIC 发布 Express Entry 2016 年第 7 捞（总第 30 捞），1014人，470分。

截止到现在加拿大 EE 累计捞取 40528 人，历次最低分 450 分，历次最高分 886分。飞出国加拿大 EE 历次邀请情况记录：

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>EE 总邀请次数</th>
    <th>EE 邀请日期</th>
    <th>EE 邀请人数</th>
    <th>年度邀请次数</th>
    <th>EE 邀请分数</th>
  </tr>
{% for ee in site.data.ee.EE2016-03-23 %}
<tr>
<td> {{ ee.no }} </td>
<td> {{ ee.date }} </td>
<td> {{ ee.people }} </td>
<td> {{ ee.numinyear }} </td>
<td> {{ ee.points }} </td>
</tr>
{% endfor %}
</table>

------

