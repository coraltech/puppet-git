
class git::params inherits git::default {

  include users::params

  #-----------------------------------------------------------------------------

  $package                 = module_param('package')
  $ensure                  = module_param('ensure')

  #---

  $root_gitconfig_template = module_param('root_gitconfig_template')
  $skel_gitconfig_template = module_param('skel_gitconfig_template')

  $user                    = module_param('user')
  $gid                     = module_param('gid')
  $group                   = module_param('group')
  $alt_groups              = module_array('alt_groups', $users::params::user_alt_groups)
  $home                    = module_param('home')

  $root_name               = module_param('root_name', $users::params::root_name)
  $root_email              = module_param('root_email', $users::params::root_email)

  $skel_name               = module_param('skel_name', $users::params::skel_name)
  $skel_email              = module_param('skel_email', $users::params::skel_email)

  $allowed_ssh_key         = module_param('allowed_ssh_key', $users::params::user_allowed_ssh_key)
  $allowed_ssh_key_type    = module_param('allowed_ssh_key_type', $users::params::user_ssh_key_type)
  $public_ssh_key          = module_param('public_ssh_key', $users::params::user_public_ssh_key)
  $private_ssh_key         = module_param('private_ssh_key', $users::params::user_private_ssh_key)
  $ssh_key_type            = module_param('ssh_key_type', $users::params::user_ssh_key_type)
  $password                = module_param('password', $users::params::user_password)

  #---

  $source                  = module_param('source')
  $revision                = module_param('revision')
  $base                    = module_param('base')

  $post_update_template    = module_param('post_update_template')
  $post_update_commands    = module_array('post_update_commands')
}
