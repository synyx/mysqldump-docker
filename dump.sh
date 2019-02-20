#!/bin/bash

DB_USER=${DB_USER:-${MYSQL_ENV_DB_USER}}
DB_PASS=${DB_PASS:-${MYSQL_ENV_DB_PASS}}
DB_NAME=${DB_NAME:-${MYSQL_ENV_DB_NAME}}
DB_HOST=${DB_HOST:-${MYSQL_ENV_DB_HOST}}
ALL_DATABASES=${ALL_DATABASES}
IGNORE_DATABASE=${IGNORE_DATABASE}

BACKUP_MAX_AGE='2 weeks ago' #1 month ago

if [[ ${NAMESPACE} == "" ]]; then
  TARGET_PATH="/mysqldump/${DB_NAME}"
else
  TARGET_PATH="/mysqldump/${DB_NAME}_${NAMESPACE}"
fi

if [[ ${DB_USER} == "" ]]; then
	echo "Missing DB_USER env variable"
	exit 1
fi
if [[ ${DB_PASS} == "" ]]; then
	echo "Missing DB_PASS env variable"
	exit 1
fi
if [[ ${DB_HOST} == "" ]]; then
	echo "Missing DB_HOST env variable"
	exit 1
fi

if [[ ${DB_NAME} == "" ]]; then
  echo "Missing DB_NAME env variable"
  exit 1
fi

function cleanup {
  touch -d "$BACKUP_MAX_AGE" "${TARGET_PATH}/date_marker"
  TODEL=`find $TARGET_PATH \! -cnewer ${TARGET_PATH}/date_marker  -iname "${DB_NAME}*.sql"`
  for i in $TODEL;do
    rm $i
    echo -e "deleted $i\n"
  done
  rm $TARGET_PATH/date_marker
}

function dump {
  if [ ! -d $TARGET_PATH ];then
    echo "$TARGET_PATH does not exist. creating…"
    mkdir -p $TARGET_PATH
  fi

  TIMESTAMP=`date +%F_%H%M`
  TARGET_FILE="${TARGET_PATH}/${DB_NAME}_${TIMESTAMP}.sql"
  DUMP_CMD="mysqldump --user=\"${DB_USER}\" --password=\"${DB_PASS}\" --host=\"${DB_HOST}\" \"$@\" \"${DB_NAME}\" > $TARGET_FILE"

  echo -e "Dumping database: ${DB_NAME}\n"
  mysqldump --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" "$@" "${DB_NAME}" > $TARGET_FILE
  if [ $? -eq 0 ];then
    echo -e "succesfully created $TARGET_FILE\n"
    DUMP_RESULT='SUCCESS'
  else
    DUMP_RESULT='FAIL'
    if [ -e $TARGET_FILE ];then
      echo -e "removing failed backup: $TARGET_FILE\n"
      rm $TARGET_FILE
    fi
  fi
}

cleanup
dump

if [ $DUMP_RESULT == 'FAIL' ];then
  echo -e "backup creation failed!\naborting"
  exit 1
fi

echo -e "finished backup, good bye\n"
exit 0

