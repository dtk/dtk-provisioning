# dtk-provisioning

#Bootstraping DTK Server with Puppet

### What is it

Walkthrough for setting up a DTK Server using provided Puppet modules. For DTK Server bootstraping, Puppet module `dtk_tenant` is used. This module will install and configure all  services and components required for the DTK Server, such as ActiveMQ, PostgreSQL Server and DB, DTK Server Ruby application and Passenger.


### Requirements

- Ubuntu Precise (12.04)
- Puppet

### Bootstraping

In `site.pp` file, set the value of host attribute to the public address of your environment,
and after that run the following command from your cloned DTK-Provisioning directory

`puppet apply site.pp --modulepath=./modules`

`site.pp` uses `dtk_tenant` module and it will install and configure DTK Server with default values.

### Module Usage

`dtk_tenant` Puppet definition contains following attributes:

- tenant_name: System user for DTK Server and Server name (default value `dtk`)
- tenant_user: Tenant user which will be used for connecting to DTK Server via DTK Client (default value `dtk`)
- gitolite_user: User which the DTK Server uses for managing component and service modules git repos (default value `git`)
- host: Host address which will be used for accessing the DTK Server.

Example of a `dtk_tenant` definition:

```
dtk_tenant { "dtk-server":
  tenant_name   => "dtk-server"
  tenant_user   => "dtk-user",
  gitolite_user => "git-user",
  host          => "dtk-server.dtk.io",
}
```
