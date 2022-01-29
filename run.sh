#!/usr/bin/env bashio

MODEL_URL=$(bashio::config "model_url")
LABELS_URL=$(bashio::config "labels_url")

if bashio::config.true "access_log"; then
  ln -s /dev/stderr coral.log
else
  ln -s /dev/null coral.log
fi


mkdir /models

wget ${MODEL_URL} -O /models/model.tflite
wget ${LABELS_URL} -O /models/labels.txt

echo "Starting the server..."
exec python3 /app/coral-app.py --model  "model.tflite" --labels "labels.txt" --models_directory "/models"
