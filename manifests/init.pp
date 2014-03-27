# == Class: role_backup
#
#
class role_backup(
  $backup                = true,
  $backuprootfolder      = '/var/backup',
  $backupdestination     = 's3',
  $directories           = ['/etc','/home'],
  $backupbucket          = 'linuxbackups',
  $backupfolder          = $fqdn,
  $dest_id               = 'rwert',
  $dest_key              = '345345',
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
  $mysqlbackup           = true,
  $mysqlbackupuser       = 'backupuser',
  $mysqlbackuppassword   = 'backupuserpwd',
  $mysqlalldatabases     = false,
  $mysqldatabasearray    = ['db1', 'db2'],
  $postgresbackup        = false,
  $backuppostcommand     = undef,
  $restorepostcommand    = undef,
  $burpserver            = undef,
  $burphostname          = undef,
  $burppassword          = 'password',
  $burpincludes          = ['/etc'],
  $burpexcludes          = undef,
  $burpoptions           = undef
){
  file { $backuprootfolder: 
    ensure                  => "directory",
    mode                    => "700"
  }

  if ($backup == true ) {
    if ($mysqlbackup == true) {
      if ($pre_command == "") { $_pre_command = "/usr/local/sbin/mysqlbackup.sh" }
      if ($pre_command != "") { $_pre_command = "${pre_command} && /usr/local/sbin/mysqlbackup.sh" }
    }

    if ($backupdestination == 'burp') {
      class { 'role_backup::burpbackup':
      }
    } 
    if ($backupdestination == 's3') {
      class { 'role_backup::s3backup':
        dest_id             => $dest_id,
        dest_key            => $dest_key,
        cloud               => $cloud,
        hour                => $hour,
        minute              => $minute,
        full_if_older_than  => $full_if_older_than,
        pre_command         => $_pre_command,
        remove_older_than   => $remove_older_than,
        backupbucket        => $backupbucket,
        backupfolder        => $backupfolder,
        directories         => $directories
      }
    }
    if ($backupdestination != "s3") and ($backupdestination != "burp") {
      fail("unsupported backupdestination: ${backupdestination}")
    }
  }

  if ($mysqlbackup == true ) {
    class { 'role_backup::mysqlbackup':
      mysqlbackupuser       => $mysqlbackupuser,
      mysqlalldatabases     => $mysqlalldatabases,
      mysqldatabasearray    => $mysqldatabasearray,
      mysqlbackuppassword   => $mysqlbackuppassword,
      backuprootfolder      => $backuprootfolder
    }
  }
  if ($postgresbackup == true ) {
    class { 'role_backup::mysqlbackup':
      mysqlbackupuser       => $mysqlbackupuser,
      mysqlalldatabases     => $mysqlalldatabases,
      mysqldatabasearray    => $mysqldatabasearray,
      mysqlbackuppassword   => $mysqlbackuppassword,
      backuprootfolder      => $backuprootfolder
    }
  }

}
