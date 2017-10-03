# == Class: role_backup
#
#
class role_backup(
# general options
  $backup                = false,
  $pgsqlbackupuser       = 'postgres',
  $pgsqlalldatabases     = false,
  $pgsqldatabasearray    = ['db1', 'db2'],
  $backuprootfolder      = '/var/backup',
  $directories           = ['/etc','/home'],
  $burpserver            = undef,
  $burpcname             = undef,
  $mysqlbackupuser       = 'backupuser',
  $mysqlbackuppassword   = 'backupuserpwd',
  $mysqlalldatabases     = false,
  $mysqlfileperdatabase  = true,
  $mysqldatabasearray    = ['db1', 'db2'],
  $burppassword          = 'password',
  $chkwarninghours       = 24,
  $chkcriticalhours      = 48,

# backup options
  $mysqlrestore          = false,
  $mysqlbackup           = false,
  $sambabackup           = false,
  $pgsqlbackup           = false,
  $pgsqlprebackupvacuum  = false,
  $burpcron              = false,
  $pre_command           = undef,
  $burpcronminute        = '*/20',
  $burpcronhour          = '*',
  $burpexcludes          = ['/var/spool','/tmp'],
  $burpoptions           = ['# random test option'],

# restore options
  $burprestorecname      = undef,
  $pgsqlrestore          = false,
  $restorescript         = false,
  $restorefromclient     = undef,
  $restoresource         = 'burp',
  $post_restore_command  = '',
  $pre_restore_command   = '',
  $restorecron           = false,
  $restorecronminute     = '0',
  $restorecronhour       = '5',
  $restorecronweekday    = '0',

)
{

# Create backup location for database dumps or other script related backup files
  file { $role_backup::backuprootfolder:
    ensure                  => 'directory',
    mode                    => '0700'
  }

# Only add backuprootfolder location to the array of the directories
# when atleast one special backup scripts is true
  if ($role_backup::pgsqlbackup == true) or ($role_backup::mysqlbackup == true) or ($role_backup::sambabackup == true){
    $_directories = [$role_backup::directories,$role_backup::backuprootfolder]
  } else {
    $_directories = $role_backup::directories
  }

# include class and sambascript with sambabackup=true
  if ($role_backup::sambabackup == true ) {
    $sambascript = '/usr/local/sbin/sambabackup.sh'
    class { 'role_backup::sambabackup':
      backuprootfolder      => $role_backup::backuprootfolder
    }
  }

# include class and mysqlscript with mysqlbackup=true
  if ($role_backup::mysqlbackup == true ) {
    $mysqlscript = '/usr/local/sbin/mysqlbackup.sh'
    class { 'role_backup::mysqlbackup':
      mysqlbackupuser       => $role_backup::mysqlbackupuser,
      mysqlalldatabases     => $role_backup::mysqlalldatabases,
      mysqldatabasearray    => $role_backup::mysqldatabasearray,
      mysqlbackuppassword   => $role_backup::mysqlbackuppassword,
      backuprootfolder      => $role_backup::backuprootfolder
    }
  }

# include class and pgsqlscript with pgsqlbackup=true
  if ($role_backup::pgsqlbackup == true ) {
    $pgsqlscript = '/usr/local/sbin/pgsqlbackup.sh'
    class { 'role_backup::pgsqlbackup':
      pgsqlbackupuser       => $role_backup::pgsqlbackupuser,
      pgsqlalldatabases     => $role_backup::pgsqlalldatabases,
      pgsqldatabasearray    => $role_backup::pgsqldatabasearray,
      backuprootfolder      => $role_backup::backuprootfolder,
      pgsqlprebackupvacuum  => $role_backup::pgsqlprebackupvacuum
    }
  }

# Create array from scripts which will be used in the burpscript.sh
$pre_command_array = [$role_backup::pre_command, $sambascript, $mysqlscript, $pgsqlscript]
#$pre_command_array = ['bla','bla','bla']

# Create backupscript from template
  if ($role_backup::backup == true) {
    if ($role_backup::pre_command_array != '') {
      $backup_script_pre = 'backup_script_pre=/usr/local/sbin/burpscript.sh'
      file {'/usr/local/sbin/burpscript.sh':
        ensure                  => 'file',
        mode                    => '0700',
        content                 => template('role_backup/burpscript.sh.erb')
      }
    }
# set cname variable for burp class
    if ($role_backup::burpcname == '') {
      $cname = $::fqdn
    } else {
      $cname = $role_backup::burpcname
    }
# include burp class
    class { 'burp':
      mode                  => 'client',
      server                => $role_backup::burpserver,
      includes              => $_directories,
      excludes              => $role_backup::burpexcludes,
      options               => $role_backup::burpoptions,
      password              => $role_backup::burppassword,
      client_password       => $role_backup::burppassword,
      cname                 => $cname,
      cron                  => $role_backup::burpcron,
      cronhour              => $role_backup::burpcronhour,
      cronminute            => $role_backup::burpcronminute,
      backup_script_pre     => $backup_script_pre
    }
  }

# add restore script to /usr/local/sbin/restore.sh when restorescript = true
  if ($role_backup::restorescript == true){
    if ($role_backup::backup == false) {
      fail('can not restore without backup being configured')
    }
    class { 'role_backup::restore':
    }
  }

# create burp check script for usage with monitoring tools ( sensu )
  file {'/usr/local/sbin/chkburp.sh':
    ensure                  => 'file',
    mode                    => '0777',
    content                 => template('role_backup/chkburp.sh.erb')
  }

# export check so sensu monitoring can make use of it
  @@sensu::check { 'Check Backup' :
    command => '/usr/local/sbin/chkburp.sh',
    tag     => 'central_sensu',
}


}