# Defines a single static route
define bird::static::route (
  String $static,
  String $prefix = $title,
  Enum['reachable', 'blackhole', 'unreachable', 'prohibit'] $kind = 'reachable',
  Array[Struct[{
    nexthop => String,
    kind    => Enum['via', 'interface'],
  }]] $destinations = undef,
) {
  if $kind in ['blackhole', 'unreachable', 'prohibit'] {
    concat::fragment { "bird_static_${static}_route_${title}":
      order   => '50',
      target  => "/etc/bird/conf.d/40_static_${static}.conf",
      content => "  route ${prefix} ${kind};",
    }
  } elsif $kind == 'reachable' {
    concat::fragment { "bird_static_${static}_route_${title}_0":
      order   => '50',
      target  => "/etc/bird/conf.d/40_static_${static}.conf",
      content => "  route ${prefix}",
    }

    $destinations.each |$dest| {
      if $dest['kind'] == 'via' {
        concat::fragment { "bird_static_${static}_route_${title}_1_${dest['nexthop']}":
          order   => '50',
          target  => "/etc/bird/conf.d/40_static_${static}.conf",
          content => "    via ${dest['nexthop']}",
        }
      } elsif $dest['kind'] == 'interface' {
        concat::fragment { "bird_static_${static}_route_${title}_1_${dest['nexthop']}":
          order   => '50',
          target  => "/etc/bird/conf.d/40_static_${static}.conf",
          content => "    via \"${dest['nexthop']}\"",
        }
      }
    }

    concat::fragment { "bird_static_${static}_route_${title}_2":
      order   => '50',
      target  => "/etc/bird/conf.d/40_static_${static}.conf",
      content => ';',
    }
  }
}
