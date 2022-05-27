#!/bin/bash

## WRF installation with parallel process.
# Download and install required library and data files for WRF.
# Tested in Ubuntu 20.04.4 LTS
# Built in 64-bit system
# Tested with current available libraries on 05/08/2022
# If newer libraries exist edit script paths for changes
#Estimated Run Time ~ 90 - 150 Minutes with 10mb/s downloadspeed.
#Special thanks to  Youtube's meteoadriatic and GitHub user jamal919

#############################basic package managment############################
sudo apt update                                                                                                   
sudo apt upgrade                                                                                                    
sudo apt install gcc gfortran g++ libtool automake autoconf make m4 default-jre default-jdk csh ksh git python3.9 mlocate

##############################Directory Listing############################
export HOME=`cd;pwd`
export DIR=$HOME/WRF/Libs
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
wget -c https://github.com/madler/zlib/archive/refs/tags/v1.2.12.tar.gz
wget -c https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_12_2.tar.gz
wget -c https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.8.1.tar.gz
wget -c https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v4.5.4.tar.gz
wget -c https://github.com/pmodels/mpich/releases/download/v4.0.2/mpich-4.0.2.tar.gz
wget -c https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz
wget -c https://www.ece.uvic.ca/~frodo/jasper/software/jasper-1.900.1.zip
wget -c https://sourceforge.net/projects/opengrads/files/grads2/2.2.1.oga.1/Linux%20%2864%20Bits%29/opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz




#############################Compilers############################
export CC=gcc
export CXX=g++
export FC=gfortran
export F77=gfortran


#############################zlib############################
#Uncalling compilers due to comfigure issue with zlib1.2.12
#With CC & CXX definied ./configure uses different compiler Flags

cd $HOME/WRF/Downloads
tar -xvzf v1.2.12.tar.gz
cd zlib-1.2.12/
CC= CXX= ./configure --prefix=$DIR/grib2
make
make install
make check


#############################libpng############################
cd $HOME/WRF/Downloads
export LDFLAGS=-L$DIR/grib2/lib
export CPPFLAGS=-I$DIR/grib2/include
tar -xvzf libpng-1.6.37.tar.gz
cd libpng-1.6.37/
./configure --prefix=$DIR/grib2
make
make install
make check

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


##############################MPICH############################
cd $HOME/WRF/Downloads
tar -xvzf mpich-4.0.2.tar.gz
cd mpich-4.0.2/
./configure --prefix=$DIR/MPICH --with-device=ch3
make
make install
make check


export PATH=$DIR/MPICH/bin:$PATH



#############################hdf5 library for netcdf4 functionality############################
cd $HOME/WRF/Downloads
tar -xvzf hdf5-1_12_2.tar.gz
cd hdf5-hdf5-1_12_2
./configure --prefix=$DIR/grib2 --with-zlib=$DIR/grib2 --enable-hl --enable-fortran
make 
make install
make check

export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH

##############################Install NETCDF C Library############################
cd $HOME/WRF/Downloads
tar -xzvf v4.8.1.tar.gz
cd netcdf-c-4.8.1/
export CPPFLAGS=-I$DIR/grib2/include 
export LDFLAGS=-L$DIR/grib2/lib
./configure --prefix=$DIR/NETCDF --disable-dap
make 
make install
make check

export PATH=$DIR/NETCDF/bin:$PATH
export NETCDF=$DIR/NETCDF

##############################NetCDF fortran library############################
cd $HOME/WRF/Downloads
tar -xvzf v4.5.4.tar.gz
cd netcdf-fortran-4.5.4/
export LD_LIBRARY_PATH=$DIR/NETCDF/lib:$LD_LIBRARY_PATH
export CPPFLAGS=-I$DIR/NETCDF/include 
export LDFLAGS=-L$DIR/NETCDF/lib
./configure --prefix=$DIR/NETCDF --disable-shared
make 
make install
make check


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
#WRF Support page recommends UPPV4.1 due to too many changes to WRF and UPP code
#since the WRF was written
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
./clean -a
sed -i -e 's/-lnetcdf/-lnetcdff -lnetcdf/g' $HOME/WRF/ARWpost/src/Makefile
export NETCDF=$DIR/NETCDF
./configure  
sed -i -e 's/-C -P -traditional/-P -traditional/g' $HOME/WRF/ARWpost/configure.arwp
./compile


export PATH=$HOME/WRF/ARWpost/ARWpost.exe:$PATH

