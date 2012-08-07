# Class: git
#
#   This module manages Git components.
#
#   Adrian Webb <adrian.webb@coraltech.net>
#   2012-05-22
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Parameters: (see <example/params.json> for Hiera configurations)
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

  $package                 = $git::params::os_git_package,
  $ensure                  = $git::params::git_ensure,
  $home                    = $git::params::os_home,
  $allowed_ssh_key         = $git::params::allowed_ssh_key,
  $allowed_ssh_key_type    = $git::params::allowed_ssh_key_type,
  $password                = $git::params::password,
  $user                    = $git::params::user,
  $group                   = $git::params::group,
  $alt_groups              = $git::params::alt_groups,
  $root_name               = $git::params::root_name,
  $root_email              = $git::params::root_email,
  $root_home               = $git::params::os_root_home,
  $skel_name               = $git::params::skel_name,
  $skel_email              = $git::params::skel_email,
  $skel_home               = $git::params::os_skel_home,
  $root_gitconfig_template = $git::params::os_root_gitconfig_template,
  $skel_gitconfig_template = $git::params::os_skel_gitconfig_template,

) inherits git::params {

  #-----------------------------------------------------------------------------
  # Installation

  if ! ( $package and $ensure ) {
    fail('Git package name and ensure value must be defined')
  }
  package { 'git':
    name   => $package,
    ensure => $ensure,
  }

  #-----------------------------------------------------------------------------
  # Configuration

  if $root_home {
    file { 'root-gitconfig':
      path    => "${root_home}/.gitconfig",
      content => template($root_gitconfig_template),
      require => Package['git'],
    }
  }

  if $skel_home {
    file { 'skel-gitconfig':
      path    => "${skel_home}/.gitconfig",
      content => template($skel_gitconfig_template),
      require => Package['git'],
    }
  }

  #-----------------------------------------------------------------------------
  # User

  if $user and $home {
    users::user { $user:
      group                => $group,
      alt_groups           => $alt_groups,
      home                 => $home,
      allowed_ssh_key      => $allowed_ssh_key,
      allowed_ssh_key_type => $allowed_ssh_key_type,
      password             => $password,
      system               => 'true',
      require              => [ Package['git'], File['skel-gitconfig'] ],
    }
  }
}
