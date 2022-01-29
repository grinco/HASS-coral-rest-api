#!/usr/bin/env bashio

MODEL_URL=$(bashio::config "MODEL_URL")
LABELS_URL=$(bashio::config "LABELS_URL")

MODEL_FILE=`echo ${MODEL_URL} | sed 's:.*/::'`
LABELS_FILE=`echo ${LABELS_URL} | sed 's:.*/::'`

rm -f /app/coral.log
if bashio::config.true "ACCESS_LOG"; then
  touch /config/coral_access.log
  ln -s /config/coral_access.log /app/coral.log
  echo "Logging to /config/coral_access.log"
else
  echo "Logging to /dev/null"
  ln -s /dev/null /app/coral.log
fi


mkdir -p /app/models

wget -q ${MODEL_URL} -O /app/models/${MODEL_FILE}
wget -q ${LABELS_URL} -O /app/models/${LABELS_FILE}

cd /app

echo "Starting the server..."
exec python3 /app/coral-app.py --model  "${MODEL_FILE}" --labels "${LABELS_FILE}" --models_directory "/app/models/"
