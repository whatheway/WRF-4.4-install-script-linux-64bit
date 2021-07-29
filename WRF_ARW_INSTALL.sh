#!/bin/bash

## WRF installation with parallel process.
# Download and install required library and data files for WRF.
# Tested in Ubuntu 20.04 LTS
# Built in 64-bit system
# Tested with current available libraries on 05/25/2021
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 80 - 120 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919

#############################basic package managment############################
sudo apt update                                                                                                   
sudo apt upgrade                                                                                                    
sudo apt install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git ncview ncl-ncarg   

##############################Directory Listing############################
export HOME=`cd;pwd`
mkdir $HOME/WRF
cd $HOME/WRF
mkdir Downloads
mkdir WRFPLUS
mkdir WRFDA
mkdir Libs
mkdir Libs/grib2
mkdir Libs/NETCDF
mkdir Libs/MPICH

##############################Downloading Libraries############################
cd Downloads
wget -c https://www.zlib.net/zlib-1.2.11.tar.gz
wget -c https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.12/hdf5-1.12.0/src/hdf5-1.12.0.tar.gz
wget -c https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-c-4.7.4.tar.gz
wget -c https://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-fortran-4.5.3.tar.gz
wget -c http://www.mpich.org/static/downloads/3.4.1/mpich-3.4.1.tar.gz
wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
wget -c https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz




#############################Compilers############################
export DIR=$HOME/WRF/Libs
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran


#############################zlib############################
cd $HOME/WRF/Downloads
tar -xvzf zlib-1.2.11.tar.gz
cd zlib-1.2.11/
./configure --prefix=$DIR/grib2
make
make install


#############################libpng############################
cd $HOME/WRF/Downloads
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR/grib2
make
make install

#############################JasPer############################
cd $HOME/WRF/Downloads
unzip jasper-1.900.1.zip
cd jasper-1.900.1/
autoreconf -i
./configure --prefix=$DIR/grib2
make
make install
export JASPERLIB=$DIR/grib2/lib
export JASPERINC=$DIR/grib2/include


#############################hdf5 library for netcdf4 functionality############################
cd $HOME/WRF/Downloads
tar -xvzf hdf5-1.12.0.tar.gz
cd hdf5-1.12.0
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install

export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

##############################Install NETCDF C Library############################
cd $HOME/WRF/Downloads
tar -xzvf netcdf-c-4.7.4.tar.gz
cd netcdf-c-4.7.4/
export CPPFLAGS=-I$DIR/grib2/include 
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap
make 
make install

export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF

##############################NetCDF fortran library############################
cd $HOME/WRF/Downloads
tar -xvzf netcdf-fortran-4.5.3.tar.gz
cd netcdf-fortran-4.5.3/
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include 
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make 
make install

##############################MPICH############################
cd $HOME/WRF/Downloads
tar -xvzf mpich-3.4.1.tar.gz
cd mpich-3.4.1/
./configure --prefix=$DIR/MPICH --with-device=ch3
make
make install

export PATH=$DIR/MPICH/bin:$PATH



###############################NCEPlibs#####################################
#The libraries are built and installed with
# ./make_ncep_libs.sh -s MACHINE -c COMPILER -d NCEPLIBS_DIR -o OPENMP [-m mpi] [-a APPLICATION]
#It is recommended to install the NCEPlibs into their own directory, which must be created before running the installer. Further information on the command line arguments can be obtained with
# ./make_ncep_libs.sh -h

#If iand error occurs go to https://github.com/NCAR/NCEPlibs/pull/16/files make adjustment and re-run ./make_ncep_libs.sh
############################################################################


cd $HOME/WRF/Downloads
git clone https://github.com/NCAR/NCEPlibs.git
cd NCEPlibs
mkdir $DIR/nceplibs

export JASPER_INC=$DIR/grib2/include
export PNG_INC=$DIR/grib2/include
export NETCDF=$DIR/NETCDF
./make_ncep_libs.sh -s linux -c gnu -d $DIR/nceplibs -o 0 -m 1 -a upp



################################UPPv4.1######################################
#Previous verison of UPP
#Current verison of UPP requires extra libraries not included in this script
#IF you choose to use UPP9.0 or later you will need to edit this script and download additional programs
#Option 8 gfortran compiler with distributed memory
#############################################################################
cd $HOME/WRF
git clone -b dtc_post_v4.1.0 --recurse-submodules https://github.com/NOAA-EMC/EMC_post UPPV4.1 
cd UPPV4.1
mkdir postprd
export NCEPLIBS_DIR=$DIR/nceplibs
export NETCDF=$DIR/NETCDF

./configure  #Option 8 gfortran compiler with distributed memory
./compile
cd $HOME/WRF/UPPV4.1/scripts
chmod +x run_unipost


######################## ARWpost V3.1  ############################
## ARWpost
##Configure #3
###################################################################
cd $HOME/WRF/Downloads
wget -c http://www2.mmm.ucar.edu/wrf/src/ARWpost_V3.tar.gz
tar -xvzf ARWpost_V3.tar.gz -C $HOME/WRF
cd $HOME/WRF/ARWpost
./clean
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
export NETCDF=$DIR/NETCDF
./configure  
sed -i -e 's/-C -P/-P/g' $HOME/WRF/ARWpost/configure.arwp
./compile


