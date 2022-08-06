#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Constants
UPDATER_URL="https://updater.craftlandia.com.br/v3/updates.json"
OLD_HASH="$(ls -Art intermediary | tail -n 1 | sed 's/\.tiny//')"

# CODE
UPDATER_FILE="$(curl --silent --insecure -s $UPDATER_URL)"
NEW_HASH="$(jq '.files.Farewell | .[] | select(contains({file: "1.5.2-CraftLandia.jar"})) | .hash' <<<"${UPDATER_FILE}" | sed 's/"//g')"

# if hash is different from last update, exit with error code 1
if [ "${NEW_HASH}" != "${OLD_HASH}" ]; then
    # if GITHUB_STEP_SUMMARY is set
    if [ -n "$GITHUB_STEP_SUMMARY" ]; then
        {
            echo "# CraftLandia Update"
            echo ""
            echo "| Old version Hash | New version Hash |"
            echo "| :--------------: | :--------------: |"
            echo "| $OLD_HASH | $NEW_HASH"
        } > "$GITHUB_STEP_SUMMARY"
    fi
    exit 1
fi
