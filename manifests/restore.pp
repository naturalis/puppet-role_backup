# == Class: role_backup::restore
#
#
class role_backup::restore
{

# Define restore command
  if ($role_backup::restorefromclient == undef){
    $_restore_command = '/usr/sbin/burp -a r -f'
  }else{
    $_restore_command = "/usr/sbin/burp -C ${role_backup::restorefromclient} -a r -f"
  }


# create restore script from template
  file {'/usr/local/sbin/restore.sh':
    mode         => '0700',
    content      => template('role_backup/restore.sh.erb')
  }

# install restore cron if true
 if ($role_backup::restorecron == 'true'){
    cron { 'initiate restore':
      command => '/usr/local/sbin/restore.sh',
      user    => root,
      hour    => $role_backup::restorecronhour,
      minute  => $role_backup::restorecronminute,
      weekday => $role_backup::restorecronweekday
    }
  }
}
