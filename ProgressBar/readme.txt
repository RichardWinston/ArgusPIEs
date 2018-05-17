ProgressBar PIE

by Richard B. Winston

Source code is available from Richard B. Winston (rbwinst@usgs.gov)
All functions are intended to be used only in export templates. The functions are visible in Developers_ProgressBar.dll but hidden in ProgressBar.dll. Otherwise, the two PIE's are identical.

The progress bar PIE allows you to display a progress bar during the export of a model that advances as the export progresses. It also has a label and a memo with which messages to the user can be displayed without halting the export process. The contents of the memo can be saved to a text file. The progress bar shows the elapsed time and gives an estimate of the time remaining to complete the export process.

Functions in the ProgressBar PIE

ProgressBarInitialize(Number, [Show_Cancel]) creates and shows the progress bar and sets the maximum position of the progress bar to Number. Initially the progress bar position is at 0. If Show_Cancel is true, an "Abort" button will be visible. This returns True if it suceeds.

ProgressBarFree() erases the frees the progress bar and frees all memory associated with the progress bar. This returns True if it suceeds.

ProgressBarMax(Number) sets the maximum value of the progress bar. This is also set in ProgressBarInitialize(Number). This function returns True if the Abort button has not been pressed and the function succeeds.

ProgressBarAdvance() increases the position of the progress bar by one. This function returns True if the Abort button has not been pressed and the function succeeds.

ProgressBarSetMessage(Message) sets the message in the label displayed in the progress bar to Message.  This function returns True if the Abort button has not been pressed and the function succeeds.

ProgressBarAddLine(Message) adds Message to the list of messages in the memo. This function returns True if the Abort button has not been pressed and the function succeeds.

ProgressBarSaveToFile(File_Name) saves the messages in the memo to a text file named File_Name and returns the number of lines in the file it saves.

Any function will fail if ProgressBarInitialize is not called first (except ProgressBarInitialize, of course)

If ProgressBarFree(), is not called at the end of the export process, the progress bar will remain visible after the export process is complete.

ProgressBarCheckVersion(First_Digit, Second_Digit, Third_Digit, Fourth_Digit) returns True if the version number of the PIE is greater than or equal to the version number passed in the arguments. The version number of the PIE may be checked by right clicking on Progressbar.dll, selecting "Properties" and going to the version information tab.

The following is an example export template that uses the ProgressBar PIE.

# 
# Initialize the progress bar. Set the maximum to the number of blocks
Evaluate expression: ProgressBarInitialize(NumBlocks())
# 
# Set the message shown in the progress bar
Evaluate expression: ProgressBarSetMessage("Exporting Blocks")
# 
Redirect output to: $BaseName$
	Loop for: Blocks
		# 
		# Advance the progress bar by one. At the end of the loop over blocks this function will have been called NumBlocks() times.
		Evaluate expression: ProgressBarAdvance()
		# 
		# make a test such as a test for an error condition
		If: Column()=Row()
			# 
			# If the test suceeds, add a message to the progress bar memo
			Evaluate expression: ProgressBarAddLine("Column: " + Column() + " = Row: " + Row())
		End if
	End loop
End file
# 
# save the messages in the progress bar memo to a file
Evaluate expression: ProgressBarSaveToFile("AFile")
# 
# get rid of the progress bar
Evaluate expression: ProgressBarFree()
