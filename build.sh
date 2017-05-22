#!/usr/bin/env bash

BUILDSCRIPTS_RELEASE=v1.5
BUILDSCRIPTS_DIR=buildscripts

# Will attempt to clone buildscripts repository...
git submodule init
git submodule update $BUILDSCRIPTS_DIR

pushd $BUILDSCRIPTS_DIR &> /dev/null
git checkout $BUILDSCRIPTS_RELEASE &> /dev/null
git pull &> /dev/null
popd &> /dev/null

./buildscripts/build.py --release $BUILDSCRIPTS_RELEASE $@
