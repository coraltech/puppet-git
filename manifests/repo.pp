
define git::repo (

  $repo_name            = $name,
  $user                 = $git::params::user,
  $group                = $git::params::group,
  $home                 = $git::params::os_home,
  $source               = $git::params::source,
  $revision             = $git::params::revision,
  $base                 = $git::params::base,
  $push_commands        = $git::params::push_commands,
  $post_update_template = $git::params::os_post_update_template,
  $git_notify           = undef,

) {

  $repo_dir             = $home ? {
    ''                   => $repo_name,
    default              => "${home}/${repo_name}",
  }

  include git

  #-----------------------------------------------------------------------------

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
    revision => $revision ? {
      ''      => undef,
      default => $revision,
    },
    require  => Class['git'],
    notify   => $git_notify,
  }

  #-----------------------------------------------------------------------------

  if $home and $base == 'false' {
    exec { "${repo_dir}-receive-deny-current-branch":
      cwd         => $repo_dir,
      path        => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      command     => "git config receive.denyCurrentBranch 'ignore'",
      user        => $user,
      refreshonly => true,
      subscribe   => Vcsrepo[$repo_dir],
    }

    file { "${repo_dir}-post-update":
      path      => "${repo_dir}/.git/hooks/post-update",
      owner     => $user,
      group     => $group,
      mode      => '0755',
      content   => template($post_update_template),
      subscribe => Vcsrepo[$repo_dir],
    }
  }
}
