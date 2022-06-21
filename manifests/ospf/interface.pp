# An OSPF interface
define bird::ospf::interface (
  $area,
  String $instance,
  String $interface = $title,
  Boolean $stub = false
) {
  # bird_ospf_${title}_1${area}_${interface}
  concat::fragment {"bird_ospf_${instance}_1${area}_1${interface}":
    target  => "/etc/bird/conf.d/40_ospf_${instance}.conf",
    order   => '50',
    content => epp(
      'bird/ospf.interface.conf.epp',
      {
        iface => $interface,
        stub  => $stub,
      }
    )
  }
}
