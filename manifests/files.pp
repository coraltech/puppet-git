
class git::files (

  $root_home = $users::params::root_home,
  $skel_home = $users::params::skel_home
)
inherits git::params {

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
