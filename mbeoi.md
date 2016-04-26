---
layout: page
title: 曼省技术移民评分标准
---

<!-- select max(num) nums,sum(inmbnum)+sum(overseasnum) ioall, sum(inmbnum) inall, sum(overseasnum) outall, min(inmbrank) minin, max(inmbrank) maxin,min(overseasrank) minoverseas,max(overseasrank)  maxoverseas from mbeoi -->

{% assign sums = site.data.mb.sum2016 %}

飞出国：曼省自 2015-05-20 起开始发放 EOI 邀请，已经进行了 {{ sums.nums }} 次邀请，总共邀请数达到 {{ sums.ioall }}。其中从曼省申请的获邀数是 {{ sums.inall }}，从加拿大境外申请曼省 EOI 获邀的申请数是 {{ sums.outall }}。

在 2016 年进行的所有邀请中，曼省境内申请获邀的最高分是 {{ sums.maxin }}，最低分是 {{ sums.minin }}。从加拿大海外申请曼省获邀的最高分是 {{ sums.maxoverseas }}，最低分是 {{ sums.minoverseas }}。

曼省 EOI 评分标准里如果有曼省6个月工作经验的话可以直接加500分，那样申请人就可以直接获得邀请。下面是飞出国整理的曼省历次邀请情况。

## 曼省 EOI 2015-2016 年邀请情况记录 - 飞出国

<!-- num,updated,inmbnum,inmbrank,overseasnum,overseasrank -->
<table border = "1" cellpadding="1" cellspacing="0">
  <tr>
    <th>EOI#</th>
    <th>邀请日期</th>
    <th>曼省人数</th>
    <th>曼省分数</th>
    <th>境外人数</th>
    <th>境外分数</th>
  </tr>
{% for mbeoi in site.data.mb.eoi2016 %}
<tr>
<td> {{ mbeoi.num }} </td>
<td> {{ mbeoi.updated }} </td>
<td> {{ mbeoi.inmbnum }} </td>
<td> {{ mbeoi.inmbrank }} </td>
<td> {{ mbeoi.overseasnum }} </td>
<td> {{ mbeoi.overseasrank }} </td>
</tr>
{% endfor %}
</table>

以下职业当前很难被曼省 EOI 选中 - 飞出国：

- 注册护士 Registered Nurses
- 中小学教师 Secondary and Elementary School Teachers
- 职业学院教师 Vocational and College Instructors
- 大学教授 University Professors
- 普通科及专科医师 General and Specialist Physicians