################################OpenGrADS######################################
#Verison 2.2.1 64bit of Linux
#############################################################################
cd $HOME/WRF/Downloads
tar -xzvf opengrads-2.2.1.oga.1-bundle-x86_64-pc-linux-gnu-glibc_2.17.tar.gz -C $HOME/WRF
cd $HOME/WRF
mv $HOME/WRF/opengrads-2.2.1.oga.1  $HOME/WRF/GrADS
cd GrADS/Contents
wget -c https://github.com/regisgrundig/SIMOP/blob/master/g2ctl.pl
chmod +x g2ctl.pl
wget -c https://sourceforge.net/projects/opengrads/files/wgrib2/0.1.9.4/wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
tar -xzvf wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
cd wgrib2-v0.1.9.4/bin
mv wgrib2 $HOME/WRF/GrADS/Contents
cd $HOME/WRF/GrADS/Contents
rm wgrib2-v0.1.9.4-bin-x86_64-glibc2.5-linux-gnu.tar.gz
rm -r wgrib2-v0.1.9.4


export PATH=$HOME/WRF/GrADS/Contents:$PATH


##################### NCAR COMMAND LANGUAGE           ##################
########### NCL compiled via Conda                    ##################
########### This is the preferred method by NCAR      ##################
########### https://www.ncl.ucar.edu/index.shtml      ##################

#Installing Miniconda3 to WRF directory and updating libraries
source $HOME/WRF-4.4-install-script-linux-64bit/Miniconda3_WRF_Install.sh




#Installing NCL via Conda
source $Miniconda_Install_DIR/etc/profile.d/conda.sh
conda init bash
conda activate base
conda create -n ncl_stable -c conda-forge ncl -y
conda activate ncl_stable
conda update -n ncl_stable --all -y
conda deactivate 
conda deactivate

##################### WRF Python           ##################
########### WRf-Python compiled via Conda  ##################
########### This is the preferred method by NCAR      ##################
##### https://wrf-python.readthedocs.io/en/latest/installation.html  ##################
source $Miniconda_Install_DIR/etc/profile.d/conda.sh
conda init bash
conda activate base
conda create -n wrf-python -c conda-forge wrf-python -y
conda activate wrf-python
conda update -n wrf-python --all -y
conda deactivate
conda deactivate





############################ WRF 4.4  #################################
## WRF v4.4
## Downloaded from git tagged releases
# option 34, option 1 for gfortran and distributed memory w/basic nesting
# large file support enable with WRFiO_NCD_LARGE_FILE_SUPPORT=1
########################################################################
cd $HOME/WRF/Downloads
wget -c https://github.com/wrf-model/WRF/releases/download/v4.4/v4.4.tar.gz -O WRF-4.4.tar.gz
tar -xvzf WRF-4.4.tar.gz -C $HOME/WRF
cd $HOME/WRF/WRFV4.4
export WRFIO_NCD_LARGE_FILE_SUPPORT=1
./clean -a
./configure # option 34, option 1 for gfortran and distributed memory w/basic nesting
./compile em_real

export WRF_DIR=$HOME/WRF/WRFV4.4


############################WPSV4.4#####################################
## WPS v4.4
## Downloaded from git tagged releases
#Option 3 for gfortran and distributed memory 
########################################################################

cd $HOME/WRF/Downloads
wget -c https://github.com/wrf-model/WPS/archive/refs/tags/v4.4.tar.gz -O WPS-4.4.tar.gz
tar -xvzf WPS-4.4.tar.gz -C $HOME/WRF
cd $HOME/WRF/WPS-4.4
./clean -a
./configure #Option 3 for gfortran and distributed memory 
./compile



############################WRFPLUS 4DVAR###############################
## WRFPLUS v4.4 4DVAR
## Downloaded from git tagged releases
## WRFPLUS is built within the WRF git folder
## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice. 
#Option 18 for gfortran/gcc and distribunted memory 
########################################################################
cd $HOME/WRF/Downloads
tar -xvzf WRF-4.4.tar.gz -C $HOME/WRF/WRFPLUS
cd $HOME/WRF/WRFPLUS/WRFV4.4
mv * $HOME/WRF/WRFPLUS
cd $HOME/WRF/WRFPLUS
rm -r WRFV4.4/
export NETCDF=$DIR/NETCDF
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
./clean -a
./configure wrfplus  #Option 18 for gfortran/gcc and distribunted memory 
./compile wrfplus   
export WRFPLUS_DIR=$HOME/WRF/WRFPLUS




