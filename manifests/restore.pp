# == Class: role_backup::restore
#
#
class role_backup::restore
{
  $_restore_pre_command = "/usr/sbin/service cron stop"
  $_restore_post_command = "/usr/sbin/service cron start"

  if ( $role_backup::restoresource == "burp"){ 
    if ($role_backup::burprestorecname == undef){
      $_restore_command = "/usr/sbin/burp -a r -f"
    }else{
      $_restore_command = "/usr/sbin/burp -C ${role_backup::burprestorecname} -a r -f"
    }
  }
  if ( $role_backup::mysqlrestore == true){ 
    if ($role_backup::mysqlalldatabase == true){
      $_restore_mysql_command = ""
    }else{
      $_restore_mysql_command = ""
    }
  }

  if ( $role_backup::pgsqlrestore == true){ 
    if ($role_backup::pgsqlalldatabase == true){
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
