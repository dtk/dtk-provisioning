class dtk_tenant::params()
{
  $tenant_name           = "dtk"
  $tenant_user           = "dtk"
  $gitolite_user         = "git"
  $update_hosts_file    = false
  $server_branch        = "master"
  $aws_access_key_id    = ""
  $remote_repo_port     = "443"
  $remote_repo_git_user = "git"
  $activemq_password    = "marionette"
  $db_host              = "/var/run/postgresql"
  $clone_from_git       = false
  $init_schema          = false
  $bundler_deployment   = false
  $seed_salts           = false
}