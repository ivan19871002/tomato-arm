#!/bin/sh
DIR=`pwd`
DUMP=.out.dump
ALL=en_EN.all
LEX=en_EN.dict
#RU_LEX=ru_RU.dict
RU_LEX=../www/ru_RU.txt
RU_LANG=ru_RU.txt
RU_MISS=ru_RU.need_translation

cd $DIR
echo "## RAW strings DUMP" > $DUMP
echo "#" > $ALL
echo "# AT translation autogen strings" >> $ALL
echo "#" >> $ALL
for file in $(grep "<% translate" $DIR/*.asp -l ); do
	echo "" >> $ALL
	echo "#" `basename $file` >> $ALL	
	echo "" >> $ALL
	# RAW (debug)
	egrep -o -E "<\% translate\(.*\%>" $file | sed -e 's/%>/%>\n/g' | awk 'match($0, /<%(.*)/) {print substr($0, RSTART, RLENGTH)}' >> $DUMP
	egrep -o -E "<\% translate\(.*\%>" $file | sed -e 's/%>/%>\n/g' | awk 'match($0, /<% translate\(.*\%>/) {print substr($0, RSTART, RLENGTH)}' | awk -F"\"" '{print $2"="}' >> $ALL
	# awk (byg: only first entrance)
	# cat $file | awk 'match($0, /<% translate\(.*\%>/) {print substr($0, RSTART, RLENGTH)}' | awk -F"\"" '{print $2"="}' >> $ALL
done

# generate main EN lex
cat $ALL | grep -v "^#" | sort | uniq > $LEX
# check for RU strings
echo "### RU lang for AT ###" > $RU_LANG
echo "### Untranslated RU strings ###" > $RU_MISS
# command | while read -r line; do command "$line"; done  
# while read -r line; do command "$line"; done <file
while read line; do
	val=`awk -F"=" '{print $1}' <<< "$line"`
#	echo "val = $val"
#	echo ""
	if ! grep "$val" $RU_LEX 1>/dev/null 2>&1; then
		echo "$line" >> $RU_MISS
	fi
done < $LEX

