#!/bin/bash

if [[ -z $1 ]]; then
  echo "zipAssign -- zips DigiPen assignment from current directory"
  echo "Usage: zipAssign [name of outputfile]"
  exit 1
fi

if [[ -f $1 ]]; then
  rm $1
fi

rm -r ipch obj bin
rm *.user *.sdf

if [[ -d settings ]]; then
  cd settings
  rm *.user
  rm -r obj
fi

cp "$(cygpath "$CODEUTILS")/include/SuperCommon.h" include
zip -x premake4.lua *.zip *.sh -r $1."zip" *
rm include/SuperCommon.h
