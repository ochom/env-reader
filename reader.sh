#!/bin/bash

configName="$1:-./env-config.js"
envFile="$2:-./.env"

CONFIG_NAME=$configName
ENV_FILE=$envFile

# Add assignment 
echo "window._env_ = {" >  $CONFIG_NAME

# read lines in .env file and skip empty lines and comments
while IFS= read -r line || [ -n "$line" ]; do
    if [[ $line != \#* ]] && [[ $line != "" ]]; then
        # split line by "="
        IFS='=' read -ra ADDR <<< "$line"
        key=${ADDR[0]}
        value=${ADDR[1]}

        # if key in environment variables, use it
        if [[ -v $key ]]; then
            value=${!key}
        fi

        # add key value pair to config file
        echo "  $key: \"$value\"," >> $CONFIG_NAME
    fi
done < $ENV_FILE

# close config file
echo "}" >> $CONFIG_NAME