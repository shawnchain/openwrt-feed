#! /bin/sh
#
# By BG5HHP, based on DMRIDUpdate.sh by Tony Corbett G0WFV,R2AJV,CT2JAY
###############################################################################
#
# On a Linux based system, such as a Raspberry Pi, this script will perform all 
# the steps required to maintain the DMRIds.dat (or similar) file for you.
#
# It is designed to run from crontab and will download the latest IDs from the 
# BM network database and optionally keep a backup of previously
# created files for you.
#
# It will also prune the number of backup files according to a value specified
# by you in the configuration below.
#
# When done, it will restart MMDVMHost to make the ID changes take effect.
#
# To install in root's crontab use the command ...
#
#     sudo crontab -e
#
# ... and add the following line to the bottom of the file ...
#
#     0  0  *  *  *  /path/to/script/DMRIDUpdateBM.sh 1>/dev/null 2>&1
#
# ... where /path/to/script/ should be replaced by the path to this script.
#
###############################################################################
#
#                              CONFIGURATION
#
# Full path to DMR ID file
DMRIDFILE=/etc/mmdvm/DMRIds.dat
DMRIDFILE_CN=/etc/mmdvm/DMRIds_CN.dat
#
# How many DMR ID files do you want backed up (0 = do not keep backups)
DMRFILEBACKUP=1
#
# Command line to restart MMDVMHost
RESTARTCOMMAND="/etc/init.d/mmdvmhost restart"
# RESTARTCOMMAND="killall MMDVMHost ; /path/to/MMDVMHost/executable/MMDVMHost /path/to/MMDVM/ini/file/MMDVM.ini"

###############################################################################
#
# Do not edit below here
#
###############################################################################

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

# Update the CN IDs as well ...
grep "^460" ${DMRIDFILE} > ${DMRIDFILE_CN}

echo "Complete! now Restarting mmdvm ... "
# Restart MMDVMHost
eval ${RESTARTCOMMAND}
