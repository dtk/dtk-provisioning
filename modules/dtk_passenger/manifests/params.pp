class dtk_passenger::params()
 {
   $rvm_path  = "/usr/local/rvm"
   $ruby_path = "${rvm_path}/wrappers/default/ruby"
   $max_pool_size = 1
   $pool_idle_time = 0

   case $::osfamily {
       'Debian' : {
          $package_list = ["nginx-full", "passenger"]
        }
       'RedHat', 'Linux' : {
          $package_list = ["nginx-passenger"]
       }
       default: {
          fail("\"${module_name}\" provides no package information for OSfamily \"${::osfamily}\"")
      } 
    }
  }
