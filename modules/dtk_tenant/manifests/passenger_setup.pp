define dtk_tenant::passenger_setup(
  $instance_name = $name
){
  class {"dtk_passenger":
  } ->

  class {"dtk_nginx::base":
  }

  dtk_nginx::vhost_for_tenant {$instance_name:
    instance_name => $instance_name,
    tenant_type   => 'http',
    require       => Class["dtk_nginx::base"]
  }
}