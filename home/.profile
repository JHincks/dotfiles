#!/bin/bash
#
# ~/.profile

## check whether log variable is set
if [[ -z ${LOGINLOG} ]]; then
	echo 'Error: "LOGINLOG" is not set'
	echo 'Exiting...'
	exit 1
fi

## XDG-Base-Specification
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CONFIG_DIRS="/usr/local/etc:/etc/xdg"
export XDG_DATA_DIRS="/usr/local/share:/usr/share"

## use ~/.local for plattform independant dotfiles
export MY_LOCAL_HOME="${HOME}/.local"
export MY_BASH_HOME="${HOME}/.local/bash"
#export MY_BIN_HOME="${HOME}/.local/bin"
export MY_LOG_HOME="${HOME}/.local/log"
export MY_X11_HOME="${HOME}/.local/x11"

## add directory for user specific applications to the path 
for dir in "${HOME}/bin" "${HOME}/.bin" "${HOME}/.local/bin"; do
    if [[ -d "${dir}" ]]; then
        if [[ "${MY_BIN_HOME}" ]] && [[ "${dir}" -ne "${MY_BIN_HOME}" ]]; then
			LOGINLOG="${LOGINLOG}"$'\n⚠ Found more than one directory for user specific applications.'
		fi
		LOGINLOG="${LOGINLOG}"$'\n☺ Directory "'"${dir}"'" was found.'
        LOGINLOG="${LOGINLOG}"$'\n Append "'"${dir}"'" to PATH.'
		PATH="${PATH}:${dir}"
		export MY_BIN_HOME="${dir}"
	fi
done
if [[ -z "${MY_BIN_HOME}" ]]; then
	LOGINLOG="${LOGINLOG}"$'\n⚠ No directory found for user specific applications.'
fi

## define preferred applications
export EDITOR=/usr/bin/micro
export PAGER=/usr/bin/less
export TERMINAL=/usr/bin/lilyterm
export VISUAL=/usr/bin/medit

## depend default browser on type of ui
if [[ -n "$DISPLAY" ]]; then
	export BROWSER=palemoon
else
	export BROWSER=/usr/bin/elinks
fi

## unmute alsa
if [[ -x /usr/bin/amixer ]]; then
	/usr/bin/amixer sset Master Mono 90% unmute  &> /dev/null 
	/usr/bin/amixer sset Master 90% unmute  &> /dev/null
	/usr/bin/amixer sset PCM 90% unmute &> /dev/null
	LOGINLOG="${LOGINLOG}"$'\nSet "Master Mono", "Master" and "PCM" to 90% of sound volume'
else
	LOGINLOG="${LOGINLOG}"$'\n☠ Error: "/usr/bin/amixer" was not found!'
fi

### ccache ###
if hash ccache 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CACHE_HOME}"/ccache)"
	export CCACHE_DIR="${XDG_CACHE_HOME}"/ccache
fi	

### conky ###
if hash conky 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/conky)"
	if [[ -f "${HOME}"/.conkyrc ]] && [[ ! -f "${XDG_CONFIG_HOME}"/conky/conkyrc ]]; then
	    LOGINLOG="${LOGINLOG}"$'\n'"$(mv -v "${HOME}"/.conkyrc "${XDG_CONFIG_HOME}"/conky/conkyrc)"
	elif [[ -f "${HOME}"/.conkyrc ]] && [[ -f "${XDG_CONFIG_HOME}"/conky/conkyrc ]]; then
		LOGINLOG="${LOGINLOG}"$'\n⚠'"$(mv -v "${HOME}"/.conkyrc "${XDG_CONFIG_HOME}"/conky/conkyrc_"$(date +%Y%m%d-%Hh%Mm%Ss)")"
	fi
	if [[ -f "${XDG_CONFIG_HOME}"/conky/conkyrc ]]; then
		alias conky='conky --config="${XDG_CONFIG_HOME}"/conky/conkyrc'
	fi
fi

### elinks ###
if hash elinks 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/elinks)"
	export ELINKS_CONFDIR="${XDG_CONFIG_HOME}"/elinks
fi

## gnupg 
if hash gpg 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/gnupg)"
	export GNUPGHOME="${XDG_CONFIG_HOME}"/gnupg
fi

