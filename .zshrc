# omz plugin
source $ZSH/oh-my-zsh.sh

# shell prompt: alien
source ~/alien/alien.zsh

export ALIEN_SECTIONS_LEFT=(
    exit
    time
    path
    vcs_branch:async
    vcs_status:async
    vcs_dirty:async
    newline
    ssh
    venvs
    prompt
)

export ALIEN_SECTION_TIME_FORMAT=%H:%M:%S
export ALIEN_THEME="gruvbox"
export ALIEN_GIT_MOD_SYM=*

# applications and quick commands
alias hmcl='java -jar ~/Minecraft/HMCL.jar'
alias clear='echo; clear; fastfetch'
alias bingwp='~/Files/Dev/bingwp/dist/bingwp'

# default arguments
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias dust='dust -r'

if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
    alias fastfetch='fastfetch --logo default'
fi

export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --preview='
if [[ -f '{}' ]]; then
    bat --color always --decorations always --wrap auto {}
elif [[ -d '{}' ]]; then
    ls -lAhG
else
    ''
fi
'"

# command replacements
alias python='python3'
alias pip='pip3'
alias top='htop'
alias cat='bat'
alias df='duf'
alias du='dust'
alias vim='nvim'

# thefuck setup
eval $(thefuck --alias)

# functions
function cleanbrew() {
    brew cleanup --prune=all
    brew autoremove
}

function fzfx() {
    if [[ -f $1 ]]; then
        eval "cat $1" | fzf
    elif [[ -d $1 ]]; then
        eval "la $1" | fzf
    else
        eval "$1" | fzf
    fi
}

function loop() {
    if [ -z $1 ]; then
        return 1
    fi

    if [ -z $1 ]; then
        1="1s"
    fi

    while true; do
        eval $1
        sleep $2
    done
}

# console ninja
PATH=~/.console-ninja/.bin:$PATH

# pnpm
export PNPM_HOME="/Users/skylar/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun completions
[ -s "/Users/skylar/.bun/_bun" ] && source "/Users/skylar/.bun/_bun"

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# user installations
export PATH=~/bin:$PATH

# tinytex
export PATH=$PATH:/Users/skylar/Library/TinyTeX/bin/universal-darwin

clear