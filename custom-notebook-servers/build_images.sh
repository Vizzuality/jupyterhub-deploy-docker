#!/bin/bash

for d in custom-notebook-servers/*/ ; do
    f="$(basename -- $d)"
    echo "$f"
    docker build -t $f ./custom-notebook-servers/$f
done