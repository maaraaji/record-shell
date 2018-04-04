
# Initialization of global variables
# New Line + Tab + Bold
NTB="\n\t$(tput bold)"
# Normal + Tab + Dash + Tab
NTDT="$(tput sgr0)\t\t\t"
# Bold
BLD="$(tput bold)"
# Normal
NRM="$(tput sgr0)"
# Underline
UND="$(tput smul)"
# Record Configuration file
RCF="${HOME}/rcd-home/bin/record.config"
# Record Scripts Directory
RSD="${HOME}/rcd-home/rcd-scripts/"
# Command Name
CMD_NAME=$(basename ${0})
# Echo extended
if [[ $(ps -p $$) =~ "bash" ]]; then
    EEXT="-e"
else
    EEXT=""
fi
# SED empty argument if executing in Mac OSX
if [[ $(echo ${TERM_PROGRAM}) =~ "Apple_Terminal" ]]; then
    SEDE="''"
elif [[ $(echo ${TERM_PROGRAM}) =~ "iTerm.app" ]]; then
    SEDE="''"
fi

# USAGE="\n${BLD}${UND}$(basename ${0})${NRM} will record your desired commands and make it as a single script
#     \n\nUSAGE:
#     ${BLD}\trcd ([-start] [-ab] [-dir] [-shs] [-ls] [-status] [-stop] [-rmes])${NRM}\n
#     ${NTB}-start${NTDT}To start the recording
#     ${NTB}-ab${NTDT}To record the previous last command to the script file
#     ${NTB}-dir${NTDT}To record the current working directory to the script file
#     ${NTB}-shs${NTDT}To show the recorded script so far
#     ${NTB}-ls${NTDT}To show the list of recorded script filenames
#     ${NTB}-status${NTDT}To print the current status of the recording
#     ${NTB}-stop${NTDT}To finish recording of the script
#     ${NTB}-rmes${NTDT}To remove recorded empty script files\n"
USAGE="\n${BLD}${UND}$(basename ${0})${NRM} will record your desired commands and make it as a single script
    \n\nUSAGE:
    ${BLD}\trcd${NRM} [-s] [-a] [-d] [-e] [-h] [-q] [-l] [-v] ${UND}${BLD}FILENAME${NRM} or ${UND}${BLD}NUMBER${NRM} [-r] ${UND}${BLD}Scriptname.sh${NRM} [-c] ${UND}${BLD}SOURCE_FILE${NRM} ${UND}${BLD}DIR/TARGET_FILE${NRM}${BLD} [-x] ${UND}${BLD}FILENAME${NRM} or ${UND}${BLD}NUMBER${NRM} [-n] ${UND}${BLD}SOURCE_FILE${NRM} ${UND}${BLD}TARGET_FILE${NRM}\n
    ${NTB}-s${NTDT}Start the recording\n
    ${NTB}-h${NTDT}Record help or rcd usage\n
    ${NTB}-e${NTDT}End the recording\n
    ${NTB}-a${NTDT}Record the last executed command to the recording script file\n
    ${NTB}-d${NTDT}Record the current working directory to the script file\n
    ${NTB}-l${NTDT}List of recorded script files. Highlighted file is the recording file if recording is running.\n
    ${NTB}-v${NTDT}View the recording script
    ${NTB}${NTDT}With ${UND}${BLD}FILENAME${NRM} or ${UND}${BLD}NUMBER${NRM}, view the specific script file\n
    ${NTB}-q${NTDT}Current status of the recording\n
    ${NTB}-r${NTDT}Remove recorded empty script files
    ${NTB}${NTDT}With ${UND}${BLD}Scriptname.sh${NRM}, Remove the specified script file\n
    ${NTB}-c${NTDT}With ${UND}${BLD}SOURCE_FILE${NRM} ${UND}${BLD}DIR/TARGET_FILE${NRM}, Export the SOURCE file as Your Directory/TARGET filename\n
    ${NTB}-x${NTDT}With ${UND}${BLD}FILENAME${NRM} or ${UND}${BLD}NUMBER${NRM}, Execute the specific script file\n
    ${NTB}-n${NTDT}With ${UND}${BLD}SOURCE_FILE${NRM} ${UND}${BLD}TARGET_FILE${NRM}, Rename the recorded SOURCE file as TARGET filename\n"
ST="NO"
AD="NO"
FN=""

