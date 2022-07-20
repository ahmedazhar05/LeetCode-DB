#!/bin/bash

ques=$(basename "$(pwd)")

if [ "$(basename "$(pwd)")" = "Questions" ]; then
	ques=$(ls -dv *.\ * | rofi -dmenu --no-custom -p Question -i)

	if [ "$ques" = "" ]; then
		exit 1
	fi
	cd "$ques"
fi

file=$(ls /tmp/question* 2>/dev/null || mktemp --tmpdir --suffix=.html questionXXX)

json=$(cat details.json | json_pp -f json -json_opt pretty,indent_length=0)
stats=$(echo -n "$json" | sed -n '/"stats" : /{s/^"stats" : "//g; s/",$//g; s/\\"/"/g; p}' | json_pp -f json -json_opt pretty,indent_length=0)

likes=$(echo "$json" | grep -Po '"likes" :.*' | grep -Po '\d+')
dislikes=$(echo "$json" | grep -Po '"dislikes" :.*' | grep -Po '\d+')
difficulty=$(echo "$json" | grep '"difficulty" : ' | cut -d'"' -f4)

accrate=$(echo "$stats" | grep '"acRate" : ' | cut -d'"' -f4)
acceptance=$(echo "$stats" | grep '"totalAcceptedRaw" : ' | grep -Po '\d+')
submissions=$(echo "$stats" | grep '"totalSubmissionRaw" : ' | grep -Po '\d+')

cat <<EOF > $file
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width">
        <title>$ques</title>
        <style>
            body {
              margin: 1em 0;
            }
            div.premium {
              display: flex;
              height: 50vh;
              position: relative;
              justify-content: center;
              align-items: center;
              font-size: 2em;
              text-align: center;
              padding: 0 20%;
              font-weight: bold;
            }
        </style>
        <style type="text/css">
            .content__u3I1 {
              font-size: 14px;
              color: #263238;
              margin: 1em;
            }
            .content__u3I1 hr {
              border: 1px solid #eceff1;
              background-color: #eceff1;
            }
            .content__u3I1 a {
              pointer-events: auto;
              color: #607d8b;
              text-decoration: none;
              padding-bottom: 1px;
              border-bottom: 1px solid transparent;
              -webkit-transition: border-bottom-color 0.3s;
              -o-transition: border-bottom-color 0.3s;
              transition: border-bottom-color 0.3s;
            }
            .content__u3I1 a:hover {
              border-bottom-color: #607d8b;
            }
            .content__u3I1 pre {
              background: #f7f9fa;
              padding: 10px 15px;
              color: #263238;
              line-height: 1.6;
              font-size: 13px;
              border-radius: 3px;
            }
            .content__u3I1 pre code {
              padding: 0;
              color: inherit;
              background-color: transparent;
              -moz-tab-size: 4;
                -o-tab-size: 4;
                   tab-size: 4;
              font-family: 'SFMono-Regular', Consolas, 'Liberation Mono', Menlo, Courier, monospace;
            }
            .content__u3I1 code {
              color: #546e7a;
              background-color: #f7f9fa;
              padding: 2px 4px;
              font-size: 13px;
              border-radius: 3px;
              font-family: monospace;
            }
            .content__u3I1 table {
              margin-bottom: 16px;
            }
            .content__u3I1 table th,
            .content__u3I1 table td {
              padding: 6px 12px;
              border: 1px solid #dddddd;
            }
            .content__u3I1 table tr {
              border-top: 1px solid #dddddd;
            }
            .content__u3I1 table tr:nth-child(2n) {
              background-color: #f7f9fa;
            }
            .content__u3I1 blockquote {
              padding-left: 15px;
              border-left: 5px solid #eceff1;
              color: #616161;
            }
            .content__u3I1 p {
              font-size: inherit;
            }
            .content__u3I1 pre {
              white-space: pre-wrap;
            }
            .content__u3I1 img {
              max-width: 100%;
              height: auto !important;
            }
        </style>
        <style>
            .css-101rr4k{
              padding-bottom: 1em;
              border-bottom: 1px solid #eeeeee;
              margin: 1em;
            }
            .css-10o4wqw {
              display: flex;
              gap: 20px;
              white-space: nowrap;
              -webkit-box-align: center;
              align-items: center;
              font-size: 12px;
              color: rgb(84, 110, 122);
              line-height: 20px;
            }
            .css-10o4wqw .diff{
              font-size: 13px;
            }
            .css-10o4wqw .diff.Medium{
              color: #ef6c00;
            }
            .css-10o4wqw .diff.Easy{
              color: #43a047;
            }
            .css-10o4wqw .diff.Hard{
              color: #e91e63;
            }
        </style>
        <style>
            .css-q9155n {
              display: flex;
              justify-content: space-evenly;
              -webkit-box-align: center;
              align-items: center;
              padding: 10px 0px;
            }
            .css-oqu510:first-child {
              padding-left: 0px;
            }
            .css-oqu510 {
              display: flex;
              -webkit-box-align: center;
              align-items: center;
              position: relative;
              padding: 0px 20px;
              font-size: 13px;
              line-height: 20px;
            }
            .css-y3si18 {
              margin-right: 10px;
              color: rgb(117, 117, 117);
            }
            .css-jkjiwi {
              color: rgb(38, 50, 56);
            }
        </style>
    </head>
    <body>
        <div id="header" class="css-101rr4k">
            <h3>$ques</h3>
            <div class="css-10o4wqw">
                <strong class="diff $difficulty">$difficulty</strong>
                <span class="likes">Likes: <span>$likes</span></span>
                <span class="dislikes">Dislikes: <span>$dislikes</span></span>
            </div>
        </div>
        <div id="content" class="content__u3I1">
EOF

content=$(cat details.json | json_pp -f json -json_opt pretty,indent_length=0 | sed -n '/"content" :/{s/^\s*"content" : "//g; s/",$//g; s/\\"/"/g; s/\\n/\n/g; s/\\t/\t/g; p;}')
if [ ${#content} -lt 20 ]; then
    echo '<div class="premium">Premium Subscription is required</div>' >> $file
else
    echo $content >> $file
fi

cat <<EOF >> $file
        </div>
        <div style="position: relative;">
            <div class="css-q9155n">
                <div class="css-oqu510">
                    <div class="css-y3si18">Accepted</div>
                    <div class="css-jkjiwi">$acceptance</div>
                </div>
                <div class="css-oqu510">
                    <div class="css-y3si18">Submissions</div>
                    <div class="css-jkjiwi">$submissions</div>
                </div>
                <div class="css-oqu510">
                    <div class="css-y3si18">Acceptance Rate</div>
                    <div class="css-jkjiwi">$accrate</div>
                </div>
            </div>
      </div>
    </body>
</html>
EOF

xdg-open $file
