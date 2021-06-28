export HISTCONTROL=ignoredups
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

alias cd..='cd ..'
alias ls='ls -GF'
alias ll='ls -ltrh'

# Only load Liquidprompt in interactive shells, not from a script or from scp
[[ $- = *i* ]] && source /opt/liquidprompt/liquidprompt

# Geant4
source  /opt/geant4/bin/geant4.sh
echo ""
echo "## checking Geant4 datasets ###############################################"
/opt/geant4/bin/geant4-config --check-datasets
echo "###########################################################################"
echo "if the Geant4 datasets are not found install them with:"
echo "geant4-config --install-datasets"
echo "###########################################################################"

echo "## gcc version ############################################################"
gcc --version
echo "###########################################################################"

cd
