#TODO: want internal links to connect these with gitolite params
class dtk_server::params()
{

  $config_base = '/etc/dtk'
  $default_port = 443
  #$app_repos = ['server','common', 'common-core']

  $ruby_version = 'ruby-1.9.3-p484'

  $server_repo = 'server'
  $dtk_common_repo = 'common'
  $dtk_common_core_repo = 'common-core'

  # removed libxslt packages since they're handled by rvm
  case $::osfamily {
    'RedHat', 'Linux': {
      # TO-DO: find out if sexp-processor is still required
      $app_packages = ['postgresql-devel'] 
    }
    'Debian' : {
      $app_packages = ['libpq-dev']
    }
  }

  $repo_urls = {
    'server'      => 'https://github.com/dtk/dtk-server',
    'common'      => 'https://github.com/dtk/dtk-common',
    'common-core' => 'https://github.com/dtk/dtk-common-core',
  }
  $repo_targets = {
    'server' => 'server/current',
    'common' => 'dtk-common',
    'common-core' => 'dtk-common-core',
  }

  $repo_hostnames = ['github.com']

  $mcollective_plugins_dir = '/usr/share/mcollective/plugins' #hard coded in dtk server code

  $sudo_config_file = '/etc/sudoers'
  $sudo_config_dir = '/etc/sudoers.d/'
}
