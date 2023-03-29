# A static protocol
define bird::static (
  Enum['ipv4', 'ipv6'] $protocol,
  String $import = 'all',
  Optional[String] $table = undef,
) {
  $act_table = $table ? {
    undef   => $protocol ? {
      'ipv4' => 'master4',
      'ipv6' => 'master6',
    },
    default => $table,
  }

  concat { "/etc/bird/conf.d/40_static_${title}.conf":
    ensure_newline => true,
    notify         => Service['bird'],
  }

  concat::fragment { "bird_static_${title}_head":
    order   => '00',
    target  => "/etc/bird/conf.d/40_static_${title}.conf",
    content => epp(
      'bird/static.conf.epp',
      {
        protocol => $protocol,
        import   => $import,
        table    => $act_table
      }
    ),
  }

  concat::fragment { "bird_static_${title}_tail":
    order   => '99',
    target  => "/etc/bird/conf.d/40_static_${title}.conf",
    content => '}',
  }
}
