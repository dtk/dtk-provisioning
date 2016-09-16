class dtk_nginx::install {

$dhparam_path = '/etc/nginx/dhparam.pem'

class { 'nginx':
  package_source            => 'passenger',
  http_cfg_append => {
    passenger_root          => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
    passenger_ruby          =>  '/usr/local/rvm/wrappers/default/ruby',
    passenger_max_pool_size => '1',
  }
}



exec { 'generate dhparam':
  command => "/usr/bin/openssl dhparam -out ${dhparam_path} 2048",
  creates => $dhparam_path,
  require => File['/etc/nginx/']
}

}
