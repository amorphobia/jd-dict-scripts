grep -P '\t\w{4,6}' danzi.txt > char.txt && \
grep -P '\t\w{4,6}' chaojizici.txt >> char.txt && \
echo "艸	cza" >> char.txt && \
echo "吰	hyo" >> char.txt && \
echo "：	xxo" >> char.txt && \
echo "“	xxo" >> char.txt && \
echo "遯	dwu" >> char.txt && \
echo "醲	nyv" >> char.txt && \
echo "嘸	xmo" >> char.txt && \
echo "蝦	xsi" >> char.txt && \
echo "昚	env" >> char.txt && \
echo "？	xxo" >> char.txt && \
echo "9	jqo" >> char.txt && \
echo "8	bso" >> char.txt && \
echo "6	lqo" >> char.txt && \
echo "3	sfo" >> char.txt && \
echo "䦆	jhi" >> char.txt && \
echo "內	nwi" >> char.txt && \
echo "沢	zea" >> char.txt && \
echo "鞌	xfo" >> char.txt && \
echo "！	xxo" >> char.txt && \
echo "2	xjo" >> char.txt && \
echo "1	yko" >> char.txt && \
cat char.txt | awk '!seen[$1]++' > char_uniq.txt && \
rm char.txt
