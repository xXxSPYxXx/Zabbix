#!/bin/bash
##### OPTIONS VERIFICATION #####
if [[ -z "$1" || -z "$2" || -z "$3" ]]; then
  exit 1
fi
##### PARAMETERS #####
RESERVED="$1"
METRIC="$2"
CURL=$(which curl)
CACHE_TTL="55"
STATSURL="$3"
CACHE_FILE="/tmp/zabbix.php-fpm.`echo $STATSURL | md5sum | cut -d" " -f1`.cache"
EXEC_TIMEOUT="1"
NOW_TIME=`date '+%s'`
##### RUN #####
if [ -s "${CACHE_FILE}" ]; then
  CACHE_TIME=`stat -c"%Y" "${CACHE_FILE}"`
else
  CACHE_TIME=0
fi
DELTA_TIME=$((${NOW_TIME} - ${CACHE_TIME}))
#
if [ ${DELTA_TIME} -lt ${EXEC_TIMEOUT} ]; then
  sleep $((${EXEC_TIMEOUT} - ${DELTA_TIME}))
elif [ ${DELTA_TIME} -gt ${CACHE_TTL} ]; then
  echo "" >> "${CACHE_FILE}" # !!!
  DATACACHE=`$CURL -sS --insecure --max-time 10 $STATSURL`
  echo "${DATACACHE}" > "${CACHE_FILE}" # !!!
  chmod 640 "${CACHE_FILE}"
fi
#

if [ ${METRIC} = "uptime" ]; then
  cat ${CACHE_FILE} | grep -w 'start since: ' | awk '{print $3}'
  exit 0
fi

if [ ${METRIC} = "max_listen_queue" ]; then
  cat ${CACHE_FILE} | grep -w 'max listen queue: ' | awk '{print $4}'
  exit 0
fi

if [ ${METRIC} = "listen_queue_len" ]; then
  cat ${CACHE_FILE} | grep -w 'listen queue len: ' | awk '{print $4}'
  exit 0
fi

if [ ${METRIC} = "listen_queue" ]; then
  cat ${CACHE_FILE} | grep -w 'listen queue: ' | grep -v max | awk '{print $3}'
  exit 0
fi

if [ ${METRIC} = "total_processes" ]; then
  cat ${CACHE_FILE} | grep 'total processes: ' | awk '{print $3}'
  exit 0
fi

if [ ${METRIC} = "active_processes" ]; then
  cat ${CACHE_FILE} | grep -w 'active processes: ' | awk '{print $3}'
  exit 0
fi

if [ ${METRIC} = "idle_processes" ]; then
  cat ${CACHE_FILE} | grep 'idle processes: ' | awk '{print $3}'
  exit 0
fi

if [ ${METRIC} = "max_active_processes" ]; then
  cat ${CACHE_FILE} | grep 'max active processes: ' | awk '{print $4}'
  exit 0
fi

if [ ${METRIC} = "max_children_reached" ]; then
  cat ${CACHE_FILE} | grep 'max children reached: ' | awk '{print $4}'
  exit 0
fi

if [ ${METRIC} = "slow_requests" ]; then
  cat ${CACHE_FILE} | grep 'slow requests: ' | awk '{print $3}'
  exit 0
fi

if [ ${METRIC} = "accepted_conn" ]; then
  cat ${CACHE_FILE} | grep 'accepted conn: ' | awk '{print $3}'
  exit 0
fi
