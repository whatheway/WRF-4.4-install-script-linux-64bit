#!/bin/bash


#Basic Package Management for Model Evaluation Tools (METplus)

sudo apt-get update
sudo apt-get upgrade



#Directory Listings for Model Evaluation Tools (METplus
mkdir $HOME/WRF
mkdir $HOME/WRF/METplus-4.1.1
mkdir $HOME/WRF/METplus-4.1.1/Sample_Data
mkdir $HOME/WRF/METplus-4.1.1/Output
mkdir $HOME/WRF/METplus-4.1.1/Downloads



#Downloading METplus and untarring files

cd $HOME/WRF/METplus-4.1.1/Downloads
wget https://github.com/dtcenter/METplus/archive/refs/tags/v4.1.1.tar.gz
tar -xvzf v4.1.1.tar.gz -C $HOME/WRF



# Insatlllation of Model Evaluation Tools Plus
cd $HOME/WRF/METplus-4.1.1/parm/metplus_config

sed -i "s|MET_INSTALL_DIR = /path/to|MET_INSTALL_DIR = $HOME/WRF/MET-10.1.1|" defaults.conf
sed -i "s|INPUT_BASE = /path/to|INPUT_BASE = $HOME/WRF/METplus-4.1.1/Sample_Data|" defaults.conf
sed -i "s|OUTPUT_BASE = /path/to|OUTPUT_BASE = $HOME/WRF/METplus-4.1.1/Output|" defaults.conf


# Downloading Sample Data

cd $HOME/WRF/METplus-4.1.1/Downloads
wget https://dtcenter.ucar.edu/dfiles/code/METplus/METplus_Data/v4.1/sample_data-met_tool_wrapper-4.1.tgz
tar -xvzf sample_data-met_tool_wrapper-4.1.tgz -C $HOME/WRF/METplus-4.1.1/Sample_Data


# Testing if installation of MET & METPlus was sucessfull
# If you see in terminal "METplus has successfully finished running." 
# Then MET & METPLUS is sucessfully installed

echo 'Testing MET & METPLUS Installation.'
$HOME/WRF/METplus-4.1.1/ush/run_metplus.py -c $HOME/WRF/METplus-4.1.1/parm/use_cases/met_tool_wrapper/GridStat/GridStat.conf 

export PATH=$HOME/WRF/METplus-4.1.1/ush:$PATH


