ToolSet
=========

A set of helpful tools, particularly for DigiPen students.

I hope these are useful to ya'll!

##Included Library Versions (All 32-bit)
* Premake5
* FMOD Ex 4.06.03
* GLFW 3.0.4
* Lua 5.2

##Requirements
1) Make sure you have [cygwin](http://cygwin.com/install.html) installed and cygwin/bin is in your path

2) If you would like to use the Gmock option when creating projects, please download and build it (instructions at bottom of this readme) and enter its location into the environment variable EXTERNALSROOT (this will also help you with CS365 if you have not taken it at DigiPen yet).

3) Run SetWindowsEnv.bat to set up your environment variables correctly, this should only be done once.


Alternatively you can do this manually by creating environment variable CODEUTILS set to your installed folder without the final slash and putting the same value in your PATH variable
eg: CODEUTILS = C:\Users\Harrison\ToolSet

##COMMAND USAGE
Note: Commands require typing out 'bash [scriptname].sh [input]'

Note: These scripts assume windows with Visual Studio 2012 at the moment, I'm working on linux compatability as well


| zipAssign.sh | cleans dir of all junk files and zips current directory |
| ------------- | ----------- |
| Usage | zipAssign [name of outputfile] |
| EX: | bash zipAssign.sh CS120_student.name_2.zip |

| testAssign.sh | builds a zipped assign in temp dir testing to make sure it bulids without CODEUTILS set, deletes temp dir on completion |
| ------------- | ----------- |
| Usage | testAssign [ziped filename] |
| EX: | bash testAssign.sh CS120_sutdent.name_2.zip |

| newProj.sh | Creates a new project folder and writes a default main/premake file for you with specifications |
| ------------- | ----------- |
| Usage | newProj [folder/exe name] |
| | optional: libraries to link [gmock, fmod, net, lua, opengl, dx11] |
| | optional: [winmain, precompiled] |
| | optional: Libraries part of this project |
| EX: | bash newProj.sh myNewProject myLibrary gmock fmod opengl |
| EX: | bash newProj.sh myWindowsProject winmain myLibrary dx11 |
           
###Windows Only
| clean.bat | cleans out directory of everything but source |
| ------------- | ----------- |
| Usage | clean |

| prem.bat | Runs the command 'premake vs2012' |
| ------------- | ----------- |
| Usage | prem |

###GMOCK NOTE
When using Gmock the project is automatically set to be static-linking. This causes Visual Leak Detector (vld) to find leaks that are not in your code. I am looking into this but if you find a solution please let me know!

###MY TODO LIST
* Linux Compatability
* Include file system library
* Include thread library

###GMOCK HELP GUIDE
Download [Gmock](https://code.google.com/p/googlemock/downloads/list). The newProj script expects version 1.7.0 so if your version is newer you may easily change this at the top of that script. To build gmock make sure to set C/C++ > Code Generation > Runtime Library to MT and MTd. For VS2012 set the Preprocessor define _VARIADIC_MAX=10. This should make everything build correctly. After it is built, set the environment variable EXTERNALSROOT to the base install folder without the trailing slash so that %EXTERNALSROOT%/gmock-1.7.0/ expands correctly