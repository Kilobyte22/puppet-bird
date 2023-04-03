# Defines an OSPF area
define bird::ospf::area (
  String $instance,
  String $id,
) {
  # bird_ospf_${title}_1${area}_${interface}
  concat::fragment {"bird_ospf_${instance}_1${id}_0":
    target  => "/etc/bird/conf.d/40_ospf_${instance}.conf",
    order   => '50',
    content => epp('bird/ospf.area.conf.epp', { area => $id })
  }

  concat::fragment {"bird_ospf_${instance}_1${id}_9":
    target  => "/etc/bird/conf.d/40_ospf_${instance}.conf",
    order   => '50',
    content => '  };'
  }
}
