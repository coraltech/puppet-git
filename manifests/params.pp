
class git::params {

  #-----------------------------------------------------------------------------

  $git_user       = true
  $git_home       = '/var/git'
  $git_group      = 'git'
  $git_alt_groups = [ ]
  $ssh_key        = ''

  $root_name   = 'Root account'
  $root_email  = ''
  $skel_name   = 'Administrative account'
  $skel_email  = ''

  case $::operatingsystem {
    debian: {}
    ubuntu: {
      $git_version = '1:1.7.9.5-1'
    }
    centos, redhat: {}
  }
}
