# == Class: role_backup::restore
#
#
class role_backup::restore(
  $backuprootfolder      = undef,
  $directories           = undef,
  $mysqlrestore          = undef,
  $mysqlbackupuser       = undef,
  $mysqlbackuppassword   = undef,
  $mysqlalldatabases     = undef,
  $mysqldatabasearray    = undef,
  $pgsqlrestore          = undef,
  $pgsqlbackupuser       = undef,
  $pgsqlalldatabases     = undef,
  $pgsqldatabasearray    = undef,
  $burpcname             = undef,
)
{


  $_restore_pre_command = "/usr/sbin/service cron stop"
  $_restore_post_command = "/usr/sbin/service cron start"


  if ( $role_backup::restoresource == "burp"){ 
    if ($role_backup::burprestorecname != ""){
      $_restore_command = "/usr/sbin/burp -C ${::burprestorecname} -a r"
    }else{
      $_restore_command = "/usr/sbin/burp -a r"
    }
  }
  if ( $mysqlrestore == true){ 
    if ($mysqlalldatabase == true){
      $_restore_mysql_command = ""
    }else{
      $_restore_mysql_command = ""
    }
  }

  if ( $pgsqlrestore == true){ 
    if ($pgsqlalldatabase == true){
      $_restore_pgsql_command = ""
    }else{
      $_restore_pgsql_command = ""
    }
  }

 file {"/usr/local/sbin/restore.sh":
    mode                    => "700",
    content                 => template('role_backup/restore.sh.erb')
  }
}
