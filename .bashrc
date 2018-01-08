#!/bin/bash
#
# ~/.bashrc

## If running interactively, source each bash_* file in ~/.local/bash
if [[ $- = *i* ]]; then
	for file in ~/.local/bash/bash_*; do
		[[ ${LOGINLOG} ]] && LOGINLOG="${LOGINLOG}"$'\nSourcing "'"${file}"'"'
		[[ -f "${file}" ]] && . "${file}" &&
		[[ ${LOGINLOG} ]] && LOGINLOG="${LOGINLOG}"$'\n☺ "'"${file}"'" was sourced successfully.'
	done
else
	LOGINLOG="${LOGINLOG}"$'\nCurrent shell is non-interactive. Will NOT source "'"${HOME}/.bashrc"'"'
fi

## set a fallback prompt in case it is not set
PS1FALLBACK='[\u@\h \W]\$ '
PS1="${PS1:-PS1FALLBACK}"

## reuse your files stored in ${HOME}/.local/x11/xresources
load_xresources ()
{
	if [ "$TERM" = "linux" ]; then
    	_SEDCMD='s/.*\*color\([0-9]\{1,\}\).*#\([0-9a-fA-F]\{6\}\).*/\1 \2/p'
    	for i in $(sed -n "$_SEDCMD" ${HOME}/.local/x11/xresources | awk '$1 < 16 {printf "\\e]P%X%s", $1, $2}'); do
        	echo -en "$i"
    	done
    	clear
	fi
}
export -f load_xresources && echo 'export -f load_xresources' >> "${LOGINLOG}"
load_xresources && echo 'Xresources loaded successfully' >> "${LOGINLOG}"
