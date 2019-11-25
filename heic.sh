#!/bin/zsh

#setopt interactivecomments
setopt +o nomatch

start=`date +%s`;

cd $1;

remove=0
subfolders=0
path_wildcard="*."

if [[ "$2" = "remove" || "$3" = "remove" ]];
then
  remove=1
fi

if [[ "$2" = "subfolders" || "$3" = "subfolders" ]];
then
  subfolders=1
  path_wildcard="**/*."
fi

exts=("jpg" "jpeg" "bmp" "png")
echo CONVERTING FILES WITH EXTENSIONS: $exts;
if [[ $subfolders -eq 1 ]];
then
  echo SUBFOLDERS INCLUDED
fi
if [[ $remove -eq 1 ]];
then
  echo ORIGINAL FILES WILL BE REMOVED AFTER CONVERSION
fi

glob_total=0;
glob_success=0; 


for ext in $exts; do 
  echo " ";
  echo "PROCESSING $ext ->";
  echo " ";
  total=0;
  success=0; 
  
  #for src in find . -name "*.$ext"; do 

  for src in $~path_wildcard$ext; do 
    if [[ "$src" = "$path_wildcard$ext" ]];
    then
      continue      # If there're no files the glob expressions can be returned instead, e.g. **/*.jpg
    fi

    echo "\t$src";
    dst="$(echo "$src" | sed -e 's/\.[^.]*$//').heic"; # remove original extension and replace it with heic
    #dst="${src%.jpg}.HEIC";
    #echo "$src -> $dst";
    magick $src $dst #&& ((success++)); 

    if [[ $? -eq 0 ]]; then
      ((success++));
      if [ $remove -eq 1 ]; then
        rm $src 
        #echo Removed $src
      fi
    else
      #echo "magick exited with error code"
    fi

    ((total++));
  done; 
  ((glob_total=total+glob_total));
  ((glob_success=success+glob_success));
  echo " ";
  echo "TOTAL '$ext' FILES: $total,  SUCCESSFUL: $success";
  echo "TOTAL FILES SO FAR: $glob_total,  SUCCESSFUL: $glob_success";
  echo " ";
done;

end=`date +%s`;
echo TIME: `expr $end - $start` seconds.;