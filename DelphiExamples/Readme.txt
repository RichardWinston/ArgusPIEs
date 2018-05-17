Instructions on how to create PIE's using Borland Delphi

1. Start Delphi.
2. From the File menu, select New and then select DLL.
3. Include any neccessary support files in the "uses" statements of your project.
4. Create any functions you need to call and use the cdecl calling convention with all functions whose addresses will be passed to Argus ONE.
5. Create a function named Get ANEfunctions using the form illustrated in the examples. Be sure to use the cdecl calling convention with it.
6. Define the PIE records you need in ANEfunctions 
7. In the project file include a statement 

exports GetANEFunctions;

after the uses statement.

8. Compile.

Debugging PIE's created with Borland Delphi

Method 1 Use integrated debugger

1. Make a copy of ArgusONE.dll and rename it ArgusONE.EXE. ArgusONE.dll is in the DatFiles directory.
Do not replace your existing ArgusONE.EXE with the version that is a copy of Argus ONE.dll. Instead, leave
the new version in the DatFiles directory.

2. Create a new directory in the DatFiles directory named ArgusPIE. 
3. Create the PIE's to be debugged in the ArgusPIE directory that is a subdirectory of the DatFiles directory.
4. In Delphi Select Run|Parameters.
5. In the parameter dialog box click the browse button and set the host application to the copy of ArgusONE.exe in the DatFiles directory.

Method 2 Use Turbo Debugger

1. Save TD32 information and use Borland Turbo debugger to debug.
 (Project|Options|Linker|Include TD32 debug information)
2. Start Turbo Debugger32
3.  Click F3 and enter the name of your dll.
4. Start Argus ONE.
5. After Argus ONE has started, attach to ArgusONE.dll.
6. From the File menu change to the directory with the source code of the PIE.
7. Click F3 and double click on your dll
8. Click F3 again and load the source files.
9. You can now set breakpoints in the dll.
