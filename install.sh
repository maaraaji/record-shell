BLD="$(tput bold)"
NRM="$(tput sgr0)"
UND="$(tput smul)"
EXISTING_PATH=$(echo -e ${PATH})
MACRO_HOME_DIR="${HOME}/rcd-home"
CREATE_MACRO_HOME_DIR="d"
HOME_DIR_CREATED=0
SET_LOCAL_BIN_PATH="NO"
LOCAL_SHELL="BASH"

function steps(){
    echo "============================================================================================"
    echo ${1}
    echo "============================================================================================\n"
}

steps "STEP 1\t➸\t Create home directory for ${BLD}Record(rcd)${NRM}"
echo "Default is ${BLD}${MACRO_HOME_DIR}${NRM}"
read -p "Set Manually/Set Default [m/d] : ${BLD}" CREATE_MACRO_HOME_DIR
while [[ "${HOME_DIR_CREATED}" = 0 ]]; do
    case "${CREATE_MACRO_HOME_DIR}" in
        m)
            echo "${NRM}What is the home directory path? : ${BLD}" && read MACRO_HOME_DIR
            MACRO_HOME_DIR="${MACRO_HOME_DIR}"
            HOME_DIR_CREATED=1
            ;;
        d) 
            echo "${NRM}Setting the home directory as ${MACRO_HOME_DIR}"
            HOME_DIR_CREATED=1
            ;;
        *)
            read -p "${NRM}Invalid Option. Either Set manually/Set Default [m/d] : " CREATE_MACRO_HOME_DIR
            HOME_DIR_CREATED=0
            ;;
    esac
done

if [[ ! -d ${MACRO_HOME_DIR} ]]; then 
    mkdir ${MACRO_HOME_DIR}
    echo "${NRM}Creating Macro's home directory ${MACRO_HOME_DIR}"
fi
echo "${NRM}Macro's home directory has been set as ${BLD}${MACRO_HOME_DIR}${NRM}\n"
echo "============================================================================================"
echo "STEP 2\t➸\t Copying Record Files"
echo "============================================================================================\n"
[ -d ${MACRO_HOME_DIR}/bin ] || mkdir ${MACRO_HOME_DIR}/bin && cp -f $(pwd)/record.sh ${MACRO_HOME_DIR}/bin/
[ -d ${MACRO_HOME_DIR}/bin/cmd ] || mkdir ${MACRO_HOME_DIR}/bin/cmd && ln -s ${MACRO_HOME_DIR}/bin/record.sh ${MACRO_HOME_DIR}/bin/cmd/rcd
echo "Record files has been copied"
touch ${MACRO_HOME_DIR}/bin/record.config
echo "Record config file has been copied\n"
echo "============================================================================================"
echo "STEP 3\t➸\t Adding Record (rcd) command to PATH"
echo "============================================================================================\n"
# if [[ ! ${EXISTING_PATH} =~ "/usr/local/bin" ]]; then
#     echo -e "${BLD}usr/local/bin${NRM} not available in PATH."
#     read -p "Shall I add the /usr/local/bin to PATH?" USER_ADD_LOCAL_BIN_TO_PATH
# fi
LOCAL_SHELL=$(echo ${0})
ADDED_TO_BASH=0
ADDED_TO_ZSH=0
if test -n "$BASH_VERSION"; then
    echo "You are using ${BLD}bash ${BASH_VERSION}${NRM}"
    while [[ ${ADDED_TO_BASH} = 0 ]]; do
        if [[ ! $(echo ${PATH}) =~ "${MACRO_HOME_DIR}/bin/cmd" ]]; then
            echo "export PATH=$PATH:${MACRO_HOME_DIR}/bin/cmd" >>${HOME}/.bash_profile
            echo "Added to PATH"
            source ${HOME}/.bash_profile
            echo "BASH profile sourced\n"
        else
            echo "Already available in PATH. Only BASH profile sourced\n"
            ADDED_TO_BASH=1
        fi
    done
    echo "============================================================================================"
    echo "Well done! Installation completed. To know what ${BLD}Record(rcd)${NRM} can do, type ${BLD}rcd -u${NRM}"
    echo "============================================================================================\n"
    if [[ ! $(echo $PATH) =~ ${MACRO_HOME_DIR}/bin/cmd ]]; then
        echo "Type ${BLD} source ~/.bash_profile ${NRM}to activate the command\n"
    fi
elif test -n "$ZSH_VERSION"; then
    echo "You are using ${BLD}zsh ${ZSH_VERSION}${NRM}"
    sed -i 's|^echo -e|echo|g' "${MACRO_HOME_DIR}/bin/record.sh" >${MACRO_HOME_DIR}/bin/record_zsh.sh
    while [[ ${ADDED_TO_ZSH} = 0 ]]; do
        if [[ ! $(grep "PATH" ${HOME}/.zshrc) =~ "${MACRO_HOME_DIR}/bin/cmd" ]]; then
            echo "export PATH=$PATH:${MACRO_HOME_DIR}/bin/cmd" >>${HOME}/.zshrc
            echo "Added to PATH\n"
            source ${HOME}/.zshrc
            echo "ZSH Profile sourced\n"
        else
            echo "Already available at export PATH in your zsh profile\n"
            ADDED_TO_ZSH=1
        fi
    done
    echo "============================================================================================"
    echo "Well done! Installation completed. To know what ${BLD}Record(rcd)${NRM} can do, type ${BLD}rcd -u${NRM}"
    echo "============================================================================================\n"
    if [[ ! $(echo $PATH) =~ ${MACRO_HOME_DIR}/bin/cmd ]]; then
            echo "Type ${BLD} source ~/.zshrc ${NRM}to activate the command\n"
    fi
fi



