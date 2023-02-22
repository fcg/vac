# https://www.canadavisa.com/news/ircc-immigration-backlog-remains-at-2.1-million-february-2023.html

html2md -i "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023.html" | tee "tmp_2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa.md"
sed 's/\[\([^][]*\)\]([^()]*)/\1/g' "tmp_2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa.md" | sed '/Tags:/,$d;/Cec Fswp Fstp	Immigrate Work/d;/Felonycanada/g;/	Immigrate Work Study Sponsor Inadmissibility/d;/Canadavisaheadstartexpressentry/d;/Complete our FREE assessment form/d;/googletag/d;/Sponsor Content/d;/Sivakumar/d;/Schedule a Free/d;/Get a Free/d;/Discover if You Are Eligible for Canadian Immigration/d;/CanadaVisa.com/d;' | cat -s | tee 2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa.md
trans -b en:zh "file://2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa.md" | tee "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_cn.md"
sed -i 's/##* //g;s/^\* //g;' 2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa.md
sed -i 's/＃/#/g;' 2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_cn.md
paste "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_cn.md" "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa.md" | tee "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa_fcg.md"

cat "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa_fm.md" "2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa_fcg.md" > "../../_posts/2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa_fcg.md"

echo "\nFCGvisa translated, © Canadavisa.com All Rights Reserved." >> "../../_posts/2023-02-22-ircc-immigration-backlog-remains-at-2.1-million-february-2023_canadavisa_fcg.md"

# rm -f *.html
# rm -f *_canadavisa.md
# rm -f *_fcg.md
# rm -f *_cn.md