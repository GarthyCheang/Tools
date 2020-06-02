# declare -a gameList=("748331560" "718019537" "599070810" "658607827" "967994994" "928376963" "967227345" "582173982" "540314848" "781069660")
# declare -a gameNameMap=(["748331560"]="caishen" ["718019537"]="dragonphoenix" ["599070810"]="greatdragons" ["658607827"]="greatWindsfortune" ["967994994"]="liondance" ["928376963"]="luckypandamacao" ["967227345"]="magicstone" ["582173982"]="thekoidragon" ["540314848"]="tigerfighter" ["781069660"]="queenofsheba")

declare -a gameList=("748331560" "718019537" "599070810" "658607827" "967994994" "928376963" "967227345" "582173982" "540314848")
declare -a gameNameMap=(["748331560"]="Cai Shen" ["718019537"]='Dragonp & Phoenix' ["599070810"]="Great Dragons" ["658607827"]="Great Winds Fortune" ["967994994"]="Lion Dance" ["928376963"]="Lucky Panda Macao" ["967227345"]="Magic Stone" ["582173982"]="The Koi Dragon" ["540314848"]="Tiger Fighter" )

version=2.3.0
p_version=2.3.0
rm -rf /tmp/sv
rm -rf /tmp/sv.zip
for i in "${gameList[@]}"
do
  # echo "${gameNameMap[$i]}"
  # mkdir -p /cont/lax/$i/clients/$p_version && cp -rf /cont/lax/TMPSV/$i/* "$_"
  # mkdir -p /tmp/sv/$i/clients/$p_version && cp -rf /cont/lax/TMPSV/$i/* "$_"
  # rm -rf /cont/lax/$i/clients/$p_version/slot-kit/assets/debugData.json
  # rm -rf /tmp/sv/$i/clients/$p_version/slot-kit/assets/debugData.json
  # cd /tmp/sv
  # zip -r ./game\#"${gameNameMap[$i]}"\#$p_version.zip ./$i
	# rm -rf $i

  mkdir -p /cont/lax/$i/clients/$p_version && cp -rf /tmp/sv/$i/* "$_"

done

cd /tmp
zip -r sv.zip ./sv
