define dtk_tenant(
  $tenant_name    = $name,
  $tenant_user    = 'UNSET',
  $gitolite_user  = 'UNSET',
  $host,
) {
  include dtk_tenant::params

  # if $tenant_name == 'UNSET' {
  #   $tenant_name_final = $dtk_tenant::params::tenant_name
  # }

  if $tenant_user == 'UNSET' {
    $tenant_user_final = $dtk_tenant::params::tenant_user
  }

  if $gitolite_user == 'UNSET' {
    $gitolite_user_final = $dtk_tenant::params::gitolite_user
  }

  dtk_tenant::activemq_setup { $tenant_name:
    common_user   => $tenant_name,
    gitolite_user => $gitolite_user_final
  } ->

  dtk_tenant::postgresql_setup { $tenant_name: } ->

  dtk_tenant::tenant_setup { $tenant_name:
    ruby_user      => $tenant_name,
    activemq_user  => $tenant_name,
    tenant_user    => $tenant_user_final,
    gitolite_user  => $gitolite_user_final,
    host           => $host,
  } ->

  dtk_tenant::passenger_setup { $tenant_name:
  }

}