#!/usr/bin/env bashio

MODEL_URL=$(bashio::config "MODEL_URL")
LABELS_URL=$(bashio::config "LABELS_URL")

rm -f /app/coral.log
if bashio::config.true "ACCESS_LOG"; then
  ln -s /dev/stderr /app/coral.log
else
  ln -s /dev/null /app/coral.log
fi


mkdir /models

wget ${MODEL_URL} -O /models/model.tflite
wget ${LABELS_URL} -O /models/labels.txt

echo "Starting the server..."
exec python3 /app/coral-app.py --model  "model.tflite" --labels "labels.txt" --models_directory "/models"
