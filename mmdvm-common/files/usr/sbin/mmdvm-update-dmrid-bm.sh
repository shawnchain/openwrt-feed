#!/bin/sh
#
# By BG5HHP, based on DMRIDUpdate.sh by Tony Corbett G0WFV,R2AJV,CT2JAY
###############################################################################
#
# Full path to DMR ID file
DMRIDFILE=/etc/mmdvm/DMRIds.dat
#DMRIDFILE_CN=/etc/mmdvm/DMRIds_CN.dat
#
# How many DMR ID files do you want backed up (0 = do not keep backups)
DMRFILEBACKUP=1
#
# Command line to restart MMDVMHost
RESTARTCOMMAND="/etc/init.d/mmdvmhost restart"
# RESTARTCOMMAND="killall MMDVMHost ; /path/to/MMDVMHost/executable/MMDVMHost /path/to/MMDVM/ini/file/MMDVM.ini"

###############################################################################
#
# Check we are root
if [ "$(id -u)" != "0" ] 
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Download the file as temporary file
TEMP_FILE="/tmp/.dmrid_upd.tmp"
rm -f $TEMP_FILE
echo "Downloading DMRIds from BM ... "
wget 'http://registry.dstar.su/dmr/DMRIds.php' -O - 2>/dev/null | sed -e 's/[[:space:]]\+/ /g' > ${TEMP_FILE}
#make sure we're success
[ $? = 0 ] || (echo "download DMRIds failed." && exit 1)

# Safe update the DMRIds.dat
TODAY=$(date +%d%m%y)
mv ${DMRIDFILE} ${DMRIDFILE}.${TODAY}
mv $TEMP_FILE $DMRIDFILE
if [ $? -ne 0 ];then
	# restore if something wrong
	echo "rename DMRIds failed, restoring ..."
	mv ${DMRIDFILE}.${TODAY} ${DMRIDFILE}
	exit 1
fi

# Prune backups
BACKUPCOUNT=$(ls ${DMRIDFILE}.* | wc -l)
BACKUPSTODELETE=$(expr ${BACKUPCOUNT} - ${DMRFILEBACKUP})
if [ ${BACKUPCOUNT} -gt ${DMRFILEBACKUP} ]; then
	for f in $(ls -tr ${DMRIDFILE}.* | head -${BACKUPSTODELETE}); do
		rm $f
	done
fi

# Update the CN IDs if file name specified.
if ! [ -z $DMRIDFILE_CN ];then
	grep "^460" ${DMRIDFILE} > ${DMRIDFILE_CN}
fi

echo "Update DMRId database complete!"
# Restart MMDVMHost
#eval ${RESTARTCOMMAND}
