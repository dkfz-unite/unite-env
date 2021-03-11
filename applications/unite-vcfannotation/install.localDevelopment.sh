#!/bin/bash

#set -x

# The "--run" option is only used to force the user to select build or run. 
#  functionally the variable is only used to switch --build on or off. 
#  --build is the default

### FUNCTIONS ##################################################################
function myecho() {
	[[ $VERBOSE == true ]] && echo $1
}

function myechon() {	
	[[ $VERBOSE == true ]] && echo -n $1
}


### USAGE ######################################################################
read -r -d '' USAGE << ENDOFUSAGE

Configure the Makefile.snps for the specific files found in the mapping
directory (created previously in pipeline).

  -h | --help
        Print this help statement.

  -b | --build
        Use the --build flag to tell Docker compuser to build the container

  -r | --run
        Use the --run flag to tell Docker compuser just torun the container

  -a | --vcfannotation-dev-dir
        The FULL PATH of the local directory where annotation tool development 
        lives

  -m | --msc-dev-dir
        The FULL PATH of the local directory where unite-python-core development
        lives 

  -V | --vep-tool-dir
        The FULL PATH of the local directory where annotation tool resources 
        reside 
        (DEFAULT:/home/vep/.vep)

  -v | --verbose
        Verbose output.

ENDOFUSAGE
### END USAGE ##################################################################
OPTS=$(getopt -o hbra:m:V:v \
-l help \
-l build \
-l run \
-l vcfannotation-dev-dir:\
-l msc-dev-dir:\
-l vep-tool-dir: \
-l verbose -- "$@")

eval set -- "$OPTS"

#--- SET DEFAULTS --------------------------------------------------------------
BUILD=true
RUN=false
VEP_TOOL_DIR="/home/vep/.vep"
VERBOSE=false
VCFANNDEVDIR="/home/mikes/WindowsDocuments/eclipse-workspace/unite-vcfannotation-service/src/UNITEvcfannotation"
MSCDEVDIR="/home/mikes/WindowsDocuments/eclipse-workspace/unite-python-core/src/UNITEmsc"
while true ; do
    case "$1" in
        -h | --help ) echo $USAGE;shift;;
        -b | --build ) BUILD=true; shift;;
        -v | --verbose ) VERBOSE=true; shift;;
        -r | --run ) RUN=true; shift;;
        -a | --vcfannotation-dev-dir ) VCFANNDEVDIR=$2;  shift 2;;
        -m | --msc-dev-dir ) MSCDEVDIR=$2;  shift 2;;
        -V | --vep-tool-dir ) HOST_TOOL_DIR=$2;  shift 2;;
        -v | --verbose ) VERBOSE=true; shift;;
        --) shift; break;;
    esac
done

if [ "$#" -ne 0 ]; then
	echo Error extra command line arguments "$@"
	echo $USAGE
fi

[[ $RUN == true ]] && BUILD=false
	
if [ $VERBOSE == true ]; then
	echo "BUILD = $BUILD"
	echo "RUN = $RUN"
	echo "VERBOSE=$VERBOSE"
	echo "VCFANNDEVDIR=$VCFANNDEVDIR"
	echo "MSCDEVDIR=$MSCDEVDIR"
	echo "VEP_TOOL_DIR=$VEP_TOOL_DIR"
fi

echo -n "Installing application..."
# Only one should run
if [ $BUILD == true ]; then
	VEP_ANNOTATIONS_TOOL_DIR=$VEP_TOOL_DIR VCFANNDEVDIR=$VCFANNDEVDIR MSCDEVDIR=$MSCDEVDIR docker-compose -p '' -f docker-compose.localDevelopment.yml up -d --build 
else
	VEP_ANNOTATIONS_TOOL_DIR=$VEP_TOOL_DIR VCFANNDEVDIR=$VCFANNDEVDIR MSCDEVDIR=$MSCDEVDIR docker-compose -p '' -f docker-compose.localDevelopment.yml up -d
fi
