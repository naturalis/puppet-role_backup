# == Class: role_backup
#
#
class role_backup::pgsqlbackup(
  $pgsqlalldatabases    = undef,
  $pgsqldatabasearray   = undef,
  $pgsqlbackupuser,
  $backuprootfolder,
){

  file {"$backuprootfolder/pgsql":
    ensure                  => "directory",
    mode                    => "700",
    require                 => File[$backuprootfolder]
  }

  file {"/usr/local/sbin/pgsqlbackup.sh":
    ensure                  => "file",
    mode                    => "700",
    content                 => template('role_backup/pgsqlbackup.sh.erb')
  }

}
