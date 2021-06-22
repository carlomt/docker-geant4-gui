source /opt/rh/devtoolset-9/enable

alias cd..='cd ..'
alias ls='ls -GF'
alias ll='ls -ltrh'

alias cmake='cmake3'
alias python='python3'
alias pip='pip3'

## DICOM Toolkit (DCMTK)
#https://dicom.offis.de/dcmtk.php.en
export DCMTK_BASE_DIR=/opt/dcmtk
export PATH=$DCMTK_BASE_DIR/bin:$PATH
export LD_LIBRARY_PATH=$DCMTK_BASE_DIR/lib64:$LD_LIBRARY_PATH

## Geant4
source /opt/geant4/bin/geant4.sh
/opt/geant4/bin/geant4-config --check-datasets

## gMocren
export PATH=/opt/gmocren/bin:$PATH