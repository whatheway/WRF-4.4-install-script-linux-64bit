# WRF-4.4-install-script
This is a script that installs all the libararies, software, programs, and geostatic data to run the Weather Research Forecast Model (WRF-4.4) with the option to run 3DVAR & 4DVAR observational data. 
Script assumes a clean directory with no other WRF configure files in the directory.
**This script does not install NETCDF4 to write compressed NetCDF4 files in parallel**

# Installation 
(Make sure to download folder into your Home Directory): $HOME


> git clone https://github.com/whatheway/WRF-4.4-install-script-linux-64bit.git

> cd $HOME/WRF-4.4-install-script-linux-64bit

> chmod 775 WRF_ARW_INSTALL_64bit.sh
> 
> chmod 775 MET_self_install_script_Linux_64bit.sh
> 
> chmod 775 METplus_self_install_script_Linux_32bit.sh
>
> chmod 775 Miniconda3_Install.sh
>
> ./WRF_ARW_INSTALL_64bit.sh

# Please make sure to read the WRF_ARW_INSTALL.sh script before installing.  
I have provided comments on what the script is doing and information on configuration files.


# WRF installation with parallel process (dmpar).
Must be installed with GNU compiler, it will not work with other compilers.

-  ### *** Tested on Ubuntu 20.04.4 LTS. ***
- Built in 64-bit system.
- Tested with current available libraries on 05/10/2022, execptions have been noted in the script documentation. 
- If newer libraries exist edit script paths for changes in future.

# Post-Processing Software Included
## UPP v4.1
User Guide: https://dtcenter.org/sites/default/files/community-code/upp-users-guide-v4.1.pdf
## ARWpost v3.1
Added to $PATH and ~/.bashrc for easy access
## Model Evaluation Tools (MET) & Model Ecaluation Tools Plus (MET Plus)
Added to $PATH and ~./bashrc for easy access
Users Guide (MET): https://met.readthedocs.io/en/main_v10.1/Users_Guide/index.html
Users Guide (MET Plus): https://metplus.readthedocs.io/en/v4.1.1/Users_Guide/index.html
## OpenGRADS v.2.2.1
Added to $PATH and ~/.bashrc for easy access
Users Guide: http://www.opengrads.org/manual/
## NCAR COMMAND LANGUAGE (NCL) v.6.6.2
 Installed via CONDA package using miniconda3
 Conda environment ncl_stable
 Users Guide: https://www.ncl.ucar.edu/Document/Manuals/NCL_User_Guide/
## WRF Python
 Installed via CONDA package using miniconda3
 Conda environment wrf-python
Users Guide: https://wrf-python.readthedocs.io/en/latest/index.html
## WRF Hydro GIS Preprocessor
 Installed via CONDA package using miniconda3
 Conda environment wrfh_gis_env
Users Guide: https://github.com/NCAR/wrf_hydro_gis_preprocessor & https://ral.ucar.edu/projects/wrf_hydro/pre-processing-tools


# Estimated Run Time ~ 90 - 150 Minutes @ 10mbps download speed.
### - Special thanks to  Youtube's meteoadriatic, GitHub user jamal919, University of Manchester's  Doug L, University of Tunis El Manar's Hosni S.

