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
#   $password   = $git::params::password,
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
#     home             => '/var/git',
#     allowed_ssh_key' => '<YOUR PUBLIC SSH KEY>',
#     root_email       => '<YOUR ROOT EMAIL ADDRESS>',
#     skel_email       => '<YOUR DEFAULT USER EMAIL ADDRESS>'
#   }
#
# [Remember: No empty lines between comments and class definition]
class git (

  $user                 = $git::params::user,
  $group                = $git::params::group,
  $home                 = $git::params::home,
  $alt_groups           = $git::params::alt_groups,
  $allowed_ssh_key      = $git::params::allowed_ssh_key,
  $allowed_ssh_key_type = $git::params::allowed_ssh_key_type,
  $password             = $git::params::password,
  $version              = $git::params::version,
  $root_name            = $users::params::root_name,
  $root_email           = $users::params::root_email,
  $skel_name            = $users::params::skel_name,
  $skel_email           = $users::params::skel_email,

) inherits git::params {

  $root_home            = $users::params::root_home
  $skel_home            = $users::params::skel_home

  #-----------------------------------------------------------------------------
  # Install

  if ! $version {
    fail('Git version must be defined')
  }
  package { 'git-core':
    ensure => $version,
  }

  #-----------------------------------------------------------------------------
  # Configure

  if $root_home {
    file { "${root_home}/.gitconfig":
      owner   => 'root',
      group   => 'root',
      mode    => 640,
      content => template('git/root.gitconfig.erb'),
      require => Package['git-core'],
    }
  }

  if $skel_home {
    file { "${skel_home}/.gitconfig":
      owner   => 'root',
      group   => 'root',
      mode    => 644,
      content => template('git/skel.gitconfig.erb'),
      require => Package['git-core'],
    }
  }

  #-----------------------------------------------------------------------------
  # Manage

  if $user and $home {
    users::user { $user:
      group                => $group,
      alt_groups           => $alt_groups,
      home                 => $home,
      allowed_ssh_key      => $allowed_ssh_key,
      allowed_ssh_key_type => $allowed_ssh_key_type,
      password             => $password,
      system               => true,
      require              => Package['git-core'],
    }
  }
}
