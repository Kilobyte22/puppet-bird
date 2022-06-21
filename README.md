# puppet-bird2

# Description
This module installs and configures the bird2 routing daemon.

# Setup

Beginning with puppet-bird2

Declare the bird2 class. You will need to define a router id. This usually should is the canonical legacy IP of your host.

# Usage

A simple setup with OSPF might look like this:

```puppet
class {'bird':
    router_id => '192.0.2.42',
}

bird::kernel { 'kernel_main':
    protocol      => 'ipv6',
    export_filter => 'all',
    import_filter => 'none',
    table         => 'master6',
}

bird::ospf { 'ospf_main':
    protocol => 'ipv6',
}

bird::ospf::area { 'backbone':
    instance => 'ospf_main',
    id       => '0.0.0.0',
}

bird::ospf::interface { 'lo':
    instance => 'ospf_main',
    area     => '0.0.0.0',
    stub     => true,
}

bird::ospf::interface { 'eth0':
    instance => 'ospf_main',
    area     => '0.0.0.0',
}

```

# Limitations
Currently a very limited feature set of bird is supported. An escape hatch allowing to specify arbitrary config options will be provided in the near future

# Development
Just submit a Pull Request on github