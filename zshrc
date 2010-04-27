# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=2000
SAVEHIST=2000
setopt appendhistory banghist histverify histignoredups
setopt autocd extendedglob
setopt monitor
unsetopt beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gaelan/.zshrc'

autoload -Uz compinit
compinit
#end of lines added by compinstall

# ZSH's xarg, with blackjack
# autoload -U zargs

# Pretty prompt
autoload -U promptinit
promptinit
prompt bigfade

# I like colours
alias ls="ls --color=auto -Fh"
alias pacman="pacman-color"

# Just in case we have real 'vi', prefer sane 'vim'
alias vi="vim"

# I use XMonad, I have no systray.
alias wicd-client='wicd-client -n'

# Firefox is a hobo sometimes
kill_firefox () {
	kill $(pgrep firefox)
}

# Music-ripping aliases
alias cda_rip="cdparanoia -B"
alias cda_ogg="find -name '*.wav' -execdir oggenc -q 6 {} +"
alias cda_mp3="find -name '*.wav' -execdir lame --vbr-new -V 2 --replaygain-accurate {} \;"

cda_cmp () {
	echo -n "FLAC: "
	find . -name '*.flac' -print | wc -l
	echo -n "M4A: "
	find . -name '*.m4a' -print | wc -l
	echo -n "MP3: "
	find . -name '*.mp3' -print | wc -l
	echo -n "Ogg: "
	find . -name '*.ogg' -print | wc -l
	echo -n "WAV: "
	find . -name '*.wav' -print | wc -l
}
alias cda_clean="find \( -name '*.wav' -or -name '*.inf' \) -delete"
#alias cda_gain="find ~/Music -type d -exec aacgain -q -a '{}/*.m4a' \;" #\&\& vorbisgain -f -s -a \"{}/*.ogg\" \;"

alias bcsi_sync='rsync --exclude "\$RECYCLE.BIN/" --exclude "RRbackups/" --exclude "System Volume Information/" --fake-super -avHAX --delete-after /cygdrive/M/* bluecoat:'
alias bcsi_preview='bcsi_sync -n'
alias penis_sync='rsync --exclude "\$RECYCLE.BIN/" --exclude "RRbackups/" --exclude "System Volume Information/" --fake-super -avHAX --delete-after /cygdrive/M/* media_penis:/media/pirated/Music/Gaelan'
alias penis_preview='penis_sync -n'

# Workflow aliases and functions
p42fs () { # Convert my p4client scheme to my filesystem scheme
	if [[ -z $P4CLIENT ]]; then
		return 1
	fi
	echo ~/proj/$(echo $P4CLIENT | cut -d_ -f2-)
}

cdproj () {
	if [[ ! -z $1 ]]; then
		p4client $1
	fi

  TO_DIR=$(p42fs)
	if [[ -d $TO_DIR ]]; then
		cd $TO_DIR 
	else
		echo "$0: Assumed directory non-existant, check \$P4CLIENT"
		return 1
	fi
}

cgrep () {
	find . -depth \( -iname '*.[ch]' -or -iname '*.[ch]pp' \) -type f -print0 | xargs -0 grep --color=auto --line-number $1
}
hgrep () {
	find . -depth \( -iname '*.h' -or -iname '*.hpp' \) -type f -print0 | xargs -0 grep --color=auto --line-number $1
}
jgrep () {
	find . -iname '*.java' -type f -print0 | xargs -0 grep --color=auto --line-number $1
}

p4client () {
	if [[ -z $1 ]]; then
		echo $P4CLIENT
	else
		export P4CLIENT=gaelan_$1
	fi
}

alias sustain_rdp="rdesktop -u gaelan.dcosta -g 1024x768 -d CF-CAL -p - sustain-1.internal.cacheflow.com"
function 2xx () { pushd $(p42fs) && cp wdir/210.chk_dbg /srv/http/210.img; popd }
function 2xxr () { pushd $(p42fs) && cp wdir/210.rls_dbg /srv/http/210.img; popd }
function 32scorp () { pushd $(p42fs) && cp bin/x86/sgos_native/debug/gcc_v4.4.2/sysimg/prototype/system_gdb.si /srv/http/210.img; popd }
function 64scorp () { pushd $(p42fs) && cp bin/x86_64/sgos_native/debug/gcc_v4.4.2/sysimg/prototype/system_gdb.si /srv/http/210.img; popd }
alias cscfiles="find . -depth \( -iname '*.[ch]' -or -iname '*.[ch]pp' \) -type f -print > cscope.files"
alias cscgen="cscope -b -q -k -i cscope.files -f cscope"
alias vizshrc="vim ~/.zshrc"
alias rezshrc="source ~/.zshrc"
alias vizprofile="vim ~/.zprofile"
alias rezprofile="source ~/.zprofile"
