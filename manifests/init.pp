# == Class: role_backup
#
#
class role_backup(
  $backup                = false,
  $backuprootfolder      = '/var/backup',
  $backupdestination     = 'burp',
  $directories           = ['/etc','/home'],
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
  $mysqlbackup           = false,
  $mysqlbackupuser       = 'backupuser',
  $mysqlbackuppassword   = 'backupuserpwd',
  $mysqlalldatabases     = false,
  $mysqldatabasearray    = ['db1', 'db2'],
  $pgsqlbackup           = false,
  $pgsqlbackupuser       = 'postgres',
  $mpgqlalldatabases     = false,
  $pgsqldatabasearray    = ['db1', 'db2'],
  $burpserver            = undef,
  $burpcname             = $fqdn,
  $burpexludes           = ['/var/spool','/tmp'],
  $burpoptions           = ['# random test option'],
  $burppassword          = 'password'
)
{

  file { $backuprootfolder: 
    ensure                  => "directory",
    mode                    => "700"
  }

  if ($backup == true ) {
    if ($pgsqlbackup == true) and ($mysqlbackup == true) {
      if ($pre_command == "") { $_pre_command = "/usr/local/sbin/pgsqlbackup.sh && /usr/local/sbin/mysqlbackup.sh" }
      if ($pre_command != "") { $_pre_command = "${pre_command} && /usr/local/sbin/pgsqlbackup.sh && /usr/local/sbin/mysqlbackup.sh" }
    }else{
      if ($mysqlbackup == true) {
        if ($pre_command == "") { $_pre_command = "/usr/local/sbin/mysqlbackup.sh" }
        if ($pre_command != "") { $_pre_command = "${pre_command} && /usr/local/sbin/mysqlbackup.sh" }
      }
      if ($pgsqlbackup == true) {
        if ($pre_command == "") { $_pre_command = "/usr/local/sbin/pgsqlbackup.sh" }
        if ($pre_command != "") { $_pre_command = "${pre_command} && /usr/local/sbin/pgsqlbackup.sh" }
      }
    }
    if ($pgsqlbackup == true) or ($mysqlbackup == true) {
      $_directories  = [$directories,$backuprootfolder]
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
        directories         => $_directories
      }
    }

    if ($backupdestination != "s3") and ($backupdestination != "burp") {
      fail("unsupported backupdestination: ${backupdestination}")
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
  if ($pgsqlbackup == true ) {
    class { 'role_backup::pgsqlbackup':
      pgsqlbackupuser       => $pgsqlbackupuser,
      pgsqlalldatabases     => $pgsqlalldatabases,
      pgsqldatabasearray    => $pgsqldatabasearray,
      backuprootfolder      => $backuprootfolder
    }
  }

  if ($backupdestination == 'burp') and ($backup == true) {
    if ($_pre_command !=""){
      $_burpoptions    = [$burpoptions,"backup_script_pre=${_pre_command}"]
    }
    if ($pre_command != "") and ($_pre_command == ""){
      $_burpoptions    = [$burpoptions,"backup_script_pre=${pre_command}"]
    }
    $burpconfig_hash       = { "${burpcname}" => {
                                      includes => "${_directories}",
                                      excludes => "${burpexcludes}",
                                      options  => "${_burpoptions}",
                                      password => "${burppassword}",
                                    }
                              }
    class { 'role_backup::burpbackup':
      burpserver          => $burpserver,
      burpconfig_hash     => $burpconfig_hash
    }
  }
}