############################WRFDA 4DVAR###############################
## WRFDA v4.4 4DVAR
## Downloaded from git tagged releases
## WRFDA is built within the WRFPLUS folder
## Does not include RTTOV Libarary for radiation data.  If wanted will need to install library then reconfigure
##Note: if you intend to run both 3DVAR and 4DVAR experiments, it is not necessary to compile the code twice. 
#Option 18 for gfortran/gcc and distribunted memory 
########################################################################
cd $HOME/WRF/Downloads
tar -xvzf WRF-4.4.tar.gz -C $HOME/WRF/WRFDA
cd $HOME/WRF/WRFDA/WRFV4.4
mv * $HOME/WRF/WRFDA
cd $HOME/WRF/WRFDA
rm -r WRFV4.4/
export NETCDF=$DIR/NETCDF
export HDF5=$DIR/grib2
export LD_LIBRARY_PATH=$DIR/grib2/lib:$LD_LIBRARY_PATH
export WRFPLUS_DIR=$HOME/WRF/WRFPLUS
./clean -a
./configure 4dvar #Option 18 for gfortran/gcc and distribunted memory 
./compile all_wrfvar



############################OBSGRID###############################
## OBSGRID
## Downloaded from git tagged releases
## Option #2
########################################################################
cd $HOME/WRF/
git clone https://github.com/wrf-model/OBSGRID.git
cd $HOME/WRF/OBSGRID

./clean -a
source $Miniconda_Install_DIR/etc/profile.d/conda.sh
conda init bash
conda activate ncl_stable


export HOME=`cd;pwd`
export DIR=$HOME/WRF/Libs
export NETCDF=$DIR/NETCDF

./configure   #Option 2

sed -i 's/-C -P -traditional/-P -traditional/g' configure.oa
sed -i 's/-lnetcdf -lnetcdff/ -lnetcdff -lnetcdf/g' configure.oa
sed -i 's/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo/-lncarg -lncarg_gks -lncarg_c -lX11 -lm -lcairo -lfontconfig -lpixman-1 -lfreetype -lhdf5 -lhdf5_hl /g' configure.oa


./compile

conda deactivate
conda deactivate

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

$HOME/WRF-4.4-install-script-linux-64bit/MET_self_install_script_Linux_64bit.sh



######################## Static Geography Data inc/ Optional ####################
# http://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
# These files are large so if you only need certain ones comment the others off
# All files downloaded and untarred is 200GB
# https://www2.mmm.ucar.edu/wrf/users/download/get_sources_wps_geog.html
#################################################################################
cd $HOME/WRF/Downloads
mkdir $HOME/WRF/GEOG
mkdir $HOME/WRF/GEOG/WPS_GEOG

#Mandatory WRF Preprocessing System (WPS) Geographical Input Data Mandatory Fields Downloads

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_high_res_mandatory.tar.gz
tar -xvzf geog_high_res_mandatory.tar.gz -C $HOME/WRF/GEOG/

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_low_res_mandatory.tar.gz
tar -xvzf geog_low_res_mandatory.tar.gz -C $HOME/WRF/GEOG/
mv $HOME/WRF/GEOG/WPS_GEOG_LOW_RES/ $HOME/WRF/GEOG/WPS_GEOG


# WPS Geographical Input Data Mandatory for Specific Applications
wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_thompson28_chem.tar.gz
tar -xvzf geog_thompson28_chem.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_noahmp.tar.gz
tar -xvzf geog_noahmp.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c  https://www2.mmm.ucar.edu/wrf/src/wps_files/irrigation.tar.gz
tar -xvzf irrigation.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_px.tar.gz
tar -xvzf geog_px.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_urban.tar.gz
tar -xvzf geog_urban.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_ssib.tar.gz
tar -xvzf geog_ssib.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/lake_depth.tar.bz2
tar -xvf lake_depth.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/topobath_30s.tar.bz2                                                
tar -xvf topobath_30s.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/gsl_gwd.tar.gz
tar -xvzf gsl_gwd.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG


#Optional WPS Geographical Input Data 


wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_older_than_2000.tar.gz
tar -xvzf geog_old_than_2000.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s_with_lakes.tar.gz
tar -xvzf modis_landuse_20class_15s_with_lakes.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/geog_alt_lsm.tar.gz
tar -xvzf geog_alt_lsm.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/nlcd2006_ll_9s.tar.bz2
tar -xvf nlcd2006_ll_9s.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/updated_Iceland_LU.tar.gz
tar -xvf updated_Iceland_LU.tar.gz -C $HOME/WRF/GEOG/WPS_GEOG

wget -c https://www2.mmm.ucar.edu/wrf/src/wps_files/modis_landuse_20class_15s.tar.bz2
tar -xvf modis_landuse_20class_15s.tar.bz2 -C $HOME/WRF/GEOG/WPS_GEOG





##########################  Export PATH and LD_LIBRARY_PATH ################################
cd $HOME

echo "export PATH=$DIR/bin:$PATH" >> ~/.bashrc
echo "export LD_LIBRARY_PATH=$DIR/lib:$LD_LIBRARY_PATH" >> ~/.bashrc




#####################################BASH Script Finished##############################
echo "Congratulations! You've successfully installed all required files to run the Weather Research Forecast Model verison 4.4."
echo "Thank you for using this script" 
