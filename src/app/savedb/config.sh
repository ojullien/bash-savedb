## -----------------------------------------------------------------------------
## Linux Scripts.
## SaveDB app configuration file.
##
## @package ojullien\bash\app\savedb
## @license MIT <https://github.com/ojullien/bash-savesite/blob/master/LICENSE>
## -----------------------------------------------------------------------------

# Remove these 3 lines once you have configured this file
echo "The 'app/savedb/config.sh' file is not configured !!!"
String::error "The 'app/savedb/config.sh' file is not configured !!!"
exit 3

## -----------------------------------------------------------------------------
## Test mariadb installed
## -----------------------------------------------------------------------------
readonly m_SAVEDB_ISMARIADB=$(mysql --version | grep -c "MariaDB")

## -----------------------------------------------------------------------------
## Destination folder
## -----------------------------------------------------------------------------
readonly m_SAVEDB_DESTINATION_DEFAULT="/home/<user>" # You may want to change this value !!!

## -----------------------------------------------------------------------------
## MySQL
## A user with the minimal rights needed to backup any database (BackupAdmin) + RELOAD + INSERT
## Global privileges: SELECT, INSERT, RELOAD, SHOW DATABASES, LOCK TABLES, EVENT
## -----------------------------------------------------------------------------
readonly m_DB_USR="<user>" # You may want to change this value !!!
readonly m_DB_PWD="<***>" # You may want to change this value !!!

## -----------------------------------------------------------------------------
## Trace
## -----------------------------------------------------------------------------
SaveDB::trace() {
    String::separateLine
    String::notice "App configuration: saveDB"
    FileSystem::checkDir "\tDefault destination directory:\t${m_SAVEDB_DESTINATION_DEFAULT}" "${m_SAVEDB_DESTINATION_DEFAULT}"
    String::notice "\tMariaDB installed:${m_SAVEDB_ISMARIADB}"
    return 0
}
