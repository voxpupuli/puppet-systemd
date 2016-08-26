# -- Class: systemd::tmpfiles_create
# Triggers systemd to create tmpfiles
class systemd::tmpfiles_create {
  exec { 'systemd-tmpfiles-create':
    command     => 'systemd-tmpfiles --create',
    refreshonly => true,
    path        => $::path,
  }
}