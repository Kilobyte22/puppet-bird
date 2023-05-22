define bird::bgp (
  Integer[0, 4294967295] $local_as,
  Integer[0, 4294967295] $neighbour_as,
  Stdlib::IP::Address $neighbour_addr,
  Optional[String] $interface = undef,
  Variant[Boolean, Enum['graceful']] $bfd = false,
  Optional[Stdlib::IP::Address::Nosubnet] $local_addr = undef,
  Optional[Sensitive] $password = undef,
  Optional[Struct[{export => String, import => String, table => Optional[String]}]] $ipv4 = undef,
  Optional[Struct[{export => String, import => String, table => Optional[String]}]] $ipv6 = undef,
  Optional[Enum['direct', 'multihop']] $kind = undef,
) {

  $neighbour_is_range = !! ($neighbour_addr =~ /\//)

  file { "/etc/bird/conf.d/40_bgp_${title}.conf":
    content => epp(
      'bird/bgp.conf.epp',
      {
        name               => $title,
        local_as           => $local_as,
        neighbour_as       => $neighbour_as,
        neighbour_addr     => $neighbour_addr,
        neighbour_is_range => $neighbour_is_range,
        interface          => $interface,
        local_addr         => $local_addr,
        password           => $password,
        ipv4               => $ipv4,
        ipv6               => $ipv6,
        kind               => $kind,
      }
    ),
    notify  => Service['bird'],
  }
}
