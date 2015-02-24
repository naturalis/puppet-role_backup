# == Class: role_backup
#
#
class role_backup(
  $backup                = false,
  $restorescript         = false,
  $restorefromclient     = undef,
  $backuprootfolder      = '/var/backup',
  $backupdestination     = 'burp',
  $restoresource         = 'burp',
  $directories           = ['/etc','/home'],
  $pre_command           = undef,
  $mysqlrestore          = false,
  $mysqlbackup           = false,
  $mysqlbackupuser       = 'backupuser',
  $mysqlbackuppassword   = 'backupuserpwd',
  $mysqlalldatabases     = false,
  $mysqlfileperdatabase  = true,
  $mysqldatabasearray    = ['db1', 'db2'],
  $pgsqlbackup           = false,
  $pgsqlrestore          = false,
  $pgsqlbackupuser       = 'postgres',
  $pgsqlalldatabases     = false,
  $pgsqldatabasearray    = ['db1', 'db2'],
  $burpserver            = undef,
  $burpcname             = undef,
  $burpcron              = false,
  $burpexcludes          = ['/var/spool','/tmp'],
  $burpoptions           = ['# random test option'],
  $burppassword          = 'password',
  $burprestorecname      = undef,
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
    if ($_pre_command != "") {
      $backup_script_pre = "backup_script_pre=/usr/local/sbin/burpscript.sh"
      file {"/usr/local/sbin/burpscript.sh":
        ensure                  => "file",
        mode                    => "700",
        content                 => template('role_backup/burpscript.sh.erb')
      }
    }
    if ($_directories == ""){
      $_directories = $directories
    }
    if ($burpcname == "") { 
      $cname = $fqdn
    } else {
      $cname = $burpcname
    }
    class { 'burp':
      mode                  => 'client',
      server                => $burpserver,
      includes              => $_directories,
      excludes              => $burpexcludes,
      options               => $burpoptions,
      password              => $burppassword,
      client_password       => $burppassword,
      cname                 => $cname,
      cron                  => $burpcron,
      backup_script_pre     => $backup_script_pre
    }
  }

  if ($restorescript == true){
    if ($backup == false) {
      fail("can't restore without configured backup")
    }
    class { 'role_backup::restore':
    }
  }
  
}