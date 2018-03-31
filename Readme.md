# Record - Record your terminal commands and executes from anywhere anytime any number of times without hassle.
---
rcd will record your desired commands and make it as a single script 

USAGE: 	rcd [-s] [-a] [-d] [-e] [-h] [-q] [-l] [-v] FILENAME or NUMBER [-r] Scriptname.sh [-c] SOURCE_FILE DIR/TARGET_FILE [-x] FILENAME or NUMBER [-n] SOURCE_FILE TARGET_FILE
 
	-s			Start the recording
 
	-h			Record help or rcd usage
 
	-e			End the recording
 
	-a			Record the last executed command to the recording script file
 
	-d			Record the current working directory to the script file
 
	-l			List of recorded script files. Highlighted file is the recording file if any.
 
	-v			View the recording script 
				With FILENAME or NUMBER, view the specific script file
 
	-q			Current status of the recording
 
	-r			Remove recorded empty script files 
				With Scriptname.sh, Remove the specified script file
 
	-c			With SOURCE_FILE DIR/TARGET_FILE, Export the SOURCE file as Your Directory/TARGET filename
 
	-x			With FILENAME or NUMBER, Execute the specific script file
 
	-n			With SOURCE_FILE TARGET_FILE, Rename the recorded SOURCE file as TARGET filename

