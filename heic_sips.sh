#!/bin/zsh
#set -x
#setopt interactivecomments
setopt +o nomatch
unsetopt CASE_GLOB #case insensitive *.

echoo () {
  echo $'\e[0;103m' $1 $'\e[0m'
}

start=`date +%s`;

cd $1;

remove=0
subfolders=0
path_wildcard=""
output_folder="_heic_conversion_tmp"
files_not_converted=()

if [[ "$2" = "remove" || "$3" = "remove" ]];
then
  remove=1
fi

if [[ "$2" = "subfolders" || "$3" = "subfolders" ]];
then
  subfolders=1
  path_wildcard="**/*/"
fi

exts=("jpg" "jpeg" "bmp" "png" "dng")

echoo "\tCONVERTING FILES WITH EXTENSIONS: $exts";
if [[ $subfolders -eq 1 ]];
then
  echoo "\tSUBFOLDERS INCLUDED";
fi
if [[ $remove -eq 1 ]];
then
  echoo "\tORIGINAL FILES WILL BE REMOVED AFTER CONVERSION";
fi

glob_total=0;
glob_success=0; 
glob_deleted=0;

mkdir $output_folder;

for ext in $exts; do 
  echoo "\t";
  echoo "\tPROCESSING $ext";

  total_ext=0;
  success_ext=0; 

  #echo $~path_wildcard;

  for dir in $~path_wildcard ./; do

    success_dir=0

    if [[ "$dir" = "$output_folder/" ]]; #ignore output folder
    then
      continue
    fi

    src_files=($dir*.$ext);

    if [[ "${src_files[@]:0:1}" = "$dir*.$ext" ]] #no files in directory
    then
      continue
    fi

    total_dir=${#src_files[@]};
    ((total_ext=total_ext+total_dir))

    echoo "\t"
    echoo "\tCURRENT DIR: $dir, TOTAL FILES: $total_dir, RUNNING SIPS..."
    
    echo ""
    sips -s format heic $src_files --out $output_folder
    echo ""

    dst_files=($output_folder/*.heic)
    #echoo \tDst files: $dst_files
    #echoo "${dst_files[@]:0:1}" 
    #echoo "$output_folder/*.heic"

    if [[  "${dst_files[@]:0:1}" != "$output_folder/*.heic" ]] #there're files in directory
    then
      success_dir=${#dst_files[@]};
      ((success_ext=success_ext+success_dir));
  #
  # MOVE CONVERTED FILES
  #
    echoo "\tCOPYING CONVERTED FILES.."
    for dst_file in $dst_files; do
      dst=$(basename -- "$dst_file")
      #echoo $dst 
      trg_file=$dst
      until
        [[ ! -f $dir/$trg_file ]]
      do
        trg_file="$(echo "$dst" | sed -e 's/\.[^.]*$//')-dup.heic"
      done

      #echoo $trg_file
      #echoo $output_folder
      #echoo $dir
      mv $output_folder/$dst $dir/$trg_file 
    done
  #
  # DELETE ORIGINALS
  #
      if [[ $remove -eq 1 ]]; then
        echoo "\tDELETING ORIGINALS.."
        for dst_file in $dst_files; do
          orig_file=$(basename -- "$(echo "$dst_file" | sed -e 's/\.[^.]*$//').$ext");
          #echoo $dst_file
          #echoo $orig_file

          file_exists=0

          if [[ -f $dir/$orig_file ]]; then
            file_exists=1
          fi;

          #echoo "\tOriginal file $orig_file ---- exists $file_exists" 

          if [[ $file_exists -eq 1 ]]; then
            rm $dir/$orig_file;
            if [[ $? -eq 0 ]]; then
              ((glob_deleted++))
            fi
          fi
        done;
      fi
    fi

    echoo "\tTOTAL FILES SUCCESSFULY CONVERTED: $success_dir";

    #mv $dst_files $dir;
    #dst="$(echo "$src" | sed -e 's/\.[^.]*$//').heic"; # remove original extension and replace it with heic
      
  done;

  ((glob_total=total_ext+glob_total));
  ((glob_success=success_ext+glob_success));
  echoo "\tFILES PROCESSED SO FAR: $glob_total,  SUCCESSFULY: $glob_success, ORIGINALS DELETED: $glob_deleted";
  echoo "\t";
done;

rm -rf $output_folder;

#echoo "\tFILES NOT CONVERTED: ${#files_not_converted[@]}"
#echoo "$files_not_converted"

end=`date +%s`;
echoo "\tTIME: `expr $end - $start` seconds.";