# @summary One or more cgroup controllers, as an array or space-separated string
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html
#
type Systemd::Unit::ControllerList = Variant[
  Systemd::Unit::Controller,
  Array[Systemd::Unit::Controller],
  Pattern[/\A(?:cpu|cpuset|io|memory|pids|bpf-firewall|bpf-devices|bpf-foreign|bpf-socket-bind|bpf-restrict-network-interfaces|bpf-bind-network-interface)(?:[ \t]+(?:cpu|cpuset|io|memory|pids|bpf-firewall|bpf-devices|bpf-foreign|bpf-socket-bind|bpf-restrict-network-interfaces|bpf-bind-network-interface))*\z/],
]
