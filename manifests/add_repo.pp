
define git::add_repo (

  $repo_path = $title,
  $git_home  = '',
  $source    = '',
  $base      = false
) {

  #-----------------------------------------------------------------------------

  if $git_home {
    $repo_path = "${git_home}/${repo_path}"
  }

  file { $repo_path:
    ensure  => 'directory',
    owner   => 'git',
    group   => 'git',
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
      provider => git,
      source   => $source,
      require  => File[$repo_path],
    }
  }
  else {
    vcsrepo { $repo_path:
      ensure   => $ensure,
      provider => git,
      require  => File[$repo_path],
    }
  }

  #-----------------------------------------------------------------------------

  $post_update_path = $base ? {
    true    => "$repo_path/hooks/post_update",
    default => "$repo_path/.git/hooks/post_update",
  }

  file { $post_update_path:
    owner => 'git',
    group => 'git',
    mode  => 755,
    source  => "puppet:///modules/git/post_update",
    require => Vcsrepo[$repo_path],
  }
}