# Segregating each options as seperate function
function getRecordFilename() {
    FN=$(grep "FN" ${RCF} | cut -d " " -f 2)
    # FN=$(grep -oh "\w*.sh\w*" "${RCF}")
    # echo ${EEXT} "Getting the filename ${FN}"
}

# Initializing record.config if not available already
function initRecordConfig() {
    AVAIL_CONFIG=$(cat ${RCF})
    if [[ ${AVAIL_CONFIG} = "" ]]; then
        echo "ST ${ST}" > ${RCF}
        echo "AD ${AD}" >> ${RCF}
        echo "FN ${FN}" >> ${RCF}
        # echo "H${AVAIL_CONFIG}E"
    fi
}

# If validated as the recording needs to be started then modify the start configuration and provided the new filename
function recordStart() {
    ST="YES"
    FN="${RSD}myscript$(echo $(date +%s)${RANDOM}).sh"
    if [[ ! -d "${RSD}" ]]; then
        mkdir "${RSD}"
    fi
    touch "${FN}"
    sed -i ${SEDE} "s|^ST.*|ST ${ST}|g;" ${RCF}
    sed -i ${SEDE} "s|^FN.*|FN ${FN}|g;" ${RCF}
    return
}

# If user given start as an argument
function startAsOption() {
    # If the start configuration is already set.
    if [[ ! -f "${RCF}" ]]; then
        touch "${RCF}"
    fi
    if [[ $(cat ${RCF}) = "" ]]; then
        initRecordConfig
    fi
    if [[ $(grep "ST" "${RCF}") =~ YES ]]; then
        getRecordFilename
        echo ${EEXT} "\nYour recording is already started and saving to the file name ${BLD}${FN}${NRM}\n"
        exit 1
    else 
        # If the start configuration is not set
        ST="YES"
        recordStart
        echo ${EEXT} "\nYou have started the recording.
        \nYour script filename is ${BLD}${FN}${NRM}\n"
        # if [[ $(grep "AD" "${RCF}") =~ "NO" ]]; then
        #     echo ${EEXT} "Not recording directory automatically. To enable it\nstart recording with \"-ad\" as option\n"
        # fi
    fi
    return
}

# If the user wants to record the previous command to his script file
function aboveAsOption() {
    statusAsOption >/dev/null
    if [[ ${?} -ne 1 ]]; then
        getRecordFilename
        PREV_CMD=$(history 2 | head -n1 | cut -c 8-)
        echo ${EEXT} "\nAdded => ${PREV_CMD}\n"
        echo "=======================> Executing ${PREV_CMD}"
        echo "${PREV_CMD}" >> ${FN}
        return
    else
        echo ${EEXT} "\nRecord not started. Start the recording using ${BLD}${CMD_NAME} -s${NRM} to record the command\n"
    fi
}

# If the user wants to record the current directory to his script file
function dirAsOption() {
    statusAsOption >/dev/null
    if [[ ${?} -ne 1 ]]; then
        getRecordFilename
        CURRENT_DIR=$(pwd)
        echo "cd ${CURRENT_DIR}" >> ${FN}
        echo ${EEXT} "\nAdded => cd ${CURRENT_DIR}\n"
        return
    else
        echo ${EEXT} "\nRecord not started. Start the recording using ${BLD}${CMD_NAME} -s${NRM} to record the directory\n"
    fi
}

# If the user wants to know the status of record. If running or not running 
function statusAsOption() {
    if [[ ! -f "${RCF}" ]]; then
        echo ${EEXT} "\nRecord haven't started ever. Start the recording using ${BLD}${CMD_NAME} -s${NRM} \n"
        echo ${EEXT} ${USAGE}
        return 1
    elif [[ $(cat ${RCF}) = "" ]]; then
        echo ${EEXT} "\nRecord haven't started ever. Start the recording using ${BLD}${CMD_NAME} -s${NRM} \n"
        echo ${EEXT} ${USAGE}
        return 1
    elif [[ $(grep "ST" ${RCF}) = "" ]]; then
        echo ${EEXT} "\nRecord haven't started ever. Start the recording using ${BLD}${CMD_NAME} -s${NRM} \n"
        echo ${EEXT} ${USAGE}
        return 1
    elif [[ $(grep "ST" ${RCF}) =~ "NO" ]]; then
        echo ${EEXT} "\nRecord not started.\n"
        return 1
    elif [[ $(grep "ST" ${RCF}) =~ "YES" ]]; then
        getRecordFilename
        echo ${EEXT} "\nRecord running"
        echo ${EEXT} "\nYour recorded script: $(tput bold)${FN}\n$(tput sgr0)"
        return 0
    fi
}

