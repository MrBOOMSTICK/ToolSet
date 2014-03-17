ToolSet
=========

A set of helpful tools, particularly for DigiPen students.

I hope these are useful to ya'll!

##Before using scripts
Requirements
* [premake4](http://industriousone.com/premake/download) Wherever this exe is must be in your path.
* If you're on windows, [cygwin](http://cygwin.com/install.html)

Set environment variable CODEUTILS to this folder without the final slash
eg: CODEUTILS = C:\Users\Harrison\CodeUtils

I also recommend putting whatever value CODEUTILS has in your path for easy calling of scripts

##COMMAND USAGE
Note: Commands require typing out 'bash [scriptname].sh [input]'

zipAssign.sh -- cleans dir of all junk files and zips current directory
    Usage: zipAssign [name of outputfile]

testAssign.sh -- unzips a zipped assignment to temp dir 'Desktop/ASSIGN_TEST' builds and runs it
                 deletes temp dir on compleation"
    Usage: testAssign [ziped filename]

newProj.sh -- Creates a new project folder and writes a default main/premake file for you with specifications
  Usage: newProj <folder/exe name> "
         [optional: libraries to link[gmock, fmod, net, lua, opengl, glfw, dx11]]"
         [optional: winmain]"
         [optional: Libraries part of this project]"
           
###Windows Only
clean.bat -- cleans out directory of any build artifacts created by vs

prem.bat -- calls premake vs2012



###MY TODO LIST
* Make installer to set up environment properly
* Include file system library
* Include thread library
