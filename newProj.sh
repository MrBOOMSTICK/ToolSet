#!/bin/bash

####### PARAMS
directory=
userLibraries=
NumUserLibraries=0

##options
winmain=false

####LIBRARIES
#--OTHER
gmock=false
fmod=false
net=false

#--SCRIPTING
lua=false

#--GRAPHICS
opengl=false
GLFW=false
dx11=false

####### FUNCTIONS ########
function Copy
{
  echo $(basename $1)
  cp $1 $2
}

function MakeDir
{
  echo $1
  if [[ -d "$1" ]]; then
    return
  fi
  mkdir -m 700 $1
}

function WriteLib
{
  if [[ "$1" == true ]]; then
    echo -e "      \"$2\", " >> premake4.lua
  fi
}

function WriteIncludeParam
{
  outfile=$2
  if [[ "$1" == "true" ]]; then
    echo -e "\n//$3" >> $outfile
    shift
    shift
    shift
    for include in $*; do
      echo -e "#include \"$include\"" >> $outfile
    done
  fi
}

#passed the filename
function WriteInclude
{
  echo -e "#pragma once\n\n//Common Include and Macros\n#include \"SuperCommon.h\"\n" > $1

  if [[ "$net" == true ]]; then
    echo -e "//Networking Includes\n#if defined(_WIN32)\n  #include <winsock2.h>" >> $1
    echo -e "#elif defined(__APPLE__)" >> $1
    echo -e "#elif defined(__linux__)" >> $1
    echo -e "  #include <sys/socket.h>\n  #include <netinet/in.h>\n  #include <fcntl.h>" >> $1  
    echo -e "#endif" >> $1
  fi

  WriteIncludeParam $gmock $1 "GMock Includes" "gtest/gtest.h" "gmock/gmock.h"
  WriteIncludeParam $fmod $1 "Fmod Includes" "fmod.hpp" "fmod_errors.h" "fmod_codec.h" "fmod_dsp.h" "fmod_output.h"

  WriteIncludeParam $opengl $1 "OpenGl Includes" "glew.h" 
  WriteIncludeParam $GLFW $1 "GLFW Includes" "glfw.h"
  WriteIncludeParam $dx11 $1 "Direct3D 11 Includes" "dxgi.h" "d3dcommon.h" "d3d11.h" "d3dx11tex.h" "d3dx11async.h" "d3dx10math.h"

  WriteIncludeParam $lua $1 "Lua Includes" "lua.hpp"
}

#passed the filename
function WriteMain
{
  cd src
  echo -e "#include \"CommonPrecompiled.h\"" > $1
  echo -e "\n" >> $1
  ### TYPE OF MAIN
  if [[ "$winmain" == "true" ]]; then
    echo -e "int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)\n{" >> $1
  else
    echo -e "int main(int argc, char** argv)\n{" >> $1
  fi

  ##### WRITE MAIN BODY
  if [[ "$gmock" == "true" ]]; then
    echo -e "  testing::InitGoogleMock(&argc, argv);\n  int ret = RUN_ALL_TESTS();\n  system(\"pause\");\n  return ret;" >> $1
  else
    echo -e "  TODO(\"Write a program!\");\n  return 0;" >> $1
  fi

  ##### END OF MAIN
  echo -e "}\n" >> $1
  cd ..
}

