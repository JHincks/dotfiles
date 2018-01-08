#!/bin/bash
#
# ~/.bash_profile

## create a login log
logtime="$(date +%Y%m%d-%Hh%Mm%Ss)"
LOGINLOG='Results of bash login @ '"$(date "+%A,%e. %B %Y at %H:%M:%S")"' :'
export LOGINLOG

## load personal environment and shell settings
for file in "${HOME}/.profile" "${HOME}/.bashrc"; do
    if [[ -f "${file}" ]]; then
        LOGINLOG="${LOGINLOG}"$'\nSourcing "'"${file}"'"'
        . "${file}" &&
		LOGINLOG="${LOGINLOG}"$'\n☺ "'"${file}"'" was sourced successfully.'
	else
		LOGINLOG="${LOGINLOG}"$'\n⚠ Missing file: "'"${file}"'"!'
    fi
done

## write Log to file and append all aliases and exported variables
write_logfile(){
	if [[ "${MY_LOG_HOME}" ]]; then
		logdir="${MY_LOG_HOME}/bash-login"
	else
		LOGINLOG="${LOGINLOG}"$'\n⚠ Unset variable: "MY_LOG_HOME"!'
		LOGINLOG="${LOGINLOG}"'Using "~/.local/log" now.'
		logdir="${HOME}/.local/log/bash-login"
	fi
	logfile="${logdir}/${logtime}.log"
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${logdir}")"
	LOGINLOG="${LOGINLOG}"' Writing Log to file "'"${logfile}"'"'
	echo "${LOGINLOG}" >> "${logfile}"
	echo 'List of all exported variables:' >> "${logfile}"
	echo "$(alias -p)" >> "${logfile}"
	echo "$(export -p | grep 'declare -' | cut -d "x" -f2)" >> "${logfile}"
}
	
## start xserver
if [[ -f "${HOME}"/.xinitrc ]]; then
	LOGINLOG="${LOGINLOG}"$'\n☺ File "'"${HOME}/.xinitrc"'" was found.'
	if [[ -z ${DISPLAY} && ${XDG_VTNR} -eq 1 ]]; then
		LOGINLOG="${LOGINLOG}"$'\n Running "startx" now.\n'
		write_logfile
		exec startx
	else
		LOGINLOG="${LOGINLOG}"$'\n☠ Error: "startx" was not able to run.'
		LOGINLOG="${LOGINLOG}"$'\n⚠ DISPLAY='"${DISPLAY}"' | XDG_VTNR='"${XDG_VTNR}"
		write_logfile
		exit 1		
	fi
else
	LOGINLOG="${LOGINLOG}"$'\n⚠ Missing file: "~/.xinitrc"!'
	write_logfile
fi		
