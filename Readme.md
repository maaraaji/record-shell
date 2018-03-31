# Record
---
#### Record your terminal commands and executes from anywhere anytime any number of times without hassle.
### **Installation**
1. Clone this git URL
>`$ git clone https://github.com/maaraaji/record-shell.git`
2. Navigate to cloned record-shell folder and give executable permission to install.sh using `chmod`
> `$ cd record-shell`  
`$ chmod +x ./install.sh`
3. Run the installer in your desired terminal.

**When you are using bash**
>`$ ./install.sh`  

**When you are using ZSH**
>`$ zsh ./instsall.sh`

4. It will ask for the home directory of record. By default it will set as home_directory/rcd-home but you can change it to whichever place you want

>To set default type **`d`**  
>To set manual type **`m`**, then it will ask you to enter the home directory name

5. Thats It all done. You are good to use **rcd** command


rcd will record your desired commands and make it as a single script 
```bash
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
```
