#!/bin/bash

#set -x

### USAGE ######################################################################
read -r -d '' USAGE << ENDOFUSAGE

Configure the Makefile.snps for the specific files found in the mapping
directory (created previously in pipeline).

  -h | --help
        Print this help statement.

  -b | --build
        Use the --build flag to tell Docker compuser to build the container

  -d | --remote-mount-dir
        The FULL PATH of the remote directory (as it appears on the remote 
         server) to be searched for files with extension <--extension>.
        (Mandatory)

  -D | --local-mount-dir
        The FULL PATH of the local directory to which the --remote-mount-dir will be
         mounted. 
        (DEFAULT:/mnt/filestobeparsed)

  -k | --key
        The FULL PATH to the ssh provate key to be used when making the SSHFS 
         mount.
        (DEFAULT: "/etc/ssl/certs/2020-03-10_ODCF")

  -o | --options
        A string of SSHFS options, exactly as they would appear after the '-o' 
         switch in a BASH sshfs mount command.
        If options are passed, it will override anything passed in for --key so 
		 the 'IdentityFile=/path/to/key' must be included.  
        (DEFAULT: "StrictHostKeyChecking=no,IdentityFile=/etc/ssl/certs/2020-03-10_ODCF,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other)

  -r | --run
        Use the --run flag to tell Docker compuser just torun the container

  -s | --server
        The DNS resolvable name or IP address of the remote server from which
         the --remote-mount-dir will be mounted.  
        (DEFAULT: "10.131.208.16")

  -t | --host-tool-dir
        The FULL PATH of the local directory where annotation tool resources 
        reside 
        (DEFAULT:/home/vep/.vep)

  -u | --user
        The name of the user with which to SSHFS mount the remote directory.
        (DEFAULT: "m309e")

  -v | --verbose
        Verbose output.

ENDOFUSAGE
### END USAGE ##################################################################
OPTS=$(getopt -o hbd:D:k:o:rs:t:u:v \
-l help \
-l build \
-l remote-mount-dir: \
-l local-mount-dir: \
-l key: \
-l options: \
-l run \
-l server: \
-l host-tool-dir: \
-l user: \
-l verbose -- "$@")

if [ $? != 0 ]; then
        echo ERROR parsing arguments >&2        exit 1
    fi

eval set -- "$OPTS"

#--- SET DEFAULTS --------------------------------------------------------------
BUILD=true
RUN=false
REMOTEDIR=""
LOCALDIR="/mnt/filestobeparsed"
HOST_TOOL_DIR="/home/vep/.vep"
KEY="/etc/ssl/certs/2020-03-10_ODCF"
OPTIONS=""
SERVER="10.131.208.16"
USER="m309e"
VERBOSE=false

while true ; do
    case "$1" in
        -h | --help ) echo $USAGE;shift;;
        -b | --build ) BUILD=true; shift;;
        -v | --verbose ) VERBOSE=true; shift;;
        -d | --remote-mount-dir ) REMOTEDIR=$2;  shift 2;;
        -D | --local-mount-dir ) LOCALDIR=$2;  shift 2;;
        -k | --key ) KEY=$2;  shift 2;;
        -o | --options ) OPTIONS=$2;  shift 2;;
        -r | --run ) RUN=true; shift;;
        -s | --server ) SERVER=$2;  shift 2;;
        -t | --host-tool-dir ) HOST_TOOL_DIR=$2;  shift 2;;
        -u | --user ) USER=$2;  shift 2;;
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
	echo "REMOTEDIR = $REMOTEDIR"
	echo "VERBOSE=$VERBOSE"
	echo "REMOTEDIR=$REMOTEDIR"
	echo "LOCALDIR=$LOCALDIR"
	echo "KEY=$KEY"
	echo "OPTIONS=$OPTIONS"
	echo "SERVER=$SERVER"
	echo "HOST_TOOL_DIR=$HOST_TOOL_DIR"
	echo "USER=$USER"
fi

function myecho() {
	[[ $VERBOSE == true ]] && echo $1
}

function myechon() {	
	[[ $VERBOSE == true ]] && echo -n $1
}

[[ $OPTIONS == "" ]] && OPTIONS="StrictHostKeyChecking=no,IdentityFile=$KEY,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other"

# sshfs m309e@10.131.208.16:/icgc/dkfzlsdf/project/hipo/hipo_057/ /mnt/filestobeparsed -o StrictHostKeyChecking=no,IdentityFile=/etc/ssl/certs/2020-03-10_ODCF,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other"
if [ $REMOTEDIR == "" ]; then
	myecho "No remote mount directory specified. Nothing mounted."
else	
	if [ $(mount | grep $LOCALDIR | grep -v grep | wc -l) -eq 0 ]; then 
		myechon "Creating local mountpoint ..."
		result=$(mkdir $LOCALDIR 2>&1) || false
		[[ $result != "" ]] && [[ $result != *"File exists"* ]] && { echo "FAILED! with $result"; exit 1; } || myecho "OK"
		
		myechon "Mounting remote directory..."
		command="sshfs $USER@$SERVER:$REMOTEDIR $LOCALDIR -o $OPTIONS"
		result=$($command 2>&1) || false
		[[ $result != "" ]] && [[ $result != *"mountpoint is not empty"* ]] && { echo "FAILED! with $result"; exit 1; } || myecho "OK"
	fi
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
[[ $RUN == true ]] && HOST_FILE_DIR=$LOCALDIR HOST_ANNOTATIONS_TOOL_DIR=$HOST_TOOL_DIR docker-compose -p '' -f docker-compose.yml up -d
[[ $BUILD == true ]] && HOST_FILE_DIR=$LOCALDIR HOST_ANNOTATIONS_TOOL_DIR=$HOST_TOOL_DIR docker-compose -p '' -f docker-compose.yml up -d --build 





