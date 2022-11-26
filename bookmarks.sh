#!/usr/bin/env bash

# Colors
c_green='\033[0;32m'
c_red='\033[0;31m'
c_yellow='\033[0;33m'
c_bold_green='\033[1;32m'
c_clear='\033[0m'

# Config Directory and Files
bookmarks_dir="$HOME"/.cache
bookmarks="$bookmarks_dir"/bookmarks.txt
bookmarks_display="${bookmarks/#$HOME/'~'}" # show `~` instead of `$HOME` (or) `/home/username`
temp_file="$bookmarks"_tmp
default_dir="./" # use current directory (`./`) as default directory, useful when cancelling the command
user_option=""

# Flag to check if an option is passed
contains_option=false

Help() {
	printf "%bbookmarks.sh%b\n" "$c_bold_green" "$c_clear"
	printf "A simple command-line utility to bookmark directories.\n"
	printf "\n"
	printf "Usage: %bbookmarks.sh%b -([%ba%b|%bd%b] %bdir%b|[%bh%b|%bl%b])\n" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear"
	printf "\n"
	printf "options:\n"
	printf "%ba%b  %ba%bdd.\n" "$c_green" "$c_clear" "$c_green" "$c_clear"
	printf "%bd%b  %bd%belete.\n" "$c_green" "$c_clear" "$c_green" "$c_clear"
	printf "%bh%b  %bh%belp.\n" "$c_green" "$c_clear" "$c_green" "$c_clear"
	printf "%bl%b  %bl%bist.\n" "$c_green" "$c_clear" "$c_green" "$c_clear"
	printf "\n"
	printf "args:\n"
	printf "%bdir%b  optional custom %bdir%b for options '%ba%b' and '%bd%b'. (defaults to '%b\$PWD%b')\n" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear" "$c_green" "$c_clear"
	printf "\n"
	printf "%bnote%b: bookmarks will be stored in \"%b%s%b\" file.\n" "$c_green" "$c_clear" "$c_green" "$bookmarks_display" "$c_clear"
}

Add() {
	if [[ -f "$bookmarks" ]]; then
		case $(
			grep --fixed-strings --line-regexp "$1" "$bookmarks" >/dev/null
			echo $?
		) in
		0)
			printf "\"%b%s%b\" is already present in \"%b%s%b\".\n" "$c_yellow" "$1" "$c_clear" "$c_yellow" "$bookmarks_display" "$c_clear"
			;;
		1)
			echo "$1" >>"$bookmarks"
			printf "\"%b%s%b\" added to \"%b%s%b\".\n" "$c_green" "$1" "$c_clear" "$c_green" "$bookmarks_display" "$c_clear"
			sort "$bookmarks" >"$temp_file" && mv "$temp_file" "$bookmarks"
			;;
		*)
			printf "%bEncountered error while searching for the directory in the file%b.\n" "$c_red" "$c_clear"
			exit 0
			;;
		esac
	else
		# if file does not exist, add `$default_dir` to the file
		echo "$default_dir" >>"$bookmarks"
		echo "$1" >>"$bookmarks"
		printf "\"%b%s%b\" added to \"%b%s%b\".\n" "$c_green" "$1" "$c_clear" "$c_green" "$bookmarks_display" "$c_clear"
	fi
}

Delete() {
	if [[ -f "$bookmarks" ]]; then
		if [[ ! -s "$bookmarks" ]]; then
			printf "file \"%b%s%b\" is empty.\n" "$c_yellow" "$bookmarks_display" "$c_clear"
			exit 0
		fi

		case $(
			grep --fixed-strings --line-regexp "$1" "$bookmarks" >/dev/null
			echo $?
		) in
		0)
			# escape backslash for sed
			sed -i '\|^'"${1//\\\ /\\\\\\\ }"'$|d' "$bookmarks"
			printf "\"%b%s%b\" deleted from \"%b%s%b\".\n" "$c_green" "$1" "$c_clear" "$c_green" "$bookmarks_display" "$c_clear"
			;;
		1)
			printf "\"%b%s%b\" is not present in \"%b%s%b\".\n" "$c_yellow" "$1" "$c_clear" "$c_yellow" "$bookmarks_display" "$c_clear"
			;;
		*)
			printf "%bEncountered error while searching for the directory in the file%b.\n" "$c_red" "$c_clear"
			exit 0
			;;
		esac
	else
		printf "file \"%b%s%b\" does not exist.\n" "$c_yellow" "$bookmarks_display" "$c_clear"
	fi
}

List() {
	if [[ (! -f "$bookmarks") || (! -s "$bookmarks") ]]; then
		echo "$default_dir" >>"$bookmarks"
	fi

	# if fzf is not found, retunr `$default_dir`
	if ! command -v fzf &>/dev/null; then
		echo "$default_dir"
		exit 0
	fi

	option=$(fzf --height 40% --reverse <"$bookmarks")
	# if option is empty return `$default_dir`
	if [[ -z "$option" ]]; then
		echo "$default_dir"
	else
		# echo -n "$option" | xclip -selection clipboard &>/dev/null
		echo "$option"
	fi
}

# Using command-line flags (`:` is prefixed for silent error checking)
while getopts :adhl option; do
	case "${option}" in
	a)
		user_option="a"
		;;
	d)
		user_option="d"
		;;
	h)
		Help
		exit 0
		;;
	l)
		user_option="l"
		;;
	?)
		printf "%bError! Invalid Option%b\n" "$c_red" "$c_clear"
		exit 0
		;;
	*) exit 0 ;;
	esac

	contains_option=true
done

# if no option is passed, run help
if [[ $contains_option = false ]]; then
	Help
	exit 0
fi

# shift to check for directory name (for options 'a' and 'd')
shift $((OPTIND - 1))

# dir="$PWD"
dir="${PWD/#$HOME/'~'}"
if [[ -n $1 ]]; then
	dir="${1/#$HOME/'~'}"
fi
# replace spaces with backslash space
dir="${dir//\ /\\\ }"

case "${user_option}" in
a)
	Add "$dir"
	;;
d)
	Delete "$dir"
	;;
l)
	List
	;;
esac
