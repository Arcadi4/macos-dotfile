# Homebrew setups
eval $(/opt/homebrew/bin/brew shellenv)

# Zoxide setup
eval "$(zoxide init zsh)"

# thefuck setup
eval $(thefuck --alias)

# brew command auto complete, must be done before 'source $ZSH/oh-my-zsh.sh'
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

# omz setup
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

export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --preview='
if [[ -f '{}' ]]; then
    bat --color always --decorations always --wrap auto {}
elif [[ -d '{}' ]]; then
    ls -lAhG
else
    ''
fi
'"

# Command replacements
alias python='python3'
alias pip='pip3'
alias top='htop'
alias cat='bat'
alias df='duf'
alias du='dust'
alias vim='nvim'

# Quick commands
alias hmcl='java -jar ~/Minecraft/HMCL.jar'
alias clear='echo; clear; fastfetch'
alias bingwp='~/Files/Developer/bingwp/dist/bingwp'

# Default flags
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias dust='dust -r'

if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
    alias fastfetch='fastfetch --logo default'
fi

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

    if [ -z $2 ]; then
        2=1
    fi

    while true; do
        eval $1
        sleep $2
    done
}

clear