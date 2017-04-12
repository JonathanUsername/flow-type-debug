#!/bin/bash
if [ "$#" -lt 3 ]; then
    echo "Usage: findtype [file regex] [line number] [column number]"
fi

line=$2
col=$3

BINPATH="$(npm bin)"
FLOW="$BINPATH/flow"

if [[ -z "$BINPATH" || -z "$FLOW" ]]; then
    (>&2 echo "Cannot find .bin/flow in local node_modules.")
    exit 1
fi

file="$($FLOW ls | grep $1)"
fno=$(echo "$file" | wc -l)

if [[ -z "$file" ]]; then
    (>&2 echo "No files matching '$1':")
    exit 1
elif [[ $fno -gt 1 ]]; then
    (>&2 echo "Too many files matching '$1'. Narrow your search term:"; echo "$file" | sed 's/^/  /g')
    exit 1
fi

output="$($FLOW type-at-pos $file $line $col --json)"

# I like colours
if tput setaf 1 &> /dev/null; then
  tput sgr0; # reset colors
  reset=$(tput sgr0);
  blue=$(tput setaf 116);
  cyan=$(tput setaf 37);
  grey=$(tput setaf 245);
  white=$(tput setaf 188);
else
  bold="";
  reset="";
  blue="";
  cyan="";
  grey="";
  white="";
fi;

echo -en "${cyan}Type:${reset}\n\n"
echo "$output" | jq -r .type | js-beautify
echo -en "\n\n"

# get and show source
def="$($FLOW get-def $file $line $col --json)"
spath="$(echo $def | jq -r .path)"

if [[ -z "$spath" ]]; then
    (>&2 echo "No associated definition.")
    exit 0
fi

sls="$(echo $def | jq -r .line)"
sle="$(echo $def | jq -r .endline)"
scs="$(echo $def | jq -r .start)"
sce="$(echo $def | jq -r .end)"

hidepath=$(npm root | python -c 'import sys; d = sys.stdin.read(); print "%s/" % "/".join(d.split("/")[:-1])')
tpath=${spath#$hidepath}

echo -e "${cyan}Defined at ${blue}$tpath:$sls:$scs${reset}"
contextabove=$(awk "FNR>=$sls - 5 && FNR<$sls" $spath)
context=$(awk "FNR>=$sls && FNR<=$sls" $spath)
context=$(echo "$context" | sed -e "s/\(.\)/${cyan}\1/$scs" -e "s/\(.\)/\1${reset}/$(($sce+11))") # Magic number. These are not the string offsets you think they are
contextbelow=$(awk "FNR>$sle && FNR<=$sle + 5" $spath)

echo -e "${grey}$contextabove\n${white}$context\n${grey}$contextbelow${reset}"
