[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.brew/bin:$PATH"
export VAGRANT_HOME="/Volumes/Storage/goinfre/vbastion/vagrant"
export CURRENT_PROJECT="$HOME/42/OhMyBash"
export PATH="/usr/bin:$PATH"
export PATH="$(tr ':' '\n' <<< $PATH | awk '!a[$0]++' | tr '\n' ':' | sed 's/:$//')"

PS1='[\033[4;49;34m\w\033[0m]
~> '

if test `which exa`; then
	alias l='exa -T -L 1'
	alias ll='exa -T -L 1 -l'
	alias lr='exa -T'
	alias l1="ls -1G"
	alias lt="ls -ltG"
	alias lt1="ls -1tG"
	alias tree='exa -T'
fi

alias psv='ps -o tty,pid,pgid,ppid,state,comm'
alias ga="git add"
alias gd="git diff"
alias gst="git status"
alias gc="git commit"
alias gr="git remote"
alias gco="git checkout"
alias gre="git reset"
alias gp="git push"
alias gl="git pull"
alias gb="git branch"

CODE_PATH=/Applications/Visual\ Studio\ Code.app
test -d "$CODE_PATH" && alias code='open -a "$CODE_PATH"'

if test `which valgrind`; then
	alias vald='valgrind --leak-check=full'
fi

alias rgrep="grep -rHn"

function rgr() {
	if [[ "$1" == "" ]]; then
		echo 'rgr <regex>'
	else
		eval 'grep -rHn "$1" **/*.c'
	fi
}

if test `which tmux`; then
	function tmc() {
		if [[ "$CURRENT_PROJECT" == "" ]]; then
			echo 'No CURRENT_PROJECT set'
		else
			BASENAME=`basename $CURRENT_PROJECT`
			VAL=`tmux list-sessions 2>/dev/stdout | grep $BASENAME`
			if [[ "$VAL" == "" ]]; then
				tmux new -s "$BASENAME" -c "$CURRENT_PROJECT"
			fi
		fi
	}
	
	function tmn() {
		if [[ "$1" == "" ]] || [[ "$2" == "" ]]
		then
			echo 'tmn <name> <root>'
		else
			tmux new -s $1 -c $2
		fi
	}
	
	function tma() {
		if [[ "$1" == "" ]]; then
			echo 'tma <root>'
		else
			tmux attach-session -c "$1"
		fi
	}
	
	function tmr() {
		if [[ "$CURRENT_PROJECT" == "" ]]; then
			echo 'No CURRENT_PROJECT set'
		else
			BASENAME=`basename $CURRENT_PROJECT`
			VAL=`tmux list-sessions 2>/dev/stdout | grep $BASENAME`
			if [[ "$VAL" == "" ]]; then
				echo 'No CURRENT_PROJECT opened in tmux.'
			else
				tmux attach-session -c "$BASENAME"
			fi
		fi
	}

	alias tml="tmux list-session"
fi

function prepend() {
	if [[ "$1" == "" ]]; then
		echo 'Usage: prepend <filename> <text>'
	else
		exec 3<> "$1" && awk -v TEXT="$2" 'BEGIN {print TEXT}{print}' "$1" >&3
	fi
}

function get_remote() {
	git remote -v | head -1 | awk '{print $2}'
}


shopt -s extglob
shopt -s globstar
shopt -s autocd

if test `which most`; then
	export MANPAGER=most
fi
