#!/usr/bin/env bash

BUILDSCRIPTS_REPOSITORY=https://github.com/enclustra-bsp/enclustra-buildscripts.git
BUILDSCRIPTS_BRANCH=module
BUILDSCRIPTS_DIR=buildscripts

if [[ ! -e $BUILDSCRIPTS_DIR ]]; then
  # Will attempt to clone buildscripts repository...
  git clone $BUILDSCRIPTS_REPOSITORY $BUILDSCRIPTS_DIR -b $BUILDSCRIPTS_BRANCH &> /dev/null
  if [[ ! $? -eq 0 ]]; then
    echo "Could not clone buildscripts repository."
    exit 1
  fi
else
  pushd $BUILDSCRIPTS_DIR &> /dev/null
  # Directory exists, checking if it is a valid git repository
  if [[ ! $(git remote -v) == *"$BUILDSCRIPTS_REPOSITORY"* ]]; then
    echo "There is something in the way. Please (re)move the" \
         "\"$BUILDSCRIPTS_DIR\" directory to continue."
    exit 1
  fi
  popd &> /dev/null
fi

pushd $BUILDSCRIPTS_DIR &> /dev/null
git pull &> /dev/null
popd &> /dev/null

./buildscripts/build.py $@
