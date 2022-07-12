#!/bin/bash

ques=$(basename "$(pwd)")

if [ "$(basename "$(pwd)")" = "Questions" ]; then
	ques=$(ls -dv *.\ * | rofi -dmenu --no-custom -p Question)
	#ques=$(cat ../questions_dump.json | json_pp -f json | grep -P '"(title|frontendQuestionId)" :' | sed -n 'N;s/\n/ /g;p' | cut --output-delimiter='. ' -d'"' -f4,8 | rofi -dmenu -no-custom -p "Question")

	if [ "$ques" = "" ]; then
		exit 1
	fi
	cd "$ques"

	#echo "Enter Question Number: "
	#read n
	#q=$(ls | grep -P "^$n\. .+")
	#if [ ${#q} -gt 3 ]; then
	#	printf "Question: %s? [Y/n]: " "$q"
	#	read ack
	#	if [ "$ack" = "" ] || [ "$ack" = "Y" ] || [ "$ack" = "y" ]; then
	#		ques="$q"
	#	else
	#		exit 1
	#	fi
	#else
	#	echo "Invalid Question number!"
	#	exit 1
	#fi
fi

lang=$(cat details.json | json_pp -f json | grep '"lang" :' | cut -d'"' -f4 | rofi -dmenu -no-custom -p Language)
# | awk -F'"' '
#$0 ~ /codeSnippets/ {f = 1}
#$0 ~ /"lang" :/ {
#	if (f == 1) print $4
#}
#$0 ~ /^ +], *$/ {exit}' | rofi -dmenu -no-custom)
if [ "$lang" = "" ]; then
	exit 1
fi

declare -A fileext=( "C" c "C#" cs "C++" cpp "JavaScript" js "Java" java "Ruby" rb "Swift" swift "Go" go "Scala" scala "Kotlin" kt "Rust" rs "PHP" php "TypeScript" ts "Racket" rkt "Erlang" erl "Elixir" exs "Python" py "Python3" py "Bash" sh "MySQL" mysql "MS SQL Server" mssql "Oracle" osql )

ext=${fileext["$lang"]}

ls code.$ext 2>1 > /dev/null

if [ $? -eq 0 ]; then
	action=$(echo -e "1. Open the existing code
2. Overwrite existing code, fresh start
3. Delete existing $lang code
4. Do nothing, exit" | rofi -dmenu -only-match -mesg "File already exists" -p Action)

	case "$action" in
		"1. Open the existing code")
			vim "code.$ext"
		;;
		"2. Overwrite existing code, fresh start")
			cat details.json | json_pp -f json | grep -P "\"lang\" : \"$lang\"" -B 1 | grep '"code"' | cut -d'"' -f4 | sed 's/\\n/\n/g' > "code.$ext"
			vim "code.$ext"	
		;;
		"3. Delete existing $lang code")
			rm "code.$ext"
			echo "Deleted \"code.$ext\"!"
		;;
		"4. Do nothing, exit")
			exit 0
			echo "Exited"
		;;
	esac
else
	cat details.json | json_pp -f json | grep -P "\"lang\" : \"$lang\"" -B 1 | grep '"code"' | cut -d'"' -f4 | sed 's/\\n/\n/g' > "code.$ext"
	vim "code.$ext"	
fi

[[ $(ls 1 2> /dev/null) ]] && rm 1 > /dev/null
