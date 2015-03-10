puppet-role_backup
==================

Backup and Restore role manifest for puppet in a foreman environment.

Parameters
-------------
All parameters are read from defaults in init.pp and can be overwritten by hiera or The foreman


```
  $backup                = false,               ' Enable or disable backup functionality
  $backuprootfolder      = '/var/backup',       ' Root backup folder for database dumps
  $directories           = ['/etc','/home'],    ' Backup directory array for burp backups
  $pre_command           = undef,               ' command to run before starting backup ( s3 and burp )
  $sambabackup           = false,               ' Enable sambabackup script, backup samba database using tdbbackup
  $mysqlbackup           = false,               ' Enable mysqlbackup script  (script wil run as pre script before backup)
  $mysqlbackupuser       = 'backupuser',        ' Mysql backupuser
  $mysqlbackuppassword   = 'backupuserpwd',     ' Mysql backupuser password
  $mysqlalldatabases     = false,               ' Mysql Backup all databases, if true then array is ignored
  $mysqldatabasearray    = ['db1', 'db2'],      ' Mysql Backup array of databases
  $mysqlfileperdatabase  = true,                ' Enable file per database backup, every db in single file. When set to false then complete backup in one tar.gz
  $pgsqlbackup           = false,               ' Enable postgresql backup script  (script wil run as pre script before backup)
  $pgsqlbackupuser       = 'postgres',          ' Postgres user, uses su - {user} -c exec commands. so password is not needed
  $pgsqlalldatabases     = false,               ' pgsql Backup all databases, if true then array is ignored
  $pgsqldatabasearray    = ['db1', 'db2'],      ' pgsql Backup array of databases
  $pgsqlfileperdatabase  = true,                ' Enable file per database backup, every db in single file. When set to false then complete backup in one tar.gz
  $burpserver            = undef,               ' Burp server address
  $burpcname             = $fqdn,               ' Burp client name
  $burpcron              = false,               ' Burp cron job, initiates every 20 minutes a backup request.
  $burpexludes           = ['/var/spool','/tmp'],       ' Burp excludes array ( includes are $directories )
  $burpoptions           = ['# random test option'],    ' Burp Options array
  $burppassword          = 'password',          ' Burp client password
  $burprestorescript     = false,               ' create burp restore script : /usr/local/sbin/restore.sh
  $burprestorecname      = $fqdn,               ' client name to restore from, on the source location the $burpoption array 
                                                ' must have: "restore_client=clientname" unless the burprestorecname = burpcname
```


Classes
-------------
- role_backup
- role_backup::mysqlbackup
- role_backup::pgsqlbackup
- role_backup::sambabackup
- role_backup::restore

Dependencies
-------------
naturalis/puppet-burp


Result
-------------
Custom backup functionality fit for almost every purpose.


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS
- Ubuntu 14.04LTS


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>
