define dtk_tenant::activemq_setup (
  $common_user,
  $gitolite_user,
  $tenant_name = $name,
  $activemq_password = $dtk_server::params::activemq_password,
) inherits dtk_server::params {
  class {"stdlib": } ->

  class {"dtk": } ->

  class {"dtk_java": } ->

  class {"dtk_activemq":
    user        => $common_user,
    password    => $activemq_password,
    tenant_name => $tenant_name,
  }

  common_user { $common_user:
    user    => $git_user,
    require => Class["dtk_activemq"]
  }
}