#!/bin/bash

if [[ -z $1 ]]; then
  echo "testAssign -- unzips a zipped assignment to temp dir 'ASSIGN_TEST' and builds and runs it"
  echo "              deletes temp dir on compleation"
  echo "Usage: testAssign [ziped filename]"
  exit 1
fi

if ! [[ -f $1 ]]; then
  echo "File does not exist"
  exit 1
fi

rm -r ./ASSIGN_TEST
mkdir ./ASSIGN_TEST
cp $1 ./ASSIGN_TEST
cd ./ASSIGN_TEST
/cygdrive/c/Program\ Files/WinRAR/winrar x $1
rm $1

#make sure this is not required to build assign
export CODEUTILS=

for i in *.sln; do
  echo Building $i
  devenv $i /Runexit Release
done

read -rsp $'Press enter to continue...\n'
cd ..
rm -r ./ASSIGN_TEST
