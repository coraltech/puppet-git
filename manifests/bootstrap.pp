
class git::bootstrap (

  $git_version = $git::params::git_version,
  $root_home   = $users::params::root_home,
  $skel_home   = $users::params::skel_home
)
inherits git::params {

  #-----------------------------------------------------------------------------
  # Install

  if ! $git_version {
    fail('Git version must be defined')
  }
  package { 'git-core':
    ensure => $git_version,
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
