#!/bin/bash

ques=$(basename "$(pwd)")

if [ "$ques" = "Questions" ]; then
	ques=$(ls -dv *.\ * | rofi -dmenu --no-custom -p Question -i)

	if [ "$ques" = "" ]; then
		exit 1
	fi
	cd "$ques"
fi

details=
if [[ $(which json_reformat 2> /dev/null) ]]; then
	details="$(cat details.json | json_reformat)"
elif [[ $(which json_pp 2> /dev/null) ]]; then
	details="$(cat details.json | json_pp -f json)"
elif [[ $(which python 2> /dev/null) ]]; then
	details="$(cat details.json | python -m json.tool)"
else
	details="$(cat details.json | python3 -m json.tool)"
fi

lang=$(echo "$details" | grep -P '"lang" ?:' | cut -d'"' -f4 | rofi -dmenu -no-custom -mesg "
    Question: $ques
" -p Language -i)

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
			vim "code.$ext"	
			echo "$details" | grep -P "\"lang\" ?: \"$lang\"" -B 1 -A 2 | grep '"code"' | cut -d'"' -f4 | sed 's/\\n/\n/g' > "code.$ext"
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
	vim "code.$ext"	
	echo "$details" | grep -P "\"lang\" ?: \"$lang\"" -B 1 -A 2 | grep '"code"' | cut -d'"' -f4 | sed 's/\\n/\n/g' > "code.$ext"
fi

[[ $(ls 1 2> /dev/null) ]] && rm 1 > /dev/null
