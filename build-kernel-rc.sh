#!/bin/bash

ARGS=1         # Script requires 1 argument.
kernel_version=$1

echo -e "\n Supplied version is:  ${kernel_version} \n";

if [ $# -ne "$ARGS" ];  then
    echo -e "\n USAGE: `basename $0` script requires ONE argument - kernel version"
    echo -e "\n Please supply a version. Ex. - ./build-kernel.sh 4.13.9 \n"
    exit 1;
fi

if   ` wget git.kernel.org/torvalds/t/linux-${kernel_version}.tar.gz`  ; then
	echo "Downloaded Kernel ${kernel_version}."
	
else
	echo "Could not download! Aborting. Check your connection and try again." 1>&2
	exit 1
fi

tar -xzf linux-${kernel_version}.tar.gz 
# if you would like to specify a kernel config you can do it as the example below
#cp /path/to/kernel/config/available linux-${kernel_version}


# aufs git clone and linux kernel should be in separate directories
cd  linux-${kernel_version} &&  git clone https://github.com/sfjro/aufs4-standalone.git aufs4-standalone.git
cd  aufs4-standalone.git && git branch -r && git checkout origin/aufs4.x-rcN
cd ../ && patch -p1 < aufs4-standalone.git/aufs4-base.patch && \
patch -p1 < aufs4-standalone.git/aufs4-standalone.patch && \
patch -p1 < aufs4-standalone.git/aufs4-mmap.patch && \
patch -p1 < aufs4-standalone.git/aufs4-kbuild.patch 

cp -R aufs4-standalone.git/Documentation/ $PWD
cp -R aufs4-standalone.git/fs/ $PWD
cp aufs4-standalone.git/include/uapi/linux/aufs_type.h $PWD/include/uapi/linux/.

# make and compile the kernel.
# Use all CPUs for the build/compilation
yes "" | make oldconfig && make clean && make -j  `getconf _NPROCESSORS_ONLN` deb-pkg LOCALVERSION=-amd64 KDEB_PKGVERSION=${kernel_version}