### gtk2 ###
if [[ -d /usr/lib/gtk-2.0 ]]; then
	## gtkrc-2.0
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/gtk-2.0)"
	if [[ -f "${HOME}"/.gtkrc-2.0 ]] && [[ ! -f "${XDG_CONFIG_HOME}"/gtk-2.0/settings.ini ]]; then
	    LOGINLOG="${LOGINLOG}"$'\n'"$(mv -v "${HOME}"/.gtkrc-2.0 "${XDG_CONFIG_HOME}"/gtk-2.0/settings.ini)"
	elif [[ -f "${HOME}"/.gtkrc-2.0 ]] && [[ -f "${XDG_CONFIG_HOME}"/gtk-2.0/settings.ini ]]; then
		LOGINLOG="${LOGINLOG}"$'\n⚠'"$(mv -v "${HOME}"/.gtkrc-2.0 "${XDG_CONFIG_HOME}"/gtk-2.0/settings_"$(date +%Y%m%d-%Hh%Mm%Ss)".ini)"
	fi
	if [[ -d "${XDG_CONFIG_HOME}"/gtk-2.0 ]]; then
		export GTK2_RC_FILES="${XDG_CONFIG_HOME}"/gtk-2.0/settings.ini
	elif [[ -f "${HOME}"/.gtkrc-2.0 ]]; then
		export GTK2_RC_FILES="${HOME}"/.gtkrc-2.0
		LOGINLOG="${LOGINLOG}"$'\n☠ Relocating GTK2_RC_FILES failed!'
	else
		LOGINLOG="${LOGINLOG}"$'\n☠ Can\'t locate GTK2_RC_FILES!' #'
	fi
	## gtk-bookmarks
	#WIP
fi

### less ###
if hash less 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CACHE_HOME}"/less)"
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/less)"
	export LESSHISTFILE="${XDG_CACHE_HOME}"/less/history
	export LESSKEY="${XDG_CONFIG_HOME}"/less/lesskey
fi

### libdvdcss ###
if [[ -e /usr/lib/libdvdcss.so ]]; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_DATA_HOME}"/dvdcss)"
	export DVDCSS_CACHE="${XDG_DATA_HOME}"/dvdcss
fi

### mednafen ###
if hash mednafen 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/mednafen)"
	export MEDNAFEN_HOME="${XDG_CONFIG_HOME}"/mednafen
fi

### mplayer ###
if hash mplayer 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/mplayer)"
	export MPLAYER_HOME="${XDG_CONFIG_HOME}"/mplayer
fi

### ncurses ###
export TERMINFO="${XDG_DATA_HOME}"/terminfo
export TERMINFO_DIRS="${XDG_DATA_HOME}"/terminfo:/usr/share/terminfo 

### node.js ###
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history

### python-setuptools ###
if [[ -a /usr/lib/python3.6/site-packages/setuptools ]]; then
	 LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CACHE_HOME}"/python-eggs)"
	 export PYTHON_EGG_CACHE="${XDG_CACHE_HOME}"/python-eggs
fi

### subversion ###
if hash svn 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/subversion)"
	alias svn='svn --config-dir "${XDG_CONFIG_HOME}"/subversion'
fi

### tmux ###
if hash tmux 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/tmux)"
	export TMUX_TMPDIR="${XDG_RUNTIME_DIR}"
	if [[ -f "${XDG_CONFIG_HOME}"/tmux/tmux.conf ]]; then
		alias tmux='tmux -f "${XDG_CONFIG_HOME}"/tmux/tmux.conf'
	elif [[ -f /etc/tmux.conf ]]; then
		LOGINLOG="${LOGINLOG}"$'\n'"$(cp -v /etc/tmux.conf "${XDG_CONFIG_HOME}"/tmux/tmux.conf)"
		alias tmux='tmux -f "${XDG_CONFIG_HOME}"/tmux/tmux.conf'
	else
		LOGINLOG="${LOGINLOG}"$'\n☠ Missing file: "/etc/tmux.conf"'
	fi
fi

### urxvtd ###
if hash urxvtd 2>/dev/null; then
	export RXVT_SOCKET="$XDG_RUNTIME_DIR"/urxvtd
fi

### wine ###
if hash wine 2>/dev/null; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "$XDG_DATA_HOME"/wineprefixes)"
	export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
fi

### X11 ###
LOGINLOG="${LOGINLOG}"$'\n'"$(mkdir -pv "${XDG_CONFIG_HOME}"/X11/xcompose)"
export XAUTHORITY="${MY_X11_HOME}"/Xauthority
export XCOMPOSEFILE="${MY_X11_HOME}"/xcompose
if [[ -f "${MY_X11_HOME}"/xresources ]] && [[ ! -f "${MY_X11_HOME}"/Xresources ]]; then
	LOGINLOG="${LOGINLOG}"$'\n'"$(mv -v "${MY_X11_HOME}"/xresources "${MY_X11_HOME}"/Xresources)"
elif [[ -f "${HOME}"/.conkyrc ]] && [[ -f "${XDG_CONFIG_HOME}"/conky/conkyrc ]]; then
	LOGINLOG="${LOGINLOG}"$'\n⚠ Warning: Found file Xresources and xresources in '"${MY_X11_HOME}"'.'
fi
export XRESOURCES="${MY_X11_HOME}"/Xresources
