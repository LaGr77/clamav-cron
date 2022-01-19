#!/bin/bash
# written by Ladislav Grulich (LaGr77)
# version 1.0.0
# since 2022-01-19
# licence MIT

CLAM_LOGFILE="/var/log/clamav/clamav-$(date +'%w').log"
CLAM_EMAIL="email-1@gmail.com"
CLAM_EMAIL_CC="email-2@gmail.com"
CLAM_EMAIL_FROM="ClamAV@$HOSTNAME"

if [ "$(date +'%w')" == 1 ]; then
	nice -n10 clamscan --recursive --infected / --exclude-dir=/proc/ --exclude-dir=/sys/ &>"${CLAM_LOGFILE}";
	#--log="${CLAM_LOGFILE}"
	CLAM_SUBJ="FULL"
else
	nice -n15 clamscan --recursive --infected $HOME &>"${CLAM_LOGFILE}";
	#--log="${CLAM_LOGFILE}"
	CLAM_SUBJ="HOME"
fi

CLAM_INFECTED=$(cat "${CLAM_LOGFILE}" | grep Infected);
(
	echo "--------- VERSION SUMMARY ----------"
	clamscan --version
	echo ""
	echo "---------- INFECTED FILES ----------"
	cat "${CLAM_LOGFILE}"
) | mail -s "[CLAMAV:${CLAM_SUBJ}] ${HOSTNAME}: ${CLAM_INFECTED}" -r "${CLAM_EMAIL_FROM}" "${CLAM_EMAIL}","${CLAM_EMAIL_CC}"


