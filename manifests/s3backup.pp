# == Class: role_backup
#
#
class role_backup::s3backup(
  $directories           = ['/etc','/var/backup','/home'],
  $backupbucket          = 'linuxbackups',
  $backupfolder          = $fqdn,
  $dest_id               = undef,
  $dest_key              = undef,
  $cloud                 = 's3',
  $hour                  = 1,
  $minute                = 1,
  $full_if_older_than    = 60,
  $remove_older_than     = 61,
  $allow_source_mismatch = false,
){
}
