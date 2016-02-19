define dtk_tenant::postgresql_setup(
  $db = $name,
  ){

  class {"dtk_postgresql::server":
    max_connections => '50',
    ssl => 'off',
  } ->

  dtk_postgresql::db { $db:
    db_name => $db,
  }
}