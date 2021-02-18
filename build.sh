#!/usr/bin/env bash

if [[ "$(pwd)" = *" "* ]]
then
	echo -e "\033[0;31mYour EBE path contains spaces. Move it to a directory without spaces to proceed.\033[0m" 1>&2
	exit 1
fi

EBE_DEFAULT_RELEASE=v1.8.2
BUILDSCRIPTS_DIR=buildscripts

# Will attempt to clone buildscripts repository...
if ! [[ -e "$BUILDSCRIPTS_DIR/.git" ]]; then
  git submodule init
  git submodule update $BUILDSCRIPTS_DIR
  git config submodule.buildscripts.ignore all
  for s in $(ls sources/); do
    git config submodule.sources/$s.ignore all
  done
fi

[[ $EBE_RELEASE ]] || EBE_RELEASE=$EBE_DEFAULT_RELEASE

./buildscripts/build.py --release $EBE_RELEASE $@
