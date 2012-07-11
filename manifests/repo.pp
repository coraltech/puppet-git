
define git::repo (

  $repo_name            = $name,
  $user                 = $git::params::user,
  $group                = $git::params::group,
  $home                 = undef,
  $source               = undef,
  $revision             = undef,
  $base                 = false,
  $push_commands        = [],
  $post_update_template = $git::params::post_update_template,
  $git_notify           = undef,

) {

  include git

  #-----------------------------------------------------------------------------

  $repo_path = $home ? {
    undef   => $repo_name,
    default => "${home}/${repo_name}",
  }

  vcsrepo { $repo_path:
    ensure   => $base ? {
      true    => 'base',
      default => 'present',
    },
    provider => 'git',
    source   => $source,
    force    => true,
    revision => $revision,
    require  => Class['git'],
    notify   => $git_notify,
  }

  file { $repo_path:
    ensure    => 'directory',
    owner     => $user,
    group     => $group,
    recurse   => true,
    subscribe => Vcsrepo[$repo_path],
  }

  #-----------------------------------------------------------------------------

  if $home and ! $base {
    exec { "$repo_path receive.denyCurrentBranch":
      cwd         => $repo_path,
      path        => [ '/bin', '/usr/bin', '/usr/local/bin' ],
      command     => "git config receive.denyCurrentBranch 'ignore'",
      user        => $user,
      group       => $group,
      refreshonly => true,
      subscribe   => File[$repo_path],
    }

    file { "$repo_path/.git/hooks/post-update":
      owner     => $user,
      group     => $group,
      mode      => 755,
      content   => template($post_update_template),
      subscribe => Exec["$repo_path receive.denyCurrentBranch"],
    }
  }
}
