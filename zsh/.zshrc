export ZSH="$HOME/.zsh"

ZSH_THEME="eastwood"

plugins=(git history-substring-search fzf fzf-tab)

source $ZSH/oh-my-zsh.sh

export FZF_CTRL_T_COMMAND="fd -u . ~/workspace ~/.dotfiles"
export FZF_ALT_C_COMMAND="fd -u . ~/workspace ~/.dotfiles"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#768390,bg:#22272e,hl:#cdd9e5 --color=fg+:#adbac7,bg+:#253040,hl+:#f69d50 --color=info:#c69026,prompt:#539bf5,pointer:#986ee2 --color=marker:#57ab5a,spinner:#636e7b,header:#3c434d'
# zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)
zstyle ':completion:*:descriptions' format '[%d]'

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''

autoload -U history-substring-search-up
autoload -U history-substring-search-down

set -o vi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

bindkey -s '^O' '~/scripts/sessionize\n'

alias zsource='source ~/.zshrc'
alias vi=nvim
