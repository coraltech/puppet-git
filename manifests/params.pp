
class git::params {

  #-----------------------------------------------------------------------------

  $root_home = '/root'
  $skel_home = '/etc/skel'

  case $::operatingsystem {
    debian: {}
    ubuntu: {
      $git_version = '1:1.7.9.5-1'
    }
    centos, redhat: {}
  }
}
