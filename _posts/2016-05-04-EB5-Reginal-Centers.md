---
layout: post
title:  "2016年美国 824 家EB5区域中心列表"
date:   2016-05-15 8:00:00
categories: eb5
---

飞出国美国 2016 年 5 月份发布的最新 EB5 区域中心（Reginal Centers）列表，共 824 间，分布到各州后的区域中心数为 1168 个。进入飞出国论坛可以查看详细内容，包括区域中心官方网站。
<!-- rccn,rc,statecn,state,rcid,topicid -->

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>美国区域中心－飞出国</th>
    <th>所在州</th>
    <th>RC ID</th>
  </tr>
{% for row in site.data.rcs.rc1605 %}
<tr>
<td> {{ row.rccn }}－{{ row.rc }} </td>
<td> {{ row.statedcn }}/{{ row.stated }} </td> -->
<td> <a href="http://bbs.fcgvisa.com/t/topic/{{ row.topicid }}" target="_blank">{{ row.rcid }}</a> </td>
</tr>
{% endfor %}
</table>

> [飞出国投资移民](http://www.flyabroad.biz/) - 2016 EB5 美国区域中心。
