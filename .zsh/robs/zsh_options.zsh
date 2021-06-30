# history settings
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
unsetopt correct_all
setopt share_history
setopt inc_append_history
setopt extended_history
setopt hist_no_store
setopt hist_save_no_dups

HISTFILE=$HOME/.zsh_history
HISTSIZE=9999999
SAVEHIST=9999999

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# test out this ignore cd command yo
setopt AUTOCD
# auto expand ~ vars
setopt CDABLE_VARS
# dont auto remove slash
unsetopt AUTO_REMOVE_SLASH
# Append a trailing `/' to all directory names resulting from filename
# generation (globbing).
setopt MARK_DIRS
# dont ask me about rm stuff
setopt RM_STAR_SILENT

# When  the  current  word has a glob pattern, do not insert all the words
# resulting from the expansion but generate matches as for completion and cycle
# through them like MENU_COMPLETE. The matches are generated as if a `*' was
# added to the end of the word, or inserted at the cursor when  COMPLETE_IN_WORD
# is  set.   This actually uses pattern matching, not globbing, so it works not
# only for files but for any completion, such as options, user names, etc.
setopt GLOB_COMPLETE

# enable advanced globbing
setopt extended_glob

# list files as well as dirs when cd tab completing
autoload -U is-at-least
if is-at-least 5.0.0; then
  compdef _path_files cd
fi

# don't retokenize variables on expansion WARNING: could this mess things up? is
# this the default for posix sh?
setopt sh_word_split

autoload -U url-quote-magic
zle -N self-insert url-quote-magic

export KEYTIMEOUT=1
