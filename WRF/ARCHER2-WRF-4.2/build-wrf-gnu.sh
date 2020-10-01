#!/usr/bin/env bash

# From the default module environemnt
# invoke as "bash ./wrf-build-gcc.sh"

set -e

# Install [uncomment as required]
wget https://github.com/wrf-model/WRF/archive/v4.2.1.tar.gz
tar zxf v4.2.1.tar.gz
cd WRF-4.2.1

module swap PrgEnv-cray PrgEnv-gnu
module load cray-hdf5
module load cray-netcdf

# Module cray-netcdf is associated with ${NETCDF}
# which must be set for the configure stage...

export NETCDF=/opt/cray/pe/netcdf/4.6.3.2/GNU/9.1

# The configure option is "34": dmpar for gcc/gfortran
# but we must edit the resulting configure.wrf to replace
# gfortran by ftn etc.

./configure <<EOF
34
1
EOF

sed -i s/gcc/cc/       configure.wrf
sed -i s/mpicc/cc/     configure.wrf
sed -i s/gfortran/ftn/ configure.wrf
sed -i s/mpif90/ftn/   configure.wrf

# Compile "em_real" target

./compile -j 4 em_real
