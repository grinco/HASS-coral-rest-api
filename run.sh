#!/usr/bin/env bashio

MODEL_URL=$(bashio::config "MODEL_URL")
LABELS_URL=$(bashio::config "LABELS_URL")

rm -f /app/coral.log
if bashio::config.true "ACCESS_LOG"; then
  ln -s /dev/stderr /app/coral.log
else
  ln -s /dev/null /app/coral.log
fi


mkdir /app/models

wget ${MODEL_URL} -O /app/models/model.tflite
wget ${LABELS_URL} -O /app/models/labels.txt

cd /app

echo "Starting the server..."
exec python3 /app/coral-app.py --model  "model.tflite" --labels "labels.txt" --models_directory "/app/models/"
