#!/usr/bin/env bash
# -*- coding: utf-8 -*-

# Constants
UPDATER_URL="https://updater.craftlandia.com.br/v3/updates.json"

# CODE
UPDATER_FILE="$(curl --silent --insecure -s $UPDATER_URL)"
NEW_HASH="$(jq '.files.Farewell | .[] | select(contains({file: "1.5.2-CraftLandia.jar"})) | .hash' <<<"${UPDATER_FILE}" | sed 's/"//g')"

# if GITHUB_STEP_SUMMARY is set
if [ -n "$GITHUB_STEP_SUMMARY" ]; then

    {
        echo "# CraftLandia Update"
        echo ""
    } >"$GITHUB_STEP_SUMMARY"

    # if intermediary of hash exists, assume the version is up to date
    if [ -f "intermediary/${NEW_HASH}.tiny" ]; then
        {
            echo "Up to date!"
        } >>"$GITHUB_STEP_SUMMARY"
        exit 0
    else
        {
            echo "| New version Hash |"
            echo "| :--------------: |"
            echo "| $NEW_HASH |"
        } >>"$GITHUB_STEP_SUMMARY"
        exit 1
    fi
fi
