MODFLOW_ReadFileValue.dll is a function PIE for Argus ONE. It contains three functions.

Source code is available from Richard B. Winston (rbwinst@usgs.gov)

1. MODFLOW_RF_Get_Value_From_File(Key, Default_Value, [FileName])
"FileName" is an optional parameter. If "FileName" is not specified, "FileName" will be given the value of "Default.txt".
The function checks if it has already opened "FileName". If it hasn't, it reads "FileName" into memory. 
If "FileName" does not exist, it creates a new version of the "FileName" in memory.
It then checks for "Key" in "FileName". 
If any full line in "FileName" is equal to "Key", the next line is converted to a double-precision real number and returned as the result of RF_Get_Value_From_File.
If none of the lines in "FileName". is equal to "Key", the result of RF_Get_Value_From_File is "Default_Value".

2. MODFLOW_RF_Clear_Files() clears all files that it currently has in memory.

3. MODFLOW_RF_Save_Files() saves all files that it currently has in memory.

4. MODFLOW_RF_CheckVersion(First_Digit, Second_Digit, Third_Digit, Fourth_Digit) returns True if the version number of the PIE is greater than or equal to the version number passed in the arguments. The version number of the PIE may be checked by right clicking on the dll, selecting "Properties" and going to the version information tab.

Further Notes:
"FileName" can be either a fully qualified path name or just a file name. If it is just a file name, ReadFileValue.dll will look for "FileName" in the current directory.

The file that MODFLOW_ReadFileValue.dll will check must consist of alternating lines of Keys and numbers. The first line must be a key. Blank lines and comments are not allowed.

This PIE is primarily useful for allowing external parameter estimation programs such as UCODE to interact with Argus ONE.