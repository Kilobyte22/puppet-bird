# A bird pipe protocol
define bird::pipe (
  $local_table,
  $peer_table,
  $export_filter = 'all',
  $import_filter = 'all',
) {
  file { "/etc/bird/conf.d/30_pipe_${title}.conf":
    ensure  => present,
    content => epp(
      'bird/pipe.conf.epp',
      {
        local_table => $local_table,
        peer_table  => $peer_table,
        export      => $export_filter,
        import      => $import_filter,
      }
    ),
    notify  => Service['bird'],
  }
}
