# @summary Possible keys for the [Kube] section of a unit file
# @see https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#kube-units-kube
type Systemd::Unit::Kube = Struct[
  {
    Optional['AutoUpdate'] => String,
    Optional['ConfigMap']  => Stdlib::Unixpath,
    Optional['ContainersConfModule'] => Stdlib::Unixpath,
    Optional['ExitCodePropagation'] => Enum['all', 'any', 'none'],
    Optioanl['GlobalArgs'] => String,
    Optional['KubeDownForce'] => Boolean,
    Optional['LogDriver'] => String,
    Optional['Network'] => String,
    Optional['PodmanArgs'] => String,
    Optional['PublishPort'] => Variant[String, Integer],
    Optional['SetWorkingDirectory'] => Enum['yaml', 'unit'],
    Optional['UserNS'] => String,
    Optional['Yaml'] => Stdlib::Unixpath,
  }
]
