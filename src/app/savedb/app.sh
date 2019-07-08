## -----------------------------------------------------------------------------
## Linux Scripts.
## SaveDB app functions
##
## @package ojullien\bash\app\savedb
## @license MIT <https://github.com/ojullien/bash-savedb/blob/master/LICENSE>
## -----------------------------------------------------------------------------

SaveDB::showHelp() {
    String::notice "Usage: $(basename "$0") [options] <database 1> [database 2 ...]"
    String::notice "\tSave a database"
    Option::showHelp
    String::notice "\t-d | --destination\tDestination folder. The default is /home/<user>/out"
    String::notice "\t<database 1>\tDatabase name"
    return 0
}

SaveDB::save() {

    # Parameters
    if (($# != 4)) || [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
        String::error "Usage: SaveDB::save <user> <password> <destination as folder path> <database name>"
        return 1
    fi

    # Init
    local -i iReturn=1
    local sUser="$1" sPwd="$2" sDatabase="$4" sDestination="$3"
    local m_Save
    m_Save="$(uname -n)-${sDatabase}-$(date +"%Y%m%d")"

    # Destination does not exist
    if [[ ! -d "${sDestination}" ]]; then
        String::error "ERROR: Directory '${sDestination}' does not exist!"
        return 1
    fi

    # Saving
    DB::dump "${sUser}" "${sPwd}" "${sDatabase}" "${sDestination}/${m_Save}-error.log" "${sDestination}/${m_Save}.sql"
    iReturn=$?
    ((0!=iReturn)) || return ${iReturn}

    # Change directory
    cd "${sDestination}" || return 18

    String::notice -n "Compress to '${m_Save}.tar.bz2':"
    tar --create --bzip2 -f "${m_Save}.tar.bz2" "${m_Save}-error.log" "${m_Save}.sql" > /dev/null 2>&1
    iReturn=$?
    String::checkReturnValueForTruthiness ${iReturn}

    if ((0==iReturn)); then
        rm --force "${m_Save:?}-error.log" "${m_Save:?}.sql" > /dev/null 2>&1
    fi

    # Go to previous directory
    cd - || return 18

    return ${iReturn}
}
