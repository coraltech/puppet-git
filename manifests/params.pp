
class git::params {

  #-----------------------------------------------------------------------------

  $ssh_key    = ''

  $user       = 'git'
  $group      = 'git'
  $alt_groups = [ ]

  $home       = '/var/git'

  case $::operatingsystem {
    debian: {}
    ubuntu: {
      $version = '1:1.7.9.5-1'
    }
    centos, redhat: {}
  }
}
