read -p "Input path:" path

files=$(ls $path)

for list in $files
do
  cd $path/$list
  echo pwd
  git add .
  git commit -m "update webpack build"
  git push
  cd ..
done
