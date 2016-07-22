---
layout: post
title: 昆士兰州 2016-07-25 190 & 489 州担保职业清单
date:  2016-07-22 16:00:00 +08:00
categories: gsm
---

## 2016-07-25 昆州 190&489 州担保职业清单

2016-07-22 昆士兰州更新了州担保清单，该清单将在 2016-07-25 周一，生效。

飞出国：下表里 Y 代表担保，X 代表不担保。注释编号代表下面对应的注册或其他额外要求。

- #1： Engineers - Applicants must have registration with the Board of Professional Engineers Queensland (BPEQ) unless already working under the supervision of a BPEQ registered engineer.		
- #2： Specialist teachers in the subjects of Maths, Physics, Chemistry, Senior English, and Industrial Technology, Design (Manual Arts) and LOTE only.		
- #3： Cadastral Surveyors and those that certify Mine Plans are required to have registration with the Surveyors Board of Queensland 
- #4： Palliative Medicine Specialists, Geriatricians, Sleep Medicine Specialist and Rehabilitation Medicine Specialist only.		
- #5： Pharmacists must be registered with the Pharmacy Board of Australia, and meet the Board's registration standards in order to practise in Australia.		
- #6： Medical Practitioners must be registered in Australia, and meet the registration standards in order to practise in Australia.		

### QSOL - 489 & 190 Off-Shore

Queensland Skilled Occupation List for applicants not currently working in Queensland – Subclasses 190 and 489

<table border = "1" cellpadding="1" cellspacing="0">
<tr>
<th>职业代码</th>
<th>职业名称</th>
<th>489</th>
<th>190</th>
</tr>
{% for c in site.data.zdb.QLD20160725 %}
<tr>
<td> <a href="http://anzsco.cgvisa.com/{{ c.anz }}" target="_blank">{{ c.anz }}</a> </td>
<td> {{ c.cn }} / {{ c.en }} </td>
<td> {{ c.489 }} </td>
<td> {{ c.190 }} </td>

</tr>
{% endfor %}
</table>

更多说明请参考<a href="http://bbs.fcgvisa.com/t/eoi/2845/" target="blank">飞出国论坛 昆州担保指南</a> 。
