---
layout: post
title:  "2016年用于英国签证及移民的雅思考试考试报名截止日期、准考证打印日期和成绩单寄送日期"
date:   2015-11-02 10:00:00
categories: ielts
---

## 2016年用于英国签证及移民的雅思考试考试报名截止日期、准考证打印日期和成绩单寄送日期

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>考试日期</th>
    <th>类别</th>
    <th>报名截止日期</th>
    <th>准考证打印日期</th>
    <th>成绩单寄送日期*</th>
  </tr>
{% for ielts in site.data.2016ieltsdateforUKVI %}
<tr>
<td> {{ ielts.test }} </td>
<td> {{ ielts.type }} </td>
<td> {{ ielts.deadline }} </td>
<td> {{ ielts.print }} </td>
<td> {{ ielts.sent }} </td>
</tr>
{% endfor %}
</table>

*考生可于成绩单寄送日的中午12:00之后上网查询成绩。
