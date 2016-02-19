define dtk_tenant(
  $tenant_name    = $dtk_tenant::params::tenant_user,
  $tenant_user    = $dtk_tenant::params::tenant_user,
  $gitolite_user  = $dtk_tenant::params::gitolite_user,
  $host,
) inherits dtk_tenant::params {

  dtk_tenant::activemq_setup { $tenant_name:
    common_user   => $tenant_user,
    gitolite_user => $gitolite_user
  } ->

  dtk_tenant::postgresql_setup { $tenant_name: } ->

  dtk_tenant::tenant_setup { $tenant_name:
    ruby_user      => $tenant_user,
    activemq_user  => $tenant_user,
    tenant_user    => $tenant_user,
    gitolite_user  => $tenant_user,
    host           => $host,
  } ->

  dtk_tenant::passenger_setup { $tenant_name:
   }

}