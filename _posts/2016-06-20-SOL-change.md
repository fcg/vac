---
layout: post
title:  "澳洲技术移民 SOL 2016-2017 年度变化分析"
date:   2016-06-20 09:56:00  +0800
categories: SOL
---

飞出国：澳大利亚移民部发布了 2016-2017 年度 SOL 职业配额，该职业配额只针对 189 独立技术移民和 489 亲属担保移民，不影响 190 州担保的 CSOL 清单。

1617年度比1516年度增加了一个 SOL ，2519；取消了 3 个 SOL 职业，2336,2513 和 4112 。

- 2336	Mining Engineers	从 SOL 里去除了？去年配额是 1000，当前才接收了 249 个。
- 2513	Occupational and Environmental Health Professionals 也被从 SOL 里去除了，去年配额 1578 个，到现在只接收 94 个。
- 4112 	Dental Hygienists, Technicians and Therapists	牙科保健员 从 2016-2017 年度 SOL 里剔除了，2015-2016年度配额 1000，到现在只接收了 59 个。

- 2519	Orthotist or Prosthetist	义肢矫形师 是 2016-2017 年度新增的 SOL 职业，配额 1000 。

新年度与上一年度都在 SOL 清单的职业如下，飞出国已经按照变化进行了排序，增加最多的在最前面，配额没有变化的在中间，配额减少的在后面。护士，会计增加最多，计算机网络职业有大幅减少。

<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>ANZSCO 代码</th>
    <th>职业名称-飞出国</th>
    <th>16-17配额</th>
    <th>15-16配额</th>
    <th>变化</th>
  </tr>
{% for sol in site.data.sol.sol-16-17 %}
<tr>
<td> <a href="http://anzsco.cgvisa.com/{{ sol.anzsco }}" target="_blank">{{ sol.anzsco }}</a> </td>
<td> {{ sol.name }} / {{ sol.en}}</td>
<td> {{ sol.q17 }} </td>
<td> {{ sol.q16 }} </td>
<td> {{ sol.change }} </td>
</tr>
{% endfor %}
</table>

------

2016-2017年度 SOL 配额情况请参考<a href="http://bbs.fcgvisa.com/t/2016-2017-189-sol/15923/" target="_blank">http://bbs.fcgvisa.com/t/2016-2017-189-sol/15923</a>。