#!/bin/bash
## -----------------------------------------------------------------------------
## Linux Scripts.
## Saves a MySQL database to a timestamped bz2 archive.
##
## @package ojullien\bash\bin
## @license MIT <https://github.com/ojullien/bash-savedb/blob/master/LICENSE>
## -----------------------------------------------------------------------------
#set -o errexit
set -o nounset
set -o pipefail

## -----------------------------------------------------------------------------
## Shell scripts directory, eg: /root/work/Shell/src/bin
## -----------------------------------------------------------------------------
readonly m_DIR_REALPATH="$(realpath "$(dirname "$0")")"

## -----------------------------------------------------------------------------
## Load constants
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_REALPATH}/../sys/constant.sh"

## -----------------------------------------------------------------------------
## Includes sources & configuration
## -----------------------------------------------------------------------------
# shellcheck source=/dev/null
. "${m_DIR_SYS}/string.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/filesystem.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/option.sh"
# shellcheck source=/dev/null
. "${m_DIR_SYS}/config.sh"
# shellcheck source=/dev/null
. "${m_DIR_APP}/savedb/app.sh"
Config::load "savedb"
if ((m_SAVEDB_ISMARIADB)); then
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/db/mariadb.sh"
else
    # shellcheck source=/dev/null
    . "${m_DIR_SYS}/db/mysql.sh"
fi

## -----------------------------------------------------------------------------
## Help
## -----------------------------------------------------------------------------
((m_OPTION_SHOWHELP)) && SaveDB::showHelp && exit 0
(( 0==$# )) && SaveDB::showHelp && exit 1

## -----------------------------------------------------------------------------
## Start
## -----------------------------------------------------------------------------
String::separateLine
String::notice "Today is: $(date -R)"
String::notice "The PID for $(basename "$0") process is: $$"
Console::waitUser

## -----------------------------------------------------------------------------
## Flush
## -----------------------------------------------------------------------------
String::separateLine
FileSystem::syncFile
DB::flush "${m_DB_USR}" "${m_DB_PWD}"
Console::waitUser

## -----------------------------------------------------
## Parse the app options and arguments
## -----------------------------------------------------
declare -i iReturn=1
declare sDestination="${m_SAVEDB_DESTINATION_DEFAULT}"

while (( "$#" )); do
    case "$1" in
    -d|--destination) # app option
        sDestination="$2"
        shift 2
        FileSystem::checkDir "The destination directory is set to:\t${sDestination}" "${sDestination}"
        ;;
    -t|--trace)
        shift
        String::separateLine
        Constant::trace
        SaveDB::trace
        ;;
    --*|-*) # unknown option
        shift
        String::separateLine
        SaveDB::showHelp
        exit 0
        ;;
    *) # We presume its a /etc/conf directory
        String::separateLine
        SaveDB::save "${m_DB_USR}" "${m_DB_PWD}" "${sDestination}" "$1"
        iReturn=$?
        ((0!=iReturn)) && exit ${iReturn}
        shift
        Console::waitUser
        ;;
    esac
done

## -----------------------------------------------------------------------------
## END
## -----------------------------------------------------------------------------
String::notice "Now is: $(date -R)"
exit 0
