export ZSH=$HOME/.zsh

### ---- history config -------------------------------------
export HISTFILE=$ZSH/.zsh_history

# How many commands zsh will load to memory.
export HISTSIZE=10000

# How many commands history will save on file.
export SAVEHIST=10000

# History won't save duplicates.
setopt HIST_IGNORE_ALL_DUPS

# History won't show duplicates on search.
setopt HIST_FIND_NO_DUPS

# History Search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Autoload completion
autoload -U compinit; compinit

# prompt theme
source $ZSH/themes/mytheme.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export JAVA_HOME=/opt/homebrew/Cellar/openjdk@11/11.0.16.1/libexec/openjdk.jdk/Contents/Home
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/Users/Library/Python/3.9/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

alias t="tmux"

# Check if we are inside TMUX session
if [ -z "$TMUX" ]; then
  # List tmux sessions, returns true if there are any
  tmux has-session 2>/dev/null

  if [ $? != 0 ]; then
    # No sessions found, start a new session
    tmux new-session
  else
    # Attach to the existing session
    tmux attach-session
  fi
fi
