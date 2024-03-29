# Deploys bird, the routing daemon
# @param [Stdlib::IP::Address::V4] router_id
#   The unique ID for this Router. Required for some Routing Protocols.
#   Typically this is the primary IPv4 Address of this router
class bird (
  Stdlib::IP::Address::V4 $router_id,
  String $bird_package = 'bird2',
) {
  package { $bird_package:
    ensure => present,
    notify => Service['bird'],
  }

  file { '/etc/bird':
    ensure => directory,
  }

  file { '/etc/bird/bird.conf':
    ensure  => present,
    content => epp(
      'bird/bird.conf.epp',
      {
        router_id => $router_id,
      }
    ),
    notify  => Service['bird'],
  }

  file { '/etc/bird/conf.d':
    ensure => directory,
  }

  concat { '/etc/bird/conf.d/00_tables.conf':
    ensure         => 'present',
    ensure_newline => true,
    notify         => Service['bird'],
  }

  concat::fragment { 'bird_tables_header':
    target => '/etc/bird/conf.d/00_tables.conf',
    order  => '00',
    source => 'puppet:///modules/bird/header.conf',
  }

  service { 'bird':
    ensure  => running,
    enable  => true,
    restart => 'birdc configure',
  }

}
