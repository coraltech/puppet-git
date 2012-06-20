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
#   $user       = $git::params::git_user,
#   $group      = $git::params::git_group,
#   $alt_groups = $git::params::git_alt_groups,
#   $home       = $git::params::git_home,
#   $ssh_key    = $git::params::ssh_key,
#   $version    = $git::params::git_version,
#   $root_name  = $users::params::root_name,
#   $root_email = $users::params::root_email,
#   $skel_name  = $users::params::skel_name,
#   $skel_email = $users::params::skel_email,
#
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
#     home       => '/var/git',
#     key        => '<YOUR PUBLIC SSH KEY>',
#     root_email => '<YOUR ROOT EMAIL ADDRESS>',
#     skel_email => '<YOUR DEFAULT USER EMAIL ADDRESS>'
#   }
#
# [Remember: No empty lines between comments and class definition]
class git (

  $user       = $git::params::user,
  $group      = $git::params::group,
  $home       = $git::params::home,
  $alt_groups = $git::params::alt_groups,
  $ssh_key    = $git::params::ssh_key,
  $version    = $git::params::version,
  $root_name  = $users::params::root_name,
  $root_email = $users::params::root_email,
  $skel_name  = $users::params::skel_name,
  $skel_email = $users::params::skel_email,

) inherits git::params {

  #-----------------------------------------------------------------------------
  # Install and configure

  stage { 'git-bootstrap': }
  Stage['git-bootstrap'] -> Stage['main']

  class { 'git::bootstrap':
    version    => $version,
    root_name  => $root_name,
    root_email => $root_email,
    skel_name  => $skel_name,
    skel_email => $skel_email,
    stage      => 'git-bootstrap'
  }

  #-----------------------------------------------------------------------------
  # Manage

  if $user and $home and $ssh_key {
    users::user { $user:
      group      => $group,
      alt_groups => $alt_groups,
      home       => $home,
      ssh_key    => $ssh_key,
      system     => true,
      require    => Package['git-core'],
    }
  }
}
