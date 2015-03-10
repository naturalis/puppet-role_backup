# == Class: role_backup::sambabackup
#
#
class role_backup::sambabackup(
  $backuprootfolder,
){

  file {"$backuprootfolder/samba":
    ensure                  => "directory",
    mode                    => "700",
    require                 => File[$backuprootfolder]
  }

  file {"/usr/local/sbin/sambabackup.sh":
    ensure                  => "file",
    mode                    => "700",
    content                 => template('role_backup/sambabackup.sh.erb')
  }

}
