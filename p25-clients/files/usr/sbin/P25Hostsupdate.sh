#! /bin/sh

###############################################################################
#
# YSFHostsupdate.sh
#
# Copyright (C) 2016 by Tony Corbett G0WFV
# Adapted to YSFHosts by Paul Nannery KC2VRJ on 6/28/2016 with all crdeit 
# to G0WFV for the orignal script.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
###############################################################################
#
# On a Linux based system, such as a Raspberry Pi, this script will perform all  
# the steps required to maintain the YSFHosts.txt (or similar) file for you.
#
# It is designed to run from crontab and will download the YSFHosts from the 
# master ysfreflector.de database and optionally keep a backup of previously
# created files for you.
#
# It will also prune the number of backup files according to a value specified
# by you in the configuration below.
#
# To install in root's crontab use the command ...
#
#     sudo crontab -e
#
# ... and add the following line to the bottom of the file ...
#
#     0  0  *  *  *  /path/to/script/YSFHostsupdate.sh 1>/dev/null 2>&1
#
# ... where /path/to/script/ should be replaced by the path to this script.
#
###############################################################################
#
#                              CONFIGURATION
#
# Full path to YSFHosts
P25HOSTS=/etc/mmdvm/P25Hosts.txt

# How many P25HOSTS files do you want backed up (0 = do not keep backups) 
P25HOSTSFILEBACKUP=0

###############################################################################
#
# Do not edit below here
#
###############################################################################

# Not supported yet - BG5HHP
echo "This script is not ready yet"
exit 0

# Check we are root
if [ "$(id -u)" != "0" ] 
then
	echo "This script must be run as root" 1>&2
	exit 1
fi

# Create backup of old file
if [ ${P25HOSTSFILEBACKUP} -ne 0 ]
then
	cp ${P25HOSTS} ${P25HOSTS}.$(date +%d%m%y)
fi

# Prune backups
BACKUPCOUNT=$(ls ${P25HOSTS}.* | wc -l)
BACKUPSTODELETE=$(expr ${BACKUPCOUNT} - ${P25HOSTSFILEBACKUP})

if [ ${BACKUPCOUNT} -gt ${P25HOSTSFILEBACKUP} ]
then
	for f in $(ls -tr ${P25HOSTS}.* | head -${BACKUPSTODELETE})
	do
		rm -f $f
	done
fi

# Generate YSFHosts.txt file
#curl https://register.ysfreflector.de/export_csv.php > ${YSFHOSTS}
#wget https://register.ysfreflector.de/export_csv.php -O ${YSFHOSTS}

exit 0
