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

  -V | --vep-tool-dir
        The FULL PATH of the local directory where annotation tool resources 
        reside 
        (DEFAULT:/home/vep/.vep)

  -v | --verbose
        Verbose output.

ENDOFUSAGE
### END USAGE ##################################################################
OPTS=$(getopt -o hbrV:v \
-l help \
-l build \
-l run \
-l vep-tool-dir: \
-l verbose -- "$@")

eval set -- "$OPTS"

#--- SET DEFAULTS --------------------------------------------------------------
BUILD=true
RUN=false
VEP_TOOL_DIR="/home/vep/.vep"
VERBOSE=false

while true ; do
    case "$1" in
        -h | --help ) echo $USAGE;shift;;
        -b | --build ) BUILD=true; shift;;
        -v | --verbose ) VERBOSE=true; shift;;
        -r | --run ) RUN=true; shift;;
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
	echo "VEP_TOOL_DIR=$VEP_TOOL_DIR"
fi

if [ $BUILD == true ]; then 
	myechon "Cleaning up source code directory..."
	rm -r -f src && myecho "OK"  || { echo "FAILED!"; exit 1; }
	
	currentdir=$(pwd)
	myechon "Making src code directory..."
	result=$(mkdir src 2>&1) || false
	[[ $result != "" ]] && [[ $result != *"File exists"* ]] && { 
		echo "FAILED! with $result"; exit 1; 
	} || myecho "OK"
	
	myechon "Changing permissions of src code directory..."
	chmod -R 777 src && myecho "OK" || { 
		echo "FAILED! changing permissions on src directory"; exit 1; 
	}
	
	myechon "Changing into src code directory..."
	cd $currentdir/src && myecho "OK" || { 
		echo "FAILED! to change into src directory."; exit 1; 
	}
	
	myechon "Cloning VCF annotation service code to src code directory..."
	git clone https://github.com/dkfz-unite/unite-vcfannotation-service.git UNITEvcfannotation && myecho "OK"  || { 
		echo "FAILED! git cloning UNITEotp"; exit 1; 
	}
	
	myechon "Cloning UNITE python core code to src code directory..."
	git clone https://github.com/dkfz-unite/unite-python-core.git UNITEmsc && myecho "OK"  || { 
		echo "FAILED! git cloning UNITEmsc"; exit 1; 
	}
	
	myechon "Returning to root directory..."
	cd $currentdir && myecho "OK" || { 
		echo "FAILED!"; exit 1; 
	}
fi

echo -n "Installing application..."
# Only one should run
if [ $BUILD == true ]; then
	VEP_ANNOTATIONS_TOOL_DIR=$VEP_TOOL_DIR docker-compose -p '' -f docker-compose.yml up -d --build 
else
	VEP_ANNOTATIONS_TOOL_DIR=$VEP_TOOL_DIR  docker-compose -p '' -f docker-compose.yml up -d
fi




