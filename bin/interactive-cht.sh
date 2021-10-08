#!/usr/bin/env bash
selected=`cat ~/.cht-languages ~/.cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/.cht-languages; then
    query=`echo $query | tr ' ' '+'`
    kitty @ new-window bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
else
    kitty @ new-window bash -c "curl -s cht.sh/$selected~$query | less"
fi

