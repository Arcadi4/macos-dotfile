# Homebrew setup
eval $(/opt/homebrew/bin/brew shellenv)

# omz plugins
plugins=(rust golang git zsh-syntax-highlighting iterm2 fzf zoxide zsh-interactive-cd zsh-navigation-tools brew github gitignore git-auto-fetch git-commit npm nmap node deno yarn tig mongocli pip pipenv nodenv emoji copyfile copypath ubuntu safe-paste thefuck themes macos tmux ssh ssh-agent colorize colored-man-pages sudo)

# omz setup
source $ZSH/oh-my-zsh.sh
clear

# fastfetch
alias fastfetch='fastfetch --processing-timeout 50 --weather-timeout 500'
if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
    alias fastfetch='fastfetch --logo default'
fi
fastfetch 

# Zoxide setup
eval "$(zoxide init zsh)"

# thefuck setup
eval $(thefuck --alias)

# brew command auto complete, must be done before 'source $ZSH/oh-my-zsh.sh'
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

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
alias zshrc='code ~/.zshrc'

# Default flags
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias dust='dust -r'

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

function historyx() {
    history | fzf | xargs | cut -d ' ' -f 2- | pbcopy 
    pbpaste
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

# for lucy development
alias lucy='~/Files/Developer/lucy/dist/lucy-darwin-arm64-dev'
PROG=lucy
source /Users/skylar/Files/Developer/lucy/autocomplete/zsh_autocomplete.txt
