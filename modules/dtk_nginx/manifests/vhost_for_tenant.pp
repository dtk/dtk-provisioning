define dtk_nginx::vhost_for_tenant(
  $instance_name,
  # possible values are: https (sets up ssl), https (listens on port 80) and docker
  $tenant_type   = 'https',
  $docker_socket = undef,
)
{
  include dtk_nginx::install
  
  if ! defined(Class['nginx::config']) {
    class { 'nginx::config':}
  }
  $dtk_tenant_name = $name
  $dtk_tenant_www_root = "/home/${dtk_tenant_name}/server/current/application/public"

  #nginx::resource::upstream { $dtk_tenant_name:
  #  members => ["unix:/home/${dtk_tenant_name}/thin/thin.sock"]
  #}

  file { '/etc/nginx/ssl':
    ensure => directory,
    mode   => '0600',
  }

  file { '/etc/nginx/ssl/dtk.io.crt':
    ensure => present,
    source => "puppet:///modules/dtk_secret/dtk.io_combined.crt",
    mode => '0700',
    require => File['/etc/nginx/ssl'],
  }

  file { '/etc/nginx/ssl/dtk.io.key':
    ensure => present,
    source => "puppet:///modules/dtk_secret/wildcard.dtk.io.key",
    mode => '0700',
    require => File['/etc/nginx/ssl'],
  }
    
  case $tenant_type {
    'https': {
      nginx::resource::vhost { "${instance_name}.dtk.io":
        listen_port           => $dtk_nginx::base::listen_port,
        #proxy                 => "http://${dtk_tenant_name}",
        www_root              => $dtk_tenant_www_root,
        ssl		                => true,
        ssl_cert              => "/etc/nginx/ssl/dtk.io.crt",
        ssl_key               => "/etc/nginx/ssl/dtk.io.key",
        ssl_protocols         => "TLSv1 TLSv1.1 TLSv1.2",
        ssl_ciphers           => "ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS",
        ssl_stapling        => true,
        ssl_stapling_verify => true,
        ssl_cache           => "shared:SSL:50m",
        ssl_dhparam         => "/etc/nginx/dhparam.pem",
        rewrite_to_https    => true,
        add_header          => {"Strict-Transport-Security" => "max-age=15768000 always"},
        vhost_cfg_append      => {
          'passenger_enabled' => 'on',
          'rack_env'          => 'production',
        },
        require             => Exec['generate dhparam']
      }
    }

    'http': {
      nginx::resource::vhost { "${instance_name}.dtk.io":
        listen_port           => $dtk_nginx::base::listen_port_unsecure,
        www_root              => $dtk_tenant_www_root,
        vhost_cfg_append      => {
          'passenger_enabled' => 'on',
          'rack_env'          => 'production',
        }
      }
    }

    'docker': {
      nginx::resource::upstream { "docker-${instance_name}":
         ensure  => present,
         members => [
           "unix:${docker_socket}", 
         ],
       }
      nginx::resource::vhost { "${instance_name}.dtk.io":
        ensure      => present,
        listen_port => $dtk_nginx::base::listen_port_unsecure,
        proxy       => "http://docker-${instance_name}",
      }
    }

    default : { fail("Tenant type ${tenant_type} is not supported!")}
  }

}

define dtk_nginx::vhost_for_router(
  $instance_name,
  $ssl_cert_path = '/etc/nginx/ssl/dtk.io_combined_2015.crt',
  $ssl_key_path = '/etc/nginx/ssl/2015.wildcard.dtk.io.key',
  $multitenant_host = 'dtkhost2.internal.r8network.com',
)
{
  $vhost_file = "/etc/nginx/conf.d/${instance_name}"
  file { $vhost_file:
    mode    => '0644',
    content => template('dtk_nginx/vhost_router.erb'),
    notify  => Service['nginx'],
  }
}

# not usable with jfryman/nginx
define dtk_nginx::vhost_enable(
  $instance_name = $name,
  $vhost_file
)
{
  $vhost_file_enabled = "/etc/nginx/sites-enabled/${instance_name}"

  file { $vhost_file_enabled:
    ensure => symlink,
    target => $vhost_file,
    notify => Service['nginx']
  }
}
