# == Class: role_backup
#
#
class role_backup(
  $backupprecommand      = undef,
  $backuppostcommand     = undef,
  $burpserver            = undef,
  $burphostname          = undef,
  $burppassword          = 'password',
  $burpincludes          = ['/etc','/var/backup'],
  $burpexcludes          = undef,
  $burpoptions           = undef,
){

}
