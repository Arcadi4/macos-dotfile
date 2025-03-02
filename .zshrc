# Homebrew setup
eval $(/opt/homebrew/bin/brew shellenv)

# fastfetch
alias fastfetch='fastfetch --processing-timeout 50 --weather-timeout 500'
if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
    alias fastfetch='fastfetch --logo default'
fi
clear
fastfetch

# omz plugins
plugins=(
    git
    zsh-syntax-highlighting
    iterm2 fzf zoxide zsh-interactive-cd zsh-navigation-tools brew github gitignore git-auto-fetch git-commit npm nmap node deno yarn tig mongocli pip pipenv nodenv emoji copyfile copypath ubuntu safe-paste thefuck themes 
    macos tmux ssh ssh-agent colorize colored-man-pages sudo)

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

# Command replacements
alias python='python3'
alias pip='pip3'
alias top='htop'
alias cat='bat'
alias df='duf'
alias du='dust'
alias vim='nvim'
alias zsh='exec zsh'

# Quick commands
alias hmcl='java -jar ~/Minecraft/HMCL.jar'
alias bingwp='~/Files/Developer/bingwp/dist/bingwp'

# Default flags
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias dust='dust -r'
alias ollama='ollama run --verbose --nowordwrap'

export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --preview='
    if [[ -f '{}' ]]; then
        bat --color always --decorations always --wrap auto {}
    elif [[ -d '{}' ]]; then
        ls -lAhG {}
    else
        echo {}
    fi
'"

export FZF_DEFAULT_COMMAND="rg --files --hidden --no-ignore"

# functions
function cleanbrew() {
    brew cleanup --prune=all
    brew autoremove
}

function fzfx() {
    if [[ -f $1 ]]; then
        eval "cat $1" | fzf
    elif [[ -d $1 ]]; then
        pushd $1
        eval "ls ." | fzf
        popd
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

# For Lucy Development
alias lucy='~/Files/Developer/lucy/dist/lucy-darwin-arm64-dev'
