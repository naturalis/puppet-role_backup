# == Class: role_backup::restore
#
#
class role_backup::restore
{
# set variables for use in script.
  $_restore_pre_command = '/usr/sbin/service cron stop'
  $_restore_post_command = '/usr/sbin/service cron start'

# Define restore command
  if ($role_backup::restorefromclient == undef){
    $_restore_command = '/usr/sbin/burp -a r -f'
  }else{
    $_restore_command = "/usr/sbin/burp -C ${role_backup::restorefromclient} -a r -f"
  }

# include mysql restore code
  if ( $role_backup::mysqlrestore == true){
    if ($role_backup::mysqlalldatabase == true){
      $_restore_mysql_command = ''
    }else{
      $_restore_mysql_command = ''
    }
  }

# include pgsql restore code
  if ( $role_backup::pgsqlrestore == true){
    if ($role_backup::pgsqlalldatabase == true){
      $_restore_pgsql_command = ''
    }else{
      $_restore_pgsql_command = ''
    }
  }

# create restore script from template
  file {'/usr/local/sbin/restore.sh':
    mode         => '0700',
    content      => template('role_backup/restore.sh.erb')
  }
}
