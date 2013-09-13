# super awesome cdr! - http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recent-Directories
# list files as well as dirs when cd tab completing                                                            
autoload -U is-at-least

if is-at-least 4.4.0; then
  autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
  add-zsh-hook chpwd chpwd_recent_dirs
fi
