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
#   $git_home   = '/var/git'
#   $git_groups = [ 'git' ]
#   $key        = ''
#   $root_name  = 'Root account'
#   $root_email = ''
#   $skel_name  = 'Administrative account'
#   $skel_email = ''
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
#     git_groups => [ 'git' ],
#     key        => '<YOUR PUBLIC SSH KEY>',
#     root_email => '<YOUR ROOT EMAIL ADDRESS>',
#     skel_email => '<YOUR DEFAULT USER EMAIL ADDRESS>'
#   }
#
# [Remember: No empty lines between comments and class definition]
class git(
  $git_home   = '/var/git',
  $git_groups = [ 'git' ],
  $key        = '',
  $root_name  = 'Root account',
  $root_email = '',
  $skel_name  = 'Administrative account',
  $skel_email = ''
) {

  include git::params

  #-----------------------------------------------------------------------------
  # Install

  if ! $git::params::git_version {
    fail('Git version must be defined')
  }
  package { 'git-core':
    ensure => $git::params::git_version;
  }

  #-----------------------------------------------------------------------------
  # Configure

  if $git::params::root_home {
    file { "${git::params::root_home}/.gitconfig":
      owner   => 'root',
      group   => 'root',
      mode    => 640,
      content => template('git/root.gitconfig.erb'),
      require => Package['git-core'],
    }
  }

  if $git::params::skel_home {
    file { "${git::params::skel_home}/.gitconfig":
      owner   => 'root',
      group   => 'root',
      mode    => 644,
      content => template('git/skel.gitconfig.erb'),
      require => Package['git-core'],
    }
  }

  #-----------------------------------------------------------------------------
  # Manage

  if $git_home and $key {
    users::user { 'git':
      groups  => $git_groups,
      home    => $git_home,
      key     => $key,
      require => Package['git-core'],
    }
  }
}
