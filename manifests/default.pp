
class git::default {

  $ensure               = 'present'

  $user                 = 'git'
  $gid                  = 785
  $group                = 'git'
  $alt_groups           = []

  $source               = ''
  $revision             = 'master'

  $base                 = 'false'
  $post_update_commands = []

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $package                 = 'git'
      $home                    = '/var/git'

      $root_gitconfig_template = 'git/root.gitconfig.erb'
      $skel_gitconfig_template = 'git/skel.gitconfig.erb'

      $post_update_template    = 'git/post-update.erb'
    }
    default: {
      fail("The git module is not currently supported on ${::operatingsystem}")
    }
  }
}
