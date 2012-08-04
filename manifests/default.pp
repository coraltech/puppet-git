
class git::default {

  include users

  #-----------------------------------------------------------------------------

  $git_ensure           = 'present'
  $allowed_ssh_key      = ''
  $allowed_ssh_key_type = 'rsa'
  $password             = ''
  $user                 = 'git'
  $group                = 'git'
  $alt_groups           = []
  $root_name            = $users::params::root_name ? {
    ''                   => 'Root',
    default              => $users::params::root_name,
  }
  $root_email           = $users::params::root_email ? {
    ''                   => "root@${::hostname}",
    default              => $users::params::root_email,
  }
  $skel_name            = $users::params::skel_name ? {
    ''                   => "User",
    default              => $users::params::skel_name,
  }
  $skel_email           = $users::params::skel_email ? {
    ''                   => "user@${::hostname}",
    default              => $users::params::skel_email,
  }
  $source               = ''
  $revision             = 'master'
  $base                 = 'false'
  $push_commands        = []
}
