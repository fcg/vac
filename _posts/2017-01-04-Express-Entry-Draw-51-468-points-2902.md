---
layout: post
title:  "Express Entry 2017-01-04 2017 年第 1 捞：2902人，468分"
date:   2017-01-04 23:56:00  +0800
categories: EE
---

飞出国：加拿大时间 2017-01-04，CIC 发布 Express Entry 2017 年第 1 捞（总第 51 捞），2902人，468分。

截止到现在加拿大 EE 累计捞取 67747 人，历次最低分 450 分，历次最高分 886分。飞出国加拿大 EE 历次邀请情况记录：

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>EE 总邀请次数</th>
    <th>EE 邀请日期</th>
    <th>EE 邀请人数</th>
    <th>年度邀请次数</th>
    <th>EE 邀请分数</th>
  </tr>
{% for ee in site.data.ee.EE2017-01-04 %}
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

2017年EE邀请情况请参考<a href="http://bbs.fcgvisa.com/t/2017-express-entry-ita-ee/20819" target="_blank">飞出国论坛 Express Entry 邀请情况记录</a>。