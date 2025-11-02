#!/bin/bash
echo "                          "
echo "**************************"
echo "                          "
echo "                          "
echo "                          "
# ------------------------------------------------------------------
# [ChaimV] xlxburn
#          use Xilinx Indirect Programming to burn FPGA Image to Flash 
#
#          This script uses shFlags -- Advanced command-line flag
#          library for Unix shell scripts.
#          http://code.google.com/p/shflags/
#
# Dependency:
#     http://shflags.googlecode.com/svn/trunk/source/1.0/src/shflags
# ------------------------------------------------------------------
VERSION=1.0.0
SUBJECT=fpga_flash
USAGE="Usage: xlxburn -imhv arg"

# --- Tool selection --------------------------------------------
if [ -d "/opt/Xilinx/Vivado_Lab/2016.2" ] ; then
    VIVADO_TOOL=/opt/Xilinx/Vivado_Lab/2016.2/bin/vivado_lab
elif [ -d "/opt/Xilinx/Vivado_Lab/2016.1" ] ; then
    VIVADO_TOOL=/opt/Xilinx/Vivado_Lab/2016.1/bin/vivado_lab
elif [ -d "/opt/Xilinx/Vivado_Lab/2015.4" ] ; then
    VIVADO_TOOL=/opt/Xilinx/Vivado_Lab/2015.4/bin/vivado_lab 
elif [ -d "/opt/Xilinx/Vivado_Lab/2015.3" ] ; then
    VIVADO_TOOL=/opt/Xilinx/Vivado_Lab/2015.3/bin/vivado_lab
elif [ -d "/opt/Xilinx/Vivado/2015.2" ] ; then
     VIVADO_TOOL=/opt/Xilinx/Vivado/2015.2/bin/vivado
else
     VIVADO_TOOL=vivado
fi

echo "using $VIVADO_TOOL"
########################                    template:
# --- Option processing --------------------------------------------
	
if [ $# == 0 ] ; then
    echo "No image selected , burning default image"
fi

while getopts ":i:m:vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "i")
        image=$OPTARG;
        echo "image: $image"
        ;;
	  "m")
        flash_size=$OPTARG;
        echo "Flash memory part size (MB): $flash_size"
        ;;
	  "h")
        echo $USAGE
        echo "************"
        echo "[-i] [arg] - select <image>.mcs for burning"
		echo "[-m] [arg] - select Flash Memory size (MB) e.g. 32/64"
        echo "[-v]      -  script version"
        echo "[-h]      -  this help on this script"
        echo "example: to burn flash with mcs created from ./my_image/top.mcs:"
        echo " # xlxburn.sh -i ./my_image/top.mcs"
        echo "                          "
        echo "                          "
        echo "**************************"
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG , burning default image"
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
   echo "Script is already running"
   exit
fi

trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE

# --- Body --------------------------------------------------------
echo "                          "
echo "                          "
echo "                          "
echo "      Burning MCS         "
echo "**************************"
echo "                          "
echo "                          "
echo "                          "
# -----------------------------------------------------------------
$VIVADO_TOOL -mode batch -notrace -source ./xlxdummy.tcl
$VIVADO_TOOL -mode batch -notrace -source ./xlxburn.tcl -tclargs $image $flash_size