# A bird routing table. The protocol must be specified.
define bird::table (
  Enum['ipv4', 'ipv6'] $protocol,
  String $table_name = $title,
) {
  concat::fragment { "bird_table_${title}":
    target  => '/etc/bird/conf.d/00_tables.conf',
    order   => '10',
    content => "${protocol} table ${table_name};",
  }
}
