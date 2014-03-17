ToolSet
=========

A set of helpful tools, particularly for DigiPen students.

I hope these are useful to ya'll!

##Requirements
1) Make sure you have [cygwin](http://cygwin.com/install.html) installed and cygwin/bin is in your path

2) Run SetWindowsEnv.bat to set up your environment variables correctly, this should only be done once.


Alternatively you can do this manually by creating environment variable CODEUTILS set to your installed folder without the final slash and putting the same value in your PATH variable
eg: CODEUTILS = C:\Users\Harrison\ToolSet

##COMMAND USAGE
Note: Commands require typing out 'bash [scriptname].sh [input]'

Note: These scripts assume windows with Visual Studio 2012 at the moment, I'm working on linux compatability as well


| zipAssign.sh | cleans dir of all junk files and zips current directory |
| ------------- | ----------- |
| Usage | zipAssign [name of outputfile] |
| EX: | bash zipAssign.sh CS120_student.name_2.zip |

| testAssign.sh | unzips a zipped file to temp dir, builds and runs it, deletes temp dir after prompt |
| ------------- | ----------- |
| Usage | testAssign [ziped filename] |
| EX: | bash testAssign.sh CS120_sutdent.name_2.zip |

| newProj.sh | Creates a new project folder and writes a default main/premake file for you with specifications |
| ------------- | ----------- |
| Usage | newProj [folder/exe name] |
| | optional: libraries to link [gmock, fmod, net, lua, opengl, glfw, dx11] |
| | optional: [winmain] |
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

###MY TODO LIST
* Linux Compatability
* Include file system library
* Include thread library
