class dtk_util()
{
case $operatingsystem {
    ubuntu: {
      class { 'dtk_util::ubuntu': }
    }
   }
}

class dtk_util::ubuntu()
{
  anchor { 'dtk_util::ubuntu::begin': }

  exec {'apt-get update dtk_util::ubuntu':
    command => 'apt-get update',
    path     => ['/usr/bin'],
    unless  => 'test -f /tmp/apt-get-update-run',
    require => Anchor['dtk_util::ubuntu::begin'],
    before  => Anchor['dtk_util::ubuntu::end']
  }

  exec {' touch for apt-get update dtk_util::ubuntu':
    command     => 'touch /tmp/apt-get-update-run',
    refreshonly => true,
    path     => ['/usr/bin'],
    subscribe   => Exec['apt-get update dtk_util::ubuntu'],
    require     => Anchor['dtk_util::ubuntu::begin'],
    before      => Anchor['dtk_util::ubuntu::end']
  }

  anchor { 'dtk_util::ubuntu::end': }
}

define dtk_util::directory_recursive_create(
  $path,    
  $owner = undef
)
{
  exec {"mkdir -p ${path} ${name}":
    command => "mkdir -p ${path}",
    creates => $path,
    path => ['/bin']
  }
  
  if $owner == undef {}
  else {
    exec {"mkdir-chown ${owner} ${path} ${name}" :
      command     => "chown ${owner} ${path}",
      path        => ['/bin'],
      refreshonly => true,
      subscribe   => Exec["mkdir -p ${path} ${name}"]
    }
  } 
}
