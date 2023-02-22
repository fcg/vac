# https://www.cicnews.com/2023/02/canada-releases-annual-report-on-express-entry-for-2021-0233078.html

html2md -i "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078.html" | tee "tmp_2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews.md"
sed '2,22d;' "tmp_2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '/Tags:/,$d;/googletag/d;/Sponsor Content/d;/cicnews/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;/Want to advertise/d;' | cat -s | tee 2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews.md
trans -b en:zh "file://2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews.md" | tee "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews.md
sed -i 's/＃/#/g;' 2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cn.md
paste "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cn.md" "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews.md" | tee "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews_fcg.md"

cat "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews_fm.md" "2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews_fcg.md" > "../../_posts/2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews_fcg.md"

echo "\nFCGvisa translated, © CIC News All Rights Reserved." >> "../../_posts/2023-02-22-canada-releases-annual-report-on-express-entry-for-2021-0233078_cicnews_fcg.md"

# https://www.cicnews.com/2023/02/want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293.html

html2md -i "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293.html" | tee "tmp_2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews.md"
sed '2,22d;' "tmp_2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '/Tags:/,$d;/googletag/d;/Sponsor Content/d;/cicnews/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;/Want to advertise/d;' | cat -s | tee 2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews.md
trans -b en:zh "file://2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews.md" | tee "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews.md
sed -i 's/＃/#/g;' 2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cn.md
paste "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cn.md" "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews.md" | tee "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews_fcg.md"

cat "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews_fm.md" "2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews_fcg.md" > "../../_posts/2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews_fcg.md"

echo "\nFCGvisa translated, © CIC News All Rights Reserved." >> "../../_posts/2023-02-22-want-to-protect-your-money-as-an-immigrant-or-refugee-to-canada-avoid-these-fringe-banking-mistakes-0233293_cicnews_fcg.md"

# https://www.cicnews.com/2023/02/exploring-the-benefits-of-a-spousal-open-work-permit-0231994.html

html2md -i "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994.html" | tee "tmp_2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews.md"
sed '2,22d;' "tmp_2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '/Tags:/,$d;/googletag/d;/Sponsor Content/d;/cicnews/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/Visit CanadaVisa.com/d;/Want to advertise/d;' | cat -s | tee 2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews.md
trans -b en:zh "file://2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews.md" | tee "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews.md
sed -i 's/＃/#/g;' 2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cn.md
paste "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cn.md" "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews.md" | tee "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews_fcg.md"

cat "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews_fm.md" "2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews_fcg.md" > "../../_posts/2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews_fcg.md"

echo "\nFCGvisa translated, © CIC News All Rights Reserved." >> "../../_posts/2023-02-22-exploring-the-benefits-of-a-spousal-open-work-permit-0231994_cicnews_fcg.md"

# rm -f *.html
# rm -f *_cicnews.md
# rm -f *_fcg.md
# rm -f *_cn.md