function WritePremakeBase
{
  echo "

    defines{" >> premake4.lua

  if [[ "$gmock" == true ]]; then
    echo -e "    \"_VARIADIC_MAX=10\"," >> premake4.lua 
  fi
  
  ## INCLUDE DIRS
  cat "$(cygpath "$CODEUTILS")/defaults/premakeIncludeDirs" >> premake4.lua
  if [[ "$gmock" == true ]]; then
    echo -e "    \"\$(EXTERNALSROOT)/gmock-1.7.0/include\",
    \"\$(EXTERNALSROOT)/gmock-1.7.0/gtest/include\"," >> premake4.lua
  fi
  if [[ "$dx11" == true ]]; then
    echo -e "    \"\$(IncludePath)\"," >> premake4.lua
    echo -e "    \"\$(DXSDK_DIR)Include\"," >> premake4.lua
  fi
  
  ## LIB DIRS
  #debug
  cat "$(cygpath "$CODEUTILS")/defaults/premakeDBGLibDirs" >> premake4.lua  
  if [[ $gmock == true ]]; then
    echo -e "      \"\$(EXTERNALSROOT)/gmock-1.7.0/msvc/2012/\$(Configuration)\"," >> premake4.lua
  fi
  #release
  cat "$(cygpath "$CODEUTILS")/defaults/premakeReleaseLibDirs" >> premake4.lua  
  if [[ "$gmock" == true ]]; then
    echo -e "      \"\$(EXTERNALSROOT)/gmock-1.7.0/msvc/2012/\$(Configuration)\"," >> premake4.lua
  fi
  
  echo -e "      \"\$(CODEUTILS)/lib/\$(Configuration)\" }" >> premake4.lua
}

function WritePremakeProjectLIBHeader
{
  echo -e "
------------------------
------$1 LIB
------------------------
  project \"$1\"
    location \"settings\"
    language \"C++\"
    kind     \"StaticLib\"

    files  {\"src/CommonPrecompiled.cpp\", \"src/$1/**.cpp\", \"include/**.h\", \"include/**.hpp\" }" >> premake4.lua
  
  WritePremakeBase $1
}

function WritePremakeProjectEXEHeader
{
    echo -e "
------------------------
------EXE
------------------------
  project \"$1\"
    language \"C++\"
    kind     \"ConsoleApp\"

    files  {\"src/*.cpp\", \"include/**.h\", \"include/**.hpp\" }" >> premake4.lua

    ## LIBRARIES TO LINK
  echo "    links  { " >> premake4.lua
  WriteLib $gmock "gmock"
  WriteLib $lua "liblua52"
  WriteLib $fmod "fmodex_vc"

  counter=0
  while [[ $counter -lt $NumUserLibraries ]]; do
    echo -e "      \"${userLibraries[$counter]}\", " >> premake4.lua
    let counter=counter+1
  done

  #WINDOWS ONLY LIBRARIES
  echo -e "    }
    
    libdirs { \"lib/\" }
    if(os.get() == \"windows\") then
      debugenvs \"PATH=%PATH%;\$(ProjectDir)\"
      links { " >> premake4.lua

  WriteLib $net "wsock32"
  
  WriteLib $opengl "glew32"
  WriteLib $opengl "opengl32"
  WriteLib $opengl "glu32"
  WriteLib $GLFW "GLFW"

  WriteLib $dx11 "dxgi"
  WriteLib $dx11 "d3d11"
  WriteLib $dx11 "d3dx11"
  WriteLib $dx11 "d3dx10"

  if [[ "$dx11" == true ]]; then
    echo -e "    }\n      libdirs { \"\$(DXSDK_DIR)Lib/x86\" " >> premake4.lua
  fi

  #LINUX ONLY LIBRARIES
  echo -e "      }
    elseif(os.get() == \"linux\") then
      links { " >> premake4.lua

  WriteLib $opengl "GL"
  WriteLib $opengl "GLU"
  WriteLib $GLFW "GLFW"

  ## DEFINES
  echo "      }
    end" >> premake4.lua

    WritePremakeBase $1
}

function WritePremake
{
  echo -e "solution \"$1\"" > premake4.lua
  cat "$(cygpath "$CODEUTILS")/defaults/premakeConfigDef" >> premake4.lua
  echo "  startproject = $1;" >> premake4.lua

  WritePremakeProjectEXEHeader $1

  libCounter=0
  while [[ $libCounter -lt $NumUserLibraries ]]; do
    WritePremakeProjectLIBHeader ${userLibraries[$libCounter]}
    let libCounter=libCounter+1
  done
}

###### START SCRIPT #######
if [[ -z $1 ]]; then
  echo "newProj -- Creates a new project folder with default values"
  echo "Usage: newProj <folder/exe name> "
  echo "       [optional: libraries to link[gmock, fmod, net, lua, opengl, glfw, dx11]]"
  echo "       [optional: winmain]"
  echo "       [optional: Libraries to be written as part of this project]"
  echo "  Note: the 'net' library will ifdef winsock and unix includes"
  exit 1
fi

directory=$1
shift
##### PARSE INPUT ######
for arg in $*; do
  temp=false
  if [[ "$arg" == "winmain" ]]; then
    winmain=true
    temp=true
  fi

  if [[ "$arg" == "gmock" ]]; then
    gmock=true
    temp=true
  fi
  if [[ "$arg" == "fmod" ]]; then
    fmod=true
    temp=true
  fi
  if [[ "$arg" == "net" ]]; then
    net=true
    temp=true
  fi
  
  if [[ "$arg" == "lua" ]]; then
    lua=true
    temp=true
  fi

  if [[ "$arg" == "opengl" ]]; then
    opengl=true
    temp=true
  fi
  if [[ "$arg" == "glfw" ]]; then
    GLFW=true
    temp=true
  fi
  if [[ "$arg" == "dx11" ]]; then
    dx11=true
    temp=true
  fi
  

  if [[ "$temp" == false ]]; then
    echo "User Library $arg Found"
    userLibraries[NumUserLibraries]=$arg
    NumUserLibraries=$(($NumUserLibraries + 1))
  fi
done

##### DO THE HARD WORK ######
echo === Creating Directories
MakeDir $directory
MakeDir $directory/src
MakeDir $directory/include

counter=0
while [[ $counter -lt $NumUserLibraries ]]; do
  MakeDir $directory/src/${userLibraries[$counter]}
  MakeDir $directory/include/${userLibraries[$counter]}
  let counter=counter+1
done
echo -------Done!

echo === Writing default files
cd $directory

echo premake.lua
WritePremake $directory $userLibraries

echo SuperCommon.h
cp "$(cygpath "$CODEUTILS")/include/SuperCommon.h" include

echo CommonPrecompiled.h
cd include
WriteInclude "CommonPrecompiled.h"
cd ..

echo CommonPrecompiled.cpp
cd src
echo -e "#include \"CommonPrecompiled.h\"" > CommonPrecompiled.cpp
cd ..

echo Main.cpp
WriteMain "Main.cpp"

counter=0
while [[ $counter -lt $NumUserLibraries ]]; do
  echo ${userLibraries[$counter]}.cpp
  echo -e "#include \"CommonPrecompiled.h\"\nTODO(\"Write The ${userLibraries[$counter]} Library!\");" >> src/${userLibraries[$counter]}/${userLibraries[$counter]}.cpp
  let counter=counter+1
done
echo -------Done!

echo === Running Premake
premake vs2012
echo -------Done!