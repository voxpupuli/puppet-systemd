# @summary A cgroup controller name that can be delegated via Delegate=
# @see https://www.freedesktop.org/software/systemd/man/latest/systemd.resource-control.html
#
type Systemd::Unit::Controller = Enum[
  'cpu',
  'cpuset',
  'io',
  'memory',
  'pids',
  'bpf-firewall',
  'bpf-devices',
  'bpf-foreign',
  'bpf-socket-bind',
  'bpf-restrict-network-interfaces',
  'bpf-bind-network-interface',
]
