#!/bin/bash

### USAGE ######################################################################
read -r -d '' USAGE << ENDOFUSAGE

Configure the Makefile.snps for the specific files found in the mapping
directory (created previously in pipeline).

  -h | --help
        Print this help statement.

  -d | --remote-dir
        The FULL PATH of the remote directory (as it appears on the remote 
         server) to be searched for files with extension <--extension>.
        (Mandatory)

  -D | --local-dir
        The FULL PATH of the local directory to which the --remote-dir will be
         mounted. 
        (DEFAULT:/mnt/filestobeparsed)

  -e | --extension
        The file extension (without preceding period) that will be searched for.
        Case insensitive.
        (DEFAULT: "vcf")

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

  -s | --server
        The DNS resolvable name or IP address of the remote server from which
         the --remote-dir will be mounted.  
        (DEFAULT: "10.131.208.16")

  -u | --user
        The name of the user with which to SSHFS mount the remote directory.
        (DEFAULT: "m309e")

  -v | --verbose
        Verbose output.

ENDOFUSAGE
### USAGE ######################################################################

#--- SET GETOPTS --------------------------------------------------------------
OPTS=`getopt -o hd:D:e:k:o:s:u:v --longoptions help,remote-dir,local-dir,extension,key,options,server,user,verbose: -n 'parse-options' -- "$@"`
if [ $? != 0 ] ; then
    echo "Failed parsing options." >&2
    echo "$USAGE" >&2
    exit 1
fi
# echo "$OPTS"
eval set -- "$OPTS"

#--- SET DEFAULTS --------------------------------------------------------------
REMOTEDIR=""
LOCALDIR="/mnt/filestobeparsed"
EXT="vcf"
KEY="/etc/ssl/certs/2020-03-10_ODCF"
OPTIONS=""
SERVER="10.131.208.16"
USER="m309e"
VERBOSE=false

#--- PARSE GETOPTS --------------------------------------------------------------
while true; do
  case "$1" in
    -h | --help ) echo "$USAGE" >&2; exit 1; shift ;;
    -d | --remote-dir ) REMOTEDIR="$2"; shift; shift ;;
    -D | --local-dir ) LOCALDIR="$2"; shift; shift ;;
    -e | --extension ) EXT="$2"; shift; shift ;;
    -k | --key ) KEY="$2"; shift; shift ;;
    -o | --options ) OPTIONS="$2"; shift; shift ;;
    -s | --server ) SERVER="$2"; shift; shift ;;
    -u | --user ) USER="$2"; shift; shift ;;
    -v | --verbose ) VERBOSE=true; shift ;;

    -- ) shift; break ;;
    * ) break ;;
  esac
done

function myecho() {
	[[ $VERBOSE == true ]] && echo $1
}

function myechon() {
	
	[[ $VERBOSE == true ]] && echo -n $1
}

[[ $REMOTEDIR == "" ]] && {
	echo "Parameter -d (--remote-dir) is mandatory. No value passed in."
	echo ""
	echo "$USAGE"
	exit 1
}

#[[ $VERBOSE == true ]] && set -x  || set +x

[[ $OPTIONS == "" ]] && OPTIONS="StrictHostKeyChecking=no,IdentityFile=$KEY,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other"

# sshfs m309e@10.131.208.16:/icgc/dkfzlsdf/project/hipo/hipo_057/ /mnt/filestobeparsed -o StrictHostKeyChecking=no,IdentityFile=/etc/ssl/certs/2020-03-10_ODCF,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other"
if [ $(mount | grep $REMOTEDIR | grep -v grep | wc -l) -eq 0 ]; then 
	myechon "Creating local mountpoint ..."
	result=$(mkdir $LOCALDIR 2>&1) || false
	[[ $result != "" ]] && [[ $result != *"File exists"* ]] && { echo "FAILED! with $result"; exit 1; } || myecho "OK"
	
	myechon "Mounting remote directory..."
	command="sshfs $USER@$SERVER:$REMOTEDIR $LOCALDIR -o $OPTIONS"
	result=$($command 2>&1) || false
	[[ $result != "" ]] && [[ $result != *"mountpoint is not empty"* ]] && { echo "FAILED! with $result"; exit 1; } || myecho "OK"
fi

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

myechon "Cloning otp service code to src code directory..."
git clone https://github.com/dkfz-unite/unite-mutations-source-otp.git UNITEotp && myecho "OK"  || { 
	echo "FAILED! git cloning UNITEotp"; exit 1; 
}

myechon "Cloning UNITE python core code to src code directory..."
git clone https://github.com/dkfz-unite/unite-python-core.git UNITEmsc && myecho "OK"  || { 
	echo "FAILED! git cloning UNITEmsc"; exit 1; 
}

myechon "Cloning PyVCF code to src code directory..."
	git clone https://b240-phabricator.dkfz-heidelberg.de/source/BODA-PyVCF.git PyVCF && echo "OK" || { 
	echo "FAILED! git cloning PyVCF"; exit 1; 
}

myechon "Copying fuse.conf..."
cp -p ./UNITEotp/fuse.conf ../ && echo "OK" || { 
	echo "FAILED! copying fuse.conf"; exit 1; } || myecho "OK"

cd $currentdir && echo "OK" || { echo "FAILED!"; exit 1; }

echo -n "Installing UNITE Web application (LOCAL)..."
HOST_FILE_DIR=$LOCALDIR ODCF_FILE_EXTENSION=$EXT docker-compose -p '' -f docker-compose.yml up -d --build 

