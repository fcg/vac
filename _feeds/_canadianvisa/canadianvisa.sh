# https://canadianvisa.org/blog/news/canada-boosts-sponsor-program-for-refugees

html2md -i "2023-02-22-canada-boosts-sponsor-program-for-refugees.html" | tee "tmp_2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa.md"
sed '/===/d;/----/d' "tmp_2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '/Tags:/,$d;/googletag/d;/Sponsor Content/d;/canadianvisa/d;/adsbygoogle/d;/！	!/d;/SHARE THIS ARTICLE/d;/Visit CanadaVisa.com/d;' | cat -s | tee 2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa.md
trans -b en:zh "file://2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa.md" | tee "2023-02-22-canada-boosts-sponsor-program-for-refugees_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa.md
sed -i 's/＃/#/g;' 2023-02-22-canada-boosts-sponsor-program-for-refugees_cn.md
paste "2023-02-22-canada-boosts-sponsor-program-for-refugees_cn.md" "2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa.md" | tee "2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa_fcg.md"

cat "2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa_fm.md" "2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa_fcg.md" > "../../_posts/2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa_fcg.md"

echo "\nFCGvisa translated, © canadianvisa All Rights Reserved." >> "../../_posts/2023-02-22-canada-boosts-sponsor-program-for-refugees_canadianvisa_fcg.md"

# rm -f *.html
# rm -f *_canadianvisa.md
# rm -f *_fcg.md
# rm -f *_cn.md