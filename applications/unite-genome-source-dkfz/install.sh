#!/bin/bash

# ./install.sh --loglevel 10 --mountpoint "/mnt/vcftestfiles/" --remote-dir "/icgc/dkfzlsdf/project/hipo/hipo_057"  --vcf-file-type snv  --filelistpurge True --nomount 

### FUNCTIONS ##################################################################
function myecho() {
	[[ $VERBOSE == true ]] && echo $1
}

function myechon() {
	
	[[ $VERBOSE == true ]] && echo -n $1
}

function valueerror() {
	echo ""  >&2
	echo "Parameter $1 is mandatory. No value (or invalid value) passed in."  >&2
	echo ""  >&2
	echo "$USAGE"  >&2
	exit 1
}

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

  -D | --mountpoint
        The FULL PATH of the local directory to which the --remote-dir will be
         mounted. 
        (Mandatory)

  -k | --key
        The FULL PATH to the ssh private key to be used when making the SSHFS 
         mount.
        (DEFAULT: "/etc/ssl/certs/2020-03-10_ODCF")

  -l | --loglevel
        The logging level for the Python environment. Set at levels 10 - 50
        (DEFAULT: 30)

  -n | --nomount
        Skip the attempt to mount the remote directory (I.e. if the directory is 
        or is a local copy of the remote directory. )
        DEFAULT: False

  -o | --options
        A string of SSHFS options, exactly as they would appear after the '-o' 
         switch in a BASH sshfs mount command.
        If options are passed, it will override anything passed in for --key so 
		 the 'IdentityFile=/path/to/key' must be included.  
        (DEFAULT: "StrictHostKeyChecking=no,IdentityFile=/etc/ssl/certs/2020-03-10_ODCF,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other)

  -p | --filelist-purge
        Purge the mongo database of all previously parsed files (I.e. force all 
        found files to be processed and sent to composer again.)
        DEFAULT: False 

  -s | --remote-server
        The DNS resolvable name or IP address of the remote server from which
         the --remote-dir will be mounted.  
        (DEFAULT: "10.131.208.16")

  -t | --vcf-file-type
        The type fo OTP VCF file to be searched out and parsed (I.e. SNV or INDEL).  
        (Mandatory)

  -u | --user
        The name of the user with which to SSHFS mount the remote directory.
        (DEFAULT: "m309e")

  -v | --verbose
        Verbose output.

ENDOFUSAGE
### USAGE ######################################################################

#--- SET GETOPTS --------------------------------------------------------------
OPTS=$(getopt -o hd:D:k:l:no:ps:t:u:v \
-l help \
-l remote-dir: \
-l mountpoint: \
-l key: \
-l loglevel: \
-l nomount \
-l options: \
-l filelist-purge \
-l remote-server: \
-l vcf-file-type: \
-l user: \
-l verbose -- "$@")

if [ $? != 0 ]
    then
        echo ERROR parsing arguments >&2        exit 1
    fi
    eval set -- "$OPTS"

#--- SET DEFAULTS --------------------------------------------------------------
REMOTEDIR=""
MOUNTPOINT=""
NOMOUNT=false
VCFFILETYPE=""
KEY="/etc/ssl/certs/2020-03-10_ODCF"
OPTIONS=""
FILELISTPURGE=false
SERVER="10.131.208.16"
USER="m309e"
VERBOSE=true
LOGLEVEL="30"

#--- PARSE GETOPTS --------------------------------------------------------------
while true; do
  case "$1" in
    -h | --help ) echo "$USAGE" >&2; exit 1; shift ;;
    -d | --remote-dir ) REMOTEDIR="$2"; shift; shift ;;
    -D | --mountpoint ) MOUNTPOINT="$2"; shift; shift ;;
    -k | --key ) KEY="$2"; shift; shift ;;
    -l | --loglevel ) LOGLEVEL="$2"; shift; shift ;;
    -n | --nomount ) NOMOUNT=true; shift ;;
    -o | --options ) OPTIONS="$2"; shift; shift ;;
    -p | --filelist-purge ) FILELISTPURGE=true; shift ;;
    -s | --remote-server ) SERVER="$2"; shift; shift ;;
    -t | --vcf-file-type ) VCFFILETYPE="$2"; shift; shift ;;
    -u | --user ) USER="$2"; shift; shift ;;
    -v | --verbose ) VERBOSE=true; shift ;;

    -- ) shift; break ;;
    * ) break ;;
  esac
