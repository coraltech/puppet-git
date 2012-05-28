
define git::add_repo (

  $repo_name = $title,
  $git_home  = '',
  $git_user  = 'git',
  $git_group = 'git',
  $source    = '',
  $base      = false
) {

  #-----------------------------------------------------------------------------

  if $git_home {
    $repo_path = "${git_home}/${repo_name}"
  }
  else {
    $repo_path = $repo_name
  }

  file { $repo_path:
    ensure  => 'directory',
    owner   => $git_user,
    group   => $git_group,
    mode    => 755,
    require => Package['git-core'],
  }

  #-----------------------------------------------------------------------------

  $ensure = $base ? {
    true    => 'base',
    default => 'present',
  }

  if $source {
    vcsrepo { $repo_path:
      ensure   => $ensure,
      provider => 'git',
      source   => $source,
      force    => true,
      require  => File[$repo_path],
    }
  }
  else {
    vcsrepo { $repo_path:
      ensure   => $ensure,
      provider => 'git',
      force    => true,
      require  => File[$repo_path],
    }
  }

  #-----------------------------------------------------------------------------

  if $git_home and ! $base {
    file { "$repo_path/.git/hooks/post-update":
      owner => $git_user,
      group => $git_group,
      mode  => 755,
      source  => "puppet:///modules/git/post-update",
      require => Vcsrepo[$repo_path],
    }
  }
}
