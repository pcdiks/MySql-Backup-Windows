$cnfFile = Join-Path -Path $PSScriptRoot -ChildPath my.cnf #Config file
$cnf2 = Join-Path -Path $PSScriptRoot -ChildPath my-zm.cnf #Config file
$backupDir = "E:\Shares\Backup\SQLServers" #Backup Directory
$mysqldump = "C:\Program Files\MySQL\MySQL Workbench 8.0 CE\mysqldump.exe" #Patch to mysqldump.exe
$mysql = "C:\Program Files\MySQL\MySQL Workbench 8.0 CE\mysql.exe"
#$mysqlDataDir = "C:\Documents and Settings\All Users\MySQL\MySQL Server 5.6\data" #Patch to datatbases files directory
$zip = "C:\Program Files\7-Zip\7z.exe" #7-Zip Command line tool

#Get list of databases without system databases
$Query = "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ('mysql','information_schema','performance_schema')"

$sqlDbDirList = (& $mysql --defaults-extra-file=$cnfFile -ANe"$Query")

foreach($dbDir in $sqlDbDirList) {
    $dbBackupDir = $backupDir + "\" + $dbDir
    #If folder not exist, create it
    if (!(Test-Path -path $dbBackupDir -PathType Container)) {
        New-Item -Path $dbBackupDir -ItemType Directory
    }
    
    $dbBackupFile = $dbBackupDir + "\" + $dbDir + "_" + (Get-Date -format "yyyyMMdd_HHmmss")
    #Dump to sql file and arhive it
    $sqlFile = $dbBackupFile + ".sql"
    & $mysqldump --defaults-extra-file=$cnfFile -B $dbDir -r $sqlFile -f
    $zipFile = $dbBackupFile + ".sql.gz"
    & $zip a -tgzip $zipFile $sqlFile
    Remove-Item $sqlFile
}

#Backup ZM database
$dbdir="zm"
$dbBackupDir = $backupDir + "\" + $dbDir
#If folder not exist, create it
if (!(Test-Path -path $dbBackupDir -PathType Container)) {
    New-Item -Path $dbBackupDir -ItemType Directory
}

$dbBackupFile = $dbBackupDir + "\" + $dbDir + "_" + (Get-Date -format "yyyyMMdd_HHmmss")
#Dump to sql file and arhive it
$sqlFile = $dbBackupFile + ".sql"
& $mysqldump --defaults-extra-file=$cnf2 -B $dbDir -r $sqlFile -f
$zipFile = $dbBackupFile + ".sql.gz"
& $zip a -tgzip $zipFile $sqlFile
Remove-Item $sqlFile
