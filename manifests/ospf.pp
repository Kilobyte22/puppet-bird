# Configures an OSPF protocol
define bird::ospf (
  Enum['ipv4', 'ipv6'] $protocol,
  String $export_filter = 'all',
  String $import_filter = 'all',
) {
  concat { "/etc/bird/conf.d/40_ospf_${title}.conf":
    ensure_newline => true,
    notify         => Service['bird'],
  }

  concat::fragment { "bird_ospf_${title}_header":
    target => "/etc/bird/conf.d/40_ospf_${title}.conf",
    source => 'puppet:///modules/bird/header.conf',
    order  => '00',
  }

  concat::fragment { "bird_ospf_${title}_head":
    target  => "/etc/bird/conf.d/40_ospf_${title}.conf",
    order   => '01',
    content => epp(
      'bird/ospf.head.conf.epp',
      {
        id         => $title,
        ip_version => $protocol,
        import     => $import_filter,
        export     => $export_filter,
      }
    ),
  }

  concat::fragment { "bird_ospf_${title}_tail":
    target  => "/etc/bird/conf.d/40_ospf_${title}.conf",
    order   => '99',
    content => '}',
  }
}
