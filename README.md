# WRF-4.2.2-install-script
This is a script that installs all the libararies, software, programs, and geostatic data to run the Weather Research Forecast Model (WRF-4.2.2) with the option to run 3DVAR & 4DVAR observational data. Script assumes a clean directory with no other WRF configure files in the directory.

# Installation 
(Make sure to download folder into your Home Directory):

git clone https://github.com/whatheway/WRF-4.2.2-install-script-linux-64bit.git

chmod +x WRF_ARW_INSTALL.sh

./WRF_ARW_INSTALL

# Please make sure to read the WRF_ARW_INSTALL.sh script before installing.  
I have provided comments on what the script is doing and information on configuration files.


# WRF installation with parallel process.
## Must be installed with GNU compiler, it will not work with other compilers.

Download and install required library and data files for WRF.

Tested in Ubuntu 20.04 LTS

Built in 64-bit system

Tested with current available libraries on 05/25/2021

If newer libraries exist edit script paths for changes

# Estimated Run Time ~ 80 - 120 Minutes
### Special thanks to  Youtube's meteoadriatic and GitHub user jamal919
