read -p "Input path:" path

files=$(ls $path)

for list in $files
do
  lo=$(pwd)
  echo $lo
  # cp -r $lo/build $path/$list/
  cp -r $lo/webpack.build.config.js $path/$list/webpack.build.config.js
done
