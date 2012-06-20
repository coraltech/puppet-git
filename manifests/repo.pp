
define git::repo (

  $repo_name = $name,
  $user      = $git::params::user,
  $group     = $git::params::group,
  $home      = undef,
  $source    = undef,
  $revision  = undef,
  $base      = false,
  $notify    = undef,

) {

  #-----------------------------------------------------------------------------

  $repo_path = $home ? {
    undef   => $repo_name,
    default => "${home}/${repo_name}",
  }

  file { $repo_path:
    ensure  => 'directory',
    owner   => $user,
    group   => $group,
    mode    => 755,
    require => Package['git-core'],
  }

  #-----------------------------------------------------------------------------

  vcsrepo { $repo_path:
    ensure   => $base ? {
      true    => 'base',
      default => 'present',
    },
    provider => 'git',
    source   => $source,
    force    => true,
    require  => File[$repo_path],
    revision => $revision,
    notify   => $notify,
  }

  #-----------------------------------------------------------------------------

  if $home and ! $base {
    file { "$repo_path/.git/hooks/post-update":
      owner     => $user,
      group     => $group,
      mode      => 755,
      source    => "puppet:///modules/git/post-update",
      subscribe => Vcsrepo[$repo_path],
    }
  }
}
