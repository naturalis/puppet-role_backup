# == Class: role_backup::restore
#
#
class role_backup::restore(
  $server,
  $cname                = $fqdn,
  $password             = 'password',
){
  file {"$backuprootfolder/mysql":
    ensure                  => "directory",
    mode                    => "700",
    require                 => File[$backuprootfolder]
  }

  file {"/usr/local/sbin/mysqlbackup.sh":
    ensure                  => "file",
    mode                    => "700",
    content                 => template('role_backup/mysqlbackup.sh.erb')
  }

}
