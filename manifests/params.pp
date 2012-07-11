
class git::params {

  #-----------------------------------------------------------------------------

  $allowed_ssh_key      = ''
  $allowed_ssh_key_type = 'rsa'
  $password             = undef

  $user                 = 'git'
  $group                = 'git'
  $alt_groups           = [ ]

  $home                 = '/var/git'

  $post_update_template = 'git/post-update.erb'

  case $::operatingsystem {
    debian: {}
    ubuntu: {
      $version = '1:1.7.9.5-1'
    }
    centos, redhat: {}
  }
}
