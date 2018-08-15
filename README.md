# MySql-Backup-Windows
Backup MySQL databases and gzip the output sql files. Using PowerShell script language for Windows. Got the idea from [mysql-backup-windows.bat](https://gist.github.com/sindresorhus/869240).

### Requirements
* [Powershell](http://support.microsoft.com/kb/968929)
* [7-Zip](http://www.7-zip.org/)
* [MySql Workbench](https://www.mysql.com/products/workbench/) if this script is not run on the mysql server, provides the tools mysqldump.exe and mysql.exe

### Setup
Download the [github archive](https://github.com/pcdiks/MySql-Backup-Windows/archive/master.zip) and extract to your script folder.

#### On mysqlbackup.ps1 file:
* Change the value of the variable `$cnfFile` to the path to your *my.cnf* file.
* Change the value of the variable `$backupDir` to the path to the folder where the backup files will be stored.
* If required change the value of the variable `$mysqldump` to the path to *mysqldump.exe* file.
* If required change the value of the variable `$mysql` to the path to *mysql.exe* file.
* If required change the value of the variable `$zip` to the path to *7z.exe* file.

#### On my.cnf file:
In section `[client]` change the user and password to your backup user. I recommend create user for backup with Limit to hosts Matching: *localhost* and Administrative Roles: BackupAdmin(Global Privileges: EVENT, LOCK TABLES, SELECT, SHOW DATABASES).

Example my.cnf
```
[client]
user="user"
password="password"
host="host.domain.name"

[mysqldump]
single-transaction
add-drop-database
add-drop-table`
```

#### On Task Scheduler:
Сreate a task to run the *mysqlbackup.ps1* script with the time necessary for you.
