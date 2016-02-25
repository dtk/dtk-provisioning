define dtk_tenant::tenant_setup(
  $tenant_name = $name,
  $ruby_user,
  $activemq_user,
  $tenant_user,
  $gitolite_user,
  $host,
){
  include dtk_server::params

  dtk_server::ruby193install{ $ruby_user:
   install => "true"
  } ->

  class { "dtk_server::base":
  }

  dtk_server::tenant{ $tenant_name:
    update_hosts_file     => $dtk_tenant::params::update_hosts_file,
    server_branch         => $dtk_tenant::params::server_branch,
    aws_access_key_id     => $dtk_tenant::params::aws_access_key_id,
    remote_repo_port      => $dtk_tenant::params::remote_repo_port,
    remote_repo_git_user  => $dtk_tenant::params::remote_repo_git_user,
    activemq_password     => $dtk_tenant::params::activemq_password,
    activemq_user         => $activemq_user,
    tenant_user           => $tenant_name,
    gitolite_user         => $gitolite_user,
    aws_secret_access_key => "",
    remote_repo_host      => "",
    stomp_server_host     => $host,
    local_repo_host       => $host,
    server_public_dns     => $host,
    db_host               => $dtk_tenant::params::db_host,
    clone_from_git        => $dtk_tenant::params::clone_from_git,
    init_schema           => $dtk_tenant::params::init_schema,
    bundler_deployment    => $dtk_tenant::params::bundler_deployment,
    seed_salts            => $dtk_tenant::params::seed_salts,
    require               => Class["dtk_server::base"],
  } ->

  gitolite::admin_client { $tenant_name:
    client_name => $tenant_name, 
    gitolite_user => $gitolite_user,
  } ->

  class {"vcsrepo::include": } ->

  common_user::common_user_ssh_config{ $tenant_name:
    user => $tenant_name,
  } ->

  dtk_server::add_user { $tenant_name:
    tenant_db_user => $tenant_user,
    tenant_user    => $tenant_name,
  }
}
