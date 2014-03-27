# == Class: role_backup
#
#
class role_backup::mysqlbackup(
  $mysqlalldatabases    = undef,
  $mysqldatabasearray   = undef,
  $mysqlbackupuser,
  $mysqlbackuppassword,
  $backuprootfolder,
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
