# Class: git
#
#   This module manages Git components.
#
#   Adrian Webb <adrian.webb@coraltg.com>
#   2012-05-22
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Parameters:
#
#   $git_user       = $git::params::git_user,
#   $git_home       = $git::params::git_home,
#   $git_group      = $git::params::git_group,
#   $git_alt_groups = $git::params::git_alt_groups,
#   $ssh_key        = $git::params::ssh_key,
#   $root_name      = $git::params::root_name,
#   $root_email     = $git::params::root_email,
#   $skel_name      = $git::params::skel_name,
#   $skel_email     = $git::params::skel_email,
#   $root_home      = $git::params::root_home,
#   $skel_home      = $git::params::skel_home,
#   $git_version    = $git::params::git_version
#
# Actions:
#
#  Installs, configures, and manages Git components.
#
# Requires:
#
# Sample Usage:
#
#   class { 'git':
#     git_home   => '/var/git',
#     git_group  => 'git',
#     key        => '<YOUR PUBLIC SSH KEY>',
#     root_email => '<YOUR ROOT EMAIL ADDRESS>',
#     skel_email => '<YOUR DEFAULT USER EMAIL ADDRESS>'
#   }
#
# [Remember: No empty lines between comments and class definition]
class git (

  $git_user       = $git::params::git_user,
  $git_home       = $git::params::git_home,
  $git_group      = $git::params::git_group,
  $git_alt_groups = $git::params::git_alt_groups,
  $ssh_key        = $git::params::ssh_key,
  $root_name      = $git::params::root_name,
  $root_email     = $git::params::root_email,
  $skel_name      = $git::params::skel_name,
  $skel_email     = $git::params::skel_email,
  $git_version    = $git::params::git_version
)
inherits git::params {

  include users::params

  #-----------------------------------------------------------------------------
  # Install and configure

  stage { 'git-bootstrap': }
  Stage['git-bootstrap'] -> Stage['main']

  class { 'git::bootstrap':
    git_version => $git_version,
    stage       => 'git-bootstrap'
  }

  #-----------------------------------------------------------------------------
  # Manage

  if $git_user and $git_home and $ssh_key {
    users::add_user { $git_user:
      group      => $git_group,
      alt_groups => $git_alt_groups,
      home       => $git_home,
      ssh_key    => $ssh_key,
      system     => true,
      require    => Package['git-core'],
    }
  }
}
