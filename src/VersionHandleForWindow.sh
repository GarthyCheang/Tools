read -p "Input path:" path
if  [ ! -n "$path" ] ;then
    echo "Input path!!!!!!!"
    exit
fi
read -p "Input game version:" version
read -p "Input slot kit version:" slotVersion
read -p "Which tag do you want to remove? (no need please click enter): " removeTag
read -p "Input tag: " pushTag
echo "============================================================"
files=$(ls $path)
if [ "$version"x = ""x -a "$slotVersion"x = ""x -a "$removeTag"x = ""x -a "$pushTag"x = ""x ]
then
  echo "No input"
else
  for list in $files
  do
    echo "In $list"
    echo "git pull ..............."
    cd $path/$list
    git pull
    rm -rf package-lock.json
    rm -rf node_modules
    cd ../../
    if [ "$version"x = ""x ]
    then
      echo "No input game version"
      vc=""
    else
      vc="game version $version"
      cl=$(grep -n "version" $path/$list/package.json | cut -d ":" -f 1)
      $(sed -i $cl'c \ \ "version":\ '\"$version\"\, $path/$list/package.json)
      echo package.json version update to $(sed -n $cl'p' $path/$list/package.json)
      $(sed -i '1c version\ =\ '\"$version\"\; $path/$list/config/version.js)
      echo version.js version update to $(sed -n '1p' $path/$list/config/version.js)
    fi
    if [ "$slotVersion"x = ""x ]
    then
      echo "No input slot version"
      sv=""
    else
      sv="slot version $slotVersion"
      sl=$(grep -n "slot-kit" $path/$list/package.json | head -1 |cut -d ":" -f 1)
      $(sed -i $sl'c \ \ \ \ "slot-kit": "'$slotVersion\"\, $path/$list/package.json)
      echo package.json slot kit version update to $(sed -n $sl'p' $path/$list/package.json)
    fi
    if [ "$version"x = ""x -a "$slotVersion"x = ""x ]
    then
      echo "No game version and slot kit version update"
    else
      cd $path/$list
      echo "npm install..........."
      npm install
      echo "git add ."
      git add .
      if [ "$version"x = ""x -o "$slotVersion"x = ""x ]
      then
        cm="Update $vc $sv"
      else
        cm="Update $vc and $sv"
      fi
      echo " "
      echo "git commit -m $cm"
      git commit -m "$cm"
      git push
    fi
    if [ ! "$removeTag"x = ""x ]
    then
      git push origin --delete $removeTag
      git tag -d $removeTag
      echo "Removed tag $removeTag"
    fi
    if [ ! "$pushTag"x = ""x ]
    then
      cd $path/$list
      pwd
      git tag -a $pushTag -m ""
      git push --tags
      echo "Pushed tag $pushTag"
    fi
    echo "----------------------- End---------------------------------"
  done
fi
echo "========================== Complete ========================="
