# https://immigrationnewscanada.ca/new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs/

curl -k -L -s --compressed https://immigrationnewscanada.ca/new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs/ | pup "article" | tee 2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs.html

html2md -i "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs.html" | tee "tmp_2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada.md"
sed '/===/d;/----/d;/\[!/d;/Something went wrong/d;/Load More Posts/d;/Loading/d;/data-lazy-fallback/d' "tmp_2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '/FIND OUT IF YOU/,$d;/googletag/d;/Free Immigration Assessment/d;/immigrationnewscanada/d;/adsbygoogle/d;/！	!/d;/SHARE THIS ARTICLE/d;/Free Assessment/d;' | cat -s | tee 2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada.md
trans -b en:zh "file://2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada.md" | tee "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada.md
sed -i 's/＃/#/g;' 2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_cn.md
paste "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_cn.md" "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada.md" | tee "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada_fcg.md"

cat "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada_fm.md" "2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada_fcg.md" > "../../_posts/2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada_fcg.md"

echo "\nFCGvisa translated, © immigrationnewscanada All Rights Reserved." >> "../../_posts/2023-02-22-new-quebec-arrima-draw-invites-1011-profiles-in-26-nocs_immigrationnewscanada_fcg.md"

# https://immigrationnewscanada.ca/canada-immigration-backlog-increases-by-6-new-ircc-data/

curl -k -L -s --compressed https://immigrationnewscanada.ca/canada-immigration-backlog-increases-by-6-new-ircc-data/ | pup "article" | tee 2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data.html

html2md -i "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data.html" | tee "tmp_2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada.md"
sed '/===/d;/----/d;/\[!/d;/Something went wrong/d;/Load More Posts/d;/Loading/d;/data-lazy-fallback/d' "tmp_2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada.md" | sed 's/\[\([^][]*\)\]([^()]*)/\1/g' | sed '/FIND OUT IF YOU/,$d;/googletag/d;/Free Immigration Assessment/d;/immigrationnewscanada/d;/adsbygoogle/d;/！	!/d;/SHARE THIS ARTICLE/d;/Free Assessment/d;' | cat -s | tee 2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada.md
trans -b en:zh "file://2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada.md" | tee "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada.md
sed -i 's/＃/#/g;' 2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_cn.md
paste "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_cn.md" "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada.md" | tee "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada_fcg.md"

cat "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada_fm.md" "2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada_fcg.md" > "../../_posts/2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada_fcg.md"

echo "\nFCGvisa translated, © immigrationnewscanada All Rights Reserved." >> "../../_posts/2023-02-22-canada-immigration-backlog-increases-by-6-new-ircc-data_immigrationnewscanada_fcg.md"

# rm -f *.html
# rm -f *_immigrationnewscanada.md
# rm -f *_fcg.md
# rm -f *_cn.md