#!/bin/bash

MEMORY_SIZE="2024M"
PORT="3000:3000"

cd ~
kraft run --rm -p $PORT -M $MEMORY_SIZE node/express-app:latest