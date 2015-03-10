# == Class: role_backup::sambabackup
#
# Samba backup script class
#
class role_backup::sambabackup(
  $backuprootfolder     = undef,
){

# Create samba directory in backuprootfolder
  file {"${backuprootfolder}/samba":
    ensure                  => 'directory',
    mode                    => '0700',
    require                 => File[$backuprootfolder]
  }

# create samba backup script from template
  file {'/usr/local/sbin/sambabackup.sh':
    ensure                  => 'file',
    mode                    => '0700',
    content                 => template('role_backup/sambabackup.sh.erb')
  }

}
