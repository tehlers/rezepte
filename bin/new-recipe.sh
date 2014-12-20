#! /usr/bin/env bash

# Ein Aufruf von bin/new-recipe.sh <Name des Rezeptes> legt im
# Verzeichnis _posts eine Datei für das Rezept an und befüllt
# swoeit möglich die Metadaten.
#

set -e

if (( $# != 1 )); then
    echo "Usage: new-recipe.sh <name of recipe>"
    exit 1
fi

RECIPES_DIR=$(dirname $0)/../_posts/
TITLE=$1
NORMALIZED_TITLE=$(echo ${TITLE,,} | sed -e 's-ä-ae-g' \
                                 -e 's-ö-oe-g' \
                                 -e 's-ü-ue-g' \
                                 -e 's-ß-ss-g' \
                                 -e 's-à-a-g' \
                                 -e 's-\ -\--g')
RECIPE_FILE="${RECIPES_DIR}$(date +%Y-%m-%d)-${NORMALIZED_TITLE}.md"

cat > $RECIPE_FILE <<EOF
---
title: "$TITLE"
date: $(date +"%Y-%m-%d %H:%M:%S")
categories: 
tags: 
---

## Zutaten

## Zubereitung

EOF
