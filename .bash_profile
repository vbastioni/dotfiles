[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH="$HOME/.brew/bin:$PATH"
export GOPATH="$HOME/go"
export GOBIN="$(dirname $(which go))"
export PATH="$PATH:$GOBIN"
export PATH="$PATH:$GOPATH/bin"
export PATH="$PATH:`pwd`/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$(tr ':' '\n' <<< $PATH | awk '!a[$0]++' | tr '\n' ':' | sed 's/:$//')"

PS1="[\033[34m\w\033[0m - \A] \033[38m\$\033[0m
+> "

# LS
if test `which exa`; then
    alias l='exa -T -L 1'
    alias ll='exa -T -L 1 -l'
    alias lr='exa -T'
	alias la='exa -a'
else
    alias l='ls -G'
    alias ll='ls -lG'
    alias lr='ls -lRG'
	alias la='ls -Ga'
fi
alias l1="ls -1G"
alias lt="ls -ltG"
alias lt1="ls -1tG"

# GIT ALIASES
alias ga="git add"
alias gd="git diff"
alias gst="git status"
alias gc="git commit"
alias gr="git remote"
alias gco="git checkout"
alias gre="git reset"
alias gp="git push"
alias gpb='git push origin $(get_branch)'
alias gl="git pull"
alias gb="git branch"

alias psv='ps -o tty,pid,pgid,ppid,state,comm'
alias code='open -a /Applications/Visual\ Studio\ Code.app'
alias rsrc="source $HOME/.bash_profile"
alias st="open -a 'sublime text'"

if test `which bat`; then
    alias cat="bat"
fi


# Valgrind if present
if test `which valgrind`; then
	alias vald='valgrind --leak-check=full'
fi

alias rgrep="grep -rHn"

# TMUX
if test `which tmux`; then
    function tmc() { # create a new tmux session based on CURRENT_PROJECT, if set
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
    
    function tmn() { # create a new tmux session with a name and a root path
		if [[ "$1" == "" ]]; then
			name="$(basename $PWD)"
		else
			name="$1"
		fi
		if [[ "$2" == "" ]]; then
			path="$(realpath $PWD)"
		else
			path="$(realpath $2)"
		fi
		tmux new -s "$name" -c "$path"
    }
    
    function tma() { # attach a tmux session on given root path
    	if [[ "$1" == "" ]]; then
    		echo 'tma <root>'
    	else
    		tmux attach-session -c "$1"
    	fi
    }
    
    function tmr() { # restore current tmux project if the CURRENT_PROJECT env var is set
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

function get_remote() { # get current remote url
    git remote -v | awk 'NR==1 {print $2}'
}

function get_branch() { # get current branch name
	git status | awk 'NR==1 {print $3}'
}

function open_remote() { # open git remote url on current branch
	open "$(get_remote)/src/branch/$(get_branch)"
}

shopt -s extglob
shopt -s globstar
shopt -s autocd

if [[ -d '/Applications/IntelliJ IDEA.app' ]]; then
	alias ij='open -a /Applications/IntelliJ\ IDEA.app'
fi

if [[ -f "~/.libmed_rc" ]]; then
	source ~/.libmed_rc
fi

function exists() { # checks if path exists, and tells whether it is a directory or a regular file
	if [[ "$1" == "" ]]; then
		echo "exists <path>" >&2
	elif [[ -d "$1" ]]; then
		echo "$1 is a directory"
	elif [[ -f "$1" ]]; then
		echo "$1 is a file"
	else
		echo "$1 does not exist" >&2
	fi
}

function get_port() { # get all processes working with given port
	if [[ "$1" == "" ]]; then
		echo "get_port <IP>" >&2
	else
		lsof -i :"$1"
	fi
}

function get_funcs() { # get all user-defined functions and there definition
	set | grep -e '()' | grep -v '=' | sed -e 's/ ().//' | while read func_name
		do grep $func_name ~/.bash_profile | gawk 'match($0, /(\ *function\ *)?(.*)\ *\(\)\ *{ .*#\ *(.*)/, grps) {printf "%-20s -> %s\n", grps[2], grps[3]}'
	done
}

function fcurl() { # curls a git file giving it its git name (ex https://raw.githubusercontent.com/grpc/grpc-web/master/docker-compose.yml -> 'docker-compose.yaml'
	if [[ "$1" == "" ]]; then
		echo "fcurl <path>" >&2
	else
		curl "$1" > "$(basename $1)"
	fi
}

KUBE_RC_PATH="$HOME/.kube_rc"
if [[ -f "$KUBE_RC_PATH" ]]; then
	source "$KUBE_RC_PATH"
fi

# docker
if test `which docker`; then
	BASH_DOCKER_RC="$HOME/.bash_docker.rc"
	if [[ -f $BASH_DOCKER_RC ]]; then
		source $BASH_DOCKER_RC
	fi
fi