################################OpenGrADS######################################
#Verison 2.2.1 64bit of Linux
#############################################################################
cd $HOME/WRF/Downloads
tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $HOME/WRF
cd $HOME/WRF
mv $HOME/WRF/opengrads-2.2.1.oga.1  $HOME/WRF/GrADS
cd GrADS/Contents
wget -c ftp://ftp.cpc.ncep.noaa.gov/wd51we/g2ctl/g2ctl
chmod +x g2ctl
wget -c https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
cd wgrib2-v0.1.9.4/bin
mv wgrib2 $HOME/WRF/GrADS/Contents
cd $HOME/WRF/GrADS/Contents
rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
rm -r wgrib2-v0.1.9.4


export PATH=$HOME/WRF/GrADS/Contents:$PATH

############################ WRF 4.3 #################################
## WRF v4.3
## Downloaded from git tagged releases
# option 34, option 1 for gfortran and distributed memory w/basic nesting
# large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
########################################################################
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
cd $HOME/WRF/Downloads
wget -c https://github.com/wrf-model/WRF/archive/v4.3.tar.gz -O WRF-4.3.tar.gz
tar -xvzf WRF-4.3.tar.gz -C $HOME/WRF
cd $HOME/WRF/WRF-4.3
./clean
./configure # option 34, option 1 for gfortran and distributed memory w/basic nesting
./compile em_real

export WRF_DIR=$HOME/WRF/WRF-4.3


############################WPSV4.3#####################################
## WPS v4.3
## Downloaded from git tagged releases
#Option 3 for gfortran and distributed memory 
########################################################################

cd $HOME/WRF/Downloads
wget -c https://github.com/wrf-model/WPS/archive/v4.3.tar.gz -O WPS-4.3.tar.gz
tar -xvzf WPS-4.3.tar.gz -C $HOME/WRF
cd $HOME/WRF/WPS-4.3
./configure #Option 3 for gfortran and distributed memory 
./compile



############################WRFPLUS 4DVAR###############################
## WRFPLUS v4.3 4DVAR
## Downloaded from git tagged releases
## WRFPLUS is built within the WRF git folder
## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice. 
#Option 18 for gfortran/gcc and distribunted memory 
########################################################################
cd $HOME/WRF/Downloads
tar -xvzf WRF-4.3.tar.gz -C $HOME/WRF/WRFPLUS
cd $HOME/WRF/WRFPLUS/WRF-4.3
mv * $HOME/WRF/WRFPLUS
cd $HOME/WRF/WRFPLUS
rm -r WRF-4.3/
export NETCDF=$DIR/NETCDF
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
./configure wrfplus  #Option 18 for gfortran/gcc and distribunted memory 
./compile wrfplus   
export WRFPLUS_DIR=$HOME/WRF/WRFPLUS




############################WRFDA 4DVAR###############################
## WRFDA v4.3 4DVAR
## Downloaded from git tagged releases
## WRFDA is built within the WRFPLUS folder
## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice. 
#Option 18 for gfortran/gcc and distribunted memory 
########################################################################
cd $HOME/WRF/Downloads
tar -xvzf WRF-4.3.tar.gz -C $HOME/WRF/WRFDA
cd $HOME/WRF/WRFDA/WRF-4.3
mv * $HOME/WRF/WRFDA
cd $HOME/WRF/WRFDA
rm -r WRF-4.3/
export NETCDF=$DIR/NETCDF
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
export WRFPLUS_DIR=$HOME/WRF/WRFPLUS
./configure 4dvar #Option 18 for gfortran/gcc and distribunted memory 
./compile all_wrfvar




######################## WPS Domain Setup Tools ########################
## DomainWizard
cd $HOME/WRF/Downloads
wget -c http://esrl.noaa.gov/gsd/wrfportal/domainwizard/WRFDomainWizard.zip
mkdir $HOME/WRF/WRFDomainWizard
unzip WRFDomainWizard.zip -d $HOME/WRF/WRFDomainWizard
chmod +x $HOME/WRF/WRFDomainWizard/run_DomainWizard


######################## WPF Portal Setup Tools ########################
## WRFPortal
cd $HOME/WRF/Downloads
wget -c https://esrl.noaa.gov/gsd/wrfportal/portal/wrf-portal.zip
mkdir $HOME/WRF/WRFPortal
unzip wrf-portal.zip -d $HOME/WRF/WRFPortal
chmod +x $HOME/WRF/WRFPortal/runWRFPortal

######################## DTC's MET & METplus ###########################
## See script for details

cd
$HOME/MET_self_install_script_Linux_64bit.sh




######################## Static Geography Data inc/ Optional ####################
# http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# Double check if Irrigation.tar.gz extracted into WPS_GEOG folder
# IF it didn't right click on the .tar.gz file and select 'extract here'
#################################################################################
cd $HOME/WRF/Downloads
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
mkdir $HOME/WRF/GEOG
tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/WRF/GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
tar -xvzf geog_thompson28_chem.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
tar -xvzf geog_noahmp.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
tar -xvzf irrigation.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
tar -xvzf geog_px.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
tar -xvzf geog_urban.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
tar -xvzf geog_ssib.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
tar -xvf lake_depth.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG
                                                 


## export PATH and LD_LIBRARY_PATH
echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc




#####################################BASH Script Finished##############################
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model verison 4.3."
echo "Thank you for using this script" 
