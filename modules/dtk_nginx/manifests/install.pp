class dtk_nginx::install {
class { 'nginx':
  package_source            => 'passenger',
  http_cfg_append => {
    passenger_root          => '/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini',
    passenger_ruby          =>  '/usr/local/rvm/wrappers/default/ruby',
    passenger_max_pool_size => '1',
  }
}
}
