# == Class: role_backup
#
#
class role_backup(
  $backup                = false,
  $backupdestination     = 's3',
  $directories           = ['/etc','/var/backup','/home'],
  $backupbucket          = 'linuxbackups',
  $backupfolder          = $fqdn,
  $dest_id               = undef,
  $dest_key              = undef,
  $cloud                 = 's3',
  $hour                  = 1,
  $minute                = 1,
  $full_if_older_than    = 60,
  $pre_command           = undef,
  $remove_older_than     = 61,
  $allow_source_mismatch = false,
  $restore               = false,
  $restoresource         = 's3',
  $restorebucket         = 'linuxbackups',
  $restorefolder         = undef,
  $restorelatest         = true,
  $restoredays           = undef,
  $mysqlbackup           = false,
  $mysqlbackupuser       = 'backupuser',
  $mysqlbackuppassword   = 'backupuserpwd',
  $mysqlalldatabases     = true,
  $mysqldatabasearray    = ['db1', 'db2'],
  $postgresbackup        = false,
  $backupprecommand      = undef,
  $backuppostcommand     = undef,
  $restoreprecommand     = undef,
  $restorepostcommand    = undef,
  $burpserver            = undef,
  $burphostname          = undef,
  $burppassword          = 'password',
  $burpincludes          = ['/etc','/var/backup'],
  $burpexcludes          = undef,
  $burpoptions           = undef,
){

  if ($backup == true ) {
    if ($backupdestination == 'burp') {
      class { 'role_backup::burpbackup':
      }
    } 
    if ($backupdestination == 's3')
      class { 'role_backup::s3backup':
    }
    if ($backupdestination != 's3' and $backupdestination != 'burp') {
      fail("unsupported backupdestination: ${backupdestination)
    }
  }

}
