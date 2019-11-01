#!/usr/bin/env bash

set -e

if [ -x $(which python3) ]
then PYTHON=$(which python3)
elif [ -x $(which python2) ]
then PYTHON=$(which python2)
elif [ -x $(which python) ]
then PYTHON=$(which python)
else
    echo "No python install found; exiting"
    exit 1
fi

# Extract "host" argument from the input into HOST shell variable
eval "$($PYTHON -c 'import sys, json; print("HOST="+json.load(sys.stdin)["host"])')"

# TODO: pass the ssh key into this command
# Fetch the join command
CMD=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    core@$HOST sudo kubeadm token create --print-join-command)

# Produce a JSON object containing the join command
echo "{\"command\":\"$CMD\"}"
