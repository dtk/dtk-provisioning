# dtk-provisioning

#Bootstraping DTK Server with Puppet

### What is it

Walkthrough for setting up a DTK Server using provided Puppet modules. This module will install and configure all  services and components required for the DTK Server, such as ActiveMQ, PostgreSQL Server and DB, DTK Server Ruby application and Passenger.


### Requirements

- Ubuntu Precise (12.04)
- Puppet

### Bootstraping

In `site.pp` file, set the value of host attribute to the public address of your environment,
and after that run the following command from your cloned `dtk-provisioning` directory

`puppet apply site.pp --modulepath=./modules`

`site.pp` uses `dtk_tenant` module and it will install and configure DTK Server with default values.

### Module usage

`dtk_tenant` module description and usage can be found in module [README](https://github.com/dtk/dtk-provisioning/tree/bootstraping/modules/dtk_tenant/README.md) page