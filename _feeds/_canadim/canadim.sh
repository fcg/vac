# https://www.canadim.com/blog/safety-in-canada-five-factors/

html2md -i "2023-02-10-safety-in-canada-five-factors.html" | tee "tmp_2023-02-10-safety-in-canada-five-factors_canadim.md"
sed '/===/d;/----/d' "tmp_2023-02-10-safety-in-canada-five-factors_canadim.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '2,4d;/Tags:/,$d;/googletag/d;/Free Immigration Assessment/d;/canadim/d;/adsbygoogle/d;/！	!/d;/SHARE THIS ARTICLE/d;/Free Assessment/d;' | cat -s | tee 2023-02-10-safety-in-canada-five-factors_canadim.md
trans -b en:zh "file://2023-02-10-safety-in-canada-five-factors_canadim.md" | tee "2023-02-10-safety-in-canada-five-factors_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-10-safety-in-canada-five-factors_canadim.md
sed -i 's/＃/#/g;' 2023-02-10-safety-in-canada-five-factors_cn.md
paste "2023-02-10-safety-in-canada-five-factors_cn.md" "2023-02-10-safety-in-canada-five-factors_canadim.md" | tee "2023-02-10-safety-in-canada-five-factors_canadim_fcg.md"

cat "2023-02-10-safety-in-canada-five-factors_canadim_fm.md" "2023-02-10-safety-in-canada-five-factors_canadim_fcg.md" > "../../_posts/2023-02-10-safety-in-canada-five-factors_canadim_fcg.md"

echo "\nFCGvisa translated, © canadim All Rights Reserved." >> "../../_posts/2023-02-10-safety-in-canada-five-factors_canadim_fcg.md"

# rm -f *.html
# rm -f *_canadim.md
# rm -f *_fcg.md
# rm -f *_cn.md