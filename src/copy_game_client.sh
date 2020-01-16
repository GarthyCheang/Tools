declare -a gameList=("853638257" "967994994" "721029205" "582173982" "718019537" "965322406" "608272818" "540314848" "967227345" "654204360" "658607827" "599070810" "735339550" "666741805" "813410842" "709619169" "630513120" "816385629" "928376963" "965145427" "527487350" "628631935" "564835740")
for i in "${gameList[@]}"
do
	echo $i
	rm -rf /laxino/lax/$i/clients/*
	cp -rf /laxino/lax/st/$i/1.3.1 /laxino/lax/$i/clients/
	cp -rf /laxino/lax/st/$i/1.3.0 /laxino/lax/$i/clients/
	cp -rf /laxino/lax/st/$i/1.5.0 /laxino/lax/$i/clients/
	cp -rf /laxino/lax/st/$i/2.1.0 /laxino/lax/$i/clients/
	cp -rf /laxino/lax/st/$i/2.1.1 /laxino/lax/$i/clients/
done
