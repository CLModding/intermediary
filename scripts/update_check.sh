#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# If CLMODDING_JARS is set
if [ -n "$CLMODDING_JARS" ]; then
    # If jars directory does not exist, clone it
    if [ -d "./jars" ]; then
        rm -rf ./jars
    fi
    
    git clone "$CLMODDING_JARS" ./jars
    
    if [ -f "./jars/latest.sh" ]; then
        # Change directory to jars
        cd jars && dos2unix latest.sh && chmod +x latest.sh && ./latest.sh   
        
        # Then change back to where we were
        cd ..    
    fi
    
    rm -rf jars
fi

# Setup ntfy CLI if not present
# First, check if ntfy is installed
# if ! command -v ntfy &> /dev/null
# then
#     wget https://github.com/binwiederhier/ntfy/releases/download/v2.7.0/ntfy_2.7.0_linux_amd64.tar.gz
#     tar zxvf ntfy_2.7.0_linux_amd64.tar.gz
#     sudo cp -a ntfy_2.7.0_linux_amd64/ntfy /usr/local/bin/ntfy
# fi

# Constants
UPDATER_URL="https://updater.craftlandia.com.br/v3/updates.json"

# CODE
UPDATER_FILE="$(curl --silent --insecure -s $UPDATER_URL)"
NEW_HASH="$(jq '.files."1.5" | .[] | select(contains({file: "1.5.2-CraftLandia.jar"})) | .hash' <<<"${UPDATER_FILE}" | sed 's/"//g')"

# if intermediary of hash exists, assume the version is up to date
if [ -f "intermediary/${NEW_HASH}.tiny" ]; then
    curl "$UPDATE_WEB_HOOK" \
        -X 'PATCH' \
        -H 'Content-Type: application/json' \
        --data-raw '{"content":null,"embeds":[{"title":"CraftLandia Farewell - AntiHack Version","description":"AntiHack definitions are up-to-date.","color":2752256,"thumbnail":{"url":"https://i.imgur.com/Kgg9vCJ.png"}}],"username":"CLModding - Update Checker","avatar_url":"https://i.imgur.com/Kgg9vCJ.png","attachments":[]}' \
        --compressed > /dev/null
else
    curl "$UPDATE_WEB_HOOK" \
        -X 'PATCH' \
        -H 'Content-Type: application/json' \
        --data-raw "{\"content\":\"<@318033838330609665>\",\"embeds\":[{\"title\":\"CraftLandia Farewell - AntiHack Version\",\"description\":\"AntiHack definitions require an update\u0021\",\"color\":16711680,\"fields\":[{\"name\":\"New Version Hash\",\"value\":\"$NEW_HASH\"}],\"thumbnail\":{\"url\":\"https://i.imgur.com/Kgg9vCJ.png\"}}],\"username\":\"CLModding - Update Checker\",\"avatar_url\":\"https://i.imgur.com/Kgg9vCJ.png\",\"attachments\":[]}" \
        --compressed > /dev/null
fi

# Write unix timestamp to file
date +%s > last_check

# Write NEW_HASH to file
echo "$NEW_HASH" > last_hash

git add .