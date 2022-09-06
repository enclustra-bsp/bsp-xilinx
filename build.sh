#!/usr/bin/env bash

if [[ "$(pwd)" = *" "* ]]
then
	echo -e "\033[0;31mYour EBE path contains spaces. Move it to a directory without spaces to proceed.\033[0m" 1>&2
	exit 1
fi

EBE_DEFAULT_RELEASE=v1.10
BUILDSCRIPTS_DIR=buildscripts

[[ $EBE_RELEASE ]] || EBE_RELEASE=$EBE_DEFAULT_RELEASE

# Will attempt to clone buildscripts repository...
if ! [[ -e "$BUILDSCRIPTS_DIR/.git" ]]; then
  git submodule init
  git submodule update $BUILDSCRIPTS_DIR
  git config submodule.$BUILDSCRIPTS_DIR.ignore all
  cd $BUILDSCRIPTS_DIR && git checkout $EBE_RELEASE && cd ..
  for s in $(ls sources/); do
    git config submodule.sources/$s.ignore all
  done
fi

./$BUILDSCRIPTS_DIR/build.py --release $EBE_RELEASE $@
