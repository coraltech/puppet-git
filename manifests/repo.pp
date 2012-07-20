
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

  include git

  #-----------------------------------------------------------------------------

  File {
    owner => $user,
    group => $group,
  }

  $repo_dir = $home ? {
    ''      => $repo_name,
    default => "${home}/${repo_name}",
  }

  vcsrepo { $repo_dir:
    ensure   => $base ? {
      'true'  => 'base',
      default => 'present',
    },
    provider => 'git',
    source   => $source,
    force    => true,
    revision => $revision,
    require  => Class['git'],
    notify   => $git_notify,
  }

  file { $repo_dir:
    ensure    => directory,
    recurse   => true,
    subscribe => Vcsrepo[$repo_dir],
  }

  #-----------------------------------------------------------------------------

  if $home and $base == 'false' {
    exec { "${repo_dir}-receive-deny-current-branch":
      cwd         => $repo_dir,
      path        => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      command     => "git config receive.denyCurrentBranch 'ignore'",
      user        => $user,
      refreshonly => true,
      subscribe   => File[$repo_dir],
    }

    file { "${repo_dir}-post-update":
      path      => "${repo_dir}/.git/hooks/post-update",
      mode      => 755,
      content   => template($post_update_template),
      subscribe => Exec["${repo_dir}-receive-deny-current-branch"],
    }
  }
}