# If the user wants to stop the recording
function endAsOption() {
    ST="NO"
    if [[ $(grep "ST" ${RCF}) =~ "NO" ]]; then
        echo ${EEXT} "\nRecord not started.\n"
        exit 1
    fi
    if [[ $(grep "ST" ${RCF}) =~ "YES" ]]; then
        sed -i ${SEDE} "s|^ST.*|ST ${ST}|g" ${RCF}
        echo ${EEXT} "\nRecord Stopped\n"
    fi
    return
}

# Show the so far recorded script
function showScriptAsOption() {
    getRecordFilename
    if [[ ! "${FN}" = "" ]]; then
        if [[ ! -f ${FN} ]]; then
            echo ${EEXT} "\nNothing to view. Either recently recorded script got renamed or record never started!\n"
        else
            echo ${EEXT} "\n$(cat ${FN})"
            echo ${EEXT} "\n${BLD}at ${FN}${NRM}\n"
        fi
    else
        echo ${EEXT} "\nRecord not running.\n"
    fi
    return
}

# Show the recoreded specific script asked by the user through argument
function showSpecificScriptAsOption() {
    FILE_TO_SHOW=${1}
    if [[ $(echo ${FILE_TO_SHOW} | grep ".sh") = "" ]]; then
        FILE_NAME=$(ls -ltrh ${RSD} | nl -b p[.*sh] -n ln | grep "^${FILE_TO_SHOW}" | sed 's|.* ||g')
        echo ${EEXT} "\n************${BLD}at $(basename ${FILE_NAME})${NRM}************"
        echo ${EEXT} "\n$(cat ${RSD}${FILE_NAME} | nl -n ln)"
        echo ${EEXT} "\n************${BLD}at ${RSD}${NRM}************\n"
    elif [[ $(basename ${FILE_TO_SHOW}) = ${FILE_TO_SHOW} ]]; then
        if [[ ! -f "${RSD}${FILE_TO_SHOW}" ]]; then
            echo ${EEXT} "\nScript file ${BLD}${FILE_TO_SHOW}${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n" 
        else
            echo ${EEXT} "\n**************${BLD}${FILE_TO_SHOW}${NRM}***************"
            echo ${EEXT} "\n$(cat ${RSD}${FILE_TO_SHOW})\n"
            echo ${EEXT} "**************${BLD}at ${RSD}${NRM}****************\n"
            # echo ${EEXT} "\n${BLD}at ${RSD}${FILE_TO_SHOW}${NRM}\n"
        fi
    else
        echo "************${BLD}at $(basename ${FILE_TO_SHOW})${NRM}************"
        echo ${EEXT} "\n$(cat ${FILE_TO_SHOW})"
        echo ${EEXT} "\n************${BLD}at $(dirname ${FILE_TO_SHOW})${NRM}************"
    fi
}

# Show the list of the recorded script files
function listFilesAsOption() {
    LIST_OF_FILES_AFTER_HIGHLIGHT=""
    getRecordFilename
    if [[ ! -d ${RSD} ]]; then
        echo ${EEXT} "\nRecord haven't started ever. Start the recording using ${BLD}${CMD_NAME} -s${NRM} \n"
        exit 1
    fi
    LIST_OF_FILES=$(ls -ltrh ${RSD} | nl -b p[.*sh] -n ln)
    statusAsOption >/dev/null
    if [[ ${?} -ne 1 ]]; then
        echo ${EEXT} "\nRecord is running and can store the script to the highlighted file"
        LIST_OF_FILES_AFTER_HIGHLIGHT=$(echo "${LIST_OF_FILES/$(basename ${FN})/${BLD}$(basename ${FN})${NRM}}")
    fi
    if [[ $(echo ${LIST_OF_FILES_AFTER_HIGHLIGHT}) = "" ]]; then
        echo ${EEXT} "\n${LIST_OF_FILES}\n"
    else
        echo ${EEXT} "\n${LIST_OF_FILES_AFTER_HIGHLIGHT}\n"
    fi
    return
}

