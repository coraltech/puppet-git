
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
    notify   => $update_notify,
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
    mode      => 0755,
    content   => template($post_update_template),
    subscribe => Vcsrepo[$repo_dir],
  }
}
