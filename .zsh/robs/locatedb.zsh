# FIXME: this seems to be ignored..
LOCATE_PATH="$HOME/tmp/locatedb"

alias glocate="glocate --database=${LOCATE_PATH}"
alias locate=glocate
alias gupdatedb="gupdatedb --localpaths=${HOME} --output=${LOCATE_PATH}"
alias updatedb=gupdatedb