# To remove the recorded script files which are empty from the recorded scripts directory
function removeEmptyFilesAsOption() {
    getRecordFilename
    IS_THERE_AN_EMPTY_FILE=$(find $(dirname ${FN}) -empty -type f)

    if [[ ${IS_THERE_AN_EMPTY_FILE} = "" ]]; then
        echo ${EEXT} "\n${BLD}No empty script file(s) found.${NRM}"
    elif [[ $(grep "ST" ${RCF}) =~ "YES" ]] && [[ ${IS_THERE_AN_EMPTY_FILE} =~ ${FN} ]]; then
        echo ${EEXT} "\nRecord is running and recording to ${BLD}$(basename ${FN})${NRM} which is an empty file.\nStop the recording using ${BLD}${CMD_NAME} -e${NRM} and then try removing the file\n"
    else
        $(find $(dirname ${FN}) -empty -type f -delete)
        echo ${EEXT} "\n${BLD}Removed all empty script files. Available script files are as below.${NRM}"
        listFilesAsOption
    fi
}

# To remove specific recorded script either with filename or the number given listed during rcd -l
function removeSpecificFileAsOption() {
    FILE_TO_DEL=${1}
    getRecordFilename
    if [[ $(basename ${FILE_TO_DEL}) = ${FILE_TO_DEL} ]]; then
        if [[ $(grep "ST" "${RCF}") =~ "YES" ]] && [[ $(basename ${FN}) = ${FILE_TO_DEL} ]] ; then
            echo ${EEXT} "\nRecord is running and recording to ${BLD}$(basename ${FN})${NRM}.\nStop the recording using ${BLD}${CMD_NAME} -e${NRM} and then try removing the file\n"
        elif [[ ! -f "${RSD}/${FILE_TO_DEL}" ]]; then
            echo ${EEXT} "\nScript file ${BLD}${FILE_TO_DEL}${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n"
        else
            rm -rf  ${RSD}/${FILE_TO_DEL}
            echo ${EEXT} "\nRemoved the script file ${BLD}${RSD}${FILE_TO_DEL}${NRM}\n"
            echo ${EEXT} "List of files at rcd-scripts directory after removal:"
            listFilesAsOption
        fi
    elif [[ $(grep "ST" ${RCF}) =~ "YES" ]] && [[ ${FILE_TO_DEL} = ${FN} ]]; then
        echo echo ${EEXT} "\nRecord is running and recording to ${BLD}$(basename ${FN})${NRM}.\nStop the recording using ${BLD}${CMD_NAME} -e${NRM} and then try removing the file\n"
    elif [[ ! -f ${FILE_TO_DEL} ]]; then
        echo ${EEXT} "\nScript file ${BLD}$(basename ${FILE_TO_DEL})${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n"
        exit 1
    else
        rm -rf ${FILE_TO_DEL}
        echo ${EEXT} "\nRemoved this file ${BLD}${FILE_TO_DEL}${NRM}"
    fi
}

# Exporting the script from rcd's script directory to the user desired directory
function exportFileAsOption() {
    FILE_TO_EXPORT=${1}
    WHERE_TO_EXPORT=${2}
    # echo "${1} S ${2} E"
    if [[ $(basename ${FILE_TO_EXPORT}) =  ${FILE_TO_EXPORT} ]]; then
        if [[ ! -f ${RSD}${FILE_TO_EXPORT} ]]; then
            echo ${EEXT} "\nScript file ${BLD}${FILE_TO_EXPORT}${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n"
            exit 1
        else
            echo ${EEXT} "\nExporting the file ${BLD}${FILE_TO_EXPORT}${NRM} from the directory ${BLD}${RSD}${NRM}\n"
            cp ${RSD}${FILE_TO_EXPORT} ${WHERE_TO_EXPORT}
            echo ${EEXT} "\nDone!\n"
        fi
    else
        echo ${EEXT} "\nExporting the file ${BLD}$(basename ${FILE_TO_EXPORT})${NRM} from the directory ${BLD}$(dirname ${FILE_TO_EXPORT})${NRM} to ${BLD}${WHERE_TO_EXPORT}${NRM}\n"
        cp ${FILE_TO_EXPORT} ${WHERE_TO_EXPORT}
        echo ${EEXT} "\nDone!\n"
    fi
}

