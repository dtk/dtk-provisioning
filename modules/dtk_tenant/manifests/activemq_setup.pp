define dtk_tenant::activemq_setup (
  $common_user,
  $gitolite_user,
  $tenant_name = $name,
  $activemq_password = 'UNSET',
) {
  include dtk_tenant::params

  if $activemq_password == 'UNSET' {
    $activemq_password_final = $dtk_tenant::params::activemq_password
  }

  class {"stdlib": } ->

  class {"dtk": } ->

  class {"dtk_java": } ->

  class {"dtk_activemq":
    user        => $common_user,
    password    => $activemq_password_final,
    tenant_name => $tenant_name,
  }

  common_user { $common_user:
    user    => $gitolite_user,
    require => Class["dtk_activemq"]
  }
}