#!/bin/sh

# warrings from shellcheck:
# SC2039: In POSIX sh, arrays are undefined

if which pngcrush >/dev/null; then

	result_file_path="./Scripts/pngcrush_result.txt"

	## read file paths from file
	IFS=$'\n' read -d '' -r -a all_pngs_file < "$result_file_path"
	## find new ones
	all_pngs_find=( $(find ./WeatherApp -type f -name "*.png") )
	## write new paths to file
	printf "%s\n" "${all_pngs_find[@]}" > "$result_file_path"

	## filter new files with old ones
	for j in "${!all_pngs_file[@]}"; do
	  for i in "${!all_pngs_find[@]}"; do
	    if [ "${all_pngs_find[$i]}" = "${all_pngs_file[$j]}" ]; then
	      unset "all_pngs_find[$i]"
	      break 1
	    fi
	  done
	done

	## exec pngcrush for new files
	for png in "${all_pngs_find[@]}"; do
	    echo "pngcrush $png ..."
	    res=$(pngcrush -brute -reduce "$png" temp.png > /dev/null 2>&1)

	    # preserve original on error
	    if $res; then
	        mv -f temp.png "$png"
	    else
	    	echo "Error with: $png"
	        rm temp.png
	    fi
	done
else
  	echo "Hmm, you're missing PNGCRUSH. Install it for best result"
fi

## other scripts for image optimizations
# https://gist.github.com/ryansully/1720244
# https://gist.github.com/sergeylukin/6510605

## jpegtran
# all_jpgs=$(find ./WeatherApp -type f -name "*.jpg")

# for jpg in $all_jpgs; do
#     echo "jpegtran $jpg ..."
#     jpegtran -copy none -optimize -perfect "$jpg" > temp.jpg

#     # preserve original on error
#     if [ $? = 0 ]; then
#         mv -f temp.jpg $jpg
#     else
#         rm temp.jpg
#     fi
# done