更多可以参考飞出国论坛： [曼省自有 EOI 邀请情况记录 (MPNP under the Expression of Interest System Draws)](http://bbs.fcgvisa.com/t/eoi-mpnp-under-the-expression-of-interest-system-draws/3723)

## 曼省技术移民评分标准 - 飞出国

曼省省提名技术移民 EOI 评分项包括语言（根据 clb 级别单项积分，第二语言达到 clb 5 可以加25分，第一语言最多可以加 100 分，共计 125 分），年龄最高 75 分（21-45周岁之间），工作经验4年以上就是75分（持有曼省内需要注册的职业的证书可以加100分，申请时提名的职业需要与该职业相关），教育最高125分（硕士或博士），适应能力最高500分（有远亲或朋友加50分，有近亲加200分，有曼省工作或留学经验可以加100分），同时曼省评分里还有减分项，如果与其他省份联系密切会被减分，详细的参考下面曼省EOI具体平分项说明。

### Factor 1: 语言能力 Language Proficiency - 飞出国

<!-- > Points are based on individual Canadian Language Benchmark (CLB) band scores for Reading Writing, Listening and Speaking. Points awarded based on official test results provided. Those candidates who do not submit valid results of an approved language test do not receive points in this category. To be considered valid, your test must have been taken no more than two years prior to the date you submit your MPNP Online application. Points for the second official language are also based on evidence in form of official test results indicating the candidate scores at least at CLB 5 overall. -->

<table>
<tbody>
<tr>
<th><a href="http://bbs.fcgvisa.com/t/canadian-language-benchmarks-clb/2995/3" target="_blank">语言CLB级别-飞出国</a></th>
<th>曼省得分</th>
</tr>
<tr>
<th>第一语言</th>
</tr>
<tr>
<td>CLB 8 或更高</td>
<td>25 每项</td>
</tr>
<tr>
<td>CLB 7</td>
<td>22 每项</td>
</tr>
<tr>
<td>CLB 6</td>
<td>20 每项</td>
</tr>
<tr>
<td>CLB 5</td>
<td>17 每项</td>
</tr>
<tr>
<td>CLB 4</td>
<td>12 每项</td>
</tr>
<tr>
<td>CLB 3 或更低</td>
</tr>
<tr>
<th>Second Official Language</th>
</tr>
<tr>
<td>CLB 5 或更高 (overall)</td>
<td>25</td>
</tr>
<tr>
<th>最高得分 – Factor 1</th>
<th>125</th>
</tr>
</tbody>
</table>

### Factor 2: 年龄 Age - 飞出国

飞出国：曼省技术移民 EOI 类别年龄评分按递交 MB PNP EOI 时的年龄计算，最高 75 分。

<!-- > Points are based on your age at the time your Expression of Interest is submitted to the MPNP. -->

<table>
<tbody>
<tr>
<th>年龄 - 飞出国</th>
<th>分数</th>
</tr>
<tr>
<td>18</td>
<td>20</td>
</tr>
<tr>
<td>19</td>
<td>30</td>
</tr>
<tr>
<td>20</td>
<td>40</td>
</tr>
<tr>
<td>21 to 45</td>
<td>75</td>
</tr>
<tr>
<td>46</td>
<td>40</td>
</tr>
<tr>
<td>47</td>
<td>30</td>
</tr>
<tr>
<td>48</td>
<td>20</td>
</tr>
<tr>
<td>49</td>
<td>10</td>
</tr>
<tr>
<td>50 及以上</td>
<td>0</td>
</tr>
<tr>
<th>最高得分 – Factor 2</th>
<th>75</th>
</tr>
</tbody>
</table>

### Factor 3: 工作经验 Work experience

飞出国：曼省EOI按照全职的工作经验算分，每周累计工作30小时且为一个雇主连续工作6个月以上的工作经验才会计算，不足一年的工作经验会被忽略。职业资格得分说的在曼省从事受限职业且申请人已经获得该职业对应监管机构的完全注册认证。

<!-- > Points are calculated based on your years of full-time work experience. Your employment is considered full-time if you are working for 30 hours or more each week for the same employer.Only full-time jobs of six months or longer should be included. You should ONLY count full years of work experience you have already completed. Do not round up your work experience (Ex.: If you have gained 7 months of work experience, you would have to answer less than 1).

> **Additional points for licensing are ONLY awarded to those candidates who are working in professions or trades that require licensing in Manitoba and have completed ALL necessary steps to be able to seek employment in Manitoba. Evidence of this is required at the time an application is submitted to the MPNP.** -->

<table>
<tbody>
<tr>
<th>工作年限 - 飞出国</th>
<th>得分</th>
</tr>
<tr>
<td>不足一年</td>
</tr>
<tr>
<td>一年</td>
<td>40</td>
</tr>
<tr>
<td>两年</td>
<td>50</td>
<tr>
</tr>
<td>三年</td>
<td>60</td>
</tr>
<tr>
<td>四年及以上</td>
<td>75</td>
</tr>
<tr>
<td>去掉职业资格认证</td>
<td>100</td>
</tr>
<tr>
<th>最高得分 – Factor 3</th>
<th>175</th>
</tr>
</tbody>
</table>

### Factor 4: 教育得分 Education - 飞出国

曼省 EOI 评分标准里按照申请人已经取得的最高学历计算学历分数。

<!-- > Points are calculated based on the highest level of education you completed at a recognized education institution. A completed program is one for which you have met all requirements and received a certificate, diploma or degree. -->

<table>
<tbody>
<tr>
<th>已经完成的最高教育 - 飞出国</th>
<th>得分</th>
</tr>
<tr>
<td>硕士或博士</td>
<td>125</td>
</tr>
<tr>
<td>两个学制2年以上的高等教育</td>
<td>115</td>
</tr>
<tr>
<td>一个学制3年及以上的高度教育</td>
<td>110</td>
</tr>
<tr>
<td>一个学制2年的高等教育</td>
<td>100</td>
</tr>
<tr>
<td>一年高等教育</td>
<td>70</td>
</tr>
<tr>
<td>技工证书 Trade Certificate</td>
<td>70</td>
</tr>
<tr>
<td>非正式高中后教育 No formal post-secondary education</td>
<td>0</td>
</tr>
<tr>
<th>最高得分 – Factor 4</th>
<th>125</th>
</tr>
</tbody>
</table>

### Factor 5: 适应能力 Adaptability - 飞出国

飞出国：申请人必须有下面任何一种与曼省的联系才符合曼省申请条件。相应的曼省联系也有对应的适应能力加分，而且有曼省联系6个月以上的工作经验的话一次就可以加500分（累计最高可以加500分）。

<!-- > Adaptability points are calculated based on the type of connection you have to Manitoba. All candidates must have at least one type of connection to our province (Regional Development is considered a supplemental connection factor; points can only be awarded in combination with a Manitoba connection). You cannot be awarded points for more than one connection factor, you will only be scored based on your connection which gives you the highest score. Supplemental points for Regional Development cannot be awarded to candidates whose connection to Manitoba is based on Manitoba Demand. All candidates indicating that they plan to settle outside of Winnipeg MUST at the time of application satisfactorily demonstrate that they have a convincing connection to a region outside of the capital city indicating a strong likelihood that they will make a long-term economic contribution to that region. -->

<table>
<tbody>
<tr>
<th>适应能力项 - 飞出国</th>
<th>得分</th>
</tr>
<tr>
<th>曼省联系</th>
</tr>
<tr>
<td>有曼省近亲属</td>
<td>200</td>
</tr>
<tr>
<td>在曼省有半年以上工作经验</td>
<td>100</td>
</tr>
<tr>
<td>在曼省完成2年以上的高等教育</td>
<td>100</td>
</tr>
<tr>
<td>在曼省完成1年的高等教育</td>
<td>50</td>
</tr>
<tr>
<td>在曼省有朋友或远亲</td>
<td>50</td>
</tr>
<tr>
<th>曼省需要 Manitoba Demand</th>
</tr>
<tr>
<td>曼省6个月以上工作（为同一个雇主）</td>
<td>500</td>
</tr>
<tr>
<td>获得 Strategic Initiative 邀请</td>
<td>500</td>
</tr>
<tr>
<th>偏远地区开发 Regional Development</th>
</tr>
<tr>
<td>移民定居地在温尼伯以外地区</td>
<td>50</td>
</tr>
<tr>
<th>最高得分 – Factor 5</th>
<th>500</th>
</tr>
</tbody>
</table>

### Factor 6: 风险评估 Risk Assessment - 飞出国

飞出国：曼省省提名EOI评分里的一个特色是有负分的风险评估项，如果申请人与其他省的联系比与曼省的联系大，或者说申请人去曼省定居有风险的话曼省EOI里会有对应的扣分项，最多会被扣400分。

<!-- > **Points are calculated based on any connections you or your spouse, if applicable, may have to other parts of Canada.** -->

<table>
<tbody>
<tr>
<th>分险项 - 飞出国</th>
<th>曼省得分</th>
</tr>
<tr>
<td>其他省有近亲但曼省没有</td>
<td>-100</td>
</tr>
<tr>
<td>有其他省份工作经验</td>
<td>-100</td>
</tr>
<tr>
<td>在其他省读过书</td>
<td>-100</td>
</tr>
<tr>
<td>曾经申请过其他省提名</td>
<td>-100</td>
</tr>
<tr>
<th>最高得分 – Factor 6</th>
<th>-400</th>
</tr>
</tbody>
</table>

更多请参考飞出国论坛： [曼省境内技工类别][1] 和 [曼省境外技工类别][2]。

  [1]: http://bbs.fcgvisa.com/t/swm-eligibility-mpnp-skilled-workers-in-manitoba/3684
  [2]: http://bbs.fcgvisa.com/t/swo-eligibility-mpnp-skilled-workers-overseas/3698
