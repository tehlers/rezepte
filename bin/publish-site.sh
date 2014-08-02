#! /usr/bin/env bash

# Ein Aufruf von bin/publish-site.sh klont das aktuelle Repository von
# Github, wechselt in den Branch 'master', generiert die Seite und
# veröffentlicht sie anschließend im Branch 'gh-pages'.
#
# Alle Schritte werden innerhalb des Repositories mit Tags und sinnvollen
# Commit-Messages protokolliert.

set -e

WORK_DIR=$(mktemp -d)
REPOSITORY="git@github.com:tehlers/rezepte.git"
CLONE_DIR=$WORK_DIR/rezepte
BUILD_DIR=$WORK_DIR/site

trap "rm -rf $WORK_DIR" SIGINT SIGTERM

# Aktuelles Repository von Github klonen

cd $WORK_DIR
git clone $REPOSITORY

# Generierung der Seite aus dem Branch 'master' mit Jekyll

cd $CLONE_DIR
git checkout master
jekyll build -d $BUILD_DIR

# Protokollierung der Änderungen
DATE=$(date +%Y-%m-%d)
TAG="Published_"$DATE"_"$(git log -n 1 --pretty=format:"%h")
CHANGELOG=$(git shortlog $(git describe --abbrev=0 --match "Published_*")..)
COMMIT_MESSAGE=$(git log -n 1 --pretty=format:"New release (%h)%n%nGenerated from branch 'master' at %H%n%nCHANGELOG")$'\n'$'\n'$CHANGELOG

# Kopieren der generierten Seite in den Branch 'gh-pages'

git checkout gh-pages
find . -type f -not -path '*\.git*' | xargs rm
find . -mindepth 1 -type d -not -path '*\.git*' | xargs rmdir --ignore-fail-on-non-empty
cp -r $BUILD_DIR/* $CLONE_DIR

# Veröffentlichung der neu generierten Seite

git add --all
git commit -m "$COMMIT_MESSAGE"
git push

# Tags erstellen

git checkout master
git tag -a -m "Published on $DATE" $TAG
git push --tags

# Aufräumen
rm -rf $WORD_DIR