done

# Make string lowercase
VCFFILETYPE=$(echo "$VCFFILETYPE" | tr '[:upper:]' '[:lower:]')

[[ $REMOTEDIR == "" ]] && valueerror "remote-dir"
[[ $MOUNTPOINT == "" ]] && valueerror "remote-dir"
[[ ! $VCFFILETYPE == "snv" ]] && [[ ! $VCFFILETYPE == "indel" ]] && valueerror "vcf-file-type"

if   [ $VCFFILETYPE == "snv" ]; then 
	FILESOURCE="crawlOTPSNVCallingWorkflowfiles"
elif [ $VCFFILETYPE == "indel" ]; 
	then FILESOURCE="crawlOTPINDELCallingWorkflowfiles"
else 
	echo "Can't determine \$FILESOURCE from \$VCFFILETYPE (VCFFILETYPE=$VCFFILETYPE)"
	exit 1
fi

[[ $OPTIONS == "" ]] && OPTIONS="StrictHostKeyChecking=no,IdentityFile=$KEY,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other"

# sshfs m309e@10.131.208.16:/icgc/dkfzlsdf/project/hipo/hipo_057/ /mnt/filestobeparsed -o StrictHostKeyChecking=no,IdentityFile=/etc/ssl/certs/2020-03-10_ODCF,auto_cache,reconnect,transform_symlinks,follow_symlinks,allow_other"
if [ $NOMOUNT==false ]; then
	if [ $(mount | grep $REMOTEDIR | grep -v grep | wc -l) -eq 0 ]; then 
		myechon "Creating local mountpoint ..."
		result=$(mkdir $MOUNTPOINT 2>&1) || false
		[[ $result != "" ]] && [[ $result != *"File exists"* ]] && { echo "FAILED! with $result"; exit 1; } || myecho "OK"
		
		myechon "Mounting remote directory..."
		command="sshfs $USER@$SERVER:$REMOTEDIR $MOUNTPOINT -o $OPTIONS"
		result=$($command 2>&1) || false
		[[ $result != "" ]] && [[ $result != *"mountpoint is not empty"* ]] && { echo "FAILED! with $result"; exit 1; } || myecho "OK"
	fi
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

#myechon "Cloning PyVCF code to src code directory..."
#	git clone https://b240-phabricator.dkfz-heidelberg.de/source/BODA-PyVCF.git PyVCF && echo "OK" || { 
#	echo "FAILED! git cloning PyVCF"; exit 1; 
#}

myechon "Copying fuse.conf..."
cp -p ./UNITEotp/fuse.conf ../ && echo "OK" || { 
	echo "FAILED! copying fuse.conf"; exit 1; } || myecho "OK"

myechon "Returning to ${currentdir}..."
cd $currentdir && echo "OK" || { echo "FAILED!"; exit 1; }

myechon "Creating '.docker-compose.tmp.yml' ..."
dirname=$(basename $REMOTEDIR)
./create_docker-compose.sh ${dirname} ${VCFFILETYPE} && echo "OK" || { 
	echo "FAILED!"; exit 1; } || myecho "OK"


echo -n "Installing UNITE Web application (LOCAL)..."
LOGLEVEL=$LOGLEVEL MOUNTPOINT=$MOUNTPOINT ORIGINAL_DIR=$REMOTEDIR VCFFILETYPE=$VCFFILETYPE FILESOURCE=$FILESOURCE FILELISTPURGE=$FILELISTPURGE docker-compose -p '' -f .docker-compose.tmp.yml up -d --build 

