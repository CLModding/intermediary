#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Constants
UPDATER_URL="https://updater.craftlandia.com.br/v3/updates.json"

# CODE
UPDATER_FILE="$(curl --silent --insecure -s $UPDATER_URL)"
NEW_HASH="$(jq '.files.Farewell | .[] | select(contains({file: "1.5.2-CraftLandia.jar"})) | .hash' <<<"${UPDATER_FILE}" | sed 's/"//g')"

# if intermediary of hash exists, assume the version is up to date
if [ -f "intermediary/${NEW_HASH}.tiny" ]; then
echo "Amogus"
    curl "$UPDATE_WEB_HOOK" \
        -X 'PATCH' \
        -H 'Content-Type: application/json' \
        --data-raw '{"content":null,"embeds":[{"title":"CraftLandia Farewell - AntiHack Version","description":"AntiHack definitions are up-to-date.","color":2752256,"thumbnail":{"url":"https://i.imgur.com/Kgg9vCJ.png"}}],"username":"CLModding - Update Checker","avatar_url":"https://i.imgur.com/Kgg9vCJ.png","attachments":[]}' \
        --compressed
else
    curl "$UPDATE_WEB_HOOK" \
        -X 'PATCH' \
        -H 'Content-Type: application/json' \
        --data-raw "{\"content\":\"<@318033838330609665>\",\"embeds\":[{\"title\":\"CraftLandia Farewell - AntiHack Version\",\"description\":\"AntiHack definitions require an update\u0021\",\"color\":16711680,\"fields\":[{\"name\":\"New Version Hash\",\"value\":\"$NEW_HASH\"}],\"thumbnail\":{\"url\":\"https://i.imgur.com/Kgg9vCJ.png\"}}],\"username\":\"CLModding - Update Checker\",\"avatar_url\":\"https://i.imgur.com/Kgg9vCJ.png\",\"attachments\":[]}" \
        --compressed
fi