# Executing the rcd recorded script files with filename or number listed as per rcd -l results
function executeFileAsOption() {
    FILE_TO_EXEC=${1}
    if [[ $(echo ${FILE_TO_EXEC} | grep ".sh") = "" ]]; then
        FILE_NAME=$(ls -ltrh ${RSD} | nl -b p[.*sh] -n ln | grep "^${FILE_TO_EXEC}" | sed 's|.* ||g')
        sh ${RSD}${FILE_NAME}
    elif [[ $(basename ${FILE_TO_EXEC}) = ${FILE_TO_EXEC} ]]; then
        if [[ ! -f ${RSD}${FILE_TO_EXEC} ]]; then
            echo ${EEXT} "\nScript file ${BLD}${FILE_TO_EXPORT}${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n"
            exit 1
        else
            echo ${EEXT} "\nExecuting the file ${BLD}${FILE_TO_EXPORT}${NRM} from the directory ${BLD}${RSD}${NRM}\n"
            sh ${RSD}${FILE_TO_EXEC}
            echo ${EEXT} "\nDone!\n"
        fi
    else
        echo ${EEXT} "\nExecuting the file ${BLD}$(basename ${FILE_TO_EXPORT})${NRM} from the directory ${BLD}$(dirname ${FILE_TO_EXPORT})${NRM} to ${BLD}${WHERE_TO_EXPORT}${NRM}\n"
        sh ${FILE_TO_EXEC}
        echo ${EEXT} "\nDone!\n"
    fi
}

# Renaming the default script named generated by rcd to user desired name
function renameFileAsOption() {
    FILE_TO_RENAME=${1}
    RENAME_NAME=${2}
    getRecordFilename
    if [[ RENAME_NAME = "" ]]; then echo ${EEXT} "\nEnter the name that your script needs to be renamed to \n"; exit 1; fi
    if [[ $(basename ${FILE_TO_RENAME}) = ${FILE_TO_RENAME} ]]; then
        if [[ $(grep "ST" "${RCF}") =~ "YES" ]] && [[ ${FILE_TO_RENAME} = $(basename ${FN}) ]] ; then
            echo ${EEXT} "\nRecord is running and recording to ${BLD}$(basename ${FN})${NRM}.\nStop the recording using ${BLD}${CMD_NAME} -e${NRM} and then try renaming the file\n"
        elif [[ ! -f ${RSD}${FILE_TO_RENAME} ]]; then
            echo ${EEXT} "\nScript file ${BLD}${FILE_TO_EXPORT}${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n"
            exit 1
        else
            echo ${EEXT} "\nRenaming the file ${BLD}${RSD}${FILE_TO_RENAME}${NRM} to ${BLD}${RSD}${RENAME_NAME}${NRM}\n"
            mv ${RSD}${FILE_TO_RENAME} ${RSD}${RENAME_NAME}
            echo ${EEXT} "\nDone!\n"
        fi
    elif [[ $(grep "ST" ${RCF}) =~ "YES" ]] && [[ ${FILE_TO_RENAME} = ${FN} ]]; then
        echo ${EEXT} "\nRecord is running and recording to ${BLD}$(basename ${FN})${NRM}.\nStop the recording using ${BLD}${CMD_NAME} -e${NRM} and then try renaming the file\n"
    elif [[ ! -f ${FILE_TO_RENAME} ]]; then
        echo ${EEXT} "\nScript file ${BLD}$(basename ${FILE_TO_RENAME})${NRM} doesn't exist in the directory ${BLD}${RSD}${NRM}\n"
        exit 1
    else
        echo ${EEXT} "\nRenaming the file ${BLD}${FILE_TO_RENAME}${NRM} to ${BLD}$(dirname ${FILE_TO_RENAME})/$(basename ${RENAME_NAME})${NRM}\n"
        mv ${FILE_TO_RENAME} "$(dirname ${FILE_TO_RENAME})/$(basename ${RENAME_NAME})"
        echo ${EEXT} "\nDone!\n"
    fi
        
}

# NOT IMPLEMENTED
function autodirAsOption() {
    # echo "You choose to record the directory automatically for each command that you record going forward until record -fn"
    if [[ $(grep "AD" "${RCF}") =~ YES ]]; then
        echo ${EEXT} "\nAuto Recording of the directory already enforced\n"
    else
        AD="YES"
        sed -i ${SEDE} "s/^AD.*/AD ${AD}/g" "${RCF}"
        echo ${EEXT} "\nEnforcing autorecording of directory for all the recording commands. It will record the directory automatically until record -end\n"
    fi
}

