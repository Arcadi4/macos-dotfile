# Homebrew sources (disabled)
# export HOMEBREW_NO_INSTALL_FROM_API=1
# export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
# export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
# export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
# export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
# export HOMEBREW_PIP_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple"

# user binaries
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac

# python packages
export PATH="$HOME/Library/Python/3.13/bin:$PATH"
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# go binaries
export PATH="$HOME/go/bin:$PATH"

# cargo binaries
export PATH="$HOME/.cargo/bin:$PATH"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# tinytex
export TEXINPUTS=$TEXINPUTS:$HOME/Library/TinyTeX/bin/universal-darwin:$HOME/Library/TinyTeX/texmf-dist/tex/latex
export PATH="$HOME/Library/TinyTeX/bin/universal-darwin:$PATH"

# zsh history
export HISTSIZE=999999999
export SAVEHIST=999999999
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
