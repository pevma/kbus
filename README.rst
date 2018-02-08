# kbus

Kernel building scripts
-----------------------

Tested on Debian/Ubuntu.  

Two scripts are provided  - one for stable kernel and one for latest RC.
Please review each script and its comments to make the needed adjustments if required.

Some build tools and packages are needed to be present on the system to build the kernel. Make sure you have the following :
:: 

 sudo apt-get install libncurses5-dev gcc make git bc libssl-dev build-essential autoconf automake

The scripts will use by default the same kernel config present on the system they are being executed on.  
That way the newly build kernel has the same configuration (system wise) with the previous kernel install.

The ``build-kernel-rc.sh`` script will attempt building the latest available RC kernel as available/specified here - https://www.kernel.org/  

The ``build-kernel.sh`` script will attempt building the kernel version you specify as available here - https://www.kernel.org/

After the build is finished you should have the new kernel pkg (plus dbg,headers,firmware) in the  current folder.
You can then install with a regular ``dpkg -i kernel_package`` command. After finished reboot to use the new kernel.
