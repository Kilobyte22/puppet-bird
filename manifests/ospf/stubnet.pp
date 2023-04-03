# An OSPF interface
define bird::ospf::stubnet (
  Stdlib::IP::Address $area,
  String $instance,
  Stdlib::IP::Address $prefix = $title,
  Boolean $hidden = false,
  Boolean $summary = false,
  Optional[Integer] $cost = undef,
) {
  # bird_ospf_${title}_1${area}_${interface}
  concat::fragment {"bird_ospf_${instance}_1${area}_1${interface}":
    target  => "/etc/bird/conf.d/40_ospf_${instance}.conf",
    order   => '50',
    content => epp(
      'bird/ospf.stubnet.conf.epp',
      {
        prefix  => $prefix,
        hidden  => $hidden,
        summary => $summary,
        cost    => $cost,
      }
    )
  }
}
