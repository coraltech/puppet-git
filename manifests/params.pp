
class git::params inherits git::default {

  include users::params

  #-----------------------------------------------------------------------------

  $package                 = module_param('package')
  $ensure                  = module_param('ensure')

  #---

  $root_gitconfig_template = module_param('root_gitconfig_template')
  $skel_gitconfig_template = module_param('skel_gitconfig_template')

  $user                    = module_param('user')
  $group                   = module_param('group')
  $alt_groups              = module_array('alt_groups', $users::params::user_alt_groups)
  $home                    = module_param('home')

  $allowed_ssh_key         = module_param('allowed_ssh_key', $users::params::user_allowed_ssh_key)
  $allowed_ssh_key_type    = module_param('allowed_ssh_key_type', $users::params::user_ssh_key_type)
  $password                = module_param('password', $users::params::user_password)

  #---

  $source                  = module_param('source')
  $revision                = module_param('revision')
  $base                    = module_param('base')

  $post_update_template    = module_param('post_update_template')
  $post_update_commands    = module_array('post_update_commands')
}
