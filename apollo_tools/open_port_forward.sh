#! /bin/bash

NODE=$1
PORT=$2
USER=<your_sussex_username>

lsof -ti:$PORT | xargs kill -9
ssh -f -N -L $PORT:node$NODE:$PORT $USER@janus.hpc.susx.ac.uk
