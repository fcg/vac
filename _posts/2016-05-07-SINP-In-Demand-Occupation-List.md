---
layout: post
title:  "2016年5月 SINP EE 类别最新紧缺职业清单"
date:   2016-05-07 23:56:00  +0800
categories: SINP
---

飞出国：加拿大时间 2016-05-06，萨省技术移民 SINP 发布了最新的紧缺职业清单。

这次清单里共有21个紧缺职业，所有职业都不需要注册。

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>NOC</th>
    <th>职业中文-飞出国</th>
    <th>职业英文名 - flyabroad</th>
  </tr>
{% for csvrow in site.data.sinp.sinpo201605 %}
<tr>
<td> <a href="http://noc.cgvisa.com/{{ csvrow.NOC }}" target="_blank">{{ csvrow.NOC }}</a> </td>
<td> {{ csvrow.cn }} </td>
<td> {{ csvrow.en }} </td>
</tr>
{% endfor %}
</table>

------

此次更新的紧缺职业清单比2015年版减少了不少，详见：<a href="http://js.flyabroad.com.hk/ca/sk/" target="_blank">SINP EE 类别申请条件及紧缺职业清单</a>。