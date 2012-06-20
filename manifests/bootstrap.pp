
class git::bootstrap (

  $version    = $git::params::version,
  $root_home  = $users::params::root_home,
  $root_name  = $users::params::root_name,
  $root_email = $users::params::root_email,
  $skel_home  = $users::params::skel_home,
  $skel_name  = $users::params::skel_name,
  $skel_email = $users::params::skel_email,

) inherits git::params {

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
}
