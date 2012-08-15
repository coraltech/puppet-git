
define git::repo (

  $repo_name            = $name,
  $user                 = $git::params::user,
  $group                = $git::params::group,
  $home                 = $git::params::home,
  $source               = $git::params::source,
  $revision             = $git::params::revision,
  $base                 = $git::params::base,
  $post_update_commands = $git::params::post_update_commands,
  $post_update_template = $git::params::post_update_template,
  $update_notify        = undef,

) {

  $repo_dir             = $home ? {
    ''                   => $repo_name,
    default              => "${home}/${repo_name}",
  }

  $repo_git_dir         = $base ? {
    'true'               => $repo_dir,
    default              => "${repo_dir}/.git"
  }

  $test_diff_cmd        = "diff ${repo_git_dir}/_NEW_REVISION ${repo_git_dir}/_LAST_REVISION"

  include git

  #--

  Exec {
    path => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd  => $repo_dir,
    user => $user,
  }

  #-----------------------------------------------------------------------------

  if $source and $revision {
    $revision_real = $revision
  }
  else {
    $revision_real = undef
  }

  vcsrepo { $repo_dir:
    ensure   => $base ? {
      'true'  => 'base',
      default => $source ? {
        ''      => 'present',
        default => 'latest',
      },
    },
    provider => 'git',
    owner    => $user,
    group    => $group,
    force    => true,
    source   => $source ? {
      ''      => undef,
      default => $source,
    },
    revision => $revision_real,
    require  => Class['git'],
  }

  #---

  exec { "${repo_dir}-new-revision":
    command     => "git rev-parse HEAD > ${repo_git_dir}/_NEW_REVISION",
    returns     => [ 0, 128 ],
    require     => Class['git'],
    subscribe   => Vcsrepo[$repo_dir],
  }

  exec { "${repo_dir}-update-notify":
    command => 'test true',
    onlyif  => $test_diff_cmd,
    notify  => $update_notify,
    require => Exec["${repo_dir}-new-revision"],
  }

  exec { "${repo_dir}-last-revision":
    command   => "git rev-parse HEAD > ${repo_git_dir}/_LAST_REVISION",
    returns   => [ 0, 128 ],
    subscribe => Exec["${repo_dir}-update-notify"],
  }

  #-----------------------------------------------------------------------------

  if $home and $base == 'false' {
    exec { "${repo_dir}-receive-deny-current-branch":
      command     => "git config receive.denyCurrentBranch 'ignore'",
      refreshonly => true,
      subscribe   => Vcsrepo[$repo_dir],
    }
  }

  file { "${repo_dir}-post-update":
    path      => "${repo_git_dir}/hooks/post-update",
    owner     => $user,
    group     => $group,
    mode      => '0755',
    content   => template($post_update_template),
    subscribe => Vcsrepo[$repo_dir],
  }
}
