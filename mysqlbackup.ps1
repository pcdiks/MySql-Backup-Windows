$cnfFile = Join-Path -Path $PSScriptRoot -ChildPath my.cnf #Config file
$backupDir = "E:\Shares\Backup\SQLServers" #Backup Directory
$mysqldump = "C:\Program Files\MySQL\MySQL Workbench 8.0 CE\mysqldump.exe" #Patch to mysqldump.exe
#$mysqlDataDir = "C:\Documents and Settings\All Users\MySQL\MySQL Server 5.6\data" #Patch to datatbases files directory
$zip = "C:\Program Files\7-Zip\7z.exe" #7-Zip Command line tool

& $mysqldump --defaults-extra-file=$cnfFile --all-databases

<#
#Get only names of the databases folders
$sqlDbDirList = ls -path $mysqlDataDir | ?{ $_.PSIsContainer } | Select-Object Name
foreach($dbDir in $sqlDbDirList) {
    $dbBackupDir = $backupDir + "\" + $dbDir.Name
    #If folder not exist, create it
    if (!(Test-Path -path $dbBackupDir -PathType Container)) {
        New-Item -Path $dbBackupDir -ItemType Directory
    }
    
    $dbBackupFile = $dbBackupDir + "\" + $dbDir.Name + "_" + (Get-Date -format "yyyyMMdd_HHmmss")
    #Dump to sql file and arhive it
    $sqlFile = $dbBackupFile + ".sql"
    & $mysqldump --defaults-extra-file=$cnfFile -B $dbDir.Name -r $sqlFile
    $zipFile = $dbBackupFile + ".sql.gz"
    & $zip a -tgzip $zipFile $sqlFile
    del $sqlFile
}
#>