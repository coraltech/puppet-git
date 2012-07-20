
class git::params {

  include git::default

  #-----------------------------------------------------------------------------
  # General configurations

  if $::hiera_ready {
    $git_ensure           = hiera('git_ensure', $git::default::git_ensure)
    $allowed_ssh_key      = hiera('git_allowed_ssh_key', $git::default::allowed_ssh_key)
    $allowed_ssh_key_type = hiera('git_allowed_ssh_key_type', $git::default::allowed_ssh_key_type)
    $password             = hiera('git_password', $git::default::password)
    $user                 = hiera('git_user', $git::default::user)
    $group                = hiera('git_group', $git::default::group)
    $alt_groups           = hiera('git_alt_groups', $git::default::alt_groups)
    $root_name            = hiera('git_root_name', $git::default::root_name)
    $root_email           = hiera('git_root_email', $git::default::root_email)
    $skel_name            = hiera('git_skel_name', $git::default::skel_name)
    $skel_email           = hiera('git_skel_email', $git::default::skel_email)
    $source               = hiera('git_source', $git::default::source)
    $revision             = hiera('git_revision', $git::default::revision)
    $base                 = hiera('git_base', $git::default::base)
    $push_commands        = hiera('git_push_commands', $git::default::push_commands)
  }
  else {
    $git_ensure           = $git::default::git_ensure
    $allowed_ssh_key      = $git::default::allowed_ssh_key
    $allowed_ssh_key_type = $git::default::allowed_ssh_key_type
    $password             = $git::default::password
    $user                 = $git::default::user
    $group                = $git::default::group
    $alt_groups           = $git::default::alt_groups
    $root_name            = $git::default::root_name
    $root_email           = $git::default::root_email
    $skel_name            = $git::default::skel_name
    $skel_email           = $git::default::skel_email
    $source               = $git::default::source
    $revision             = $git::default::revision
    $base                 = $git::default::base
    $push_commands        = $git::default::push_commands
  }

  #-----------------------------------------------------------------------------
  # Operating specific configurations

  case $::operatingsystem {
    debian, ubuntu: {
      $os_git_package             = 'git'
      $os_home                    = '/var/git'

      $os_root_home               = $users::params::os_root_home ? {
        ''                         => '/root',
        default                    => $users::params::os_root_home,
      }
      $os_skel_home               = $users::params::os_skel_home ? {
        ''                         => '/etc/skel',
        default                    => $users::params::os_skel_home,
      }

      $os_root_gitconfig_template = 'git/root.gitconfig.erb'
      $os_skel_gitconfig_template = 'git/skel.gitconfig.erb'

      $os_post_update_template    = 'git/post-update.erb'
    }
    default: {
      fail("The git module is not currently supported on ${::operatingsystem}")
    }
  }
}