#NOT IMPELEMENTED
function manudirAsOption() {
    AD="NO"
    sed -i ${SEDE} "s/^AD .*/AD ${AD}/g" "${RCF}"
    echo "Enfornced manual recording. You can record the directory by typing \"pwd && record -ab\""
}

# If user needs help
function helpAsOption() {
    echo ${EEXT} ${USAGE}
    exit 1
    return
}

# If user haven't supplied any options
function nothingAsOption() {
    echo ${EEXT} ${USAGE}
    exit 1
}

# Check Record has started ever if not advise the option to start. If started but config removed, ask the user to start it again
function passStartCheck() {
    if [[ ! -f "${RCF}" ]]; then
        echo ${EEXT} "\nStart the recording first using $(tput bold)${CMD_NAME} -s$(tput sgr0) \n"
        echo ${EEXT} ${USAGE}
        exit 1
    fi
    AVAIL_CONFIG=$(cat "${RCF}")
    if [[ ${AVAIL_CONFIG} = "" ]]; then
        echo ${EEXT} "\n$(tput bold)Start the recording first$(tput sgr0) \n"
        echo ${EEXT} ${USAGE}
        exit 1
    fi
}

# Iterating through the given option
# if [[ $# -eq 0 ]]; then nothingAsOption; fi
# VALID_OPTION=0
# for X in $@; do
#     if [[ ${X} = '-start' ]]; then startAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-ab' ]]; then passStartCheck; aboveAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-dir' ]]; then dirAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-stop' ]]; then passStartCheck; endAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-help' ]]; then helpAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-status' ]]; then statusAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-shs' ]]; then showScriptAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-ls' ]]; then listFilesAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-exps' ]]; then exportScriptAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = '-rmes' ]]; then removeEmptyFilesAsOption; VALID_OPTION=1; fi
#     if [[ ${X} = "" ]]; then helpAsOption; VALID_OPTION=1; fi
# done
# if [[ ${VALID_OPTION} -eq 0 ]]; then echo ${EEXT} "\n${BLD}Invalid Input.${NRM}"; helpAsOption; fi

# Iterating through getopts
GIVEN_OPTIONS=${1}
while getopts :sadehqnlc:v:x:r: opt "$@"; do
    case ${opt} in
        # b for begin
        s)  startAsOption   ;;
        # a for above command
        a)  passStartCheck; aboveAsOption   ;;
        # d for directory
        d)  passStartCheck; dirAsOption ;;
        # e for end
        e)  passStartCheck; endAsOption   ;;
        # h for help
        h)  helpAsOption    ;;
        # q for query the status
        q)  statusAsOption  ;;
        # s for current view script file; If no arguments given then view the current recording file
        v)  showSpecificScriptAsOption ${OPTARG}  ;;
        # l for list recoreded script files
        l)  listFilesAsOption   ;;
        # r for removing all empty files if no file mentioend or specific script file by passing file name or number as argument
        r)  removeSpecificFileAsOption ${OPTARG} ;;
        # c for copy file
        c)  exportFileAsOption ${2} ${3} ;;
        # x for execute the script file passed in the argument
        x)  executeFileAsOption ${OPTARG} ;;
        # the next parameter is an argument but not an option
        n)  renameFileAsOption ${2} ${3}    ;;
        # Other parameter passing options
        :) 
            if [[ ${GIVEN_OPTIONS} = "-v" ]]; then showScriptAsOption;
            elif [[ ${GIVEN_OPTIONS} = "-r" ]]; then removeEmptyFilesAsOption;
            elif [[ ${GIVEN_OPTIONS} = "-c" ]]; then echo ${EEXT} "\nNeed ${BLD}${UND}SOURCE${NRM} and ${BLD}${UND}DESTINATION${NRM} filenames as arguments"; helpAsOption;
            elif [[ ${GIVEN_OPTIONS} = "-x" ]]; then echo ${EEXT} "\nNeed ${BLD}${UND}Script filename${NRM} as arguments to execute that script. ${BLD}$(basename ${0}) -x <filename.sh>${NRM}"; helpAsOption; fi  ;;
        # Invalid Inputs
        \?) echo ${EEXT} "\n${BLD}Invalid Input.${NRM}" >&2; helpAsOption     ;;
    esac
done