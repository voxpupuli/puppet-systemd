# -- Class systemd
# This module allows triggering systemd commands once for all modules
class systemd {
  include ::systemd::daemon_reload
  include ::systemd::tmpfiles_create
}
