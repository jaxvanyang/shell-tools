#i!/bin/bash

help_msg="Usage:\n
		\t./extract_boot.sh <image.zip>\n"

zip_file=""

if [ $# -ne 1 ]; then
	echo $help_msg
	exit 0
else
	zip_file=$1
fi

if [ ! -e $zip_file ]; then
	echo "Caution: file not exists !"
	echo $help_msg
	exit 0
fi

zip_info=$(unzip -l $zip_file)
inner_zip=$(printf "$zip_info" | awk '{print $4}' | grep .zip)
# inner_zip_name=$(printf "$inner_zip_path" | awk -F / '{print $NF}')
unzip $zip_file $inner_zip -d extract-tmp
unzip extract-tmp/$inner_zip boot.img
rm -rf extract-tmp
