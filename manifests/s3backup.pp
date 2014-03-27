# == Class: role_backup
#
#
class role_backup::s3backup(
  $directories,
  $backupbucket,
  $backupfolder,
  $dest_id,
  $dest_key,
  $cloud                 = 's3',
  $hour                  = 1,
  $minute                = 1,
  $full_if_older_than    = 60,
  $remove_older_than     = 61,
  $allow_source_mismatch = false,
  $pre_command           = undef,
){
  duplicity { 'backupjob':
    directories             => $directories,
    folder                  => $backupfolder,
    bucket                  => $backupbucket,
    dest_id                 => $dest_id,
    dest_key                => $dest_key,
    cloud                   => $cloud,
    hour                    => $hour,
    minute                  => $minute,
    remove_older_than       => $remove_older_than,
    full_if_older_than      => $full_if_older_than,
    pre_command             => $pre_command,
    allow_source_mismatch   => $allow_source_mismatch,
  }
}
