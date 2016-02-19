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