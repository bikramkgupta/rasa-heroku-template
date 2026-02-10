#!/bin/sh

if [ -z "$PORT" ]
then
  PORT=8080
fi

# Train the model if it doesn't exist
if [ ! -d "models" ] || [ -z "$(ls -A models 2>/dev/null)" ]
then
  echo "Training model..."
  rasa train nlu
fi

rasa run --enable-api --port $PORT