#!/bin/bash
#Default miniconda install location
#export Miniconda_Install_DIR=~/miniconda3


export Miniconda_Install_DIR=$HOME/WRF/miniconda3

mkdir -p $Miniconda_Install_DIR

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $Miniconda_Install_DIR/miniconda.sh
bash $Miniconda_Install_DIR/miniconda.sh -b -u -p $Miniconda_Install_DIR

rm -rf $Miniconda_Install_DIR/miniconda.sh

export PATH=/$HOME/WRF/miniconda3/bin:$PATH

source $Miniconda_Install_DIR/etc/profile.d/conda.sh

$Miniconda_Install_DIR/bin/conda init bash
$Miniconda_Install_DIR/bin/conda init zsh 
$Miniconda_Install_DIR/bin/conda init tcsh
$Miniconda_Install_DIR/bin/conda init xonsh
$Miniconda_Install_DIR/bin/conda init powershell

conda config --add channels conda-forge
conda config --set auto_activate_base false
conda update -n root --all -y 


export $PATH
#Special Thanks to @_WaylonWalker for code development 



