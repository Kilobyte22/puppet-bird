# Defines a bird filter
# @param [String] code
#   The bird code for this filter.
define bird::filter (
  String $code
) {
  file { "/etc/bird/conf.d/10_filter_${$title}.conf":
    ensure  => present,
    content => epp(
      'bird/filter.conf.epp',
      {
        name => $title,
        code => $code,
      }
    ),
    notify  => Service['bird'],
  }
}
