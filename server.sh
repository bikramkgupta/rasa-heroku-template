#!/bin/sh

if [ -z "$PORT" ]
then
  PORT=8080
fi

rasa run --enable-api --port $PORT