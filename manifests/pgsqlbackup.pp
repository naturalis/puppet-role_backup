# == Class: role_backup::pgsqlbackup
#
# Mysql backup script class
#
class role_backup::pgsqlbackup(
  $pgsqlalldatabases    = undef,
  $pgsqldatabasearray   = undef,
  $pgsqlbackupuser      = undef,
  $backuprootfolder     = undef,
  $pgsqlprebackupvacuum = undef,
){

# create mysql directory in backuprootfolder
  file {"${backuprootfolder}/pgsql":
    ensure                  => 'directory',
    mode                    => '0700',
    require                 => File[$backuprootfolder]
  }

# Create pqsql backup script
  file {'/usr/local/sbin/pgsqlbackup.sh':
    ensure                  => 'file',
    mode                    => '0700',
    content                 => template('role_backup/pgsqlbackup.sh.erb')
  }

}
