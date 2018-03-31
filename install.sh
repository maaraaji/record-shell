BLD="$(tput bold)"
NRM="$(tput sgr0)"
UND="$(tput smul)"
EXISTING_PATH=$(echo ${EEXT} -e ${PATH})
MACRO_HOME_DIR="${HOME}/rcd-home"
CREATE_MACRO_HOME_DIR="d"
HOME_DIR_CREATED=0
SET_LOCAL_BIN_PATH="NO"
LOCAL_SHELL="BASH"
if [[ $(ps -p $$) =~ "bash" ]]; then
    EEXT="-e"
else
    EEXT=""
fi

function steps(){
    echo ${EEXT} "============================================================================================"
    echo ${EEXT} ${1}
    echo ${EEXT} "============================================================================================\n"
}

steps "STEP 1\t➸\t Create home directory for ${BLD}Record(rcd)${NRM}"
echo ${EEXT} "Default is ${BLD}${MACRO_HOME_DIR}${NRM}"
read -p "Set Manually/Set Default [m/d] : ${BLD}" CREATE_MACRO_HOME_DIR
while [[ "${HOME_DIR_CREATED}" = 0 ]]; do
    case "${CREATE_MACRO_HOME_DIR}" in
        m)
            echo ${EEXT} "${NRM}What is the home directory path? : ${BLD}" && read MACRO_HOME_DIR
            MACRO_HOME_DIR="${MACRO_HOME_DIR}"
            HOME_DIR_CREATED=1
            ;;
        d) 
            echo ${EEXT} "${NRM}Setting the home directory as ${MACRO_HOME_DIR}"
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
    echo ${EEXT} "${NRM}Creating Macro's home directory ${MACRO_HOME_DIR}"
fi
echo ${EEXT} "${NRM}Macro's home directory has been set as ${BLD}${MACRO_HOME_DIR}${NRM}\n"
echo ${EEXT} "============================================================================================"
echo ${EEXT} "STEP 2\t➸\t Copying Record Files"
echo ${EEXT} "============================================================================================\n"
[ -d ${MACRO_HOME_DIR}/bin ] || mkdir ${MACRO_HOME_DIR}/bin && cp -f $(pwd)/src/record.sh ${MACRO_HOME_DIR}/bin/
[ -d ${MACRO_HOME_DIR}/bin/cmd ] || mkdir ${MACRO_HOME_DIR}/bin/cmd && ln -s ${MACRO_HOME_DIR}/bin/record.sh ${MACRO_HOME_DIR}/bin/cmd/rcd
echo ${EEXT} "Record files has been copied"
touch ${MACRO_HOME_DIR}/bin/record.config
echo ${EEXT} "Record config file has been copied\n"
echo ${EEXT} "============================================================================================"
echo ${EEXT} "STEP 3\t➸\t Adding Record (rcd) command to PATH"
echo ${EEXT} "============================================================================================\n"
# if [[ ! ${EXISTING_PATH} =~ "/usr/local/bin" ]]; then
#     echo ${EEXT} -e "${BLD}usr/local/bin${NRM} not available in PATH."
#     read -p "Shall I add the /usr/local/bin to PATH?" USER_ADD_LOCAL_BIN_TO_PATH
# fi
LOCAL_SHELL=$(echo ${EEXT} ${0})
ADDED_TO_BASH=0
ADDED_TO_ZSH=0
if test -n "$BASH_VERSION"; then
    echo ${EEXT} "You are using ${BLD}bash ${BASH_VERSION}${NRM}"
    while [[ ${ADDED_TO_BASH} = 0 ]]; do
        if [[ ! $(echo ${EEXT} ${PATH}) =~ "${MACRO_HOME_DIR}/bin/cmd" ]]; then
            echo ${EEXT} "export PATH=$PATH:${MACRO_HOME_DIR}/bin/cmd" >>${HOME}/.bash_profile
            echo ${EEXT} "Added to PATH"
            source ${HOME}/.bash_profile
            echo ${EEXT} "BASH profile sourced\n"
        else
            echo ${EEXT} "Already available in PATH. Only BASH profile sourced\n"
            ADDED_TO_BASH=1
        fi
    done
    echo ${EEXT} "============================================================================================"
    echo ${EEXT} "Well done! Installation completed. To know what ${BLD}Record(rcd)${NRM} can do, type ${BLD}rcd -u${NRM}"
    echo ${EEXT} "============================================================================================\n"
    if [[ ! $(echo ${EEXT} $PATH) =~ ${MACRO_HOME_DIR}/bin/cmd ]]; then
        echo ${EEXT} "Type ${BLD} source ~/.bash_profile ${NRM}to activate the command\n"
    fi
elif test -n "$ZSH_VERSION"; then
    echo ${EEXT} "You are using ${BLD}zsh ${ZSH_VERSION}${NRM}"
    sed -i 's|^echo ${EEXT} -e|echo|g' "${MACRO_HOME_DIR}/bin/record.sh" >${MACRO_HOME_DIR}/bin/record_zsh.sh
    while [[ ${ADDED_TO_ZSH} = 0 ]]; do
        if [[ ! $(grep "PATH" ${HOME}/.zshrc) =~ "${MACRO_HOME_DIR}/bin/cmd" ]]; then
            echo ${EEXT} "export PATH=$PATH:${MACRO_HOME_DIR}/bin/cmd" >>${HOME}/.zshrc
            echo ${EEXT} "Added to PATH\n"
            source ${HOME}/.zshrc
            echo ${EEXT} "ZSH Profile sourced\n"
        else
            echo ${EEXT} "Already available at export PATH in your zsh profile\n"
            ADDED_TO_ZSH=1
        fi
    done
    echo ${EEXT} "============================================================================================"
    echo ${EEXT} "Well done! Installation completed. To know what ${BLD}Record(rcd)${NRM} can do, type ${BLD}rcd -u${NRM}"
    echo ${EEXT} "============================================================================================\n"
    if [[ ! $(echo ${EEXT} $PATH) =~ ${MACRO_HOME_DIR}/bin/cmd ]]; then
            echo ${EEXT} "Type ${BLD} source ~/.zshrc ${NRM}to activate the command\n"
    fi
fi



