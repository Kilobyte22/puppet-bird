# A bird kernel protocol
# The kernel protocol is a pseudo-procotol that allows exchanging routes with the operating system kernel
# @param [String] export_filter
#   A filter spec for exporting routes via this protocol (ie. into the kernel)
# @param [String] import_filter
#   A filter spec for importing routes via this protocol (ie. from the kernel)
# @param [Enum['ipv4', 'ipv6']] protocol
#   Which version of IP to use for this protocol
# @param [String] table
#   The bird internal table for this protocol
# @param [Integer] kernel_table
#   Which kernel table to use for this protocol
define bird::kernel (
  String $export_filter,
  String $import_filter,
  Enum['ipv4', 'ipv6'] $protocol,
  String $table = 'master4',
  Integer $kernel_table = 254,
) {
  file { "/etc/bird/conf.d/40_kernel_${title}.conf":
    ensure  => present,
    content => epp(
      'bird/kernel.conf.epp',
      {
        import       => $import_filter,
        export       => $export_filter,
        table        => $table,
        kernel_table => $kernel_table,
        protocol     => $protocol,
      }
    ),
    notify  => Service['bird'],
  }
}
