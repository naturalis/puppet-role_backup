puppet-role_backup
==================

Backup and Restore role manifest for puppet in a foreman environment.

Parameters
-------------
All parameters are read from defaults in init.pp and can be overwritten by hiera or The foreman


```
  $backup                = false,               ' Enable or disable backup functionality
  $backuprootfolder      = '/var/backup',       ' Root backup folder for database dumps
  $backupdestination     = 'burp',              ' Destination. s3 and burp are supported
  $directories           = ['/etc','/home'],    ' Backup directory array for s3 and burp backups
  $backupbucket          = 'linuxbackups',      ' s3 Bucket
  $backupfolder          = $fqdn,               ' s3 Foldername
  $dest_id               = undef,               ' s3 API id
  $dest_key              = undef,               ' s3 API key
  $cloud                 = 's3',                ' cloud selection, s3 or cloudfiles. only s3 is tested succesfully
  $hour                  = 1,                   ' s3 backup script cronjob start hour
  $minute                = 1,                   ' s3 backup script cronjob start minute
  $full_if_older_than    = 60,                  ' s3 make new full after x days
  $pre_command           = undef,               ' command to run before starting backup ( s3 and burp )
  $remove_older_than     = 61,                  ' s3 remove all backups older than x
  $allow_source_mismatch = false,               ' s3 allow overwrite existing backup for other hosts
  $mysqlbackup           = false,               ' Enable mysqlbackup script  (script wil run as pre script before backup)
  $mysqlbackupuser       = 'backupuser',        ' Mysql backupuser
  $mysqlbackuppassword   = 'backupuserpwd',     ' Mysql backupuser password
  $mysqlalldatabases     = false,               ' Mysql Backup all databases, if true then array is ignored
  $mysqldatabasearray    = ['db1', 'db2'],      ' Mysql Backup array of databases
  $pgsqlbackup           = false,               ' Enable postgresql backup script  (script wil run as pre script before backup)
  $pgsqlbackupuser       = 'postgres',          ' Postgres user, uses su - {user} -c exec commands. so password is not needed
  $pgsqlalldatabases     = false,               ' pgsql Backup all databases, if true then array is ignored
  $pgsqldatabasearray    = ['db1', 'db2'],      ' pgsql Backup array of databases
  $burpserver            = undef,               ' Burp server address
  $burpcname             = $fqdn,               ' Burp client name
  $burpcron              = false,               ' Burp cron job, initiates every 20 minutes a backup request.
  $burpexludes           = ['/var/spool','/tmp'],       ' Burp excludes array ( includes are $directories )
  $burpoptions           = ['# random test option'],    ' Burp Options array
  $burppassword          = 'password',          ' Burp client password
  $burprestore           = false,               ' Initiate full Burp restore to original location, runs once logs in /var/log/burprestore.log
  $burprestorecname      = $fqdn,               ' client name to restore from, on the source location the $burpoption array 
                                                ' must have: "restore_client=clientname" unless the burprestorecname = burpcname
```


Classes
-------------
role_backup
role_backup::mysqlbackup
role_backup::pgsqlbackup
role_backup::burpbackup
role_backup::s3backup
role_backup::burprestore

Dependencies
-------------
puppet-duplicity
naturalis/puppet-burp


Result
-------------
Custom backup functionality fit for almost every purpose.


Limitations
-------------
This module has been built on and tested against Puppet 3 and higher.

The module has been tested on:
- Ubuntu 12.04LTS 


Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>