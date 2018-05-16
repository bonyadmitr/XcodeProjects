#!/bin/sh

## to run from root folder:
## ./Scripts/alias.sh

# file_name=".bash_profile"
file_name=".zshenv"

add_alias() {
	## check for existing alias
	if grep -q "$2" "$HOME/$file_name"; then
		echo "you already have alias for: $2"
	else
		echo "alias $1='$2'" >> ~/"$file_name"
	fi
}

add_alias "fsynx" "bundle e fastlane synx"
add_alias "fpods" "bundle e fastlane pods"
add_alias "fcloc" "bundle e fastlane clocc"
add_alias "pngo" "./Scripts/pngcrush.sh"

## update aliases
source ~/"$file_name"

## maybe:
# Алиасы лучше поместить в файл ~/.bash_aliases, а в .bashrc прописать
# if [ -f ~/.bash_aliases ]; then
# 	. ~/.bash_aliases
# fi