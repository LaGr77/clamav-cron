#!/bin/bash
# written by Ladislav Grulich (LaGr77)
# version 0.1.0
# since 2022-01-18
# licence MIT

CLAM_LOGFILE="/var/log/clamav/clamav-$(date +'%w').log"
CLAM_EMAIL="gru1950@gmail.com"
CLAM_EMAIL_CC="lada.grulich@gmail.com"
CLAM_EMAIL_FROM="ClamAV@$HOSTNAME"

if [ "$(date +'%w')" == 6 ]; then
	nice -n10 clamscan --recursive --infected / --exclude-dir=/proc/ &>"${CLAM_LOGFILE}";
	#--log="${CLAM_LOGFILE}"
	#--exclude-dir=/sys/
else
	nice -n15 clamscan --recursive --infected $HOME &>"${CLAM_LOGFILE}";
fi

CLAM_INFECTED=$(cat "${CLAM_LOGFILE}" | grep Infected);

cat "${CLAM_LOGFILE}" | mail -s "[CLAMAV] ${HOSTNAME}: ${CLAM_INFECTED}" -r "${CLAM_EMAIL_FROM}" "${CLAM_EMAIL}","${CLAM_EMAIL_CC}"
