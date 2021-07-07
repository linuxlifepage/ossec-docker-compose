#!/bin/sh

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

# Узнать chat_id https://api.telegram.org/bot17023235345345:AAEXlAW4fsjdbfJ786AbDpXRsUc/getUpdates
# Telegram settings
TOKEN="1697576146:AAELDR1r5zHF0tBhLKjlIT-AfAyDRCaYtJQ"
CHAT_ID="1598481958"

# Checking user arguments
if [ "x$1" = "xdelete" ]; then
    exit 0;
fi
ALERTID=$4
RULEID=$5
LOCAL=`dirname $0`;

# Logging
cd $LOCAL
cd ../
PWD=`pwd`
echo "`date` $0 $1 $2 $3 $4 $5 $6 $7 $8" >> ${PWD}/../logs/active-responses.log
ALERTTITLE=`grep -A 1 "$ALERTID" ${PWD}/../logs/alerts/alerts.log | tail -1`
ALERTTEXT=`grep -A 10 "$ALERTID" ${PWD}/../logs/alerts/alerts.log | grep -v "Src IP: " | grep -v "User: " | grep "Rule: " -A 4 | sed '/^$/Q' | cut -c -139 | sed 's/\"//g'`

LEVEL=`echo "${ALERTTEXT}" | head -1 | grep "(level [0-9]*)" | sed 's/^.*(level \([0-9]*\)).*$/\1/'`
COLOR="🚔⚠️ OSSEC⚠️🚔 "
if [ "${LEVEL}" ]
then
  [ "${LEVEL}" -ge 7 ] && COLOR="🚔🅰️ ‼️‼️ OSSEC‼️‼️🚔 "
  [ "${LEVEL}" -ge 4 ] && COLOR="🚔🅱️ ‼️‼️ OSSEC‼️‼️🚔 "
  [ "${LEVEL}" -ge 12 ] && COLOR="🚔🆘 ‼️ ‼️ OSS‼️C🚔 🚔"
fi

PAYLOAD="%0A${COLOR} ${ALERTTITLE}%0A${ALERTTEXT}"
PAYLOAD_SNS="${COLOR} ${ALERTTITLE} ${ALERTTEXT}"

if echo "$PAYLOAD" | grep "openvas" || echo "$PAYLOAD" | grep "File added to the system" || echo "$PAYLOAD" | grep "FIPS 140" || echo "$PAYLOAD" | grep "for user www-data" || echo "$PAYLOAD" | grep "Log file size reduced" || echo "$PAYLOAD" | grep "/dev/zram1" || echo "$PAYLOAD" | grep "for user nobody" || echo "$PAYLOAD" | grep "Web server 400 error" || echo "$PAYLOAD" | grep "Log file rotated" || echo "$PAYLOAD" | grep "Blacklisted user agent" || echo "$PAYLOAD" | grep "404 error"
then
        echo "SKIP MESSAGE" >/dev/null
else
        curl -s \
        -X POST \
        https://api.telegram.org/bot$TOKEN/sendMessage \
        -d text="${PAYLOAD}" \
        -d chat_id=$CHAT_ID >>${PWD}/../logs/active-responses.log

        #python3 /var/ossec/active-response/bin/sns.py --message="${PAYLOAD_SNS}"
fi
