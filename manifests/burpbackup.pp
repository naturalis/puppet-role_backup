# == Class: role_backup::burpbackup
#
#
class role_backup::burpbackup(
  $burpserver            = undef,
  $burpconfig_hash       = undef,
){
  class { 'burp':
    mode                => 'client',
    server              => $burpserver,
    config_hash         => $burpconfig_hash,
  }
}

