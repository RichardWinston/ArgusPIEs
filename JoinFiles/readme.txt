Join Files PIE

Source code is available from Richard B. Winston (rbwinst@usgs.gov)
All functions are intended to be used only in export templates. The functions are visible in Developers_JoinFiles.dll but hidden in JoinFiles.dll. Otherwise, the two PIE's are identical.

Join_Files(First_File, Second_File, Result_File) appends Second_File to First_File and stores the result in Result_File

Delete_File(File_Name) deletes the file indicated by File_Name

Rename_File(Old_File_Name, New_File_Name) changes the name of a file from Old_File_Name to New_File_Name

Split_File('Input_File, First_File, Search_String, Second_File [, Search_String, Third_File]
  [, Search_String, Fourth_File]...[, Search_String, Thirtieth_File]) Splits a file into up to 30 sections. The input file is read one line at a time and saved to FirstFile. If Search_String is found in a line, FirstFile is closed and subsequent lines are saved in Second_File. If there are additional parameters (Search_String, Third_File, etc, the remainder of Input file will continue to be searched by occurences of the new Search_String.

Int2Str(Number) converts a number to its character representation in Base 36. (0, 1, ... , 9, A, B, ... Z, 10, 11, ... , 19, 1A, ....).

JF_CheckVersion(First_Digit, Second_Digit, Third_Digit, Fourth_Digit) returns True if the version number of the PIE is greater than or equal to the version number passed in the arguments. The version number of the PIE may be checked by right clicking on JoinFiles.dll, selecting "Properties" and going to the version information tab.