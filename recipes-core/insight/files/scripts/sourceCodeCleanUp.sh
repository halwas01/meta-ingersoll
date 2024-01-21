#!/bin/sh
#*****************************************************************************
# MODULE      : Manufacturing support
#
# SUBSYSTEM   : 
#
# DESCRIPTION : Delete the source files for image creation
#
#*****************************************************************************
echo "\n***********************************************************************"
echo "\n                       DELETE THE SOURCE CODE                          "
echo "\n***********************************************************************"
echo "\n"

echo "\n\nEnter the source code directory \n"
cd /usr/src/ir/insight/Firmware

echo "\n\n Deleting source(*.c) files : \n"
#print the file names
find . -type f -iname '*.c'
#delete the files actually
find . -type f -iname '*.c' -delete

echo "\n\n Deleting source(*.cpp) files : \n"
#print the file names
find . -type f -iname '*.cpp'
#delete the files actually
find . -type f -iname '*.cpp' -delete

echo "\n\n Deleting source(*.h) files : \n"
#print the file names
find . -type f -iname '*.h'
#delete the files actually
find . -type f -iname '*.h' -delete

echo "\n\n Deleting source(*.hpp) files : \n"
#print the file names
find . -type f -iname '*.hpp'
#delete the files actually
find . -type f -iname '*.hpp' -delete

echo "\n\n Deleting Makefiles : \n"
#print the file names
find . -type f -iname 'Makefile'
#delete the files actually
find . -type f -iname 'Makefile' -delete

find . -type f -iname 'Makefile_SO'
find . -type f -iname 'Makefile_SO' -delete


echo "\n\n Deleting repo info files : \n"
#print the file names
find . -type f -iname '.MySCMServerInfo'
#delete the files actually
find . -type f -iname '.MySCMServerInfo' -delete

echo "\n\n Deleting all object files :\n"
#print the file names
find . -type f -iname '*.o'
#delete the files actually
find . -type f -iname '*.o' -delete

echo "\n\n Deleting all xlsx files :\n"
#print the file names
find . -type f -iname '*.xlsx'
#delete the files actually
find . -type f -iname '*.xlsx'  -delete

echo "\n\n Deleting all Includes directories :\n"
#print the file names
find . -type d -iname Includes
#delete the files actually
find . -type d -iname Includes  | xargs rmdir
find . -type d -iname Include
find . -type d -iname Include   | xargs rmdir
 
echo "\n\n Deleting all Source directories :\n"
#print the file names
find . -type d -iname Source
#delete the files actually
find . -type d -iname Source  | xargs rmdir
find . -type d -iname 'Sources'   | xargs rmdir

echo "\n\n Deleting all OBJ directories :\n"
#print the file names
find . -type d -iname OBJ
#delete the files actually
find . -type d -iname OBJ  | xargs rmdir

echo "\n\n Deleting all Test directories :\n"
find . -type d -iname 'Test'
find . -type d -iname 'Test'  | xargs rm -rf
find . -type d -iname 'UnitTest'  | xargs rm -rf

find . -type f -iname '*.project'
find . -type f -iname '*.project' -delete



echo "\n***********************************************************************"
echo "\n                       DONE WITH SOURCE CODE CLEANUP                   "
echo "\n***********************************************************************"
echo "\n"
