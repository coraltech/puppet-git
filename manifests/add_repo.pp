
define git::add_repo (

  $repo_name = $title,
  $git_home  = '/var/git'
) {

  #-----------------------------------------------------------------------------

  $repo_path = "${git_home}/${repo_name}"

  file { $repo_path:
    ensure  => 'directory',
    owner   => 'git',
    group   => 'git',
    mode    => 755,
    require => Package['git-core'],
  }

  #-----------------------------------------------------------------------------

  exec { 'create-git-repo':
    cwd => $repo_path,
    user => 'git',
    command => '/usr/bin/git init',
    creates => "$repo_path/.git/HEAD",
    require => File[$repo_path],
  }

  file { "$repo_path/.git/hooks/post_update":
    owner => 'git',
    group => 'git',
    mode  => 755,
    source  => "puppet:///modules/git/post_update",
    require => Exec['create-git-repo'],
  }
}
