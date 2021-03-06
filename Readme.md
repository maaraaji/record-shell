# Record
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/maaraaji/record-shell/blob/master/LICENSE)
---
#### Record your terminal commands and executes from anywhere anytime any number of times without hassle.
### **Installation**
1. Clone this git URL
```bash
$ git clone https://github.com/maaraaji/record-shell.git
```
2. Navigate to cloned record-shell folder and give executable permission to install.sh using `chmod`
```bash
$ cd record-shell
$ chmod +x ./install.sh
```
3. Run the installer in your desired terminal.
```bash
#When you are using bash
$ ./install.sh

#When you are using ZSH
$ zsh ./instsall.sh
```
4. It will ask for the home directory of record. By default it will set as home_directory/rcd-home but you can change it to whichever place you want

```bash
To set default type d
To set manual type m, then it will ask you to enter the home directory name
```
>If you are installing it in zsh, please check if rcd-home/bin/cmd is correctly set to PATH as below,  
>`$ cat ~/.zshrc | grep "export PATH"`  
>This should show rcd-home/bin/cmd in PATH.  
>Check the PATH env variable as below and see if PATH have rcd-home/bin/cmd in it,  
>`$ env | grep PATH`  
>If env don't have rcd-home/bin/cmd in PATH but .zshrc have it, then type `source ~/.zshrc` to load the PATH variable.

5. Finally, type below commands to ensure rcd-home cmd directory is added to path to use rcd command  
```bash
# If bash environment
$ source ~/.bash_profile

# If zsh environemtn
$ source ~/.zshrc
```

6. Thats It all done. You are good to use ***rcd*** command


### **Usage:**

![record-shell](record-shell.gif)

***rcd*** will record your desired commands and make it as a single script 
>rcd [-s] [-a] [-d] [-e] [-h] [-q] [-l]  
[-v] **FILENAME** or **NUMBER**  
[-r] **Scriptname.sh**  
[-c] **SOURCE_FILE DIR/TARGET_FILE**  
[-x] **FILENAME** or **NUMBER**  
[-n] **SOURCE_FILE** **TARGET_FILE**


Options | Briefing
---|---
-s|Start the recording
-h|Record help or rcd usage
-e|End the recording 
-a|Record the last executed command to the recording script file
-d|Record the current working directory to the script file
-l|List of recorded script files. Highlighted file is the recording file if recording is running .
-v|View the recording script. With **FILENAME** or **NUMBER**, view the specific script file
-q|Current status of the recording
-r|Remove recorded empty script files. With **Scriptname.sh**,Remove the specified script file
-c|With **SOURCE_FILE** ***DIRECTORY/TARGET_FILENAME***, Export the SOURCE file as Your Directory/TARGET_FILENAME
-x|With **FILENAME** or **NUMBER**, Execute the specific script file
-n|With **SOURCE_FILE** ***TARGET_FILE***, Rename the recorded SOURCE file as TARGET filename
