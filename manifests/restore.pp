# == Class: role_backup::restore
#
#
class role_backup::burprestore(
  $cname                = $fqdn,
){

  exec {"execute_restore":
    command                 => "/usr/sbin/service cron stop && /usr/sbin/burp -C ${cname} -a r > /var/log/burprestore.log && /usr/sbin/service cron start ",
    require                 => Package['burp'],
    unless                  => "test -f /var/log/burprestore.log"
  }

}
